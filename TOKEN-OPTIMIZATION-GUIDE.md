# Token Optimization Guide for Users

## 🎯 How to Get Answers Using Fewer Tokens

This guide helps you ask questions efficiently to minimize token consumption (which reduces costs and improves speed).

---

## 💡 Key Concept: Progressive Questions

Instead of asking for everything at once, ask progressively:

### ❌ High Token Approach

```
"Tell me everything about all stories in Sprint 14 including full acceptance 
criteria, solutions, descriptions, and all fields"

Cost: ~15,000 tokens
```

### ✅ Low Token Approach

```
"What stories are in Sprint 14?"
→ Get summary (2,000 tokens)

"Show me acceptance criteria for story PR1050558-123"
→ Get specific AC (500 tokens)

"What's the solution for that story?"
→ Get solution (500 tokens)

Total: ~3,000 tokens (80% savings!)
```

---

## 📋 Efficient Question Patterns

### Pattern 1: Lookup Questions (Very Cheap)

**Cost: 50-200 tokens**

```
"Which sprint contains story PR1050558-123?"
"How many stories are in Sprint 14?"
"Which sprints are loaded?"
"What's the status of story PR1050558-XXX?"
```

**Why cheap**: Uses index or grep, no HTML reading needed

### Pattern 2: Summary Questions (Cheap)

**Cost: 500-2,000 tokens**

```
"List all stories in Sprint 14" (gets summary table)
"What stories in Sprint 13 are Done?"
"Show me story titles from Sprint 12"
```

**Why cheap**: Reads headers only, not full details

### Pattern 3: Specific Story Questions (Medium)

**Cost: 1,000-3,000 tokens**

```
"What are the acceptance criteria for story PR1050558-123?"
"Show me the solution for story PR1050558-456?"
"What components does story PR1050558-789 affect?"
```

**Why medium**: Reads one story's details, not entire sprint

### Pattern 4: Search Questions (Medium-High)

**Cost: 2,000-8,000 tokens**

```
"Which stories across all sprints mention 'Account'?"
"Find stories with 'validation' in acceptance criteria"
"What stories modified the Opportunity object?"
```

**Why higher**: Searches multiple files, but uses grep first

### Pattern 5: Analysis Questions (High)

**Cost: 5,000-15,000 tokens**

```
"Compare Sprint 13 and Sprint 14 in detail"
"Analyze all stories related to feature X across sprints"
"Deep dive into all Account-related stories with full AC and solutions"
```

**Why high**: Requires reading multiple stories in detail

---

## 🎓 Best Practices for Efficient Queries

### 1. Start Broad, Then Narrow

```
✅ GOOD:
"What stories are in Sprint 14?" 
  → See list
"Tell me more about PR1050558-123"
  → Get specific story
"Show me the acceptance criteria"
  → Get just AC

Cost: ~3,000 tokens total

❌ BAD:
"Show me all stories in Sprint 14 with complete details"

Cost: ~15,000 tokens
```

### 2. Be Specific with Story Numbers

```
✅ GOOD:
"What are the AC for story PR1050558-123?"

Cost: ~1,000 tokens

❌ BAD:
"Show me all acceptance criteria for all stories"

Cost: ~50,000 tokens
```

### 3. Ask What You Need, Not Everything

```
✅ GOOD:
"What's the status of story PR1050558-123?"

Cost: ~500 tokens

❌ BAD:
"Tell me everything about story PR1050558-123"

Cost: ~3,000 tokens
```

### 4. Use Follow-Up Questions

```
✅ GOOD (uses context):
"What stories are in Sprint 14?"
  → Get list (2,000 tokens)
"What about the first three?"
  → Uses context (500 tokens)

Total: 2,500 tokens

❌ BAD (re-reads):
"What stories are in Sprint 14?"
  → Get list (2,000 tokens)
"Show me details for PR1050558-1, PR1050558-2, PR1050558-3"
  → Re-reads everything (5,000 tokens)

Total: 7,000 tokens
```

### 5. Request Summaries First

```
✅ GOOD:
"Summarize Sprint 14"
  → Get overview (1,500 tokens)
"Tell me more about the highest priority stories"
  → Targeted details (2,000 tokens)

Total: 3,500 tokens

❌ BAD:
"Give me complete details on all Sprint 14 stories"

Cost: 20,000 tokens
```

---

## 📊 Token Cost Comparison Table


| Question Type     | Example                          | Token Cost | Alternative       |
| ----------------- | -------------------------------- | ---------- | ----------------- |
| Story lookup      | "Which sprint has story XXX?"    | 50-200     | Most efficient    |
| Story count       | "How many stories in Sprint 14?" | 50-100     | Most efficient    |
| Story list        | "What stories are in Sprint 14?" | 500-2K     | Efficient         |
| Single story AC   | "AC for story XXX?"              | 1-3K       | Efficient         |
| Component search  | "Stories modifying Account?"     | 2-8K       | Medium            |
| Sprint comparison | "Compare Sprint 13 vs 14"        | 5-15K      | Use summary first |
| Deep analysis     | "Full details on all stories"    | 20-50K+    | Break into parts  |


---

## 🔧 Power User Tips

### Tip 1: Use the Index

Ask Cursor to check the index first:

```
"Check the sprint index - which sprint has story PR1050558-123?"

Much cheaper than:
"Find story PR1050558-123"
```

### Tip 2: Ask for Just What You Need

```
Instead of: "Tell me about story XXX"
Try: "What are the acceptance criteria for story XXX?"
```

### Tip 3: Request Progressive Disclosure

```
"Show me Sprint 14 story list"
"Now show details for the top 3"
"Now show AC for the first one"
```

### Tip 4: Build on Context

```
After getting a story list:
"Tell me more about the first one"  ← Uses context
"What about the second?"  ← Uses context
"Show AC for the third?"  ← Uses context
```

### Tip 5: Use Component Filters

```
Instead of: "Show all stories"
Try: "Show stories that modified Account object"
```

---

## 🎯 Example Efficient Conversations

### Example 1: Finding a Story

```
You: "Which sprint has story PR1050558-123?"
AI: [Checks index/grep - 100 tokens]
    "Sprint 14"

You: "What's the summary?"
AI: [Reads summary only - 200 tokens]
    "Add validation to Account status field"

You: "Show me the acceptance criteria"
AI: [Reads AC section - 800 tokens]
    [Lists AC]

Total: ~1,100 tokens
vs ~8,000 if asked for "everything about story XXX"
```

### Example 2: Sprint Overview

```
You: "How many stories in Sprint 14?"
AI: [Grep count - 50 tokens]
    "56 stories"

You: "How many are Done?"
AI: [Grep status - 100 tokens]
    "42 Done, 10 In Progress, 4 To Do"

You: "List the In Progress ones"
AI: [Targeted read - 800 tokens]
    [Lists 10 stories]

You: "Tell me about the first one"
AI: [Uses context - 300 tokens]
    [Shows details]

Total: ~1,250 tokens
vs ~15,000 if asked for "all Sprint 14 details"
```

### Example 3: Component Research

```
You: "Which stories modified Account object?"
AI: [Grep all sprints - 500 tokens]
    "Found in Sprint 12, 13, 14"

You: "Show me the Sprint 14 ones"
AI: [Targeted read - 1,500 tokens]
    [Lists 3 stories with summaries]

You: "What were their solutions?"
AI: [Reads solution field - 1,000 tokens]
    [Shows 3 solutions]

Total: ~3,000 tokens
vs ~30,000 if asked to "analyze all Account stories with full details"
```

---

## 📈 Measuring Your Savings

After implementing these practices, you should see:

- **Simple lookups**: 90-95% token reduction
- **Story exploration**: 70-80% token reduction
- **Sprint analysis**: 60-70% token reduction
- **Deep research**: 50-60% token reduction

**Overall expected savings: 70-85%**

---

## 🚀 Quick Reference Card

**Print this out or keep handy:**

```
TOKEN-EFFICIENT QUESTIONS:

CHEAPEST (50-200 tokens):
- "Which sprint has story XXX?"
- "How many stories in Sprint N?"
- "What's the status of story XXX?"

CHEAP (500-2K tokens):
- "List stories in Sprint N"
- "Stories in Sprint N with status Done"
- "Show Sprint N summary"

MEDIUM (1-3K tokens):
- "What are AC for story XXX?"
- "Show solution for story XXX"
- "Details on story XXX"

HIGHER (2-8K tokens):
- "Stories modifying Component X"
- "Find stories with keyword Y"
- "Component search across sprints"

EXPENSIVE (5K+ tokens):
- "Compare sprints in detail"
- "Deep analysis of feature"
- "All details on all stories"

REMEMBER:
✓ Start broad, then narrow
✓ Ask for summaries first
✓ Build on context
✓ Be specific when possible
```

---

## 🎉 You're Now a Token-Efficient User!

By following these patterns, you'll:

- Get answers faster
- Use fewer tokens (lower cost)
- Have smoother conversations
- Get more done with less

**Start practicing now!**

Try this efficient sequence:

```
1. "How many stories in Sprint 14?"
2. "Show me the summary"
3. "Tell me about story [pick one from list]"
4. "What are its acceptance criteria?"
```

vs the expensive way:

```
"Show me everything about all stories in Sprint 14"
```

**Same information, 80% fewer tokens!** 🎯