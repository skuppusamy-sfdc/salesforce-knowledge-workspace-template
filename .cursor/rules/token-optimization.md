# Token Optimization Rules

## Purpose
Minimize token consumption while maintaining accurate, helpful responses about JIRA stories.

---

## 🎯 Core Optimization Strategy

### 1. Check Per-Story Markdown Files First (Saves ~95% tokens)
**ALWAYS** look for a per-story markdown file before reading sprint HTML files.

```
User asks: "What are the AC for story PR1050558-123?"

❌ BAD (High tokens):
- Read entire 12,000 line HTML file
- Cost: ~8K tokens

✅ GOOD (Low tokens):
- Read knowledge/sprints/Sprint N/stories/PR1050558-123.md
- Cost: ~200-500 tokens (full story with AC, Solution, Description)
```

Per-story files live at `knowledge/sprints/Sprint N/stories/PR1050558-XXX.md` and contain the complete story metadata, AC, Solution, and Description in clean markdown.

### 2. Check Index for Sprint Lookup (Saves ~90% tokens)
**ALWAYS** check `/knowledge/sprints/SPRINT-INDEX.md` to find which sprint a story belongs to.

```
User asks: "What sprint is story PR1050558-123 in?"

❌ BAD (High tokens):
- Read all 20 HTML files searching for story
- Cost: ~100K+ tokens

✅ GOOD (Low tokens):
- Check SPRINT-INDEX.md story directory
- If not there, use targeted grep
- Cost: ~100 tokens
```

### 3. Use Targeted Search for Bulk Queries (Saves ~80% tokens)
Only use shell grep or HTML files when you need to search across stories or don't have a per-story file.

```
User asks: "Which stories in Sprint 14 mention Account?"

✅ GOOD:
- Use grep across knowledge/sprints/Sprint 14/stories/*.md
- Cost: ~200 tokens for the search + reading matching files
```

### 3. Provide Summaries Not Full Content (Saves ~70% tokens)
When user asks for "all stories", provide summaries, not full details.

```
User asks: "What stories are in Sprint 14?"

❌ BAD (High tokens):
- Extract every field for every story
- Show complete AC and Solution for all
- Cost: ~15K tokens

✅ GOOD (Low tokens):
- Provide: Issue Key, Summary, Status (table format)
- Offer to drill down on specific stories
- Cost: ~2K tokens
```

### 4. Cache Recent Queries (Saves ~60% tokens)
Remember context from recent questions in same conversation.

```
Conversation:
User: "What stories are in Sprint 14?"
AI: [Provides list]
User: "Tell me more about the first one"

✅ GOOD (Low tokens):
- Remember which stories were just listed
- Reference "first one" from context
- Don't re-read HTML
```

### 5. Progressive Disclosure (Saves ~50% tokens)
Start with minimal info, offer to expand.

```
User asks: "Tell me about story PR1050558-123"

✅ GOOD (Low tokens):
- First: Show summary, status, components (200 tokens)
- Then ask: "Would you like AC, Solution, or full details?"
- User chooses, read only what's needed
```

---

## 📋 Specific Optimization Rules

### Rule 1: Sprint Lookup Optimization

**When asked which sprint has a story:**
1. Check SPRINT-INDEX.md first
2. If not there, use grep: `grep -l "PR1050558-123" knowledge/sprints/**/*.html`
3. Only read HTML if grep finds the file

**Token savings**: 95%

### Rule 2: Story Count Optimization

**When asked how many stories in a sprint:**
1. Check SPRINT-INDEX.md first
2. If not there, use: `grep -c "<tr" "knowledge/sprints/Sprint 14/SCP HC Sprint 14.html"`
3. Don't read full HTML just to count

**Token savings**: 99%

### Rule 3: Component Search Optimization

**When asked which stories modified a component:**
1. Check component index in SPRINT-INDEX.md
2. Use grep across files: `grep -l "Account" knowledge/sprints/**/*.html`
3. Then read only matching files for story extraction

**Token savings**: 90%

### Rule 4: Acceptance Criteria Extraction

**When asked for AC of specific story:**
1. Read the per-story file: `knowledge/sprints/Sprint N/stories/PR1050558-123.md`
2. The AC section is already extracted and formatted in the markdown
3. Fall back to HTML grep only if the per-story file doesn't exist

**Token savings**: 95%

### Rule 5: Sprint Comparison Optimization

**When comparing sprints:**
1. Check SPRINT-INDEX.md for high-level stats first
2. Ask user what aspect to compare (stories? components? status?)
3. Read only relevant sections of each HTML

**Token savings**: 70%

---

## 🔍 Smart Search Patterns

### Pattern 1: Two-Step Lookup
```python
Step 1: Cheap search to locate
  - Use index, grep, or shell commands
  - Cost: 50-200 tokens

Step 2: Targeted read if needed
  - Read only relevant file sections
  - Cost: 500-2000 tokens

Total: 550-2200 tokens vs 8000+ tokens for full read
```

### Pattern 2: Summary-First Approach
```python
Step 1: Provide brief summary
  - Issue Key, Summary, Status only
  - Cost: ~100 tokens per story

Step 2: Offer details
  - "Would you like AC? Solution? Full details?"
  - Read only what user requests

Total: 100 tokens initially vs 1000+ tokens if showing everything
```

### Pattern 3: Index-Driven Queries
```python
Step 1: Check SPRINT-INDEX.md
  - Story directory, component index, counts
  - Cost: ~200 tokens

Step 2: Use index info to answer OR guide search
  - If in index, answer immediately
  - If not, search only relevant sprint

Total: 200-500 tokens vs 5000+ for blind search
```

---

## 🎯 Response Templates (Token-Efficient)

### Template 1: Story List (Minimal)
```markdown
**Sprint 14 Stories** (56 total):

| Issue Key | Summary | Status |
|-----------|---------|--------|
| PR1050558-1 | Story title | Done |
| PR1050558-2 | Story title | Done |
... (truncate if >20)

Want details on any specific story? (Saves tokens)
```

### Template 2: Single Story (Progressive)
```markdown
**Story PR1050558-123**
- Summary: [Title]
- Status: Done
- Components: Account, Opportunity

🔍 Available Details:
- [A] Acceptance Criteria
- [S] Solution approach  
- [F] Full details

Which would you like? (Type A, S, or F)
```

### Template 3: Component Search (Targeted)
```markdown
**Stories affecting "Account" object:**

Sprint 14:
- PR1050558-123: Modified Account fields
- PR1050558-145: Added Account validation

Sprint 13:
- PR1050558-089: Account trigger changes

Want AC or Solution for any of these? (Saves tokens)
```

---

## 🚫 Anti-Patterns (What NOT to Do)

### ❌ Anti-Pattern 1: Reading All HTML Files
```
User: "Find story PR1050558-123"
BAD: Read all 20 HTML files sequentially
COST: 100K+ tokens
```

### ❌ Anti-Pattern 2: Extracting Everything
```
User: "What's in Sprint 14?"
BAD: Extract all fields for all 56 stories
COST: 20K+ tokens
```

### ❌ Anti-Pattern 3: Re-reading Same Content
```
Conversation flow - user asks 3 questions about same story
BAD: Read HTML 3 times
COST: 24K tokens
```

### ❌ Anti-Pattern 4: Full File Reads for Counts
```
User: "How many stories in Sprint 14?"
BAD: Read entire 12K line HTML to count
COST: 8K tokens
```

### ❌ Anti-Pattern 5: Searching Without Indexing
```
User: "Which stories modified Account?"
BAD: Read all 20 HTMLs looking for "Account"
COST: 120K+ tokens
```

---

## 📊 Token Budget Guidelines

### Query Type vs Token Budget

| Query Type | Token Budget | Method |
|------------|--------------|--------|
| Story lookup (which sprint) | 50-200 | Index or grep |
| Story count | 50-100 | Index or grep -c |
| Story list (summary) | 500-2000 | Read HTML headers only |
| Single story (full) | 1000-3000 | Targeted read |
| Component search | 500-5000 | Grep + targeted read |
| Sprint comparison | 2000-8000 | Index + selective read |
| Cross-sprint analysis | 5000-15000 | Multiple targeted reads |

### Conversation Token Budgets

| Conversation Type | Total Budget | Strategy |
|-------------------|--------------|----------|
| Simple lookup | <1K tokens | Use index/grep only |
| Story exploration | 2-5K tokens | Progressive disclosure |
| Sprint analysis | 5-10K tokens | Summaries + targeted details |
| Deep analysis | 10-20K tokens | Selective full reads |

---

## 🔧 Implementation Commands

### Command 1: Find Story Sprint (Cheap)
```bash
# Cost: ~50 tokens
grep -l "PR1050558-123" knowledge/sprints/**/*.html | head -1
```

### Command 2: Count Stories (Cheap)
```bash
# Cost: ~50 tokens
grep -c "class=\"issuekey\"" "knowledge/sprints/Sprint 14/SCP HC Sprint 14.html"
```

### Command 3: Read Per-Story File (Cheapest for single story)
```bash
# Cost: ~200-500 tokens — full story content in clean markdown
cat "knowledge/sprints/Sprint 14/stories/PR1050558-123.md"
```

### Command 4: Find Component Mentions (Medium)
```bash
# Cost: ~200 tokens
grep -l "Account" knowledge/sprints/**/*.html
```

### Command 5: Get Sprint Story Count (Cheap)
```bash
# Cost: ~100 tokens
for file in knowledge/sprints/**/*.html; do
  echo "$file: $(grep -c 'class=\"issuekey\"' "$file")"
done
```

---

## 📈 Expected Token Savings

### Before Optimization (Typical Query)
```
User: "What stories are in Sprint 14?"
- Read full HTML: 8,000 tokens
- Extract all fields: 12,000 tokens
- Format response: 15,000 tokens
Total: ~15,000 tokens
```

### After Optimization (Same Query)
```
User: "What stories are in Sprint 14?"
- Check index: 200 tokens
- Grep story count: 50 tokens
- Read headers only: 1,500 tokens
- Format summary: 2,000 tokens
Total: ~2,000 tokens
```

**Savings: 87%**

### Multiple Queries in Conversation
```
Before:
- Query 1: 15K tokens
- Query 2: 15K tokens
- Query 3: 15K tokens
Total: 45K tokens

After:
- Query 1: 2K tokens (initial read)
- Query 2: 500 tokens (use context)
- Query 3: 500 tokens (use context)
Total: 3K tokens
```

**Savings: 93%**

---

## 🎓 Best Practices Summary

1. **Always check index first** - SPRINT-INDEX.md
2. **Use shell commands for lookups** - grep, grep -c, grep -l
3. **Read targeted sections** - not entire files
4. **Provide summaries first** - offer details on request
5. **Remember context** - don't re-read same content
6. **Progressive disclosure** - start minimal, expand as needed
7. **Update index** - add frequently accessed stories
8. **Ask clarifying questions** - before expensive operations

---

## 🔄 Continuous Optimization

### Weekly: Update Index
- Add frequently queried stories to SPRINT-INDEX.md
- Populate component index
- Add story number directory entries

### Per Conversation: Build Context
- Remember which HTML files already read
- Cache story data from current conversation
- Reference previous responses

### Per Query: Choose Strategy
- Simple lookup → Index/grep only
- Summary needed → Headers only
- Full details → Targeted read
- Analysis → Multiple targeted reads

---

**Target**: Reduce average token consumption by 80-90%
**Method**: Smart indexing + targeted reading + progressive disclosure
**Maintenance**: Keep SPRINT-INDEX.md updated with frequent queries
