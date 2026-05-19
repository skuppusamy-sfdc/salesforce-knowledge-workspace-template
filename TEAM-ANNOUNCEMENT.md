# Salesforce Agile Knowledge Assistant - Cursor AI Agent

## 🎯 What Is This?

A **Cursor AI workspace** that acts as your intelligent assistant for understanding Salesforce project requirements, analyzing sprints, and planning work. Think of it as having an expert teammate who instantly knows everything about our JIRA stories across all sprints.

**Important**: This is **supplemental** to our code repository - requirements and planning live here, actual Salesforce code lives in our Git repo (Dev environment). The `/knowledge/metadata/` folder documents **QA environment** configuration.

---

## 📊 What's Loaded

- ✅ **20 sprints of JIRA stories** (Sprint 1 through Sprint 14)
- ✅ **Acceptance Criteria** and **Solutions** from all stories
- ✅ Ready to query using natural language with Cursor AI

---

## 💡 What Can You Do?

### For Solution Architects

```
"What stories in Sprint 13 conflict with Sprint 14?"
"Review acceptance criteria for story PR1050558-XXX"
"Which components were modified across multiple sprints?"
```

### For Technical Architects

```
"Show me the solution approach for story PR1050558-XXX"
"What components does story PR1050558-XXX impact?"
"Create a technical design based on these requirements"
```

### For Developers

```
"What are the acceptance criteria for my assigned story?"
"What do I need to know to implement story PR1050558-XXX?"
"What previous stories modified the Account object?"
```

### For Testers

```
"Generate test scenarios for story PR1050558-XXX"
"What edge cases should I test based on the AC?"
"Which stories need regression testing after Sprint 14?"
```

---

## 🚀 How to Use (3 Steps)

### Step 1: Open in Cursor

Location: `[Your shared drive path]/SCPHealthCnC`

### Step 2: Read the Guides

- Start with: `START-HERE.md`
- Essential: `HTML-STORIES-GUIDE.md`
- Save tokens: `TOKEN-OPTIMIZATION-GUIDE.md`

### Step 3: Ask Questions

Use **Ask Mode** or **Plan Mode** (not Agent/code mode)

**Efficient query example:**

```
"How many stories in Sprint 14?"
"List the stories"
"Show me acceptance criteria for story PR1050558-123"
```

---

## ⚡ Token Optimization (Save 70-90% on costs!)

**Ask progressively** to minimize token usage:

❌ **Expensive**: "Show me everything about Sprint 14"  
✅ **Efficient**: "How many stories?" → "List them" → "Tell me about #1"

**Expected savings**: 30+ million tokens annually across team

---

## 📁 Key Features

### 1. Cross-Sprint Analysis

Find conflicts, dependencies, and patterns across all sprints instantly

### 2. Acceptance Criteria Focus

Quickly extract and understand what defines "done" for any story

### 3. Solution Reference

See how similar problems were solved in previous sprints

### 4. Component Tracking

Identify all stories that modified specific Salesforce components

### 5. Traceability

Connect JIRA stories to actual code changes (story numbers bridge both)

---

## 🎓 Quick Reference


| Need to...       | Ask Cursor...                    | Cost        |
| ---------------- | -------------------------------- | ----------- |
| Find a story     | "Which sprint has story XXX?"    | ~200 tokens |
| Count stories    | "How many stories in Sprint 14?" | ~50 tokens  |
| List stories     | "List Sprint 14 stories"         | ~2K tokens  |
| Get AC           | "Show AC for story XXX"          | ~1K tokens  |
| Search component | "Stories modifying Account?"     | ~5K tokens  |


---

## 🔗 How It Connects to Our Code

```
┌─────────────────────────┐         ┌──────────────────────────┐
│  Cursor AI Workspace    │         │   Code Repository        │
│  (Requirements & QA)    │         │   (Dev Implementation)   │
├─────────────────────────┤         ├──────────────────────────┤
│ • JIRA stories (HTML)   │         │ • Apex classes           │
│ • Acceptance Criteria   │◄───────►│ • Flows                  │
│ • Solution approaches   │         │ • Objects & Fields       │
│ • QA metadata docs      │  Story  │ • Deployments            │
│ • Planning & analysis   │  Number │ • Dev/Sandbox code       │
└─────────────────────────┘  Bridge └──────────────────────────┘
```

**Environment Notes:**

- **This workspace** documents QA environment in `/knowledge/metadata/`
- **Code development** happens in Dev/Sandbox environments
- **Story numbers** (e.g., PR1050558-123) link requirements to code commits

---

## 👥 Roles Supported

✅ **Solution Architect** - Conflict detection, AC validation  
✅ **Technical Architect** - Solution design, impact analysis  
✅ **Developer** - Requirements understanding, test planning  
✅ **Tester** - Test script creation, regression planning

---

## 📞 Getting Started

1. **Clone/Access**: `[Your shared drive]/SCPHealthCnC`
2. **Read**: `START-HERE.md` (5 minutes)
3. **Try**: "What stories are in Sprint 14?"
4. **Explore**: Ask questions about your work!

---

## 💰 Cost Efficiency

- **Without optimization**: ~39M tokens/year
- **With optimization**: ~6.5M tokens/year
- **Savings**: 83% reduction
- **Setup time**: 10-20 minutes

---

## ⚠️ Important Notes

- **Not for coding**: Use this for planning; code in our Git repository
- **Use Ask/Plan modes**: Don't use Agent mode for code generation
- **Story numbers are key**: Use full JIRA IDs (PR1050558-XXX)
- **Ask progressively**: Start broad, drill down for details

---

## 🎉 Benefits

✅ Instant access to 20 sprints of requirements  
✅ No more searching through JIRA manually  
✅ Cross-sprint pattern recognition  
✅ Faster requirement clarification  
✅ Better conflict detection  
✅ Reduced rework from misunderstandings  
✅ 70-90% token cost savings  

---

## 📚 Documentation Available

- `START-HERE.md` - Quick start guide
- `HTML-STORIES-GUIDE.md` - Working with story data
- `TOKEN-OPTIMIZATION-GUIDE.md` - Efficient query patterns
- `guidelines/[role].md` - Role-specific workflows
- `INDEX.md` - Complete documentation index

---

**Questions?** Check `START-HERE.md` or ask in `#salesforce-team` channel

**Ready to try?** Open Cursor, navigate to workspace, and ask your first question!