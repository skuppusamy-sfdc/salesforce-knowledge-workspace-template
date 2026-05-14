#!/usr/bin/env python3
"""
split-sprint-stories.py

Split monolithic JIRA HTML exports into per-story markdown files.

Reads each sprint HTML and writes one .md file per story to a `stories/`
subdirectory. This dramatically improves RAG retrieval by letting the AI
fetch a single 2-30KB story instead of parsing a 1-4.5MB sprint HTML.

Reads project-specific config from workspace.config.yaml (story_id pattern, etc.).

Usage:
    python scripts/split-sprint-stories.py                      # all sprints
    python scripts/split-sprint-stories.py --sprint "Sprint 14"  # single sprint
    python scripts/split-sprint-stories.py --force               # overwrite existing
"""

from __future__ import annotations

import argparse
import html
import re
from html.parser import HTMLParser
from pathlib import Path
from typing import Dict, List

import _config as cfg

FIELD_MAP = {
    "issuekey":            "issue_key",
    "summary":             "summary",
    "status":              "status",
    "statusCategory":      "status_category",
    "issuetype":           "issue_type",
    "priority":            "priority",
    "assignee":            "assignee",
    "reporter":            "reporter",
    "creator":             "creator",
    "components":          "components",
    "parent":              "epic",
    "labels":              "labels",
    "resolution":          "resolution",
    "description":         "description",
    "customfield_10033":   "acceptance_criteria",
    "customfield_10040":   "solution",
    "customfield_10034":   "build_components",
    "customfield_10035":   "deployment_instructions",
    "customfield_10036":   "epic_theme",
    "customfield_10047":   "story_points",
    "customfield_10020":   "sprint_name",
    "customfield_10300":   "root_cause",
    "customfield_10301":   "root_cause_type",
    "customfield_10038":   "environment",
    "issuelinks":          "linked_issues",
    "subtasks":            "subtasks",
    "created":             "created",
    "updated":             "updated",
    "resolutiondate":      "resolved",
    "acceptance":          "acceptance_criteria",
    "solution":            "solution",
    "approach":            "solution",
    "ac":                  "acceptance_criteria",
}


class StoryHTMLParser(HTMLParser):
    """Parse JIRA HTML table exports, preserving full content with line breaks."""

    def __init__(self) -> None:
        super().__init__()
        self.in_table = False
        self.in_header = False
        self.in_body = False
        self.in_row = False
        self.in_cell = False

        self.current_row: List[Dict[str, str]] = []
        self.current_cell = ""
        self.current_cell_class = ""
        self.stories: List[List[Dict[str, str]]] = []

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)

        if tag == "table" and (a.get("id") == "issuetable" or "issue" in (a.get("class") or "")):
            self.in_table = True
        elif self.in_table and tag == "thead":
            self.in_header = True
        elif self.in_table and tag == "tbody":
            self.in_body = True
        elif self.in_body and tag == "tr" and "issuerow" in a.get("class", ""):
            self.in_row = True
            self.current_row = []
        elif self.in_row and tag == "td":
            self.in_cell = True
            self.current_cell = ""
            self.current_cell_class = (a.get("class", "") + " " + a.get("data-id", "")).strip()
        elif self.in_cell and tag in ("br", "p"):
            self.current_cell += "\n"
        elif self.in_cell and tag == "li":
            self.current_cell += "\n- "

    def handle_endtag(self, tag):
        if tag == "table" and self.in_table:
            self.in_table = False
        elif tag == "thead":
            self.in_header = False
        elif tag == "tbody":
            self.in_body = False
        elif tag == "tr" and self.in_row:
            self.in_row = False
            if self.current_row:
                self.stories.append(self.current_row[:])
        elif tag == "td" and self.in_cell:
            self.in_cell = False
            self.current_row.append({
                "class": self.current_cell_class,
                "content": self.current_cell.strip(),
            })

    def handle_data(self, data):
        if self.in_cell:
            self.current_cell += data

    def handle_entityref(self, name):
        if self.in_cell:
            self.current_cell += html.unescape(f"&{name};")

    def handle_charref(self, name):
        if self.in_cell:
            self.current_cell += html.unescape(f"&#{name};")


def _clean(text: str) -> str:
    text = text.strip()
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text


def _extract_story(cells: List[Dict[str, str]], sprint_folder: str) -> Dict[str, str]:
    story: Dict[str, str] = {"sprint_folder": sprint_folder}
    seen_status = False

    for cell in cells:
        cls = cell["class"].lower()
        content = cell["content"]

        if "status" in cls and "statuscategory" not in cls and not seen_status:
            seen_status = True
            story["status"] = content
            continue
        if "statuscategory" in cls:
            continue

        field = None
        for css_key, field_name in FIELD_MAP.items():
            if css_key in cls:
                field = field_name
                break

        if field and field not in story:
            if field == "issue_key":
                m = cfg.STORY_ID_PATTERN_LOOSE.search(content)
                story[field] = m.group() if m else content.strip()
            else:
                story[field] = content

    return story


def _jira_wiki_to_md(text: str) -> str:
    text = re.sub(r"^h([1-6])\.\s*", lambda m: "#" * int(m.group(1)) + " ", text, flags=re.MULTILINE)
    text = re.sub(r"\*([^*\n]+)\*", r"**\1**", text)
    text = re.sub(r"\{\{([^}]+)\}\}", r"`\1`", text)
    text = re.sub(r"^\*\s", "- ", text, flags=re.MULTILINE)
    text = re.sub(r"^#\s", "1. ", text, flags=re.MULTILINE)
    return text


def story_to_markdown(story: Dict[str, str]) -> str:
    key = story.get("issue_key", "UNKNOWN")
    summary = story.get("summary", "No summary")
    lines = [f"# {key}: {summary}", ""]

    meta_fields = [
        ("Sprint",       story.get("sprint_name") or story.get("sprint_folder", "")),
        ("Status",       story.get("status", "")),
        ("Type",         story.get("issue_type", "")),
        ("Priority",     story.get("priority", "")),
        ("Resolution",   story.get("resolution", "")),
        ("Assignee",     story.get("assignee", "")),
        ("Reporter",     story.get("reporter", "")),
        ("Components",   story.get("components", "")),
        ("Epic",         story.get("epic", "") or story.get("epic_theme", "")),
        ("Story Points", story.get("story_points", "")),
        ("Labels",       story.get("labels", "")),
        ("Environment",  story.get("environment", "")),
        ("Created",      story.get("created", "")),
        ("Resolved",     story.get("resolved", "")),
        ("Updated",      story.get("updated", "")),
    ]
    for label, value in meta_fields:
        value = value.strip()
        if value and value != "&nbsp;":
            lines.append(f"- **{label}**: {value}")
    lines.append("")

    rich_sections = [
        ("Description",              "description"),
        ("Acceptance Criteria",      "acceptance_criteria"),
        ("Solution",                 "solution"),
        ("Build Components",         "build_components"),
        ("Deployment Instructions",  "deployment_instructions"),
        ("Root Cause",               "root_cause"),
        ("Root Cause Type",          "root_cause_type"),
    ]
    for heading, field in rich_sections:
        content = _clean(story.get(field, ""))
        if content and content != "&nbsp;":
            content = _jira_wiki_to_md(content)
            lines.append(f"## {heading}")
            lines.append("")
            lines.append(content)
            lines.append("")

    link_sections = [
        ("Linked Issues", "linked_issues"),
        ("Sub-tasks",     "subtasks"),
    ]
    for heading, field in link_sections:
        raw = story.get(field, "").strip()
        if raw:
            ids = cfg.STORY_ID_PATTERN_LOOSE.findall(raw)
            if ids:
                lines.append(f"## {heading}")
                lines.append("")
                for sid in ids:
                    lines.append(f"- {sid}")
                lines.append("")

    return "\n".join(lines) + "\n"


def process_sprint(sprint_dir: Path, force: bool = False) -> int:
    html_files = list(sprint_dir.glob(cfg.CONFIG["sprints"]["html_export_pattern"]))
    if not html_files:
        return 0

    stories_dir = sprint_dir / "stories"

    if stories_dir.exists() and not force:
        existing = list(stories_dir.glob("*.md"))
        if existing:
            print(f"  Skipping {sprint_dir.name} — {len(existing)} story files exist (use --force)")
            return 0

    html_file = html_files[0]
    print(f"  Parsing {html_file.name} …")

    parser = StoryHTMLParser()
    parser.feed(html_file.read_text(encoding="utf-8", errors="replace"))

    if not parser.stories:
        print(f"  WARNING: No stories found in {html_file.name}")
        return 0

    stories_dir.mkdir(exist_ok=True)
    count = 0

    for cells in parser.stories:
        story = _extract_story(cells, sprint_dir.name)
        issue_key = story.get("issue_key")
        if not issue_key:
            continue

        md_content = story_to_markdown(story)
        out_path = stories_dir / f"{issue_key}.md"
        out_path.write_text(md_content, encoding="utf-8")
        count += 1

    print(f"    → {count} story files in {stories_dir}/")
    return count


def main() -> int:
    cfg.banner("split-sprint-stories")

    parser = argparse.ArgumentParser(description="Split JIRA sprint HTML into per-story markdown")
    parser.add_argument("--sprint", help="Process only this sprint folder (e.g. 'Sprint 14')")
    parser.add_argument("--force", action="store_true", help="Overwrite existing story files")
    args = parser.parse_args()

    if not cfg.SPRINTS_DIR.exists():
        print(f"No sprints directory at {cfg.SPRINTS_DIR}. Nothing to do.")
        return 0

    if args.sprint:
        target = cfg.SPRINTS_DIR / args.sprint
        if not target.exists():
            print(f"ERROR: Sprint folder not found: {target}")
            return 1
        sprint_dirs = [target]
    else:
        sprint_dirs = cfg.find_sprint_dirs()

    total = 0
    for sprint_dir in sprint_dirs:
        total += process_sprint(sprint_dir, force=args.force)

    print(f"\n✓ {total} story files written across {len(sprint_dirs)} sprints.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
