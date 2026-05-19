# QA Environment Clarification - Update Summary

## What Was Updated

All documentation has been updated to clarify that the `/knowledge/metadata/` folder documents Salesforce metadata from the **QA environment**, not Dev environment.

---

## Key Clarification

### Environment Separation

**This Workspace (QA Documentation)**:
- JIRA story HTML files with requirements
- `/knowledge/metadata/` = Documents **QA environment** configuration
- Planning and analysis artifacts
- What's currently deployed in QA

**Code Repository (Dev Implementation)**:
- Actual Salesforce code development
- Happens in **Dev/Sandbox** environments
- Version control and deployments
- Where developers write code

**Story Requirements**:
- Apply across all environments
- Bridge between QA documentation and Dev implementation
- Story numbers link both worlds

---

## Files Updated

### 1. knowledge/metadata/README.md
**Changes**:
- Added clarification that metadata is from **QA environment**
- Updated SFDX commands to specify "QA Salesforce environment"
- Added note about connecting to QA org for metadata retrieval

### 2. .cursor/rules/no-code-development.md
**Changes**:
- Clarified that code development happens in Dev/Sandbox
- Added note that `/knowledge/metadata/` documents **QA environment**

### 3. QUICK-START.md
**Changes**:
- Updated to specify code repo is Dev environment
- Added note that metadata docs reference **QA environment**
- Step 2 clarified to document QA environment configuration

### 4. WORKFLOW-GUIDE.md
**Changes**:
- Added Developer workflow context about QA vs Dev environments
- Clarified metadata docs are for QA environment state

### 5. START-HERE.md
**Changes**:
- Added note that `/knowledge/metadata/` documents **QA environment**

### 6. guidelines/developer.md
**Changes**:
- Added environment clarification section
- Workflow updated to reference QA metadata docs
- Artifacts section now specifies QA environment metadata

### 7. HTML-STORIES-GUIDE.md
**Changes**:
- Updated "Relationship to Code Repository" section
- Added environment clarification table
- Specified that workspace documents QA environment

### 8. TEAM-ANNOUNCEMENT.md
**Changes**:
- Updated workspace description to mention QA environment
- Diagram updated to show QA vs Dev separation
- Added environment notes section

---

## Consistent Message Added

Throughout all files, this consistent language is now used:

> "The `/knowledge/metadata/` folder documents Salesforce metadata from the **QA environment**. Actual code development and implementation happens in your separate Dev/Sandbox environments and Git repository."

---

## Why This Matters

### Clarity for Team
- Developers know to check QA for current state
- Documentation reflects what's actually in QA
- No confusion about which environment to reference

### Accurate Documentation
- Metadata docs match QA org configuration
- SFDX commands target correct environment
- Testing references correct environment state

### Workflow Alignment
1. **Plan** using QA metadata as reference (this workspace)
2. **Develop** in Dev/Sandbox environments (external)
3. **Deploy** to QA (external process)
4. **Update** QA metadata docs (this workspace) after deployment

---

## Environment Flow

```
Story Requirements (HTML files)
        ↓
QA Metadata Docs (/knowledge/metadata/)
        ↓
Developer References QA State
        ↓
Develops in Dev/Sandbox Environment
        ↓
Code Deploys through Pipeline
        ↓
Reaches QA Environment
        ↓
QA Metadata Docs Updated
```

---

## Impact on Users

### Solution Architects
- Validate AC against **QA environment** state
- Check QA metadata docs for current configuration

### Technical Architects
- Design solutions referencing **QA environment**
- Document QA state in metadata folder

### Developers
- Reference **QA metadata** docs for current state
- Implement in **Dev/Sandbox** environments
- Update QA docs after changes deploy to QA

### Testers
- Test against **QA environment**
- Reference QA metadata docs for expected state

---

## No Action Required

This is a **clarification update** only. If you were already:
- Documenting QA environment metadata → Continue as before
- Developing in Dev/Sandbox → Continue as before
- Using story numbers to link both → Continue as before

The updates simply make explicit what may have been implicit before.

---

## Questions?

**Q: Should I document Dev environment instead?**  
A: No, continue documenting QA environment in `/knowledge/metadata/`. Dev code lives in your Git repository.

**Q: Where does actual development happen?**  
A: In your Dev/Sandbox Salesforce environments, with code in Git repository.

**Q: Do story requirements apply to both environments?**  
A: Yes, story requirements are environment-agnostic. Implementation happens in Dev, documentation reflects QA.

**Q: When should I update QA metadata docs?**  
A: After changes are deployed to QA environment, update the docs to reflect current QA state.

---

**Update Date**: April 22, 2026  
**Files Updated**: 8 documentation files  
**Impact**: Clarification only, no workflow changes  
**Status**: Complete ✅
