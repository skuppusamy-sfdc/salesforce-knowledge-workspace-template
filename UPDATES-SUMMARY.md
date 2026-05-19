# Workspace Updates Summary

## 🔥 CRITICAL FIX (May 19, 2026)

### JIRA Wiki Markup Strikethrough Bug — RESOLVED

**Issue**: The script `split-sprint-stories.py` was not filtering JIRA wiki markup strikethrough (`-text-`) or color markup (`{color:#hex}`), causing deprecated/withdrawn Acceptance Criteria to appear as active requirements in the per-story markdown files and all downstream indexes.

**Impact**: 
- 20-36% of stories in some sprints contained unfiltered JIRA markup
- Deprecated ACs appeared as current requirements
- AI analysis included withdrawn content as authoritative

**Root Cause**:
- `.cursor/rules/html-story-parsing.md` documented HTML strikethrough tags (`<s>`, `<del>`, `<strike>`) that don't exist in the JIRA exports
- Actual JIRA exports use JIRA wiki markup: `-text-` for strikethrough and `{color:#hex}text{color}` for highlighting
- The `_clean()` function in `split-sprint-stories.py` only collapsed blank lines; it never filtered markup

**Fix Applied**:
1. ✅ Updated `scripts/split-sprint-stories.py` — added regex filters in `_clean()` function to strip `-text-` and `{color:...}` markup
2. ✅ Updated `.cursor/rules/html-story-parsing.md` — corrected documentation to reflect actual JIRA wiki markup format, not HTML tags

**Next Steps** (manual):
1. Regenerate all per-story markdown files: `python scripts/split-sprint-stories.py --force`
2. Rebuild all aggregate indexes (AC-INDEX.md, SOLUTION-INDEX.md, etc.)

**Validation**: Grep analysis confirmed zero instances of HTML strikethrough tags across 20 sprint HTML files; all strikethrough uses JIRA wiki `-text-` format.

---

## ✅ What Was Updated (April 2026)

The workspace has been updated to work with your **HTML story files** and emphasize its **supplemental relationship** to your code repository.

---

## 🔄 Key Changes

### 1. HTML Story File Support

**Before**: Workspace expected markdown files for each story
**Now**: Workspace works directly with JIRA HTML exports

**What Changed:**

- ✅ Added HTML parsing rules in `.cursor/rules/html-story-parsing.md`
- ✅ Updated AI configuration to read HTML table structures
- ✅ Focus on **Acceptance Criteria** and **Solution** columns
- ✅ Can parse 20 sprint HTML files (Sprint 1-14)

### 2. Supplemental Workspace Concept

**Before**: Unclear relationship to actual code
**Now**: Explicitly positioned as supplemental to code repository

**What Changed:**

- ✅ All documentation emphasizes: **Requirements here, Code elsewhere**
- ✅ Story numbers (Issue Keys) bridge both worlds
- ✅ Clear guidance: Use for planning, not coding
- ✅ Reminders throughout that implementation lives in separate repository

### 3. Updated Documentation

**New Files Created:**

1. **HTML-STORIES-GUIDE.md** - Complete guide for working with HTML files
2. **.cursor/rules/html-story-parsing.md** - Detailed HTML parsing rules for AI

**Updated Files:**

1. **README.md** - Added supplemental workspace explanation, HTML file info
2. **START-HERE.md** - Simplified since data is loaded, added HTML guidance
3. **INDEX.md** - Reorganized to highlight HTML guide, de-emphasize setup
4. **knowledge/sprints/README.md** - Complete rewrite for HTML format
5. **.cursor/AGENTS.md** - Added HTML parsing instructions, supplemental context
6. **.cursor/rules/salesforce-knowledge.md** - Added HTML-first search strategy

---

## 📊 Your Current State

### Data Loaded

✅ **20 Sprint HTML Files** in `/knowledge/sprints/`:

- Sprint 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
- Sprint 12.1, 12.2, 12.3, 12.4, 12.5, 12.6
- Sprint 13, 14

### Each HTML File Contains

- Table with rows = stories
- Columns: Issue Key, Summary, **Acceptance Criteria**, **Solution**, Status, Components, etc.
- Ready to query with Cursor AI

### What You Can Do Now

✅ Ask about any story by Issue Key
✅ Analyze sprints
✅ Extract Acceptance Criteria
✅ Review Solution approaches
✅ Find stories by component
✅ Compare across sprints

---

## 🎯 Focus Areas

### Priority 1: Acceptance Criteria

The AI is configured to **heavily focus** on the Acceptance Criteria column when analyzing stories. This defines what "done" means.

**Example Questions:**

```
"What are the acceptance criteria for story PR1050558-XXX?"
"List all AC from Sprint 14"
"Which stories have incomplete AC?"
```

### Priority 2: Solution

The AI is configured to **heavily focus** on the Solution column which describes the technical approach.

**Example Questions:**

```
"What's the solution approach for story PR1050558-XXX?"
"Extract all solutions from Sprint 13"
"Compare solutions between story X and Y"
```

---

## 🔗 Relationship to Code Repository

### This Workspace (Requirements & Planning)

```
/knowledge/sprints/*.html
├── Contains: Acceptance Criteria, Solutions, Requirements
├── Purpose: Understanding what to build
└── Use for: Planning, analysis, design
```

### Your Code Repository (Implementation)

```
Separate Git Repository
├── Contains: Apex, Flows, Objects, Fields, Test Classes
├── Purpose: Actual Salesforce metadata and code
└── Use for: Implementation, deployment, version control
```

### The Bridge

```
Story Number (Issue Key like PR1050558-123)
├── In HTML files: Links to requirements and AC
└── In code commits: Links implementation back to story
```

---

## 🚀 How to Use

### 1. Start Simple

```
"What stories are in Sprint 14?"
"How many stories are completed in Sprint 13?"
```

### 2. Dive into Specific Stories

```
"Tell me about story PR1050558-[number]"
"What are the acceptance criteria for story [number]?"
"What's the solution approach for story [number]?"
```

### 3. Cross-Sprint Analysis

```
"What stories across all sprints mention 'Account'?"
"Which components have been modified most?"
"Compare Sprint 13 and Sprint 14"
```

### 4. Before Implementation

```
Read story AC and Solution (here)
   ↓
Ask Cursor for clarification/design help (here)
   ↓
Switch to code repository
   ↓
Implement in Salesforce (there)
   ↓
Commit with story number (there)
```

---

## 📚 Updated Documentation Structure

### Must Read (New Priority Order)

1. **START-HERE.md** - Quick start (updated for HTML)
2. **HTML-STORIES-GUIDE.md** - Essential guide for your data
3. **Your role's guideline** - Role-specific workflows

### Reference Documentation

- **README.md** - Overview (updated with HTML context)
- **INDEX.md** - Complete documentation index (reorganized)
- **PROJECT-OVERVIEW.md** - Deep concepts
- **WORKFLOW-GUIDE.md** - Visual workflows

### Configuration Files (Updated)

- `.cursor/AGENTS.md` - Main AI config (HTML + supplemental)
- `.cursor/rules/html-story-parsing.md` - HTML parsing rules (new!)
- `.cursor/rules/salesforce-knowledge.md` - Knowledge retrieval (updated)
- `.cursor/rules/no-code-development.md` - Unchanged
- `.cursor/rules/conflict-detection.md` - Unchanged

---

## 🎓 Example Questions You Can Ask Right Now

### Understanding Your Data

```
"How many sprints do I have loaded?"
"What's the structure of the HTML files?"
"Show me a sample story from Sprint 14"
```

### Story Analysis

```
"List all stories in Sprint 14"
"What are the acceptance criteria for story PR1050558-XXX?"
"Show me the solution for story PR1050558-XXX"
"What's the status of story PR1050558-XXX?"
```

### Component Tracking

```
"What stories in Sprint 14 affect the Account object?"
"Show me all stories that mention 'Flow' in the solution"
"Which components are modified most across all sprints?"
```

### Cross-Sprint Insights

```
"Compare Sprint 13 and Sprint 14"
"What stories across all sprints modified [component]?"
"Show progression of [feature] across sprints"
```

### Planning & Design

```
"Based on story XXX's solution, what should I consider?"
"Are there similar stories from previous sprints?"
"What approach did we use for similar work in the past?"
```

---

## 🎉 You're Ready!

Your workspace is now optimized for:

- ✅ Reading HTML story files directly
- ✅ Focusing on Acceptance Criteria and Solutions
- ✅ Understanding its supplemental role to code repository
- ✅ Cross-sprint analysis and planning
- ✅ Supporting all 4 roles (Solution Architect, Technical Architect, Developer, Tester)

**Start exploring your stories now!**

Try this first question:

```
"What stories are in Sprint 14 and what are their statuses?"
```

---

## 📞 Need Help?

- **Understanding HTML files?** → Read `HTML-STORIES-GUIDE.md`
- **Getting started?** → Read `START-HERE.md`
- **Role-specific guidance?** → Read `guidelines/[your-role].md`
- **All documentation?** → Check `INDEX.md`

---

**Last Updated**: May 19, 2026 (Critical strikethrough bug fix)
**Sprints Loaded**: 20 (Sprint 1 through Sprint 14)
**Ready to Use**: Yes! ✅ (Regenerate per-story files to apply fix)