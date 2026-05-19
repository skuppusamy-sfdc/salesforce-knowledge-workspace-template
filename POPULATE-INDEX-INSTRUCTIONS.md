# How to Populate the Sprint Index

## Purpose
Populating the SPRINT-INDEX.md file will dramatically reduce token consumption by enabling quick lookups without reading full HTML files.

---

## 🎯 What to Populate

The index has three main sections to populate:

1. **Sprint Overview** - Story counts and dates
2. **Story Summaries** - Frequently accessed stories
3. **Component Index** - Which stories modified which components
4. **Story Number Directory** - Quick sprint lookup by story number

---

## 🚀 Quick Population (Ask Cursor)

### Option 1: Populate Sprint Counts (Fastest)
```
"For each sprint HTML file, count the stories and update SPRINT-INDEX.md 
with the counts. Use grep -c to count efficiently."
```

**Time**: 2-3 minutes
**Token Cost**: ~1,000 tokens
**Benefit**: Enables instant story count queries

### Option 2: Populate Sprint 14 Details (Most Useful)
```
"Parse Sprint 14 HTML and add the top 20 most recent stories to the 
SPRINT-INDEX.md with their Issue Key, Summary, and Components"
```

**Time**: 5 minutes
**Token Cost**: ~5,000 tokens
**Benefit**: Fast access to most current sprint

### Option 3: Populate Component Index (High Value)
```
"Search all sprint HTML files and create a component index showing 
which stories modified: Account, Opportunity, Contact, Flow, and Apex"
```

**Time**: 10 minutes
**Token Cost**: ~8,000 tokens
**Benefit**: Fast component-based searches

### Option 4: Full Index Population (Comprehensive)
```
"Populate the complete SPRINT-INDEX.md by:
1. Counting stories in all sprints
2. Extracting story summaries for Sprint 13 and 14
3. Building component index for common components
4. Creating story number directory for recent sprints"
```

**Time**: 20 minutes
**Token Cost**: ~15,000 tokens
**Benefit**: Maximum query efficiency going forward

---

## 📋 Step-by-Step Manual Approach

If you want to populate gradually:

### Step 1: Count Stories Per Sprint
Ask Cursor:
```
"Count stories in all sprint HTML files using grep and update 
the Sprint Overview table in SPRINT-INDEX.md"
```

### Step 2: Add Recent Sprint Summaries
Ask Cursor:
```
"Extract Issue Key, Summary, Status, and Components for all stories 
in Sprint 14 and add to SPRINT-INDEX.md under Sprint 14 section"
```

### Step 3: Build Component Index
Ask Cursor:
```
"Search all sprints for stories mentioning 'Account' and add them 
to the Component Index section under Account Object"
```

Repeat for other components:
- Opportunity
- Contact
- Case
- Flow
- Apex/Trigger
- Validation Rules

### Step 4: Create Story Number Directory
Ask Cursor:
```
"For Sprint 13 and 14, create a list mapping each story number to 
its sprint and add to the Story Number Directory section"
```

---

## 🔄 Incremental Population Strategy

You don't need to populate everything at once. Use this strategy:

### Week 1: Minimal Index
- Populate sprint counts
- Add Sprint 14 story list
- Cost: ~2,000 tokens
- Savings: 50% on future queries

### Week 2: Enhanced Index
- Add Sprint 13 story list
- Start component index for Account
- Cost: ~3,000 tokens
- Savings: 65% on future queries

### Week 3: Comprehensive Index
- Add component index for top 5 components
- Add story number directory
- Cost: ~5,000 tokens
- Savings: 80% on future queries

### Ongoing: Maintain Index
- Add frequently queried stories
- Update component index as you discover patterns
- Cost: ~100-500 tokens per update
- Maintains 80%+ savings

---

## 💡 Smart Population Tips

### Tip 1: Start with What You Use Most
If you frequently ask about Sprint 14, populate that first.

### Tip 2: Populate Based on Questions
After asking a question that required reading HTML, add that info to the index.

Example:
```
You ask: "What stories in Sprint 13 modified Account?"
Cursor reads HTML (8,000 tokens)
Then: "Add those stories to the component index for Account"
Next time: Index lookup only (50 tokens)
```

### Tip 3: Use Grep for Population
Ask Cursor to use shell commands:
```
"Use grep to find all stories with 'Account' in component column 
and add to index"
```

Much cheaper than reading full HTML files.

### Tip 4: Batch Population Requests
```
"In one pass, populate:
- Story counts for all sprints
- Sprint 14 story list
- Component index for Account and Opportunity"
```

More efficient than three separate requests.

---

## 📊 Expected Token Savings

### Before Index (No Index)
```
Query: "Which sprint has story PR1050558-123?"
Process: Read all 20 HTML files searching
Cost: ~100,000 tokens
```

### After Minimal Index (Counts + Recent Sprint)
```
Query: "Which sprint has story PR1050558-123?"
Process: Check story directory, grep if not found
Cost: ~200 tokens
Savings: 99.8%
```

### After Full Index (All Sections Populated)
```
Query: "What stories modified Account?"
Process: Check component index
Cost: ~50 tokens
Savings: 99.95%
```

### Investment vs Savings
```
Index Population Cost: ~10,000-15,000 tokens (one time)
Average Query Savings: ~8,000 tokens per query
Break Even: 2-3 queries
Typical Use: 20-50 queries per week

Return on Investment:
- Week 1: 40,000 tokens saved (after 2 queries)
- Month 1: 400,000 tokens saved
- Year 1: 4,800,000 tokens saved
```

---

## 🎯 Recommended Population Order

### Priority 1: Sprint Counts (Do First)
```
"Count stories in all sprints and update Sprint Overview table"

Cost: ~500 tokens
Time: 2 minutes
Impact: Enables instant counts
```

### Priority 2: Recent Sprint Details (Do Second)
```
"Extract all stories from Sprint 14 and add to index"

Cost: ~5,000 tokens
Time: 5 minutes
Impact: Fast access to current work
```

### Priority 3: Component Index (Do Third)
```
"Build component index for Account, Opportunity, Contact"

Cost: ~5,000 tokens
Time: 10 minutes
Impact: Fast component searches
```

### Priority 4: Story Directory (Do Fourth)
```
"Create story number directory for Sprint 13-14"

Cost: ~3,000 tokens
Time: 5 minutes
Impact: Fast story lookups
```

**Total Investment**: ~13,500 tokens
**Break Even**: After ~2 complex queries
**Annual Savings**: 4-5 million tokens

---

## 🔧 Quick Commands for Cursor

Copy and paste these:

### Command 1: Count All Sprints
```
"Execute this for each sprint HTML file and update SPRINT-INDEX.md:
grep -c 'class=\"issuekey\"' [file]
Update the Sprint Overview table with counts."
```

### Command 2: Extract Sprint 14 Stories
```
"Parse Sprint 14 HTML table and extract:
- Issue Key
- Summary
- Status
- Components

Add all stories to SPRINT-INDEX.md under Sprint 14 section in table format."
```

### Command 3: Build Component Index
```
"For each sprint HTML file, grep for 'Account' and extract the story numbers.
Add all findings to Component Index section under Account Object.
Use format: Sprint X: Story PR1050558-###"
```

### Command 4: Create Story Directory
```
"For Sprint 13 and 14, extract all Issue Keys and create a directory mapping:
PR1050558-XXX → Sprint N

Add to Story Number Directory section alphabetically."
```

---

## 📈 Maintenance Plan

### Daily (If Active Use)
- Add any frequently queried stories to index
- Cost: ~100 tokens
- Time: 1 minute

### Weekly
- Review queries from the week
- Add patterns to component index
- Cost: ~500 tokens
- Time: 5 minutes

### Per New Sprint
- When new sprint HTML added, populate its entry
- Cost: ~5,000 tokens
- Time: 5 minutes

### Monthly
- Review and clean up index
- Add any missing components
- Cost: ~1,000 tokens
- Time: 10 minutes

---

## 🎉 Start Populating Now!

**Recommended First Step:**
```
"Count stories in all sprint HTML files and update the Sprint Overview 
table in SPRINT-INDEX.md. Use grep -c 'class=\"issuekey\"' for efficiency."
```

**This takes 2 minutes and provides immediate value!**

After that, continue with Priority 2, 3, and 4 as time permits.

---

**Remember**: Every token spent populating the index saves 100+ tokens on future queries. It's an investment that pays off immediately!
