# Working with HTML Story Files - Quick Guide

## 🎯 What You Have

**20 Sprint HTML Files** loaded in `/knowledge/sprints/`:
```
Sprint 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
Sprint 12.1, 12.2, 12.3, 12.4, 12.5, 12.6
Sprint 13, 14
```

Each HTML file is a JIRA export containing a **table where each row is a story**.

## 📊 HTML Table Structure

```
┌─────────────┬──────────┬─────────────────────────┬──────────────────────┬────────┐
│ Issue Key   │ Summary  │ Acceptance Criteria     │ Solution            │ Status │
├─────────────┼──────────┼─────────────────────────┼──────────────────────┼────────┤
│ PR1050558-1 │ Story 1  │ AC 1: Do this          │ Use Apex class...   │ Done   │
│ PR1050558-2 │ Story 2  │ AC 1: Do that          │ Create Flow...      │ Done   │
│ PR1050558-3 │ Story 3  │ AC 1: Another thing    │ Modify Object...    │ In Prog│
└─────────────┴──────────┴─────────────────────────┴──────────────────────┴────────┘
```

### Key Columns (Focus Here!)

1. **Issue Key** - JIRA story number (e.g., PR1050558-123)
2. **Acceptance Criteria** ⭐ - What defines "done"
3. **Solution** ⭐ - Technical approach/implementation details
4. Summary - Story title
5. Description - Detailed requirements
6. Status - To Do, In Progress, Done, etc.
7. Components - Affected Salesforce components
8. Story Points - Complexity estimate

## 💡 Example Questions to Ask Cursor

### Understanding Stories

```
"Read Sprint 14 and tell me about story PR1050558-XXX"

"What are the acceptance criteria for story [number]?"

"Show me the solution approach for story [number]"

"What is the status of story [number]?"
```

### Sprint Analysis

```
"How many stories are in Sprint 14?"

"List all completed stories in Sprint 13"

"Which stories in Sprint 12 are still in progress?"

"Summarize Sprint 14 stories by status"

"What are the story points for Sprint 13?"
```

### Acceptance Criteria Focus

```
"List all acceptance criteria from Sprint 14"

"Show me stories with incomplete acceptance criteria"

"What are the most common types of acceptance criteria in Sprint 13?"

"Compare acceptance criteria between story X and story Y"

"Which stories have acceptance criteria related to [feature]?"
```

### Solution Analysis

```
"Extract all solution descriptions from Sprint 13"

"What technical approaches are used in Sprint 14?"

"Show me all stories that use Apex in their solution"

"Which stories mention Flow in the solution?"

"Compare solutions between story X and story Y"
```

### Component Tracking

```
"What stories in Sprint 14 affect the Account object?"

"Show me all stories across sprints that modified [Component]"

"Which components are mentioned most in Sprint 13?"

"List stories by component affected"
```

### Cross-Sprint Analysis

```
"Find all stories across sprints that mention [keyword]"

"Compare Sprint 13 and Sprint 14 - what changed?"

"What stories from previous sprints are related to story [number]?"

"Show the progression of [feature] across sprints"

"Which components have been modified in multiple sprints?"
```

### Finding Specific Content

```
"Search all sprints for stories with 'validation' in acceptance criteria"

"Find stories where solution mentions 'trigger'"

"Show me stories assigned to [person]"

"List all stories with component 'ClinicianClientExperience'"
```

## 🔄 Relationship to Your Code Repository

### This Workspace (Requirements & QA Documentation)
✅ JIRA story HTML files with AC and Solutions
✅ Requirements and planning documentation
✅ QA environment metadata documentation (`/knowledge/metadata/`)
✅ Solution designs and analysis
✅ Cross-sprint understanding

### Your Code Repository (Development & Implementation)
✅ Actual Salesforce code (Apex, Flows, Objects, Fields)
✅ Source code implementations in Dev/Sandbox
✅ Version control history
✅ Deployment packages
✅ Unit tests

### Environment Clarification
- **This workspace** documents QA environment in `/knowledge/metadata/`
- **Code development** happens in Dev/Sandbox environments
- **Story requirements** apply across all environments

### How They Connect
**Story Numbers (Issue Keys) are the bridge!**

```
Workflow:
1. Read story AC and Solution in HTML file (here)
   ↓
2. Understand requirements and design approach (here)
   ↓
3. Ask Cursor for analysis/clarification (here)
   ↓
4. Switch to your code repository
   ↓
5. Implement in Salesforce (Apex, Flows, etc.)
   ↓
6. Commit code with story number in commit message
   ↓
7. Story number links commit back to requirements
```

## 📋 Common Use Cases

### Use Case 1: Understanding a Story Before Implementation
```
You: "I'm assigned story PR1050558-XXX. What do I need to know?"

Cursor reads HTML, extracts:
- Acceptance criteria (what to build)
- Solution approach (how to build it)
- Components affected
- Dependencies
- Status
```

### Use Case 2: Reviewing Sprint Deliverables
```
You: "What did we deliver in Sprint 13?"

Cursor parses Sprint 13 HTML:
- Lists all stories with Status = Done
- Summarizes by component
- Highlights key features delivered
```

### Use Case 3: Finding Related Work
```
You: "What previous stories modified the Account object?"

Cursor searches all sprint HTMLs:
- Finds stories mentioning "Account"
- Extracts issue keys and sprints
- Shows what was changed and why
```

### Use Case 4: Conflict Detection
```
You: "I'm working on story XXX which modifies Component Y. 
     Any conflicts with previous sprints?"

Cursor:
- Reads story XXX AC and Solution
- Searches previous sprints for Component Y mentions
- Identifies potential conflicts
- Recommends coordination
```

### Use Case 5: Solution Design Review
```
You: "Review the solution approaches in Sprint 14. 
     Any patterns or concerns?"

Cursor:
- Extracts all Solution columns from Sprint 14
- Analyzes technical approaches
- Identifies patterns (Apex, Flow, Config)
- Notes any inconsistencies or risks
```

## ⚡ Quick Tips

### 1. Be Specific with Story Numbers
❌ "Tell me about the account story"
✅ "Tell me about story PR1050558-123"

### 2. Reference Sprint Names as They Appear
❌ "Sprint fourteen"
✅ "Sprint 14"
✅ "Sprint 12.3"

### 3. Ask About AC and Solution Explicitly
✅ "What are the acceptance criteria for story XXX?"
✅ "Show me the solution approach for story XXX?"
✅ "Compare AC and solutions between story XXX and YYY"

### 4. Use for Planning, Not Coding
✅ "Based on the solution, what components need changes?"
✅ "What should I consider when implementing this story?"
❌ "Write the Apex code for this story" (that's in your code repo)

### 5. Cross-Reference for Context
✅ "Find related stories from previous sprints"
✅ "What stories are similar to this one?"
✅ "Show progression of this feature across sprints"

## 🎓 Example Session

**You:** "I need to understand story PR1050558-145 from Sprint 14"

**Cursor:**
- Opens `/knowledge/sprints/Sprint 14/SCP HC Sprint 14.html`
- Parses table to find row with Issue Key = PR1050558-145
- Extracts and formats:
  - Summary: [Story title]
  - Acceptance Criteria: [Formatted AC list]
  - Solution: [Technical approach]
  - Status: [Current status]
  - Components: [List]

**You:** "Are there any related stories from previous sprints?"

**Cursor:**
- Searches Sprint 1-13 HTML files
- Looks for same components or similar AC/solutions
- Returns list of related stories with sprint context

**You:** "What should I consider when implementing this?"

**Cursor:**
- Reviews the Solution field details
- Identifies affected components
- Checks for dependencies in AC
- Suggests implementation approach
- **Reminds**: "Implementation happens in your code repository"

## 🚫 What This Workspace Does NOT Contain

❌ Actual Apex classes (in your code repo)
❌ Flow definitions (in your code repo)
❌ Object/Field XML (in your code repo)
❌ Deployment packages (in your code repo)
❌ Unit test code (in your code repo)

✅ This workspace has **requirements and planning**
✅ Your code repository has **implementation**

## 📞 Need Help?

### "Cursor can't find my story"
- Verify the story number (Issue Key)
- Check which sprint it's in
- Try: "Search all sprints for story XXX"

### "Acceptance criteria are unclear"
- Ask: "What are the AC for story XXX?"
- Request: "Explain the acceptance criteria in detail"
- Compare: "Show similar AC from other stories"

### "Solution field is empty"
- Check if solution is in Description instead
- Ask: "What does the description say for story XXX?"
- Look for related stories with similar solutions

### "Want to see code"
- Remember: Code lives in your separate repository
- This workspace: Requirements and planning
- Ask: "Based on the solution, what code changes are needed?"
- Then implement in your code repository

---

**You're ready to work with your HTML story files!**

Start with a simple question like:
```
"What stories are in Sprint 14?"
```

Then explore from there! 🚀
