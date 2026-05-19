# Solution Index

**Purpose**: Searchable index of all technical solutions across all sprints.

**Last Updated**: April 22, 2026  
**Total Stories with Solutions**: 963  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find by technology**: Ctrl+F for "Apex", "LWC", "Flow", etc.
- **Filter by category**: Jump to category sections below
- **Find by story**: Search for "PR1050558-XXX"

---

## Solution Categories

| Category | Count | Description |
|----------|-------|-------------|
| Configuration | 278 | Declarative configurations |
| General | 183 | Other solutions |
| Apex Development | 178 | Apex classes and triggers |
| Flow Automation | 154 | Salesforce Flow automations |
| LWC/Aura Component | 59 | Lightning components and UI |
| Security Setup | 52 | Permission sets and profiles |
| OmniStudio | 50 | OmniScripts and Integration Procedures |
| Reporting | 4 | Reports and dashboards |
| Declarative Logic | 4 | Formulas and validation rules |
| Integration | 1 | External system integrations |

---

## Technology Stack Usage

| Technology | Stories | Percentage |
|------------|---------|------------|
| Flow | 320 | 33.2% |
| Apex | 213 | 22.1% |
| OmniScript | 67 | 7.0% |
| Formula Field | 38 | 3.9% |
| Validation Rule | 31 | 3.2% |
| REST | 23 | 2.4% |
| Integration Procedure | 12 | 1.2% |
| LWC | 10 | 1.0% |
| JavaScript | 6 | 0.6% |
| CSS | 1 | 0.1% |
| Aura | 1 | 0.1% |

---

## Solutions by Category

### Configuration (278 stories)

#### PR1050558-205 (Sprint 1)

**Summary**: Configure Service Line Object

**Tech Stack**: Not specified

**Solution Preview**: create Service Line object from data dictionary

LRP...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-165 (Sprint 1)

**Summary**: Permission Sets

**Tech Stack**: Not specified

**Solution Preview**: +Create Collaborative Practice Agreement object+
Labels: Collaborative Practice Agreement / Collaborative Practice Agreements (plural)
Does not start with vowel sound
Object Name: Collaborative_Practice_Agreement
Record Name: Collaborative Practice A...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-88 (Sprint 1)

**Summary**: Create Service Records

**Tech Stack**: Not specified

**Solution Preview**: Confirm Service record types and page layouts
Add Service related list on Opportunity record
Create fields
Configure LRP with dynamic forms
Create Default record type...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-86 (Sprint 1)

**Summary**: Initial National, Facility, and Service Line Account Records

**Tech Stack**: Not specified

**Solution Preview**: Configure 5 lightning record pages for Account object
Assign as app default and record type default...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-81 (Sprint 1)

**Summary**: Initial Clinician Record

**Tech Stack**: Not specified

**Solution Preview**: Record type

Configure lightning record page

Page layout

Create fields approx. 10 fields

Assign as app & record type default...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-80 (Sprint 1)

**Summary**: Facility Contract and Rate Records

**Tech Stack**: Not specified

**Solution Preview**: Configure page layout
Configure lightning record page
Assign as app default...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-79 (Sprint 1)

**Summary**: Create Facility Records

**Tech Stack**: Not specified

**Solution Preview**: Create 5 Account record types and 5 page layouts

Create approx. 50 fields

Grant access to record types and page layouts

LRP is configured in [https://salesforce.atlassian.net/browse/PR1050558-86|https://salesforce.atlassian.net/browse/PR1050558-86...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-23 (Sprint 1)

**Summary**: Create Clinician Person Accounts

**Tech Stack**: Not specified

**Solution Preview**: Enable person accounts
Assign record type to Manage Clinicians permission set...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-2832 (Sprint 10)

**Summary**: Term Sheet Generation - Trigger Contract Generation

**Tech Stack**: Not specified

**Solution Preview**: Add a New picklist value for Contract.Status = “Contracting - In Progress” , only for Clinician record type. 

Contracting Status = Signed


Add a validation only can change from Status = “Approved” to “Contracting - In Progress”



Add Custom Permis...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2828 (Sprint 10)

**Summary**: HPF Updates & Platform Event: Contract becomes Active

**Tech Stack**: Not specified

**Solution Preview**: When the Contract.Status = “Executed”

Query ALL HPF Related to that Contract Record with Condition 

HealthcarePractitionerFacility.First_Clinical_Shift__c IS NOT NULL

Send a bulk Platform Event

For Each HealthcarePractitionerFacility record creat...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2822 (Sprint 10)

**Summary**: Clinician Contract Request: Copy rates from Old HPF to New

**Tech Stack**: Not specified

**Solution Preview**: This functionality may already exist. Please test before developing.

As part of the existing Clone functionality of a clinician contract, 
If executed Clinician contract exists and we submit a new contract request, 
check if the SA of the HPF is sam...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2811 (Sprint 10)

**Summary**: Generate Term Sheet - Term Sheet Generation

**Tech Stack**: Not specified

**Solution Preview**: * Link to template [https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true|https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=1073326...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2677 (Sprint 10)

**Summary**: Clinician Offboarding - Termination Details Updates for Partner

**Tech Stack**: Not specified

**Solution Preview**: As part of the existing Clinician offboarding OS,
For Emp type = Partner, ( add to existing condition)
Display the fields mentioned above 

Facility Offboarding Task
Update the critieria for task creation to include Partner Employee type...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2676 (Sprint 10)

**Summary**: Clinician Offboarding - Termination Details Updates for Locums, Leased, Managed

**Tech Stack**: Not specified

**Solution Preview**: In the existing Clinician offboarding OS,
As part of the condition/filter check on Employee type for Facility table,
Remove Prospect (IF HPF status != Inactive) and include employee type Leased or Managed.
Create a separate picklist field with the op...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2635 (Sprint 10)

**Summary**: Account (Service Account) - Add Case Related List

**Tech Stack**: Not specified

**Solution Preview**: Create related list for Account Object with criteria specific in AC...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2616 (Sprint 10)

**Summary**: Update Case Related Lists on Clinician Record

**Tech Stack**: Not specified

**Solution Preview**: On Clinician record page > Cases sub tab > Add a single related list of Cases ( where record type = Clinical Match and Status != Closed) . Position this related list above the exit Interview cases.

Remove existing “Offboarding Case” related list....

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2554 (Sprint 10)

**Summary**: Locums Rate Management

**Tech Stack**: Not specified

**Solution Preview**: NOTE:
Contract > CPA(n) > PCA (n)
Contract - PNC (Junction) - HPF
Contract has 1 to many CPA . CPA has 1 to many relationship with PCA
CPA record has PNC from which we can know the HPF for the Contract.

Add new Code Set (Locum) and load new Health C...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2469 (Sprint 10)

**Summary**: Open Shift APAY Request: Approval

**Tech Stack**: Formula Field

**Solution Preview**: In the existing oS for Open Shift APAY , add the three fields. The fields are mapped to Case (of record type Rate Approval)

* APAY Used for the Month (currency, 8 digits 0 decimals, required)
* APAY Budgeted (currency, 8 digits 0 decimals, required)...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2431 (Sprint 10)

**Summary**: Update Clinician Visa Data Model

**Tech Stack**: Not specified

**Solution Preview**: Delete the Visa object and any reference to it. Create destructive changes.

Create new fields on Clinician Person account as mentioned in the DD
Visa Number - text, 25

* Type - picklist
** Values: Birth Abroad Cert, Citizen/Naturalized, E-2, EAD, H...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2422 (Sprint 10)

**Summary**: Service Account Attributes

**Tech Stack**: Not specified

**Solution Preview**: Follow Data Dictionary for field created details...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2227 (Sprint 10)

**Summary**: Client Rate Configuration - Cloning and Editing - "Re-Add"

**Tech Stack**: Not specified

**Solution Preview**: We can identify cloned contracts using “PreviousContractId“  field
For those contracts, If IsDeleted = true, display “Re-Add” button on the flexcard.
When Re-Add is selected, IsDeleted = false, and hide “Re-Add” button....

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2114 (Sprint 10)

**Summary**: Review Credentialling Fields

**Tech Stack**: Not specified

**Solution Preview**: Create the fields mentioned in the story and DD, on Service Account and HPF.
Provide access to Integration user and any persona that has access to te object...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1794 (Sprint 10)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * [See Data Dictionary for:|https://docs.google.com/spreadsheets/d/1sWZQMIMr_raV7StFgRo96aUVhRNDGkeVIW7PpSpAO50/edit?usp=sharing]
** Layouts
** Field setup
* All fields listed above should be made visible on permission sets that have object access....

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1667 (Sprint 10)

**Summary**: Add Account Contact Relationship

**Tech Stack**: Not specified

**Solution Preview**: !image-20250805-202258.png|width=1004,height=649,alt="image-20250805-202258.png"!

On Contact they already have Related Accounts with the ability to Add Relationship

On Service Account we have story [+PR1050558-1787+|https://salesforce.atlassian.net...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-319 (Sprint 10)

**Summary**: Employee Self-Service Experience (Link to MySCP - Employee Audience)

**Tech Stack**: Not specified

**Solution Preview**: Use Federation Id from User to verify if okta username exits.


The field will be populated by Integration [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd]  Is this data mapping already captured in a user story?
On the portal, use Rich text e...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3572 (Sprint 11)

**Summary**: Update HPF Temporary Inactive Reason data type

**Tech Stack**: Not specified

**Solution Preview**: Update the field to Muti-Select Picklist (DD updated)...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3565 (Sprint 11)

**Summary**: Practice Operation Change Object

**Tech Stack**: Not specified

**Solution Preview**: * Object, field, and layout - see DD tab = *Practice Operation Change*
* Security Matrix
** -OWD- - controlled by parent
** Permission Sets:
*** System Administrator
*** *View Client Rates:* Read
*** *Manage Client Contracts:* Read, Edit
*** *View Cl...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3518 (Sprint 11)

**Summary**: Client Contract Request - Create new fields

**Tech Stack**: Not specified

**Solution Preview**: For newly created fields, please set FLS for the following permission sets:

* System Administrator
* Manage Client Contracts
* View Client Contracts...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3459 (Sprint 11)

**Summary**: Client Onboarding - Configure Action Plan Template

**Tech Stack**: Not specified

**Solution Preview**: Action Plan Template for Client Onboarding Tasks

* Add 2 new Tasks fields
** Update the Task (RT:Default) layout - add “Category”
** Update the FLS for all permission sets that have access the the Task (RT:Default)
* Update the Action Plan Template ...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3449 (Sprint 11)

**Summary**: Facility Change Request: Reset flags when cloning a Practice Operations or Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: During the Contract Clone Process Set the Check Box Fields to as FALSE Contract  

* RecordType: Practice Operations
* RecordType: Clinician

Shift__c

# Existing_Shift_Type_Added__c = FALSE
# New_Shift_Type_Added__c = FALSE

Rate_Pay_Code__c

# Is_N...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3391 (Sprint 11)

**Summary**: Client Change Management Object

**Tech Stack**: Not specified

**Solution Preview**: * Object, field, and layout - see DD tab = Client Change Management
* Security Matrix
** -OWD- - controlled by parent
** Permission Sets:
*** System Administrator 
*** *View Client Rates:* Read
*** *Manage Client Contracts:* Read, Edit
*** *View Clie...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3018 (Sprint 11)

**Summary**: Facility Change Request: Practice Operation Contract - Send notification when future contract exists

**Tech Stack**: Not specified

**Solution Preview**: AC1: When Contract Record Type = Practice Operation is Status = Executed 

Check if there are any forward Contract for that Account → Contract.StartDate > current.Contract.Start Date and Status = Executed if there are contract records

Create a Task ...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2988 (Sprint 11)

**Summary**: Facility Change Request: No Hard Deletes & Exclude "Is Deleted" Rates [Part 1 of 2]

**Tech Stack**: Not specified

**Solution Preview**: copied from 2965 - update as needed. 
*Shift:*

# When Delete Icon is used in Shift and Shift__c.Cloned_From__c != null then set  Is_Deleted__c = true and do not delete the records (show Is Deleted Icon in the Related List Field
## Make Is_Deleted__c...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2811 (Sprint 11)

**Summary**: Generate Term Sheet - Term Sheet Generation

**Tech Stack**: Not specified

**Solution Preview**: * Link to template [https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true|https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=1073326...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1800 (Sprint 11)

**Summary**: Facility Term: Review Clinician Roster

**Tech Stack**: Not specified

**Solution Preview**: Create new case record type = Client Offboarding & Layout - see DD

Read Only View: Use Flex Card or Edit Block (there is ready only)

Select All HealthcarePractitionerFacility with HealthcarePractitionerFacility.Status__c <> “Inactive”  realted to t...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1794 (Sprint 11)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * [See Data Dictionary for:|https://docs.google.com/spreadsheets/d/1sWZQMIMr_raV7StFgRo96aUVhRNDGkeVIW7PpSpAO50/edit?usp=sharing]
** Layouts
** Field setup
* All fields listed above should be made visible on permission sets that have object access....

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-319 (Sprint 11)

**Summary**: Employee Self-Service Experience (Link to MySCP - Employee Audience)

**Tech Stack**: Not specified

**Solution Preview**: Use Federation Id from User to verify if okta username exits.


The field will be populated by Integration [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd]  Is this data mapping already captured in a user story?
On the portal, use Rich text e...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-314 (Sprint 11)

**Summary**: Client Onboarding - Action Plan Template

**Tech Stack**: Formula Field

**Solution Preview**: *Action Plan Template* for Client Onboarding Tasks



Object For Action Plan Template = Account

Action Plan Type = {{Industries}}

Migration for higher environment [https://help.salesforce.com/s/articleView?id=ind.fsc_action_plans_admin_package_temp...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-313 (Sprint 11)

**Summary**: Client Onboarding - Update PMT Layout

**Tech Stack**: Not specified

**Solution Preview**: See DD tabs: (note if we can update the labels then we need to update the DD Field Label to reflect.

* PMT Project
* PMT Phase
* PMT Task...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4107 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Update Design for Displaying related active Opportunity

**Tech Stack**: Not specified

**Solution Preview**: AC1: Use the Contract.RT=”Letter of Intent” Record Page design to show the “Opportunity Services” using Contract.SourceOpportunity 

AC2: Adjust the Contract.RT=”Letter of Intent” Record Page TAB based on AC

AC3: 

# Delete the Letter of Intent fiel...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3803 (Sprint 12)

**Summary**: Facility Term: Add Case related list to Client Offboarding Case

**Tech Stack**: Not specified

**Solution Preview**: Add Related Cases related list based on [Parent Case|https://corehc--dev1.sandbox.my.salesforce-setup.com/lightning/setup/ObjectManager/Case/FieldsAndRelationships/Parent/view]...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3777 (Sprint 12)

**Summary**: Facility Change Request: No Hard Deletes & Exclude "Is Deleted" Rates [Part 2 of 2]

**Tech Stack**: Not specified

**Solution Preview**: * Security Matrix Updates: [~accountid:712020:43340b88-fbfb-4495-b309-a8c2ea5841fb] [~accountid:61f8618e8d9e3c00688e380b] 
** Public Groups tab - add ‘SA Edit Access’
** Sharing Rules tab - add ‘Service Account Edit Access’
** User Setup tab - add Pu...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3768 (Sprint 12)

**Summary**: Contract Provider Network Relation Object

**Tech Stack**: Not specified

**Solution Preview**: * Create new object, fields, update FLS for permission sets with access to the object (see below)
* Security Matrix
** Object: Contract Provider Network Relation
*** Permission Sets:
**** System Administrator
**** Manage Client Contracts
**** View Cl...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3585 (Sprint 12)

**Summary**: Update permissions to Opportunity records

**Tech Stack**: Not specified

**Solution Preview**: Modify Object access  based on Security Metrics as per AC. 

Permission Set = View Client Onboarding

* Remove Opportunity Read Access...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3572 (Sprint 12)

**Summary**: Update HPF Temporary Inactive Reason data type

**Tech Stack**: Not specified

**Solution Preview**: Update the field to Muti-Select Picklist (DD updated)...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3521 (Sprint 12)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * For newly added fields, see the DD for layout and update FLS for permission sets that have access to the object....

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3518 (Sprint 12)

**Summary**: Client Contract Request - Create new fields

**Tech Stack**: Not specified

**Solution Preview**: For newly created fields, please set FLS for the following permission sets:

* System Administrator
* Manage Client Contracts
* View Client Contracts...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3474 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Action = Terminate Contract

**Tech Stack**: Not specified

**Solution Preview**: New Button in Contract RT: Client Contract AND Contract_Type__c = “Master” (as part of this story create the Ultiamte_Parent_Id__c field)

On Button Click (Terminate Contract)

Update Current Record

# Contract.Status = “Terminated”...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3464 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - View & Edit

**Tech Stack**: Not specified

**Solution Preview**: * Add/update fields, update layout. For new fields added set FLS based on permission sets with access to this record type. 
** System Administrator
** Manage Client Contracts
** View Client Contracts



Add the fields as per AC

Add the Related List ...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3463 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Update LOI guided experience

**Tech Stack**: Not specified

**Solution Preview**: * Name of each Hospital -[text area (long), 131,072]- *UPDATE: Display a read only list of related Services (active Services related Opportunity)*
** *Fields to display: Service Account (name) & Service Line*
** Object Service__c.Account_r.Name, Serv...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3459 (Sprint 12)

**Summary**: Client Onboarding - Configure Action Plan Template

**Tech Stack**: Not specified

**Solution Preview**: Action Plan Template for Client Onboarding Tasks

* Add 2 new Tasks fields
** Update the Task (RT:Default) layout - add “Category”
** Update the FLS for all permission sets that have access the the Task (RT:Default)
* Update the Action Plan Template ...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3351 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Action = Activate Contract

**Tech Stack**: Not specified

**Solution Preview**: New Button in Contract RT: Client Contract AND Contract_Type__c = “Master” (as part of this story create the Ultiamte_Parent_Id__c field)

On Button Click

Query Contract.Ultiamte_Parent_Id__c = CURRENT.Contract.Ultiamte_Parent_Id__c AND Contract.Sta...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3201 (Sprint 12)

**Summary**: Generate Term Sheet - Term Sheet Generation - Add Other Type of Rates

**Tech Stack**: Not specified

**Solution Preview**: * Link to template [https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true|https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=1073326...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3023 (Sprint 12)

**Summary**: Client Contract Request - Edit Client Contract (Add Configuration)

**Tech Stack**: Not specified

**Solution Preview**: # Create a Button
# Create Flex Card for Each Section
# Create Omni Script for Each Section (7 Screens in Total)
## After Save of Each Configuration Refresh the Configuration Screen

Create Flex Card for each Section and the Fields are available part...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3020 (Sprint 12)

**Summary**: Client Contract Request - Expanded View

**Tech Stack**: Not specified

**Solution Preview**: In Omni Script:

The Picklist display the list of Account records from ProviderNetworkContract.ContractId = [Contract.Id|http://Contract.Id] (the Contract where Contract_Type__c = Master) display   ProviderNetworkContract.Service_Account__r.Name  (al...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2965 (Sprint 12)

**Summary**: Clinician Contract - Update Cloning to include Rate Pay Codes

**Tech Stack**: Not specified

**Solution Preview**: Applies to Contract.RecordType = Practice Operation 

AC1:

# Add new Field Cloned_From__c in Rate_Pay_Code__c 
# When the Clinician Contract is cloned based on [https://salesforce.atlassian.net/browse/PR1050558-3017|https://salesforce.atlassian.net/...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2907 (Sprint 12)

**Summary**: Term Sheet Generation - “Send Term Sheet for Signature” & List View

**Tech Stack**: Not specified

**Solution Preview**: * Field = Term Sheet Executed, creation part of [+PR1050558-1794+|https://salesforce.atlassian.net/browse/PR1050558-1794]...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2472 (Sprint 12)

**Summary**: Clinician Offboarding: Backfill Needed

**Tech Stack**: Not specified

**Solution Preview**: -Case RT: Clinician Offboarding-

-When Case.Backfill_Recommended__c is updated and set as True- 

-then- *-CLONE-* *-ALL Field-* -the bpats__Job__c record identified by Healthcare_Practitioner_Facility__r.Job_Applicant__r.bpats__Job__c-

-Set fields...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2441 (Sprint 12)

**Summary**: Client Contract Request - Client Agreement Request Case Layout & List View

**Tech Stack**: Not specified

**Solution Preview**: AC1:

# New List view for Case 

AC2:

# Update Case Layout as per AC for Record Type Client Agreement Request



[^SCP Health - Data Model - Client Contract.pdf]...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1800 (Sprint 12)

**Summary**: Facility Term: Review Clinician Roster

**Tech Stack**: Not specified

**Solution Preview**: Create new case record type = Client Offboarding & Layout - see DD

Read Only View: Use Flex Card or Edit Block (there is ready only)

Select All HealthcarePractitionerFacility with HealthcarePractitionerFacility.Status__c <> “Inactive”  realted to t...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-886 (Sprint 12)

**Summary**: SUN Task Template Setup

**Tech Stack**: Not specified

**Solution Preview**: Action Plan Template for SUN Tasks

Create the Action Plan Template as specified in the AC





NOTE: Service Account field = ‘Bordering States’ as referenced in tasks, created as part of [+PR1050558-3521+|https://salesforce.atlassian.net/browse/PR10...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-319 (Sprint 12)

**Summary**: Employee Self-Service Experience (Link to MySCP - Employee Audience)

**Tech Stack**: Not specified

**Solution Preview**: Use Federation Id from User to verify if okta username exits.


The field will be populated by Integration [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd]  Is this data mapping already captured in a user story?
On the portal, use Rich text e...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-314 (Sprint 12)

**Summary**: Client Onboarding - Action Plan Template

**Tech Stack**: Formula Field

**Solution Preview**: *Action Plan Template* for Client Onboarding Tasks



Object For Action Plan Template = Account

Action Plan Type = {{Industries}}

Migration for higher environment [https://help.salesforce.com/s/articleView?id=ind.fsc_action_plans_admin_package_temp...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-313 (Sprint 12)

**Summary**: Client Onboarding - Update PMT Layout

**Tech Stack**: Not specified

**Solution Preview**: See DD tabs: (note if we can update the labels then we need to update the DD Field Label to reflect.

* PMT Project
* PMT Phase
* PMT Task...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-5208 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT390 From the Service Account Missing Client Contract Link In "Contracts"

**Tech Stack**: Formula Field

**Solution Preview**: Expose a formula field linking the contract related list...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5173 (Sprint 12.1)

**Summary**: UAT Enhancement - Facility Change Request: Coverage Change UPDATE

**Tech Stack**: JavaScript

**Solution Preview**: Added examples for better understanding [https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?gid=1493984067#gid=1493984067|https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?g...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5152 (Sprint 12.1)

**Summary**: UAT Enhancement: Activate Services Object Record Types

**Tech Stack**: Not specified

**Solution Preview**: Active the Record Type and make sure the record type are required for Creation of Service Records

These Record Type should be already available in Service object...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5120 (Sprint 12.1)

**Summary**: UAT Enhancement : Grant Payroll Access for Pay Codes

**Tech Stack**: Validation Rule

**Solution Preview**: AC1: Unlock the record in the 1st step and then lock it from Step 2 [https://salesforce.atlassian.net/browse/PR1050558-1740|https://salesforce.atlassian.net/browse/PR1050558-1740|smart-link] 

AC2: Make the field not editable in Layout when Contract....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5104 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on Practice Ops record not pulled onto Clini

**Tech Stack**: Not specified

**Solution Preview**: Copy the field from PO to Clinician Contract...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5093 (Sprint 12.1)

**Summary**: UAT Enhancement: Add Time Type to Pay Codes Layout

**Tech Stack**: Not specified

**Solution Preview**: Add the fields as per AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5075 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT341 Rate Active Date - Net New Field

**Tech Stack**: Not specified

**Solution Preview**: Make this ready only in Layout

Update the “Rate Active Date”  = Todays Date when the Flag “Ok to Send Rates” is checked (add the logic for adding it as part of Credential Status as well if come one manually update the flag then it should fire as wel...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4998 (Sprint 12.1)

**Summary**: UAT Enhancement: Add Blended Rates ("EE NP/PA Hourly Blended") to Preventive Care Agreement (PCA)

**Tech Stack**: Formula Field

**Solution Preview**: * create new PCA field
* update field permission for permission sets with access to the object.



Create a FORMULA field in Preventive Care Agreement

* EE NP/PA Hourly Blended (Number)

Logic

If(PreventiveCareAgreement.ContractPaymentAgreement.Con...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4970 (Sprint 12.1)

**Summary**: UAT Enhancement: Risk Review - Add visibility to the Assessment on the Risk Review Case

**Tech Stack**: Not specified

**Solution Preview**: Grant Access based on AC



# Create new Picklist value at Type field on Assessment object
## In *ClinicianRiskReviewOS* OS, while creating Assessment, populate type field as *Risk Review, refer  Competency_SaveAssessmentResponse IP*
## Create a shar...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4902 (Sprint 12.1)

**Summary**: UAT Enhancement: Practice Operations Contract - NPPA Tier, Contract Start Date & Contract End Date r

**Tech Stack**: Validation Rule

**Solution Preview**: Validation Rule: in Contract for PO Contract

When Contract Status = Executed make field read as per AC

Validation rule should by pass for admins...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4683 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT243 Update Practice Operations fields

**Tech Stack**: Not specified

**Solution Preview**: Modify the page layout as per AC

DO NOT delete the Contract fields listed, we are just asking to update the layout...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4638 (Sprint 12.1)

**Summary**: Some personas don't have access to view Time Type of HPF related list on service account

**Tech Stack**: Not specified

**Solution Preview**: Update the *Corporate Support* permission set to grant *Read access* to the *All Fields* on the *Healthcare Practitioner Facilities* object, then re-deploy and validate for all personas....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4628 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT232 Client Contract Term & Renewal Contract End Date Not Populating

**Tech Stack**: Formula Field

**Solution Preview**: Update the formula fields...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4593 (Sprint 12.1)

**Summary**: NP/PA Onboarding Comments field on HPF

**Tech Stack**: Not specified

**Solution Preview**: Create the field as per data dictionary

add read and edit access to all permission sets with HPF object access

add the field to the Record Page

ensure the field is cloned...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4578 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT202 Edit functionality needed for all statuses

**Tech Stack**: Formula Field

**Solution Preview**: Refactor the Omni script as per AC

To ensure users are NOT manually updating the Status field, we will create a new formula field, to enforce users to use the available actions...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4569 (Sprint 12.1)

**Summary**: HPF Field History Tracking

**Tech Stack**: Not specified

**Solution Preview**: Enable Field History and Expose History Relates List in Records Page

OUTSTANDING TICKET WTIH SALESFORCE SUPPORT

Since salesforce Support said its a defect we are building a Omni solution...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4553 (Sprint 12.1)

**Summary**: Clinician NP/PA Tier Updates

**Tech Stack**: Not specified

**Solution Preview**: AC1: The solution is similar of how the NPPA Tier is auto populated or user entered when there is a mismatch.  

Check if the Contract.Employment_Type__c is Employee Contract.Time_Type__c is Full Time, and clinician Contract.Account.Professional_Titl...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4521 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT183 Error message when viewing all tasks for client account

**Tech Stack**: Not specified

**Solution Preview**: . Go to the page layout.

# Click Edit button and add Activity History related list.

!https://www.infallibletechie.com/wp-content/uploads/2019/02/Activity2BHistory2BRelated2BList2BSalesforce.png|width=250!...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4513 (Sprint 12.1)

**Summary**: SFO Persona is unable to update the Contract End Date field.

**Tech Stack**: Not specified

**Solution Preview**: *Note:* *This was not mentioned initially in the user story. Later on added.*

Give the edit access to *Contract.End Date* field via this *Manage Client Contracts* permission set....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4512 (Sprint 12.1)

**Summary**: While working on LOI and Client Contract with status Draft - When user updates the Key Dates section

**Tech Stack**: Not specified

**Solution Preview**: Fix the Status → Category field dependency by moving _Internal_ and _External_ from *Submitted__old* to *Submitted*, and add this as a post-deployment step in Copado....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4433 (Sprint 12.1)

**Summary**: UAT Enhancement: Contract - Add validation that Start can NOT be after End Date

**Tech Stack**: Validation Rule

**Solution Preview**: Enter a Validation Rule in Contract irrespective of Record Type

Fix the Omni Script 

* Clinician - Contract Request
* Client - Contract Request...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4366 (Sprint 12.1)

**Summary**: UAT Enhancement: Update HPF field = "Received Current Completed References" to a Checkbox and update

**Tech Stack**: Not specified

**Solution Preview**: AC1: Change the data type of the Field 

AC2: Change the logic using the field from ISCHANGED(Date Field) to Received_Current_Completed_References__c = True...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4362 (Sprint 12.1)

**Summary**: UAT Enhancement: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: Where the object has permission provide the permission...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4309 (Sprint 12.1)

**Summary**: Training Enhancement: Update Related Lists on Clinician and Case Record

**Tech Stack**: Not specified

**Solution Preview**: Adjust the Related List and Related List field in the Record Page based on AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4308 (Sprint 12.1)

**Summary**: Training Enhancement: Contract Field Visibility and Edit Access

**Tech Stack**: Not specified

**Solution Preview**: Modify the Contract Status Category to accommodate for Status Change





Draft (Draft)
Submitted (Draft)
Approved (Draft)
Contracting - In Progress (Draft)
Executed (Activated)
Canceled (Canceled)



Adjust the Record Type for Clinician and Client C...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4107 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Update Design for Displaying related active Opportunity

**Tech Stack**: Not specified

**Solution Preview**: AC1: Use the Contract.RT=”Letter of Intent” Record Page design to show the “Opportunity Services” using Contract.SourceOpportunity 

AC2: Adjust the Contract.RT=”Letter of Intent” Record Page TAB based on AC

AC3: 

# Delete the Letter of Intent fiel...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4012 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT86 HPF and Agreement history sections

**Tech Stack**: Not specified

**Solution Preview**: Enable Field History and Expose History Relates List in Records Page



Remove PNC flex page from Layout of from Client Contract Record Page (Practice Operations)...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3585 (Sprint 12.1)

**Summary**: Update permissions to Opportunity records

**Tech Stack**: Not specified

**Solution Preview**: Modify Object access  based on Security Metrics as per AC. 

Permission Set = View Client Onboarding

* Remove Opportunity Read Access...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3521 (Sprint 12.1)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * For newly added fields, see the DD for layout and update FLS for permission sets that have access to the object....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3474 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Action = Terminate Contract

**Tech Stack**: Not specified

**Solution Preview**: New Button in Contract RT: Client Contract AND Contract_Type__c = “Master” (as part of this story create the Ultiamte_Parent_Id__c field)

On Button Click (Terminate Contract)

Update Current Record

# Contract.Status = “Terminated”...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3464 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - View & Edit

**Tech Stack**: Not specified

**Solution Preview**: * Add/update fields, update layout. For new fields added set FLS based on permission sets with access to this record type. 
** System Administrator
** Manage Client Contracts
** View Client Contracts



Add the fields as per AC

Add the Related List ...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3463 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Update LOI guided experience

**Tech Stack**: Not specified

**Solution Preview**: * Name of each Hospital -[text area (long), 131,072]- *UPDATE: Display a read only list of related Services (active Services related Opportunity)*
** *Fields to display: Service Account (name) & Service Line*
** Object Service__c.Account_r.Name, Serv...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3351 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Action = Activate Contract

**Tech Stack**: Not specified

**Solution Preview**: New Button in Contract RT: Client Contract AND Contract_Type__c = “Master” (as part of this story create the Ultiamte_Parent_Id__c field)

On Button Click

Query Contract.Ultiamte_Parent_Id__c = CURRENT.Contract.Ultiamte_Parent_Id__c AND Contract.Sta...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3201 (Sprint 12.1)

**Summary**: Generate Term Sheet - Term Sheet Generation - Add Other Type of Rates

**Tech Stack**: Not specified

**Solution Preview**: * Link to template [https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true|https://docs.google.com/document/d/1gM9YFc0Fu9zy1aaFFZDoWHgCtqD3INIO/edit?usp=sharing&ouid=1073326...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3023 (Sprint 12.1)

**Summary**: Client Contract Request - Edit Client Contract (Add Configuration)

**Tech Stack**: Not specified

**Solution Preview**: # Create a Button
# Create Flex Card for Each Section
# Create Omni Script for Each Section (7 Screens in Total)
## After Save of Each Configuration Refresh the Configuration Screen

Create Flex Card for each Section and the Fields are available part...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3020 (Sprint 12.1)

**Summary**: Client Contract Request - Expanded View

**Tech Stack**: Not specified

**Solution Preview**: In Omni Script:

The Picklist display the list of Account records from ProviderNetworkContract.ContractId = [Contract.Id|http://Contract.Id] (the Contract where Contract_Type__c = Master) display   ProviderNetworkContract.Service_Account__r.Name  (al...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2907 (Sprint 12.1)

**Summary**: Term Sheet Generation - “Send Term Sheet for Signature” & List View

**Tech Stack**: Not specified

**Solution Preview**: * Field = Term Sheet Executed, creation part of [+PR1050558-1794+|https://salesforce.atlassian.net/browse/PR1050558-1794]...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2472 (Sprint 12.1)

**Summary**: Clinician Offboarding: Backfill Needed

**Tech Stack**: Not specified

**Solution Preview**: -Case RT: Clinician Offboarding-

-When Case.Backfill_Recommended__c is updated and set as True- 

-then- *-CLONE-* *-ALL Field-* -the bpats__Job__c record identified by Healthcare_Practitioner_Facility__r.Job_Applicant__r.bpats__Job__c-

-Set fields...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2441 (Sprint 12.1)

**Summary**: Client Contract Request - Client Agreement Request Case Layout & List View

**Tech Stack**: Not specified

**Solution Preview**: AC1:

# New List view for Case 

AC2:

# Update Case Layout as per AC for Record Type Client Agreement Request



[^SCP Health - Data Model - Client Contract.pdf]...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-886 (Sprint 12.1)

**Summary**: SUN Task Template Setup

**Tech Stack**: Not specified

**Solution Preview**: Action Plan Template for SUN Tasks

Create the Action Plan Template as specified in the AC





NOTE: Service Account field = ‘Bordering States’ as referenced in tasks, created as part of [+PR1050558-3521+|https://salesforce.atlassian.net/browse/PR10...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5288 (Sprint 12.2)

**Summary**: UAT Bug: C&CUAT405 When ClinicianCoverageUpdateBatch ran it did not update the provider contract rec

**Tech Stack**: Validation Rule

**Solution Preview**: Fix1: Relax the “Rate Pay Code Validation Rule” in Rate Pay Code to apply only for Practice Operation Contract

Fix 2: The spelling of the contract status in one of the SOQL is wrong correct it

Fix 3: Any one who have Client Change Managment object ...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5093 (Sprint 12.2)

**Summary**: UAT Enhancement: Add Time Type to Pay Codes Layout

**Tech Stack**: Not specified

**Solution Preview**: Add the fields as per AC...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4970 (Sprint 12.2)

**Summary**: UAT Enhancement: Risk Review - Add visibility to the Assessment on the Risk Review Case

**Tech Stack**: Not specified

**Solution Preview**: Grant Access based on AC



# Create new Picklist value at Type field on Assessment object
## In *ClinicianRiskReviewOS* OS, while creating Assessment, populate type field as *Risk Review, refer  Competency_SaveAssessmentResponse IP*
## Create a shar...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4902 (Sprint 12.2)

**Summary**: UAT Enhancement: Practice Operations Contract - NPPA Tier, Contract Start Date & Contract End Date r

**Tech Stack**: Validation Rule

**Solution Preview**: Validation Rule: in Contract for PO Contract

When Contract Status = Executed make field read as per AC

Validation rule should by pass for admins...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4628 (Sprint 12.2)

**Summary**: UAT Enhancement: C&CUAT232 Client Contract Term & Renewal Contract End Date Not Populating

**Tech Stack**: Formula Field

**Solution Preview**: Update the formula fields...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4593 (Sprint 12.2)

**Summary**: NP/PA Onboarding Comments field on HPF

**Tech Stack**: Not specified

**Solution Preview**: Create the field as per data dictionary

add read and edit access to all permission sets with HPF object access

add the field to the Record Page

ensure the field is cloned...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4553 (Sprint 12.2)

**Summary**: Clinician NP/PA Tier Updates

**Tech Stack**: Not specified

**Solution Preview**: AC1: The solution is similar of how the NPPA Tier is auto populated or user entered when there is a mismatch.  

Check if the Contract.Employment_Type__c is Employee Contract.Time_Type__c is Full Time, and clinician Contract.Account.Professional_Titl...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5642 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare189 - Special Terms in Contract didn't Route to Tactical

**Tech Stack**: Not specified

**Solution Preview**: AC1: Modify the Lightning Page layout make the fields Read Only on record page when status ≠ Draft

AC2: Update OmniStudio FlexCards to hide delete/trash actions when Recruiter + Status ≠ Draft and Hide Edit for Recruiters when Status ≠ Draft via Fle...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5474 (Sprint 12.3)

**Summary**: PROD Bug: Integration User needs ability to update/create Training record

**Tech Stack**: Not specified

**Solution Preview**: On Training Object → Contact Field → Change Sharing Settings → Read Only...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5470 (Sprint 12.3)

**Summary**: PROD Bug: Training object - Integration user needs access to Assigned Date field

**Tech Stack**: Not specified

**Solution Preview**: Refer the security matrix - give training fields access to *Data Integration* permission sets

!image-20260209-165347.png|width=889,alt="image-20260209-165347.png"!...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5208 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT390 From the Service Account Missing Client Contract Link In "Contracts"

**Tech Stack**: Formula Field

**Solution Preview**: Expose a formula field linking the contract related list...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5206 (Sprint 12.3)

**Summary**: UAT Enhancement: Update Intake Form State Input

**Tech Stack**: Not specified

**Solution Preview**: Covert the field to underlying refer to underlying picklist values and data type and create the as new values...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5173 (Sprint 12.3)

**Summary**: UAT Enhancement - Facility Change Request: Coverage Change UPDATE

**Tech Stack**: JavaScript

**Solution Preview**: Added examples for better understanding [https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?gid=1493984067#gid=1493984067|https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?g...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5104 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on Practice Ops record not pulled onto Clini

**Tech Stack**: Not specified

**Solution Preview**: Copy the field from PO to Clinician Contract...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5734 (Sprint 12.4)

**Summary**: PROD Enhancement: UPHypercare251 - Need 2 decimal places on certain fields (PCA)

**Tech Stack**: Validation Rule

**Solution Preview**: * *Update the following fields to be Number(3,2)*
* PreventativeCareAgreement.Admin_Hours__c Number(3,0)

* *Update the Validation Rule* to allow for 2 decimals and update failure message to read “Please enter a value with no more than 3 digits and 2...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5726 (Sprint 12.4)

**Summary**: Preventive Care Agreement - Add Field History

**Tech Stack**: Not specified

**Solution Preview**: Add Field Tracking for this fields (max 60 field for Shield)

Add the -Related List- flexcard to Record Page...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5703 (Sprint 12.4)

**Summary**: PROD Bug: UPHypercare228 - Missing service lines used for financial reporting

**Tech Stack**: Formula Field, REST

**Solution Preview**: * AC1: New Formula Field Label: Service Line, API Name Service_line_formula__c
** Formula is Text and show the value of Account.Service_Line__c
* AC2: Permission Set = *Corporate Support*
** Add READ to Service Line Formula
* AC3: Permission Set = *H...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5206 (Sprint 12.4)

**Summary**: UAT Enhancement: Update Intake Form State Input

**Tech Stack**: Not specified

**Solution Preview**: Covert the field to underlying refer to underlying picklist values and data type and create the as new values...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5173 (Sprint 12.4)

**Summary**: UAT Enhancement - Facility Change Request: Coverage Change UPDATE

**Tech Stack**: JavaScript

**Solution Preview**: Added examples for better understanding [https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?gid=1493984067#gid=1493984067|https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?g...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5104 (Sprint 12.4)

**Summary**: UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on Practice Ops record not pulled onto Clini

**Tech Stack**: Not specified

**Solution Preview**: Copy the field from PO to Clinician Contract...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-4744 (Sprint 12.4)

**Summary**: Contract Payment Agreement Related List Columns

**Tech Stack**: Formula Field

**Solution Preview**: Clinician Contract

Create new URL formula field in CPA to show the Account (Facility Name) from PNC>HPF 

Create new URL formula field in CPA to show the HPF Name from PNC>HPF 

Add the Contract CPA Related List View as per AC

Use formula field to ...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-6307 (Sprint 12.5)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 2 of 3 (Inactivation 

**Tech Stack**: Apex

**Solution Preview**: * 4 new Fields in HPF 
** {{Is_Sister_Site_Location__c - Checkbox}} - is true when sister-site links exist for that HPF account
** {{Inactivity_Qualified_270__c - Checkbox}} -  is true when crosses over 270 days threshold 
** {{Re_Contract__c - Check...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5823 (Sprint 12.5)

**Summary**: PROD Enhancement: HPF - Add Section = 'Insurance Information'

**Tech Stack**: Not specified

**Solution Preview**: # Create new *Permission Set*: Risk Management
## Read on *HPF*
### Edit on only the specific fields per AC2
#### Insurance Provided By
#### Certificate of Insurance Start
#### Certificate of Insurance Expiration
## Read on *Account*
### Edit on only...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5822 (Sprint 12.5)

**Summary**: PROD Enhancement: 'Risk Management' Account Team Role

**Tech Stack**: REST

**Solution Preview**: -TBD - on permission set =- *-Health Cloud Restricted User - Corporate Support Permission-*-, Add “Edit” to Account object-. – *REMOVE Access, will implement new permission set as part of* [https://salesforce.atlassian.net/browse/PR1050558-5823|https...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5642 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare189 - Special Terms in Contract didn't Route to Tactical

**Tech Stack**: Not specified

**Solution Preview**: AC1: Modify the Lightning Page layout make the fields Read Only on record page when status ≠ Draft

AC2: Update OmniStudio FlexCards to hide delete/trash actions when Recruiter + Status ≠ Draft and Hide Edit for Recruiters when Status ≠ Draft via Fle...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5641 (Sprint 12.5)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 1 of 3 (3 month repor

**Tech Stack**: Apex

**Solution Preview**: * 4 new Fields in HPF 
** {{Is_Sister_Site_Location__c - Checkbox}} - is true when sister-site links exist for that HPF account
** {{Inactivity_Qualified_270__c - Checkbox}} -  is true when crosses over 270 days threshold 
** {{Re_Contract__c - Check...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5457 (Sprint 12.5)

**Summary**: UAT Enhancement: Intake Form: Clinician Profile Assessment CTI section missing for IC

**Tech Stack**: Formula Field

**Solution Preview**: Change the Assessment Logic to use Job instead of HPF

Create a new formula field on the applicant record - please update DD with new formula field created...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5173 (Sprint 12.5)

**Summary**: UAT Enhancement - Facility Change Request: Coverage Change UPDATE

**Tech Stack**: JavaScript

**Solution Preview**: Added examples for better understanding [https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?gid=1493984067#gid=1493984067|https://docs.google.com/spreadsheets/d/19DsMwfjs0JSxk6DUu0KoafnznoQSOS83XHbvXCKMEA4/edit?g...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5853 (Sprint 12.6)

**Summary**: PROD Permissions: UPHypercare298: Unable to edit bootcamp date fields

**Tech Stack**: Not specified

**Solution Preview**: Add Training permissions to “Manage Clinicians” Permission Set (This Perm Set is already part of the DataQuality Perm Set Group.

*Object* Training__c
*Object Settings*
Read=True
Edit=True

*Read/Edit on Fields:*
- Bootcamp Completion Date	Bootcamp_C...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5703 (Sprint 12.6)

**Summary**: PROD Bug: UPHypercare228 - Missing service lines used for financial reporting

**Tech Stack**: Formula Field, REST

**Solution Preview**: * AC1: New Formula Field Label: Service Line, API Name Service_line_formula__c
** Formula is Text and show the value of Account.Service_Line__c
* AC2: Permission Set = *Corporate Support*
** Add READ to Service Line Formula
* AC3: Permission Set = *H...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5642 (Sprint 12.6)

**Summary**: PROD Enhancement: UPHypercare189 - Special Terms in Contract didn't Route to Tactical

**Tech Stack**: Not specified

**Solution Preview**: AC1: Modify the Lightning Page layout make the fields Read Only on record page when status ≠ Draft

AC2: Update OmniStudio FlexCards to hide delete/trash actions when Recruiter + Status ≠ Draft and Hide Edit for Recruiters when Status ≠ Draft via Fle...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5999 (Sprint 13)

**Summary**: PROD Enhancement: Recruiter Self-Service: Password Reset Link / Username Visibility

**Tech Stack**: Not specified

**Solution Preview**: # New Action button on Clinician Person Account Page Layout named “Reset Password”
# OnClick query the User record related to the Clinician person Account and store the user ID
# Invoke {{System.resetPassword(userId, sendEmail)}}
# Log an Activity Ty...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5984 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare369 - HPF Termination Date not correct

**Tech Stack**: Not specified

**Solution Preview**: *DevNotes:* 

+ONLY+ - Update the help text property of the field: 

*HealthcarePractitionerFacility*.+_TerminationDate_+ 

*From:* _“Date the practitioner stopped working at this facility.”_

*To:* *_“_*_AKA ‘TSG Inactive Date’. Date stamp that the ...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5840 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare289 - Risk Team - Needs Access to Edit Fields

**Tech Stack**: Not specified

**Solution Preview**: * Configure as per AC for Security Matrix and AC
* Permission Set = View Client Contracts (3/17: added to address findings on subtask 6230)
** Add Read for fields:
*** SCP Corporate Entity
*** Time Type...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6307 (Sprint 14)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 2 of 3 (Inactivation 

**Tech Stack**: Apex

**Solution Preview**: * 4 new Fields in HPF 
** {{Is_Sister_Site_Location__c - Checkbox}} - is true when sister-site links exist for that HPF account
** {{Inactivity_Qualified_270__c - Checkbox}} -  is true when crosses over 270 days threshold 
** {{Re_Contract__c - Check...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6264 (Sprint 14)

**Summary**: Create two fields on Integration_Log__c - Error_Code__c and Retry_Count__c

**Tech Stack**: Not specified

**Solution Preview**: Two fields will be created on the existing salesforce object along with the permissions necessary to see them on the form...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6208 (Sprint 14)

**Summary**: PROD Enhancement: Remove ability for Recruiters to create Account Record Type = Person Account

**Tech Stack**: Not specified

**Solution Preview**: * Remove Person Account from the Assigned Record Types on the ATS Recruiter Perm Set - OK...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6163 (Sprint 14)

**Summary**: Client Change Management: Update Permission Set = Manage Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: *Solution (Status: Ready to Work)* 

+*AC1*+

PS: ‘Manage_Client_Contracts’

# READ permissions following fields:

* Client_Change_Management__c.Healthcare_Practitioner_Facility__c

_/_**Review PageLayout(s) AND/OR RecordPage(s) field is added**/

Se...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6097 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare410 - Unable to check the Nocturnist box on HPFs

**Tech Stack**: Not specified

**Solution Preview**: Add *Read, Edit for field HealthcarePracticitionerFacility.Nocturnist__c* on the Permission Set Named *Manage Clinician to Facility Relationships*...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5999 (Sprint 14)

**Summary**: PROD Enhancement: Recruiter Self-Service: Password Reset Link / Username Visibility

**Tech Stack**: Not specified

**Solution Preview**: # New Action button on Clinician Person Account Page Layout named “Reset Password”
# OnClick query the User record related to the Clinician person Account and store the user ID
# Invoke {{System.resetPassword(userId, sendEmail)}}
# Log an Activity Ty...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5984 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare369 - HPF Termination Date not correct

**Tech Stack**: Not specified

**Solution Preview**: *DevNotes:* 

+ONLY+ - Update the help text property of the field: 

*HealthcarePractitionerFacility*.+_TerminationDate_+ 

*From:* _“Date the practitioner stopped working at this facility.”_

*To:* *_“_*_AKA ‘TSG Inactive Date’. Date stamp that the ...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5921 (Sprint 14)

**Summary**: PROD Enhancement: Service Account, HPF and Clinician Contract - Add Billing Only Indicator

**Tech Stack**: Not specified

**Solution Preview**: AC1: Add a field “*Billing Only Account*” checkbox in Account and assign security as per AC

# Field History
# Edit Access: System Administrators & Data Quality
# Read Only for all Others



AC2: Add a field “*Billing Only (Service Account)*” checkbo...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5840 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare289 - Risk Team - Needs Access to Edit Fields

**Tech Stack**: Not specified

**Solution Preview**: * Configure as per AC for Security Matrix and AC
* Permission Set = View Client Contracts (3/17: added to address findings on subtask 6230)
** Add Read for fields:
*** SCP Corporate Entity
*** Time Type...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5641 (Sprint 14)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 1 of 3 (3 month repor

**Tech Stack**: Apex

**Solution Preview**: * 4 new Fields in HPF 
** {{Is_Sister_Site_Location__c - Checkbox}} - is true when sister-site links exist for that HPF account
** {{Inactivity_Qualified_270__c - Checkbox}} -  is true when crosses over 270 days threshold 
** {{Re_Contract__c - Check...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-4780 (Sprint 14)

**Summary**: UAT Enhancement: Optimize Clinician Contract Views

**Tech Stack**: Not specified

**Solution Preview**: Create the related list as per AC for Apttus__APTS_Agreement__c Object...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-3478 (Sprint 14)

**Summary**: Agentforce Clinician Rate Change Notices Use Case - Enhancement

**Tech Stack**: Not specified

**Solution Preview**: Leverage default LLM (OpenAI GPT-4)

Contract Custom Field - “Base Agreement Date” (Date)



Detailed Solution Notes: [https://docs.google.com/document/d/1seAuTkf2faZ-NMlNIjdD2R0iufTQiat3PsFawymX03o/edit?tab=t.0#heading=h.rm31g9f34slk|https://docs.go...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-242 (Sprint 2)

**Summary**: Update Standard Care Fee Agreement to Preventive Care Agreement

**Tech Stack**: Not specified

**Solution Preview**: * Configure Preventive Care Agreement LRP with standard design
** Template = header and one region
** Details tab with page layout
* Configure page layout as specified in data dictionary...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-147 (Sprint 2)

**Summary**: CPA Relationship and Contract Records

**Tech Stack**: Not specified

**Solution Preview**: Create 2 custom objects - LRP and page layout for both objects

Create 3 record types on Compliance Rule Assignment with descriptions (same LRP with different page layouts)

Create Collaborative Practice Agreement record type on Contract...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-83 (Sprint 2)

**Summary**: Clinician Contract Records

**Tech Stack**: Not specified

**Solution Preview**: Configure page layout
Configure lightning record page
Assign as app default...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-485 (Sprint 3)

**Summary**: Integration Log Object

**Tech Stack**: Not specified

**Solution Preview**: Create the Object: Integration Log API: Integration_Log__c

Create a Tab: Integration Log

Create the Fields as per data dictionary

*Permission Set:*

Corporate Support Group (All Fields): Read, Create

Data Integration (All Fields): Read, Create, E...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-421 (Sprint 3)

**Summary**: Clinician Risk Review - Record Type & Layout

**Tech Stack**: Not specified

**Solution Preview**: Enable Discovery Framework

Turn on All the related settings Discovery Framework

create Risk Review record type on Case

LRP and page layout for risk review case

add lookup to Assessment object on Case...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-382 (Sprint 3)

**Summary**: Facility Rate Creation - Summary Screen

**Tech Stack**: Not specified

**Solution Preview**: when Service Account has a Contract (record type = Client) in Status = Draft AND Contract Payment Agreement in Status = Draft, then display related Preventative Care Agreements

And upon selecting button = Finish, then the system shall:

* Create a C...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-374 (Sprint 3)

**Summary**: Code Set Object

**Tech Stack**: Not specified

**Solution Preview**: Configure LRP

Custom fields & update picklist values on fields

Create records for Risk Review and Shift - manual step for each environment  (Link to [Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-358 (Sprint 3)

**Summary**: Assessment & Assessment Question Response Object

**Tech Stack**: Not specified

**Solution Preview**: create Form Response custom object

LRP

security matrix - permission sets and OWD...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-340 (Sprint 3)

**Summary**: Update the Account Account Relationship

**Tech Stack**: Not specified

**Solution Preview**: configure LRP for Account Account Relationship object

add related lists to Corporate Entity and Service Account pages

create record for Party Role Relationship as specified in the [Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJ...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-337 (Sprint 3)

**Summary**: Standardize Facility Title Values

**Tech Stack**: Not specified

**Solution Preview**: load code set records for facility title using Health Cloud Records sheet

Object & field updates:

* Healthcare Practitioner Facility
** Add “Facility Title”
** Remove “Current Facility Title” & “Future Facility Title”
* Preventive Care Agreement
**...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-298 (Sprint 3)

**Summary**: Facility Rate Creation - Type of Rate = Shift

**Tech Stack**: Not specified

**Solution Preview**: unit of measure? object or *picklist* (updated in data dictionary)

And upon selecting button = Finish, then the system shall:

* Create a Contract (record type = Client) record
** Status = Draft
** Account Name = <Service Account record>
** _do not ...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-234 (Sprint 3)

**Summary**: Standardize State Picklist Values

**Tech Stack**: Not specified

**Solution Preview**: [Configure State and Country/Territory Picklists|https://help.salesforce.com/s/articleView?id=xcloud.admin_state_country_picklists_configure.htm&type=5]

custom fields leverage global picklist for state values

||*Full Name*||*State Code*||
|Alaska|A...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-827 (Sprint 4)

**Summary**: Configure Case Page - Intake Form

**Tech Stack**: Not specified

**Solution Preview**: configure Intake Form case page layout and LRP according to data dictionary and AC

create Case sharing rules as specified in security matrix

assign test users to public groups according to security matrix...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-776 (Sprint 4)

**Summary**: SPIKE - Pro Forma Outputs - POC for Option 1

**Tech Stack**: Not specified

**Solution Preview**: * DO NOT promote to QA, this spike story will live in Dev Only.
* See data dictionary for fields to be created in 3 tabs prefixed with “BOB Contract Option 1”
* Create 3 new Custom Objects:
** “Pro Forma Model” 
** “Pro Forma Service Line”
** “Pro Fo...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-716 (Sprint 4)

**Summary**: Update Guided Clinician Creation

**Tech Stack**: Not specified

**Solution Preview**: * Design prefer for both “Medical License” & “Geographic Preference” fields to display/behave like the standard SF multi-select picklist.
* Board Certification Status - create one record if any of the below values are selected, but do not create dupl...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-715 (Sprint 4)

**Summary**: Facility Rate Creation - Summary tab

**Tech Stack**: Not specified

**Solution Preview**: * When testing ensure you have at least 50 records
* Facility Title & Rate & *Unit of Measure* (Preventive Care Agreement.FacilityTitle__c & Preventive Care Agreement.Rate__c & *_Preventive Care Agreement._**Unit_of_Measure__c*)
** *Format*:
First li...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-703 (Sprint 4)

**Summary**: Facility Rate Creation - Button and Record Creation

**Tech Stack**: Not specified

**Solution Preview**: Upon selecting button = Finish, then the system shall create the following records:

* Create a *Contract Payment Agreement* record related to the Contract (Client) record.
** Name = <“Account Name” from the Client Contract record “-” Type>
** Status...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-608 (Sprint 4)

**Summary**: Facility Rate Creation - Type of Rate = Bonus

**Tech Stack**: Not specified

**Solution Preview**: * Guided Experience UI Mapping:
* “Type” picklist values defined by: 
** Field = Code Set Type = Bonus
** Field = Active = True/Checked
** Creation of Code Set is a Subtask under [https://salesforce.atlassian.net/browse/PR1050558-469|https://salesfor...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-606 (Sprint 4)

**Summary**: Facility Rate Creation - Type of Rate = Variable

**Tech Stack**: Not specified

**Solution Preview**: Guided Experience UI Mapping:

* “Type” picklist values defined by:
** Field = Code Set Type = Variable
** Field = Active = True/Checked
** Creation of Code Set is a Subtask under [https://salesforce.atlassian.net/browse/PR1050558-469|https://salesfo...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-605 (Sprint 4)

**Summary**: Facility Rate Creation - Type of Rate = Stipend

**Tech Stack**: Not specified

**Solution Preview**: Guided Experience UI Mapping:

* “Type” picklist values defined by: 
** Field = Code Set Type = Stipend
** Field = Active = True/Checked
** Creation of Code Set is a Subtask under [https://salesforce.atlassian.net/browse/PR1050558-469|https://salesfo...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-592 (Sprint 4)

**Summary**: Create Default Task Record Type and Page Layout - Portal

**Tech Stack**: Not specified

**Solution Preview**: create Default record type on Task object

clean up record type assignment on Corporate Support Group permission set

LRP for tasks - assigned to Corporate Support, System Administrator, and Core HC Customer Community Plus Login User profiles...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-561 (Sprint 4)

**Summary**: Clinician Onboarding Case & Task Templates

**Tech Stack**: Not specified

**Solution Preview**: Story includes the setup of Action Plans ([https://help.salesforce.com/s/articleView?id=ind.fsc_action_plans_admin_setup.htm&type=5|https://help.salesforce.com/s/articleView?id=ind.fsc_action_plans_admin_setup.htm&type=5|smart-link] ), generation of ...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-470 (Sprint 4)

**Summary**: Facility Rate Creation - Type of Rate = Leadership Incentives

**Tech Stack**: Not specified

**Solution Preview**: Guided Experience UI Mapping:

* “Type” picklist values defined by: 
** Field = Code Set Type = Leadership Incentives
** Field = Active = True/Checked
** Creation of Code Set is a Subtask under [https://salesforce.atlassian.net/browse/PR1050558-469|h...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-469 (Sprint 4)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * All fields listed above should be made visible on permission sets that have object access.
* Subtask to update/add code sets....

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-467 (Sprint 4)

**Summary**: Intake Form Case

**Tech Stack**: Not specified

**Solution Preview**: * Story includes creating new Record Type = Clinician Intake Form
* NOTE: this story will update [https://salesforce.atlassian.net/browse/PR1050558-245|https://salesforce.atlassian.net/browse/PR1050558-245|smart-link] 
* NOTE: Related story to update...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-430 (Sprint 4)

**Summary**: Clinician Attributes in Salesforce to Send to Workday

**Tech Stack**: Not specified

**Solution Preview**: * NO Integration needed in this story.
* Confirm Account fields match the labels specified in the user story
* Create I-9 Completed field on Contact object & add to Person Account layout
* Update permission sets (anyone who can see Account (Service A...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-429 (Sprint 4)

**Summary**: Credentialing & Scheduling Attributes from QGenda

**Tech Stack**: Not specified

**Solution Preview**: * includes field creation, value updates and layout updates
* All fields listed in the story should be made visible on permission sets that have object access.
The Permissions Sets that should be updated: (bold indicate which permission sets are asso...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-385 (Sprint 4)

**Summary**: Update Guided Clinician Creation - Geographic Preference

**Tech Stack**: Not specified

**Solution Preview**: * “Geographic Preference” field _Contact object_ - Update from Text field to a State multi-select picklist
* Design prefer for both “Medical License” & “Geographic Preference” fields to display/behave like the standard SF multi-select picklist.
* Ens...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-379 (Sprint 4)

**Summary**: Client Division (Operational Structure)

**Tech Stack**: Not specified

**Solution Preview**: create custom object

create LRP

update OWD & permission sets (includes updates to Permission set group = *Staffing Operations*, add “*Manage Client Contracts*” permission set)

Field & page layout updates on Account (Service Account)...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-359 (Sprint 4)

**Summary**: Create Default Task Record Type and Page Layout

**Tech Stack**: Not specified

**Solution Preview**: create Default record type on Task object

clean up record type assignment on Corporate Support Group permission set

LRP for tasks - assigned to Corporate Support, System Administrator, and Core HC Customer Community Plus Login User profiles...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-227 (Sprint 4)

**Summary**: Account Hierarchy Columns

**Tech Stack**: Not specified

**Solution Preview**: Object Manager > Account > Hierarchy Columns > New

Everyone can access the account hierarchy as long as they can see the account....

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-145 (Sprint 4)

**Summary**: Manual Onboarding Case Creation

**Tech Stack**: Not specified

**Solution Preview**: Clinician Onboarding case record type

Account is populated with Service Account record from Healthcare Practitioner Facility lookup

<10 fields to be created

Action to create case

Priority is on the case.

Note: access to create Cases with the spe...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-839 (Sprint 5)

**Summary**: Facility Rate Creation - Type of Rate = All: Add Override Prohibited

**Tech Stack**: Not specified

**Solution Preview**: * Add create new “Override Prohibited” field (field visible to all permission that have access to the object), add to layout, and ensure populated upon record creation
** Data Dictionary tab = Preventive Care Agreement
* Mock
** !image-20250711-15345...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-838 (Sprint 5)

**Summary**: Facility Rate Creation - Type of Rate = Variable, Stipend & Leadership Incentive: Add Notes

**Tech Stack**: Not specified

**Solution Preview**: * Add create new “Notes” field (field visible to all permission that have access to the object), add to layout, and ensure populated upon record creation
** Data Dictionary tab = Preventive Care Agreement
* Mock
** !image-20250711-153443.png|width=18...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-836 (Sprint 5)

**Summary**: Update Employment Type on Healthcare Practitioner Facility

**Tech Stack**: Formula Field

**Solution Preview**: * Dependent upon story - [https://salesforce.atlassian.net/browse/PR1050558-833|https://salesforce.atlassian.net/browse/PR1050558-833|smart-link] for field and data setup. 
* See DD tab = Healthcare Practitioner Facility, for update to Employment Typ...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-833 (Sprint 5)

**Summary**: Update Code Set Object and Facility Title Records

**Tech Stack**: Formula Field

**Solution Preview**: * -change Employment_Type__c picklist on HPF to formula field to display (from Facility Title lookup to Code Set on HPF) the value in Code Set Sub Type picklist field- - moved comment to 836
* Update the Contact (Clinician Person Account) field = Pro...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-774 (Sprint 5)

**Summary**: Facility Rate Creation - Type of Rate = Variable: Modify Type

**Tech Stack**: Not specified

**Solution Preview**: * Load [Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?gid=916344142#gid=916344142] - see tab = Code Set (Variable)
* Add new fields (field visible to all permission that have access to t...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-697 (Sprint 5)

**Summary**: Shift Custom Object & PCA Cleanup

**Tech Stack**: Not specified

**Solution Preview**: * clean up fields on Preventive Care Agreement - create and delete
** Note on the UI “ContractPaymentAgreement ID” label is displayed. Standard, can’t edit. 
* clean up fields on Code Set - create and delete
* create Shift custom object
** create tab...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-471 (Sprint 5)

**Summary**: Pro Forma Outputs

**Tech Stack**: Validation Rule

**Solution Preview**: * Delete the POC object as part of Spike Story ([https://salesforce.atlassian.net/browse/PR1050558-776|https://salesforce.atlassian.net/browse/PR1050558-776|smart-link] )
* Create Pro Forma Model base on Data Dictionary
** Ensure field visibility bas...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-291 (Sprint 5)

**Summary**: Create HPF: Facility Selection & Specify Facility Title

**Tech Stack**: REST

**Solution Preview**: * Refer UX-291.jpeg file as Mock UI to introduce four new fields.
* When User click save - populate all four attributes on newly created HPF records.
* Updated error to cover both search scenarios: No Service Account records found, or the Service Acc...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1747 (Sprint 6)

**Summary**: Integration User - Add New Provider Network Contract fields

**Tech Stack**: Formula Field

**Solution Preview**: * Ensure when you create the new fields that visibility is granted to all permission sets with access to the object. 

Create 2 formula fields that points to the respective values of Facility_Title__r.Name and Time_Type__c from HPF. Time_Type__c is a...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1710 (Sprint 6)

**Summary**: Integration User - Edit HPF

**Tech Stack**: Not specified

**Solution Preview**: * [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesforce%20team%20Deliverables/Architecture...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1435 (Sprint 6)

**Summary**: Auto Create Relationship Records for CPA - CPA Review Object

**Tech Stack**: Not specified

**Solution Preview**: * Data Dictionary: *CPA Review*
** New Custom object, add fields & layout
** Ensure all fields are made visible on permission sets that have object access. Permission Sets:
*** System Administrator
*** Manage Collaborative Practice Agreements
* Check...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1389 (Sprint 6)

**Summary**: Clinician Contract Request: Summary Screen - Add HPF

**Tech Stack**: Not specified

**Solution Preview**: Follow solution approach used in Client Contract *SpecifyRates_SummaryContractScreen* flexcard which is built for Client Contract and render records as per below mock UI

!image-20250728-140903.png|width=707,height=671,alt="image-20250728-140903.png"...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1367 (Sprint 6)

**Summary**: Pay Code Data Load

**Tech Stack**: Not specified

**Solution Preview**: Load the Data from Health Cloud Records sheet into Pay Code object.

[https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?gid=1262543513#gid=1262543513|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZD...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1305 (Sprint 6)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: * Ensure you follow the layout in the Data dictionary 
** For Healthcare Practitioner Facility, there were 2 fields added in sprint 5 (702). Can you please include placement of the following fields:  Latest Contract Signed Date, Anticipated Terminati...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1243 (Sprint 6)

**Summary**: Client Contract Update - Pay Code Association

**Tech Stack**: Not specified

**Solution Preview**: Create Rate Pay Codes -Tags- Tab in Contract of Record Type = Client

Display All the *Preventive Care Agreement* records for the Contract where *Contract Payment Agreement* Type = Shift

* Field to Display
** *Shift*.Shift Full Name
** *Facility Tit...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1173 (Sprint 6)

**Summary**: Pay Code Association to Client/Clinician

**Tech Stack**: Not specified

**Solution Preview**: * See Data Dictionary for Details on Rate Pay Code
** Ensure fields are made visible on permission sets that have object access. Permission Sets:
*** System Administrator
Manage Client Rates (R,C,E,D)
View Client Rates (R)
Manage Client Contracts (R,...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1112 (Sprint 6)

**Summary**: Update Case layout - Clinician Intake Form & Risk Review

**Tech Stack**: Not specified

**Solution Preview**: Update the Record Page and Page Layout...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1111 (Sprint 6)

**Summary**: Standardize Service Line Records

**Tech Stack**: Not specified

**Solution Preview**: load records into Service Line object...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1074 (Sprint 6)

**Summary**: Add Files on Contract

**Tech Stack**: Not specified

**Solution Preview**: Add Files related list to the required Contract Page Layout (the one for Clinicia RT).

!Captura de pantalla 2025-07-23 a la(s) 10.01.20 p.m..png|width=1277,height=825,alt="Captura de pantalla 2025-07-23 a la(s) 10.01.20 p.m..png"!...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1070 (Sprint 6)

**Summary**: Clinician Contract Request: Contract Changes

**Tech Stack**: Not specified

**Solution Preview**: Given that we click on the Contract Request button on Clinician, Omniscrip Clinician/ContractRequest runs.

# Screen Shows Employment Type Radio Button using Picklist (Contract.Employment Type)  Built Part of  [https://salesforce.atlassian.net/browse...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-891 (Sprint 6)

**Summary**: Clinician Application Withdrawal - HC Portal

**Tech Stack**: Not specified

**Solution Preview**: * Use a flex card to display each ATS Applicant record. 
* For each ATS Applicant record that should be a button *Withdraw Application*
* When the user clicks on the Individual button show the message as specific in AC
* Update the ATS record with th...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-471 (Sprint 6)

**Summary**: Pro Forma Outputs

**Tech Stack**: Validation Rule

**Solution Preview**: * Delete the POC object as part of Spike Story ([https://salesforce.atlassian.net/browse/PR1050558-776|https://salesforce.atlassian.net/browse/PR1050558-776|smart-link] )
* Create Pro Forma Model base on Data Dictionary
** Ensure field visibility bas...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-249 (Sprint 6)

**Summary**: Pay Code Management

**Tech Stack**: Not specified

**Solution Preview**: * Data Dictionary: *Pay Code*
** Ensure all fields are made visible on permission sets that have object access. Permission Sets:
*** System Administrator
Manage Client Rates (R)
View Client Rates (R)
Manage Client Contracts (R)
View Client Contracts ...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-167 (Sprint 6)

**Summary**: Collaborative Practice Agreement Legal Requirements

**Tech Stack**: Not specified

**Solution Preview**: * Compliance Rule Assignments records ([Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?usp=sharing]) - loading covered under 1072
* 3 Record Type and 3 Record Page
** *Compliance Rule Ass...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1775 (Sprint 7)

**Summary**: Offboarding Case Record Type Setup

**Tech Stack**: Not specified

**Solution Preview**: * See DD
** New Record Type for = Case (Clinician Offboarding)
** layout...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1749 (Sprint 7)

**Summary**: Integration User - Remove old Provider Network Contract fields

**Tech Stack**: Formula Field

**Solution Preview**: * Ensure that when we added the new formula fields in story 1747 we updated field visibility on all permission sets that had access to the object, not just Data Integration....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1747 (Sprint 7)

**Summary**: Integration User - Add New Provider Network Contract fields

**Tech Stack**: Formula Field

**Solution Preview**: * Ensure when you create the new fields that visibility is granted to all permission sets with access to the object. 

Create 2 formula fields that points to the respective values of Facility_Title__r.Name and Time_Type__c from HPF. Time_Type__c is a...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1712 (Sprint 7)

**Summary**: Update Sharing Settings

**Tech Stack**: Not specified

**Solution Preview**: Update sharing settings to Public Read/Write for health provider object...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1710 (Sprint 7)

**Summary**: Integration User - Edit HPF

**Tech Stack**: Not specified

**Solution Preview**: * [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesforce%20team%20Deliverables/Architecture...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1708 (Sprint 7)

**Summary**: Manage Sister Relationships

**Tech Stack**: Validation Rule, Formula Field, REST

**Solution Preview**: Account Account Relationship - manually enter the relationship between sites, using party  role relationship
Use ARC (Actionable Relationship center) to visually display the sites AAR (relationship established above) in under subtab “Sites” in Servic...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1704 (Sprint 7)

**Summary**: View HPFs from Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: Contract (Master)

* Provider Network Contract(Detail) – Has lookup to HPF

On Clinician Contract lightning page, edit and add sub tab, with custom label “Facilities”
Use the ProviderNetworkContract, to get the Healthcare_Practitioner_Facility__c rec...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1666 (Sprint 7)

**Summary**: Clinician Contract: Other Bonus Details

**Tech Stack**: Not specified

**Solution Preview**: * Update Clinician Rate Omni Script
* When Selecting bonus type, (multi-select picklist) if “Other” option is also selected, then display text field “Other Bonus details”. Map this to Notes field (PreventiveCareAgreement.Notes__c)....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1659 (Sprint 7)

**Summary**: Clinician Contract Special Terms

**Tech Stack**: Not specified

**Solution Preview**: In object Contract, add new Field Contract Special Terms

Add the field to Contract Record Page *Contract (Clinician)*

User Navigated to the Contract record to enter any Contract Special Term....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1655 (Sprint 7)

**Summary**: Auto Create Relationship Records for CPA - Physician

**Tech Stack**: Apex, Validation Rule

**Solution Preview**: *Validation Rule:*

Create a validation rule in CPA to check if  Physician Healthcare Facility.AccountID = NP/PA Healthcare Practitioner Facility.AccountID other wise throw error that “CPA Account Association mismatch. Make sure the MD/DO and NP/PA a...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1651 (Sprint 7)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: Configure as per Data Dictionary as per AC


HPF - update the following fields to read only: Credentialling Status and Temporary Inactive Reason, EXCEPT any Integration permission set

All fields listed above should be made visible on permission sets...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1582 (Sprint 7)

**Summary**: Tactical Team Queue

**Tech Stack**: Not specified

**Solution Preview**: Use OOTB Feature

!image-20250810-143347.png|width=1192,height=234,alt="image-20250810-143347.png"!

* New List view = *Tactical Team Work Items*
** Filter by: Assigned To = Tactical Team Queue & Status = Assigned
** Columns: Related Record, Related ...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1415 (Sprint 7)

**Summary**: Creating Shifts - Physician or NP/PA

**Tech Stack**: Not specified

**Solution Preview**: Create a new Picklist field Type in *Shift* object as specified in Data Dictionary

make the Field as Required as marked in Data Dictionary.

# Shift Name
# Shift Iteration
# Shift Day of the Week
# Shift Start Time
# Shift End Time

Error message = ...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1112 (Sprint 7)

**Summary**: Update Case layout - Clinician Intake Form & Risk Review

**Tech Stack**: Not specified

**Solution Preview**: Update the Record Page and Page Layout...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1074 (Sprint 7)

**Summary**: Add Files on Contract

**Tech Stack**: Not specified

**Solution Preview**: Add Files related list to the required Contract Page Layout (the one for Clinicia RT).

!Captura de pantalla 2025-07-23 a la(s) 10.01.20 p.m..png|width=1277,height=825,alt="Captura de pantalla 2025-07-23 a la(s) 10.01.20 p.m..png"!...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-891 (Sprint 7)

**Summary**: Clinician Application Withdrawal - HC Portal

**Tech Stack**: Not specified

**Solution Preview**: * Use a flex card to display each ATS Applicant record. 
* For each ATS Applicant record that should be a button *Withdraw Application*
* When the user clicks on the Individual button show the message as specific in AC
* Update the ATS record with th...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-425 (Sprint 7)

**Summary**: Clinician Contract List Views

**Tech Stack**: Not specified

**Solution Preview**: * Use Filter By and Specify configure related list based on AC and add to Contract Record page
* [https://salesforce.atlassian.net/browse/PR1050558-1651|https://salesforce.atlassian.net/browse/PR1050558-1651|smart-link] - dependent story, Adds new fi...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-306 (Sprint 7)

**Summary**: Clinician Offboarding - Termination Details

**Tech Stack**: Not specified

**Solution Preview**: For the selected HPF from previous screen (701) 
Display the fields mentioned above as a edit block, edit view with the help icons at the table header
on completion, create Case records of record type Offboarding (added to Perm Set = *Manage Clinicia...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-146 (Sprint 7)

**Summary**: Auto Create Relationship Records for CPA - Nurse Practitioner or Physician Assistant

**Tech Stack**: Apex, Validation Rule

**Solution Preview**: *Validation Rule:*

Create a validation rule in CPA to check if  Physician Healthcare Facility.AccountID = NP/PA Healthcare Practitioner Facility.AccountID other wise throw error that “CPA Account Association mismatch. Make sure the MD/DO and NP/PA a...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2620 (Sprint 8)

**Summary**: Incorrect picklist values in Status field using Contract Record (Record Type = Client Contract & Let

**Tech Stack**: Not specified

**Solution Preview**: Updated the record types with correct picklist values...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2423 (Sprint 8)

**Summary**: Clinician Contract: Set Start Date for Cloned Contract

**Tech Stack**: Not specified

**Solution Preview**: While cloning, for CPA - Convert Contract’s Date to Datetime field and use the generic time
For PCA, no need to create/populate start date and end date, as it does not exist on the object....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2186 (Sprint 8)

**Summary**: Clinical Match Case Record Type - Update Sharing Rule

**Tech Stack**: Not specified

**Solution Preview**: * Update Group Name and Label:
** From: Clinical Match Request Group
** To: Clinical Match Request
* Update existing sharing rule for 'Manage Cases'
** Criteria: Case: Case Record Type not equal to Risk Review*, Clinical Match*...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2162 (Sprint 8)

**Summary**: Clinician Attributes from Workday to Salesforce

**Tech Stack**: Not specified

**Solution Preview**: Create the fields mentioned on clinician person account.
FLS : Manage Clinician Recruiting permission set, add read permission

* NO Integration needed in this story.
* Confirm Account fields match the labels specified in the user story
* Create I-9 ...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2143 (Sprint 8)

**Summary**: Opportunity & Services Objects Info Due Updates

**Tech Stack**: Not specified

**Solution Preview**: * Add Field per DD
** Tab = Opportunity (Growth Opportunity) 
** Tab = Services
* Update FLS for new fields for all permission sets with access to the object...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2142 (Sprint 8)

**Summary**: Contract Object Record Type Setup

**Tech Stack**: Not specified

**Solution Preview**: * Add new Contract record types
* Update label of existing contract record type = “Client' to 'Practice Operations '
* Data Dictionary updates - Add fields and update layout
** See tab = Contract (Letter of Intent)
** Contract (Client Contract)
* Upd...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2123 (Sprint 8)

**Summary**: Clinician Contract Request: Bonus Details

**Tech Stack**: Not specified

**Solution Preview**: 6 New fields to be created on Preventive Care Agreement (per data dictionary)
FLS: Recruiter persona, and any other persona that has access to the Contract.

Create the new fields the current screen (where we capture type, rate , unit of measure etc)...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2113 (Sprint 8)

**Summary**: Review Bootcamp and Proctor Fields

**Tech Stack**: Not specified

**Solution Preview**: Create a new obejct : Training. Create fields mentioned in DD ( for both Compliance and Proctorship sheets, ensure no duplicate fields are created)
Types: Proctorship, Compliance.
Use the type field to display the fields given in Compliance sheet and...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1799 (Sprint 8)

**Summary**: Client Contracting - Early Start Confirmed

**Tech Stack**: REST

**Solution Preview**: * DD tab = Opportunity (Growth Oppty)
** Add New field = Green Light for Client Outreach
** Update layout
* Add field visibility to all permission sets with access to the object
* Restrict field edit access to only System Admin & Sales VP users. 
** ...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1775 (Sprint 8)

**Summary**: Offboarding Case Record Type Setup

**Tech Stack**: Not specified

**Solution Preview**: * See DD
** New Record Type for = Case (Clinician Offboarding)
** layout...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1773 (Sprint 8)

**Summary**: Client Shift Rate Configuration

**Tech Stack**: Not specified

**Solution Preview**: * Data Dictionary - tab = Code Set, new field: “Shift Type”
* [Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?gid=719228658#gid=719228658] - tab = Code Set (Facility Title), upsert
* !ima...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1704 (Sprint 8)

**Summary**: View HPFs from Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: Contract (Master)

* Provider Network Contract(Detail) – Has lookup to HPF

On Clinician Contract lightning page, edit and add sub tab, with custom label “Facilities”
Use the ProviderNetworkContract, to get the Healthcare_Practitioner_Facility__c rec...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1676 (Sprint 8)

**Summary**: Client Contracting - “LOI Request”

**Tech Stack**: Not specified

**Solution Preview**: * Data Dictionary updates:
** See tab = Contract (Letter of Intent)
** Add fields
** update layout
* Update FLS for new fields for all permission sets with access to the object

!image-20250811-235942.png|width=765,height=736,alt="image-20250811-2359...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1675 (Sprint 8)

**Summary**: Client Needs Questionnaire - Data Collection

**Tech Stack**: Not specified

**Solution Preview**: * AS part of this story add new field to Oppty =  “Client Questionnaire Status”, see DD.
* Update FLS For new field for all permissions that have object access
* Story covers this part of the future state:

!image-20250812-185758.png|width=445,height...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1651 (Sprint 8)

**Summary**: Add Additional Fields

**Tech Stack**: Not specified

**Solution Preview**: Configure as per Data Dictionary as per AC


HPF - update the following fields to read only: Credentialling Status and Temporary Inactive Reason, EXCEPT any Integration permission set

All fields listed above should be made visible on permission sets...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1097 (Sprint 8)

**Summary**: Intake Form Case - Load Assessment Questions & Capture Question Responses

**Tech Stack**: REST

**Solution Preview**: For list of questions to load into the Discovery Framework object = Assessment Question, see document = Clinician Intake Form Case_Questions{color:#bf2600}.{color} tabs:

# *Clinician Information screen*
# *Conflict of Interest screen*
# *CAQH screen...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1095 (Sprint 8)

**Summary**: Intake Form Case - Conflict of Interest Form

**Tech Stack**: Not specified

**Solution Preview**: Create Question set for the mentioned type of document - and add the appropriate questions and response.
This intake form applies only to clinicians where Employment Type is Employee (check HPF records where Status does not equal Inactive, Facility T...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-775 (Sprint 8)

**Summary**: Corporate Compliance Status

**Tech Stack**: Not specified

**Solution Preview**: Add the Training related object to Clinician.
Data Dictionary fields updated

* Security Matrix: See updates on 
** Tab = OWD
** Tab = Permission sets
** Tab = User Setup for Human Resources...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-488 (Sprint 8)

**Summary**: Record Type Cleanup

**Tech Stack**: Not specified

**Solution Preview**: Deactivate the listed record types for Contract. Ensure the two record types are created - letter of intent and practice operations.
Deactivate the listed record types for Opportunity.
Relabel the TSG rec type of Contact to SCP Internal....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-384 (Sprint 8)

**Summary**: HC Portal Helpful Links Visibility

**Tech Stack**: Not specified

**Solution Preview**: Experience cloud - home page - Links are already built as part of 204. Please update the links / verify the links mentioned in this story. Use flexcard to accommodate the visibility criteria
Visibility Conditions
HPF employment type - HPF > Facility ...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-319 (Sprint 8)

**Summary**: Employee Self-Service Experience (Link to MySCP - Employee Audience)

**Tech Stack**: Not specified

**Solution Preview**: Use Federation Id from User to verify if okta username exits.


The field will be populated by Integration [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd]  Is this data mapping already captured in a user story?
On the portal, use Rich text e...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-310 (Sprint 8)

**Summary**: Opportunity (Growth Oppty) Object

**Tech Stack**: Not specified

**Solution Preview**: Security Matrix:

* Permission Sets tab
** Object = Deal Workstream, added to System Administrator and Manage Client BD permission set...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-231 (Sprint 8)

**Summary**: Intake Form - Clinician Profile Updates

**Tech Stack**: Not specified

**Solution Preview**: * [link to current intake form|https://schumachergroup.sharepoint.com/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Forms/AllItems.aspx?id=%2Fteams%2FUnifiedPlatform%2DReGenesis%2FShared%20Documents%2FProgram%20Documentation%2FSCP%20SME%20Refere...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2983 (Sprint 9)

**Summary**: Integration log object status picklist value not updated.

**Tech Stack**: Not specified

**Solution Preview**: Upload Status field....

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2892 (Sprint 9)

**Summary**: Initiate Leadership Change - Create Case RT: Leadership Change

**Tech Stack**: Not specified

**Solution Preview**: * Create new Case record type = Leadership Change
** Setup record page
** Update FLS for all permission that have access to this record type
* Security Matrix 
** Add new record type to Permission Set = *Manage Clinician Onboarding* & System Administ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2810 (Sprint 9)

**Summary**: Update HPF Field = Temporary Inactive Reason

**Tech Stack**: REST

**Solution Preview**: remove Restrict picklist to the values defined in the value set for this field.. we make this field as picklist before we know it always comes from Qgenda...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2791 (Sprint 9)

**Summary**: Clinician Contract Request: Capture "Anticipated Clinical Hours"

**Tech Stack**: Not specified

**Solution Preview**: capture when HPF is selected (create contract & Add HPF) - map to HPF.Anticipated_Hours__c
Create the field if its not already added to HPF. Add to layout.

To edit the added rates, As part of Configure Rates, on the first screen, before Rate type, D...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2790 (Sprint 9)

**Summary**: Facility Rate Creation - Type of Rate = Stipend - Add "Stipend Tier" & "Admin Hours"

**Tech Stack**: Not specified

**Solution Preview**: Add new Preventive Care Agreement fields:

* *Stipend Tier (NEW field)*
** *Required, Picklist (single select): Tier 1, Tier 2 , Tier 3, Tier 4, Legacy, Flat,  NPPA*
* *Admin Hours (NEW field)*
** *Required, number (3, 0)*...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2677 (Sprint 9)

**Summary**: Clinician Offboarding - Termination Details Updates for Partner

**Tech Stack**: Not specified

**Solution Preview**: As part of the existing Clinician offboarding OS,
For Emp type = Partner, ( add to existing condition)
Display the fields mentioned above 

Facility Offboarding Task
Update the critieria for task creation to include Partner Employee type...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2676 (Sprint 9)

**Summary**: Clinician Offboarding - Termination Details Updates for Locums, Leased, Managed

**Tech Stack**: Not specified

**Solution Preview**: In the existing Clinician offboarding OS,
As part of the condition/filter check on Employee type for Facility table,
Remove Prospect (IF HPF status != Inactive) and include employee type Leased or Managed.
Create a separate picklist field with the op...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2616 (Sprint 9)

**Summary**: Update Case Related Lists on Clinician Record

**Tech Stack**: Not specified

**Solution Preview**: On Clinician record page > Cases sub tab > Add a single related list of Cases ( where record type = Clinical Match and Status != Closed) . Position this related list above the exit Interview cases.

Remove existing “Offboarding Case” related list....

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2554 (Sprint 9)

**Summary**: Locums Rate Management

**Tech Stack**: Not specified

**Solution Preview**: NOTE:
Contract > CPA(n) > PCA (n)
Contract - PNC (Junction) - HPF
Contract has 1 to many CPA . CPA has 1 to many relationship with PCA
CPA record has PNC from which we can know the HPF for the Contract.

Add new Code Set (Locum) and load new Health C...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2527 (Sprint 9)

**Summary**: Clinician Contract - Update Related Lists (Approval Work Items & Clinician Contracts)

**Tech Stack**: Not specified

**Solution Preview**: Create a flexcard - which queries the Approval Work Items (History) for the clinician and display the records (via data table or any other table format )
Add the Employment type field  to Clinician Contract related list on the Agreements subtab in cl...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2469 (Sprint 9)

**Summary**: Open Shift APAY Request: Approval

**Tech Stack**: Formula Field

**Solution Preview**: In the existing oS for Open Shift APAY , add the three fields. The fields are mapped to Case (of record type Rate Approval)

* APAY Used for the Month (currency, 8 digits 0 decimals, required)
* APAY Budgeted (currency, 8 digits 0 decimals, required)...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2431 (Sprint 9)

**Summary**: Update Clinician Visa Data Model

**Tech Stack**: Not specified

**Solution Preview**: Delete the Visa object and any reference to it. Create destructive changes.

Create new fields on Clinician Person account as mentioned in the DD
Visa Number - text, 25

* Type - picklist
** Values: Birth Abroad Cert, Citizen/Naturalized, E-2, EAD, H...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2430 (Sprint 9)

**Summary**: Update Bonus Configuration for Client and Clinician

**Tech Stack**: Not specified

**Solution Preview**: * Health Cloud Records
** Add new Code Set (Shift)  =  Shift Bonus
Change the length of field “Shift Iteration” from 20 t0 255
When configuring rates, if Shift and Night Shift Bonus is selected, ensure Unit of Measure is per shift - validation check ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2422 (Sprint 9)

**Summary**: Service Account Attributes

**Tech Stack**: Not specified

**Solution Preview**: Follow Data Dictionary for field created details...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2210 (Sprint 9)

**Summary**: Clinician Contract Request: Update CPA naming

**Tech Stack**: Not specified

**Solution Preview**: Create auto-number field on HPF (Need to be added to the DD)
Add the auto number field to the CPA name field concatenation as mentioned in AC, to make it unique and human readable.

Ignore this - will be added to new story

On the existing submit con...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2186 (Sprint 9)

**Summary**: Clinical Match Case Record Type - Update Sharing Rule

**Tech Stack**: Not specified

**Solution Preview**: * Update Group Name and Label:
** From: Clinical Match Request Group
** To: Clinical Match Request
* Update existing sharing rule for 'Manage Cases'
** Criteria: Case: Case Record Type not equal to Risk Review*, Clinical Match*...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2162 (Sprint 9)

**Summary**: Clinician Attributes from Workday to Salesforce

**Tech Stack**: Not specified

**Solution Preview**: Create the fields mentioned on clinician person account.
FLS : Manage Clinician Recruiting permission set, add read permission

* NO Integration needed in this story.
* Confirm Account fields match the labels specified in the user story
* Create I-9 ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2143 (Sprint 9)

**Summary**: Opportunity & Services Objects Info Due Updates

**Tech Stack**: Not specified

**Solution Preview**: * Add Field per DD
** Tab = Opportunity (Growth Opportunity) 
** Tab = Services
* Update FLS for new fields for all permission sets with access to the object...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2142 (Sprint 9)

**Summary**: Contract Object Record Type Setup

**Tech Stack**: Not specified

**Solution Preview**: * Add new Contract record types
* Update label of existing contract record type = “Client' to 'Practice Operations '
* Data Dictionary updates - Add fields and update layout
** See tab = Contract (Letter of Intent)
** Contract (Client Contract)
* Upd...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2126 (Sprint 9)

**Summary**: HC Portal Flip from Login to SSO

**Tech Stack**: Not specified

**Solution Preview**: This story will not cover sso setup. this story is only to show SSO login option when the Federation ID field is popualted on the user record.
Enable OKTA and Okta login ( as test) in Workspace > Adminstration > login & registration
In builder , cust...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2114 (Sprint 9)

**Summary**: Review Credentialling Fields

**Tech Stack**: Not specified

**Solution Preview**: Create the fields mentioned in the story and DD, on Service Account and HPF.
Provide access to Integration user and any persona that has access to te object...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2113 (Sprint 9)

**Summary**: Review Bootcamp and Proctor Fields

**Tech Stack**: Not specified

**Solution Preview**: Create a new obejct : Training. Create fields mentioned in DD ( for both Compliance and Proctorship sheets, ensure no duplicate fields are created)
Types: Proctorship, Compliance.
Use the type field to display the fields given in Compliance sheet and...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1799 (Sprint 9)

**Summary**: Client Contracting - Early Start Confirmed

**Tech Stack**: REST

**Solution Preview**: * DD tab = Opportunity (Growth Oppty)
** Add New field = Green Light for Client Outreach
** Update layout
* Add field visibility to all permission sets with access to the object
* Restrict field edit access to only System Admin & Sales VP users. 
** ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1676 (Sprint 9)

**Summary**: Client Contracting - “LOI Request”

**Tech Stack**: Not specified

**Solution Preview**: * Data Dictionary updates:
** See tab = Contract (Letter of Intent)
** Add fields
** update layout
* Update FLS for new fields for all permission sets with access to the object

!image-20250811-235942.png|width=765,height=736,alt="image-20250811-2359...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1675 (Sprint 9)

**Summary**: Client Needs Questionnaire - Data Collection

**Tech Stack**: Not specified

**Solution Preview**: * AS part of this story add new field to Oppty =  “Client Questionnaire Status”, see DD.
* Update FLS For new field for all permissions that have object access
* Story covers this part of the future state:

!image-20250812-185758.png|width=445,height...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1667 (Sprint 9)

**Summary**: Add Account Contact Relationship

**Tech Stack**: Not specified

**Solution Preview**: !image-20250805-202258.png|width=1004,height=649,alt="image-20250805-202258.png"!

On Contact they already have Related Accounts with the ability to Add Relationship

On Service Account we have story [+PR1050558-1787+|https://salesforce.atlassian.net...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-775 (Sprint 9)

**Summary**: Corporate Compliance Status

**Tech Stack**: Not specified

**Solution Preview**: Add the Training related object to Clinician.
Data Dictionary fields updated

* Security Matrix: See updates on 
** Tab = OWD
** Tab = Permission sets
** Tab = User Setup for Human Resources...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-488 (Sprint 9)

**Summary**: Record Type Cleanup

**Tech Stack**: Not specified

**Solution Preview**: Deactivate the listed record types for Contract. Ensure the two record types are created - letter of intent and practice operations.
Deactivate the listed record types for Opportunity.
Relabel the TSG rec type of Contact to SCP Internal....

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-319 (Sprint 9)

**Summary**: Employee Self-Service Experience (Link to MySCP - Employee Audience)

**Tech Stack**: Not specified

**Solution Preview**: Use Federation Id from User to verify if okta username exits.


The field will be populated by Integration [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd]  Is this data mapping already captured in a user story?
On the portal, use Rich text e...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-310 (Sprint 9)

**Summary**: Opportunity (Growth Oppty) Object

**Tech Stack**: Not specified

**Solution Preview**: Security Matrix:

* Permission Sets tab
** Object = Deal Workstream, added to System Administrator and Manage Client BD permission set...

*Full Solution: See Sprint 9 HTML file*

---

### General (183 stories)

#### PR1050558-164 (Sprint 1)

**Summary**: Project Management Tool Installation

**Tech Stack**: Not specified

**Solution Preview**: Add task for manual step in Copado

Install Project Management Tool from Salesforce Labs: [https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3u00000MRsKnEAL&tab=e|https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3u000...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-107 (Sprint 1)

**Summary**: Duplicate Clinician Records

**Tech Stack**: Not specified

**Solution Preview**: configure duplicate rules...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-87 (Sprint 1)

**Summary**: Related Clinician Records

**Tech Stack**: Not specified

**Solution Preview**: Configure lightning record page
Assign as app default...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-30 (Sprint 1)

**Summary**: Organization Wide Defaults

**Tech Stack**: Not specified

**Solution Preview**: Configure OWD according to security matrix...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-20 (Sprint 1)

**Summary**: OmniStudio Installation

**Tech Stack**: Not specified

**Solution Preview**: Install OmniStudio package

Add OmniStudio permissions to developers

for reference: [https://help.salesforce.com/s/articleView?id=000394906&type=1|https://help.salesforce.com/s/articleView?id=000394906&type=1|smart-link] 

Add task for manual step i...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-3374 (Sprint 10)

**Summary**: Clinician Portal User License

**Tech Stack**: Not specified

**Solution Preview**: Check when the first HPF status = Active,  (first clinical shift date is populated) , the license should be updated from Customer community to customer community plus...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3233 (Sprint 10)

**Summary**: Permission for Integration User - Rate Pay Code, Contract Point Phone

**Tech Stack**: Not specified

**Solution Preview**: Provide access based on security matrix...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3211 (Sprint 10)

**Summary**: Comparison View - Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: !image-20250930-174150.png|width=665,alt="image-20250930-174150.png"!



!0_0_a=162&x=-82&y=66&w=1100&h=463&store=1&accept=image%2F_&auth=LCA%2093ea83ca0908bce6a27097d6d56504e37751cd4c79cd5f83f010451bb98f73e9-ts%3D1759202750|width=572!


On the summa...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3017 (Sprint 10)

**Summary**: Facility Change Request: Practice Operation Contract - Rules

**Tech Stack**: Not specified

**Solution Preview**: Based on Contract Start Date entered in Previous Screen [https://salesforce.atlassian.net/browse/PR1050558-1739|https://salesforce.atlassian.net/browse/PR1050558-1739|smart-link] 

Contract Start Date = user entered date from screen [https://salesfor...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2916 (Sprint 10)

**Summary**: Facility Change Request: Coverage Change - Only Shift change & Pay Code Change - Auto Update Execute

**Tech Stack**: Not specified

**Solution Preview**: Create a batch job that is  Scheduled to run daily
on CPA of  (Practice Operations Contract ) where StartDate = Today & Status = Executed , Contract.RecordType = Client, and Type= ShiftType and 
Existing_Shift_Type_Added__c = true and Is_Newly_Added_...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2634 (Sprint 10)

**Summary**: Contract (Client Contract) - Add Case Related List

**Tech Stack**: Not specified

**Solution Preview**: Add the related list to Contract Records Page as specified in AC...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2630 (Sprint 10)

**Summary**: Contracts Page Update - Add Path

**Tech Stack**: Not specified

**Solution Preview**: Add standard salesforce path in Lightning Record page based on Status...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2468 (Sprint 10)

**Summary**: Collaborative Practice Agreement Review UI: Name Fields

**Tech Stack**: Not specified

**Solution Preview**: Create a Omni Script with Multi Select functionality Mass Update the CPA records.

Use Edit Block to display records 

NPPA Name: Collaborative Practice Agreement -> NP/PA Healthcare Practitioner Facility -> Practitioner ->Name

Physician Name: Colla...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2237 (Sprint 10)

**Summary**: Clinician Onboarding Case & Task Updates

**Tech Stack**: Not specified

**Solution Preview**: [https://docs.google.com/spreadsheets/d/1YC9vi1-hRUZfYPY3doZwSIxczV2HtMeLl6jcUrI-qKY/edit?usp=sharing|https://docs.google.com/spreadsheets/d/1YC9vi1-hRUZfYPY3doZwSIxczV2HtMeLl6jcUrI-qKY/edit?usp=sharing|smart-link] 

Rename the task subject  “*Create...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2023 (Sprint 10)

**Summary**: Approval Work Item - Replace Approval Trace component

**Tech Stack**: Not specified

**Solution Preview**: Replace with a Flexcard...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1809 (Sprint 10)

**Summary**: Clinician Contract List Views - Update All Clinician Contracts - Approved

**Tech Stack**: Not specified

**Solution Preview**: Use Filter By and Specify configure related list based on AC and add to Contract Record page...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3444 (Sprint 11)

**Summary**: Clinicians Contract Request: Mixed Bag Shift Rates?

**Tech Stack**: Not specified

**Solution Preview**: * Apples for Both Practice Operation Contract and Clinician Contract
* For each *Contract Payment Agreement* records select query all related Shift__c records *Preventive Care Agreement* records and count based on logic below and update the count int...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3392 (Sprint 11)

**Summary**: Facility Rate Creation - Clean Up - Remove "Shift" from Contract (RT: Clinician)

**Tech Stack**: Not specified

**Solution Preview**: Remove the Related list from layout...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3374 (Sprint 11)

**Summary**: Clinician Portal User License

**Tech Stack**: Not specified

**Solution Preview**: Check when the first HPF status = Active,  (first clinical shift date is populated) , the license should be updated from Customer community to customer community plus...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3233 (Sprint 11)

**Summary**: Permission for Integration User - Rate Pay Code, Contract Point Phone

**Tech Stack**: Not specified

**Solution Preview**: Provide access based on security matrix...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3211 (Sprint 11)

**Summary**: Comparison View - Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: !image-20250930-174150.png|width=665,alt="image-20250930-174150.png"!



!0_0_a=162&x=-82&y=66&w=1100&h=463&store=1&accept=image%2F_&auth=LCA%2093ea83ca0908bce6a27097d6d56504e37751cd4c79cd5f83f010451bb98f73e9-ts%3D1759202750|width=572!


On the summa...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3205 (Sprint 11)

**Summary**: Queues to Support Onboarding/SUN process - List Views

**Tech Stack**: Not specified

**Solution Preview**: Create List View as per AC...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3204 (Sprint 11)

**Summary**: Queues to Support Onboarding/SUN process - Queue Creation

**Tech Stack**: Not specified

**Solution Preview**: Create new Queue as per AC...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3026 (Sprint 11)

**Summary**: Client Onboarding - Implementation Queue

**Tech Stack**: Not specified

**Solution Preview**: Create a queue and check if list view is auto created for the queue and set the layout as per AC...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3024 (Sprint 11)

**Summary**: Facility Change Request: Sync Practice Operations Contract rates to a Clinician Contract

**Tech Stack**: Apex

**Solution Preview**: When the user clicks the “*Refresh Client Rates*”

Apex Code

# For Each ProviderNetworkContract Record in the Clinician Contract
## Get the latest +relevant+ Practice Operation Contract 
### ProviderNetworkContract.Healthcare_Practitioner_Facility__...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3017 (Sprint 11)

**Summary**: Facility Change Request: Practice Operation Contract - Rules

**Tech Stack**: Not specified

**Solution Preview**: Based on Contract Start Date entered in Previous Screen [https://salesforce.atlassian.net/browse/PR1050558-1739|https://salesforce.atlassian.net/browse/PR1050558-1739|smart-link] 

Contract Start Date = user entered date from screen [https://salesfor...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2916 (Sprint 11)

**Summary**: Facility Change Request: Coverage Change - Only Shift change & Pay Code Change - Auto Update Execute

**Tech Stack**: Not specified

**Solution Preview**: Create a batch job that is  Scheduled to run daily
on CPA of  (Practice Operations Contract ) where StartDate = Today & Status = Executed , Contract.RecordType = Client, and Type= ShiftType and 
Existing_Shift_Type_Added__c = true and Is_Newly_Added_...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2088 (Sprint 11)

**Summary**: Client Onboarding - Auto Task Creation - Manually Confirm Onboarding Start

**Tech Stack**: Not specified

**Solution Preview**: Create a new Action in Opportunity Name  “Begin Client Onboarding” is visibly only when  Opportunity Stage = “Validate Solution” or “Negotiate Contract & Close” and PMT Project = NULL

The button will create a task record as specified in the AC...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1684 (Sprint 11)

**Summary**: Facility Term: Auto Create Tasks

**Tech Stack**: Not specified

**Solution Preview**: * Create child case and tasks as specified in AC
* Create new Task Queue:
** Risk Management Queue - users will be manually added
** IT Infrastructure Queue (NOTE: created as part of story [+PR1050558-1683+|https://salesforce.atlassian.net/browse/PR1...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4065 (Sprint 12)

**Summary**: Client Contract Request - Configurations tab - Layout

**Tech Stack**: Not specified

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4005 (Sprint 12)

**Summary**: UAT Enhancement: Allow $0 Rates on Clinician Contracts

**Tech Stack**: Not specified

**Solution Preview**: Allow default be 0 in the omni script for 

Shift Rate Type(change) can be 0

 All other Rate Type  _(Bonus, Leadership Incentives, Stipend, Target, Variable, Locum_) it cannot be 0(as built)...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4001 (Sprint 12)

**Summary**: UAT Enhancement: Clinician Contract - Bonus Approval Updates

**Tech Stack**: Not specified

**Solution Preview**: In the current approval process, add a condition to check if HPF.Job is null, if so, assign the lVPO as the approver and send for approval...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3931 (Sprint 12)

**Summary**: TECH - Clinician Contract Request: Summary Screen - Add HPF - Refine Logic for setting the Colors

**Tech Stack**: Not specified

**Solution Preview**: !image-20251031-174502.png|width=610,alt="image-20251031-174502.png"!

Add Color the Flex Card Based on the logic provided. The logic is derived based PNC



 *Add HPF* functionality, Before inserting PNCs, check if there is any existing PNC with the...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3469 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Email Alert

**Tech Stack**: Not specified

**Solution Preview**: Update the Omnis Script InitiateContractingRequest to send email upon creation

Contract.RT: Letter of Intent is created 

* Email Subject: as per AC
* Email Body: as per AC

The Email is storied in a Custom Label...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3444 (Sprint 12)

**Summary**: Clinicians Contract Request: Mixed Bag Shift Rates?

**Tech Stack**: Not specified

**Solution Preview**: * Apples for Both Practice Operation Contract and Clinician Contract
* For each *Contract Payment Agreement* records select query all related Shift__c records *Preventive Care Agreement* records and count based on logic below and update the count int...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3375 (Sprint 12)

**Summary**: Tech - HC Portal Configuration - Update Sender and Portal Admin

**Tech Stack**: Not specified

**Solution Preview**: The ACs are configurations and settings that need to be verified in the org. 
Current config for Email address configuration custom metadata in UAT


||*Name*||*PROD Email*||*UAT Email*||
|eeinactivations|[eeinactivations@scphealth.com|mailto:eeinact...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3339 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Action = Cancel Contract

**Tech Stack**: Not specified

**Solution Preview**: Create a Action in Contract RT: Client Contract

On Button Click Update the Contract.Status = 'Abandoned’...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3205 (Sprint 12)

**Summary**: Queues to Support Onboarding/SUN process - List Views

**Tech Stack**: Not specified

**Solution Preview**: Create List View as per AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3204 (Sprint 12)

**Summary**: Queues to Support Onboarding/SUN process - Queue Creation

**Tech Stack**: Not specified

**Solution Preview**: Create new Queue as per AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3026 (Sprint 12)

**Summary**: Client Onboarding - Implementation Queue

**Tech Stack**: Not specified

**Solution Preview**: Create a queue and check if list view is auto created for the queue and set the layout as per AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3024 (Sprint 12)

**Summary**: Facility Change Request: Sync Practice Operations Contract rates to a Clinician Contract

**Tech Stack**: Apex

**Solution Preview**: When the user clicks the “*Refresh Client Rates*”

Apex Code

# For Each ProviderNetworkContract Record in the Clinician Contract
## Get the latest +relevant+ Practice Operation Contract 
### ProviderNetworkContract.Healthcare_Practitioner_Facility__...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3021 (Sprint 12)

**Summary**: Client Contract Request - New Client Contract

**Tech Stack**: Not specified

**Solution Preview**: Story will Create below items

#  Contract RT: Client Contract 
# PNC Records (with the Opportunity Service Selected)



* New Contract RecordType = Client Contract
** Contract Start Date: User Input
** Contract End Date (optional)
** Contract Name (...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3019 (Sprint 12)

**Summary**: Client Contract Request - View related Client Contracts on Accounts

**Tech Stack**: Not specified

**Solution Preview**: Create the Related List as per AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3013 (Sprint 12)

**Summary**: Tech - SSO Flow - Experience Cloud Welcome Email

**Tech Stack**: Not specified

**Solution Preview**: Out of the box functionality 
When a new user is created, the welcome email is sent out ( as long as the generate email checkbox is checked on the user)
Ensure the community URL is a link to the word “Community” ( if this is possible)

!image-2025110...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2088 (Sprint 12)

**Summary**: Client Onboarding - Auto Task Creation - Manually Confirm Onboarding Start

**Tech Stack**: Not specified

**Solution Preview**: Create a new Action in Opportunity Name  “Begin Client Onboarding” is visibly only when  Opportunity Stage = “Validate Solution” or “Negotiate Contract & Close” and PMT Project = NULL

The button will create a task record as specified in the AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1736 (Sprint 12)

**Summary**: Client Contract Request View for Legal

**Tech Stack**: Not specified

**Solution Preview**: Create list view based on criteria...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1684 (Sprint 12)

**Summary**: Facility Term: Auto Create Tasks

**Tech Stack**: Not specified

**Solution Preview**: * Create child case and tasks as specified in AC
* Create new Task Queue:
** Risk Management Queue - users will be manually added
** IT Infrastructure Queue (NOTE: created as part of story [+PR1050558-1683+|https://salesforce.atlassian.net/browse/PR1...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-5202 (Sprint 12.1)

**Summary**: UAT Enhancement: HPF Effective Dates UPDATE

**Tech Stack**: Not specified

**Solution Preview**: Modify the criteria in the query to pick HPF as per AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5118 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT364 Warning Message in Error - Experience Cloud

**Tech Stack**: Not specified

**Solution Preview**: Due to OOTB Limitation we are introducing a refresh page in Omni on Submit for assessment completion...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5083 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT348 Candidate Tracker not Updating properly

**Tech Stack**: Not specified

**Solution Preview**: When this story gets picked up, update [SCP Health - HPF Pizza Tracker.xlsx|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Execution/1.%20Build,%20QA,%20Refinement/Cli...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5068 (Sprint 12.1)

**Summary**: UAT Enhancement: Include Active HPFs in Clinician Contract

**Tech Stack**: Not specified

**Solution Preview**: When the use case is if there are existing Executed Contract for the Employment Type then they should always clone the existing Contract irrespective of Employment Type

 “Start New Request” should be hidden in this case

# RAD_Executed
# RAD_Continu...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5001 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT328 Experience Cloud - Change Your Password

**Tech Stack**: Not specified

**Solution Preview**: Require custom visualforce...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4942 (Sprint 12.1)

**Summary**: UAT Enhancement: Refresh Client Rate button: Deleting Rates when Facility Rate field is null on CPA 

**Tech Stack**: Not specified

**Solution Preview**: The implemented logic was referring to CPA’s Facility Title' Account, but correct logic to refer CPA’s PNC’s HPF’s Account....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4918 (Sprint 12.1)

**Summary**: UAT Enhancement: Practice Operations Contract - NPPA Tier & Contract Start Date required on layout

**Tech Stack**: Not specified

**Solution Preview**: Making it required in layout...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4897 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT294 Data Quality, MSL, and PE Team Personas need to be able to view the Intak

**Tech Stack**: Not specified

**Solution Preview**: Provide access to the specific group based on AC. - Public Group = Manage Onboarding Forms

Only the specific assessment record must be shared...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4893 (Sprint 12.1)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - ‘Facility Rates as R

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4892 (Sprint 12.1)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - ‘Refresh Client Rate

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4891 (Sprint 12.1)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - 'Configure Rates' Bu

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4863 (Sprint 12.1)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - Update Agentforce (1

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4844 (Sprint 12.1)

**Summary**: UAT Enhancement: NP/PA Tier Process - Add HPF

**Tech Stack**: Not specified

**Solution Preview**: Update the calculation base on AC (existing code)...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4765 (Sprint 12.1)

**Summary**: UAT Bug: Clinician Contract Cloning should use Start Date not Create Date

**Tech Stack**: Not specified

**Solution Preview**: For Clinician Contract all Query that sorts Contract records should be using Start Date not Created Date

Update all DR that pulls Creates Clinician Contract and Clones Clinician Contract...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4763 (Sprint 12.1)

**Summary**: Observation bug: During Clinician contract request - Active Contracts should be sorted based on Star

**Tech Stack**: Not specified

**Solution Preview**: Fix DataMapper DMFetchActiveContracts and StartDate DESC as order by...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4750 (Sprint 12.1)

**Summary**: UAT Enhancement: NP/PA Tier Process

**Tech Stack**: Not specified

**Solution Preview**: Update the calculation base on AC (existing code)...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4746 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT261 Cloned contract pulling in incorrect contract during duplication

**Tech Stack**: Not specified

**Solution Preview**: For Clinician Contract all Query that sorts Contract records should be using Start Date not Created Date

Update all DR that pulls Creates Clinician Contract and Clones Clinician Contract...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4739 (Sprint 12.1)

**Summary**: UAT Enhancement :Task to Clear QGenda for Reactivating a Clincian

**Tech Stack**: Not specified

**Solution Preview**: When a clinician contract is *Submitted for Approval*

Check all the HPF Record in the Contract via PNC> HPF and collect the IDs HPF.AccountId and HPF.Id...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4685 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT245 SCP Contracting entities

**Tech Stack**: Not specified

**Solution Preview**: Check for the Corp entity for the selected HPF in the Contract during contract process

Get the Selected HPF get the HPF.Contracting_Corporate_Entity__c (create a list)

Query for All HPF for the Clinician where [HPF.I|http://HPF.Is]d Not in (Selecte...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4630 (Sprint 12.1)

**Summary**: UAT Enhancement: Update matching logic for "Refresh Client Rates"

**Tech Stack**: Apex

**Solution Preview**: {color:#bf2600}Note: Facility Title is one of the KEY but we are processing One Facility Title at a time so that key is not included in the solution and handled at step step 1.a.ii{color}

When the user clicks the “*Refresh Client Rates*”

Apex Code
...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4621 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT229 Missing Validation between Contract Active + Begin Facility Termination P

**Tech Stack**: Not specified

**Solution Preview**: Adjust the Client Omni Script to put in the additional filter based on AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4583 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT207 Letter of Intent Request - Letter of Intent - Status and Key Dates Update

**Tech Stack**: Not specified

**Solution Preview**: Update the layout based on AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4580 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT204 View of Contracts from Opportunity

**Tech Stack**: Not specified

**Solution Preview**: Add new related list as per AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4556 (Sprint 12.1)

**Summary**: Failed to update Healthcare Practitioner Facility History

**Tech Stack**: Not specified

**Solution Preview**: Since salesforce Support said its a defect we are building a Omni solution...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4409 (Sprint 12.1)

**Summary**: UAT Enhancement: Generate Term Sheet - Term Sheet Generation - Add back Clinician Hours

**Tech Stack**: Not specified

**Solution Preview**: Update the AnticipatedClinicianHours in Datamapper

Update ConditionalOfferLetter docgen functionality...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4391 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT157 Cannot add Contact Role to Opportunity

**Tech Stack**: Not specified

**Solution Preview**: Not a DEFECT...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4375 (Sprint 12.1)

**Summary**: Regression Bug - I9 Update tasks is not closing when I9 Status field updates on Clinician record.

**Tech Stack**: Not specified

**Solution Preview**: New story got created 4432 for missing requirement...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4203 (Sprint 12.1)

**Summary**: UAT Enhancement: View Clinicians from Service Account Record

**Tech Stack**: Apex

**Solution Preview**: Clinician Contracts under Facility

Create a Flex Card similar to ClinicianContract_DisplayRelatedHPF

Query: SELECT Id, Contract.ContractNumber, Contract.Employment_Type__c, Contract.Status, Contract.StartDate, Contract.EndDate FROM ProviderNetworkC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4065 (Sprint 12.1)

**Summary**: Client Contract Request - Configurations tab - Layout

**Tech Stack**: Not specified

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4005 (Sprint 12.1)

**Summary**: UAT Enhancement: Allow $0 Rates on Clinician Contracts

**Tech Stack**: Not specified

**Solution Preview**: Allow default be 0 in the omni script for 

Shift Rate Type(change) can be 0

 All other Rate Type  _(Bonus, Leadership Incentives, Stipend, Target, Variable, Locum_) it cannot be 0(as built)...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3616 (Sprint 12.1)

**Summary**: UAT Enhancement: Corporation and Tax Information Updates

**Tech Stack**: Not specified

**Solution Preview**: Follow the security Matrix

Default value as per AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3469 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Email Alert

**Tech Stack**: Not specified

**Solution Preview**: Update the Omnis Script InitiateContractingRequest to send email upon creation

Contract.RT: Letter of Intent is created 

* Email Subject: as per AC
* Email Body: as per AC

The Email is storied in a Custom Label...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3375 (Sprint 12.1)

**Summary**: Tech - HC Portal Configuration - Update Sender and Portal Admin

**Tech Stack**: Not specified

**Solution Preview**: The ACs are configurations and settings that need to be verified in the org. 
Current config for Email address configuration custom metadata in UAT


||*Name*||*PROD Email*||*UAT Email*||
|eeinactivations|[eeinactivations@scphealth.com|mailto:eeinact...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3339 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Action = Cancel Contract

**Tech Stack**: Not specified

**Solution Preview**: Create a Action in Contract RT: Client Contract

On Button Click Update the Contract.Status = 'Abandoned’...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3021 (Sprint 12.1)

**Summary**: Client Contract Request - New Client Contract

**Tech Stack**: Not specified

**Solution Preview**: Story will Create below items

#  Contract RT: Client Contract 
# PNC Records (with the Opportunity Service Selected)



* New Contract RecordType = Client Contract
** Contract Start Date: User Input
** Contract End Date (optional)
** Contract Name (...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3013 (Sprint 12.1)

**Summary**: Tech - SSO Flow - Experience Cloud Welcome Email

**Tech Stack**: Not specified

**Solution Preview**: Out of the box functionality 
When a new user is created, the welcome email is sent out ( as long as the generate email checkbox is checked on the user)
Ensure the community URL is a link to the word “Community” ( if this is possible)

!image-2025110...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-1736 (Sprint 12.1)

**Summary**: Client Contract Request View for Legal

**Tech Stack**: Not specified

**Solution Preview**: Create list view based on criteria...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5410 (Sprint 12.2)

**Summary**: Observation Bug - IC NPPA Termination - Cases are created with blank Subject & Not linked to the cli

**Tech Stack**: Not specified

**Solution Preview**: Per related 3772:

* Date Termination Received = date the automation ran
* Termination Request Date = date the automation ran
* Last Day = date the automation ran
* Reason for Termination = “Contract Termination”...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5383 (Sprint 12.2)

**Summary**: UAT Bug: C&C437 - UAT1 - Start from Previous Active on Clinician Contract - New Record did not pull 

**Tech Stack**: Not specified

**Solution Preview**: [https://docs.google.com/spreadsheets/d/1-5QN8OKJ-95Sb7eDn8FdAU9faqUkuS0b3CYKbv20bKk/edit?gid=0#gid=0|https://docs.google.com/spreadsheets/d/1-5QN8OKJ-95Sb7eDn8FdAU9faqUkuS0b3CYKbv20bKk/edit?gid=0#gid=0|smart-card]...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5202 (Sprint 12.2)

**Summary**: UAT Enhancement: HPF Effective Dates UPDATE

**Tech Stack**: Not specified

**Solution Preview**: Modify the criteria in the query to pick HPF as per AC...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5118 (Sprint 12.2)

**Summary**: UAT Bug: C&CUAT364 Warning Message in Error - Experience Cloud

**Tech Stack**: Not specified

**Solution Preview**: Due to OOTB Limitation we are introducing a refresh page in Omni on Submit for assessment completion...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5083 (Sprint 12.2)

**Summary**: UAT Enhancement: C&CUAT348 Candidate Tracker not Updating properly

**Tech Stack**: Not specified

**Solution Preview**: When this story gets picked up, update [SCP Health - HPF Pizza Tracker.xlsx|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Execution/1.%20Build,%20QA,%20Refinement/Cli...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4918 (Sprint 12.2)

**Summary**: UAT Enhancement: Practice Operations Contract - NPPA Tier & Contract Start Date required on layout

**Tech Stack**: Not specified

**Solution Preview**: Making it required in layout...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4897 (Sprint 12.2)

**Summary**: UAT Enhancement: C&CUAT294 Data Quality, MSL, and PE Team Personas need to be able to view the Intak

**Tech Stack**: Not specified

**Solution Preview**: Provide access to the specific group based on AC. - Public Group = Manage Onboarding Forms

Only the specific assessment record must be shared...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4893 (Sprint 12.2)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - ‘Facility Rates as R

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4892 (Sprint 12.2)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - ‘Refresh Client Rate

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4891 (Sprint 12.2)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - 'Configure Rates' Bu

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4863 (Sprint 12.2)

**Summary**: UAT Enhancement: Clinician Contract - Include PO Contract Status = Superseded - Update Agentforce (1

**Tech Stack**: Not specified

**Solution Preview**: Include Status =  Superseded in the PO Contract Query that pulls the Rates...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4630 (Sprint 12.2)

**Summary**: UAT Enhancement: Update matching logic for "Refresh Client Rates"

**Tech Stack**: Apex

**Solution Preview**: {color:#bf2600}Note: Facility Title is one of the KEY but we are processing One Facility Title at a time so that key is not included in the solution and handled at step step 1.a.ii{color}

When the user clicks the “*Refresh Client Rates*”

Apex Code
...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5634 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare186 - Receiving error when generating term sheet

**Tech Stack**: Not specified

**Solution Preview**: Not a DEFECT but working as expected however the technical limitation originaly proposed was not accepted by business and now we are implementing the original suggestion   

*_Root Cause is term sheet designed had naming format that is greater than w...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5441 (Sprint 12.3)

**Summary**: PROD Enhancement: C&CUAT466 Payroll Report Building Access

**Tech Stack**: Not specified

**Solution Preview**: Update based on security matrix...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5227 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT398 Contract Request - Time Type Visibility on Rate Configuration

**Tech Stack**: Not specified

**Solution Preview**: AC1: Summary tab Omni add the PCA.TimeType

AC2: Configure Rates Omni add PCA.Time Type...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5153 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT368 Add Time Type to Summary Tab on Practice Ops record

**Tech Stack**: Not specified

**Solution Preview**: Ok to follow the same format as Clinician’s Summary Tab (Add 'Time Type' under the Facility Title) see [https://salesforce.atlassian.net/browse/PR1050558-5227|https://salesforce.atlassian.net/browse/PR1050558-5227|smart-link].  If no Time Type, then ...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5788 (Sprint 12.4)

**Summary**: PROD Permissions: UPHypercare264 - Operation Finance financial impact field

**Tech Stack**: Not specified

**Solution Preview**: *Solution*
Add Finance Perm Set Group to following RUL Users

Brent Malaski
Daniel Moore
Candace Weston
Madison Dupuy

*Testing*
Login with one of the above and ensure that they can edit Contract.Financial Implications and Contract.Financial Impact...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5083 (Sprint 12.4)

**Summary**: UAT Enhancement: C&CUAT348 Candidate Tracker not Updating properly

**Tech Stack**: Not specified

**Solution Preview**: When this story gets picked up, update [SCP Health - HPF Pizza Tracker.xlsx|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Execution/1.%20Build,%20QA,%20Refinement/Cli...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5947 (Sprint 12.5)

**Summary**: PROD Bug: UPHypercare340 - QGenda Scheduling Event Firing Too Early

**Tech Stack**: Not specified

**Solution Preview**: Data Issue

The Rates (Qgenda Scheduling Setup) event should come to MuleSoft only after the Credential Status is Active or Schedule Pending on HC. As per discussion with Nick & Ron on 26th Feb, the Credential Status for the corresponding contract (8...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5859 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare303 - EE/Employed clinicians not receiving Certification of Competency 

**Tech Stack**: Apex

**Solution Preview**: Adjust the Apex and Omni for Intake for functionality as per AC

ClinicianIntakeFormAssessmentController.cls

Build Question for Omni using the Assessment Questions 

Add new Omnis Script for the assessment 



The question need to look similar to wh...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5788 (Sprint 12.5)

**Summary**: PROD Permissions: UPHypercare264 - Operation Finance financial impact field

**Tech Stack**: Not specified

**Solution Preview**: *Solution*
Add Finance Perm Set Group to following RUL Users

Brent Malaski
Daniel Moore
Candace Weston
Madison Dupuy

*Testing*
Login with one of the above and ensure that they can edit Contract.Financial Implications and Contract.Financial Impact...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5733 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare250 - NPPA 'Call' shift with per shift unit of measure

**Tech Stack**: Not specified

**Solution Preview**: *Dev Notes (Updated):* 

*OS:* ServiceAccFacilityRateCreation

# Shift Type “*Call*“ will allow NPPA only Unit per Measure: “per Shift“ *AND* “per Hour“ 
## Error message 1 verbatim for validation 

*Notes:* Shift Type “Call“ is  available and active...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5728 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare243 - Provider Contracting needs access to Practice Operations

**Tech Stack**: Not specified

**Solution Preview**: Update dynamic visibility on the element named “ClinicianContractPOComparisonSummaryContainer” on the Contract Lightning Page “Clinician Contract Record Page”...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5597 (Sprint 12.5)

**Summary**: PROD Permissions: UPhypercare151: Access to Leadership Change

**Tech Stack**: Not specified

**Solution Preview**: *Dev Notes*

# Create New Queue “VPO Delegates“
# Modify “LeadershipChange_DataServiceIP” in VPO_Check block, append condition and query for members in queue. (If  current user in new queue return true)



QA Notes: 

in lower environments you can ad...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5525 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare73 - Need a solution for recruiters to request a new contract with the 

**Tech Stack**: Not specified

**Solution Preview**: Duplicates 5521 [https://salesforce.atlassian.net/browse/PR1050558-5521|https://salesforce.atlassian.net/browse/PR1050558-5521|smart-link]...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-4921 (Sprint 12.5)

**Summary**: UAT Enhancement: C&CUAT301 On the CPA screen in Clinician Onboarding enhance the list view on that Q

**Tech Stack**: Not specified

**Solution Preview**: Add column to List View...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5950 (Sprint 12.6)

**Summary**: PROD Enhancement: Facility Change Request - Coverage Change - Add additional check before auto pushi

**Tech Stack**: Apex

**Solution Preview**: Repeate the Logic to update the Client Change Management Record Process Type = Manual before running the Clinician Change job

The logic is in chained queued job need to move to Apex and the Apex need to be reused in both chained queuable job as well...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5788 (Sprint 12.6)

**Summary**: PROD Permissions: UPHypercare264 - Operation Finance financial impact field

**Tech Stack**: Not specified

**Solution Preview**: *Solution*
Add Finance Perm Set Group to following RUL Users

Brent Malaski
Daniel Moore
Candace Weston
Madison Dupuy

*Testing*
Login with one of the above and ensure that they can edit Contract.Financial Implications and Contract.Financial Impact...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5733 (Sprint 12.6)

**Summary**: PROD Enhancement: UPHypercare250 - NPPA 'Call' shift with per shift unit of measure

**Tech Stack**: Not specified

**Solution Preview**: *Dev Notes (Updated):* 

*OS:* ServiceAccFacilityRateCreation

# Shift Type “*Call*“ will allow NPPA only Unit per Measure: “per Shift“ *AND* “per Hour“ 
## Error message 1 verbatim for validation 

*Notes:* Shift Type “Call“ is  available and active...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-6252 (Sprint 13)

**Summary**: HPF Validation Rule Update

**Tech Stack**: Not specified

**Solution Preview**: [~accountid:61f8618e8d9e3c00688e380b] provided the following update criteria
--

AND(

  ISCHANGED(Insurance_Provided_By__c),

  OR(

    AND(

      Facility_Title__r.Name <> "External Locums",

      OR(

        ISPICKVAL(Insurance_Provided_By__c,...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6098 (Sprint 13)

**Summary**: PROD Enhancement: Clinician Onboarding tasks - Populate 'Name' (WhoID)

**Tech Stack**: Not specified

**Solution Preview**: *SOLUTION:*

Update Task creation for tasks to include WhoID on creation. WhoID should be populated with the related Case.ContactName

Tasks to update are located here:
Link to SharePoint - see ‘Clinician Onboarding’ tab [+Clinician Onboarding_Offboa...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6015 (Sprint 13)

**Summary**: Compliance Rule Assignments - Needs Mapping

**Tech Stack**: Not specified

**Solution Preview**: Add the Manage Collaborative Practice Agreements Perm Set to the Data Quality Perm Set Group...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6001 (Sprint 13)

**Summary**: UAT Enhancement: Single Intake Completion (No Repeat Intake on Stage/Opportunity Movement)

**Tech Stack**: Not specified

**Solution Preview**: Amend Intake Case creation logic to check for an existing Intake Case with a Completed Status for the same Clinician

If none is found, create new Case and assessmentEnvelopes as is done today.

If an existing Intake Case is Found, create a new intak...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5859 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare303 - EE/Employed clinicians not receiving Certification of Competency 

**Tech Stack**: Apex

**Solution Preview**: Adjust the Apex and Omni for Intake for functionality as per AC

ClinicianIntakeFormAssessmentController.cls

Build Question for Omni using the Assessment Questions 

Add new Omnis Script for the assessment 



The question need to look similar to wh...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5728 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare243 - Provider Contracting needs access to Practice Operations

**Tech Stack**: Not specified

**Solution Preview**: Update dynamic visibility on the element named “ClinicianContractPOComparisonSummaryContainer” on the Contract Lightning Page “Clinician Contract Record Page”...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6354 (Sprint 14)

**Summary**: Observation: Old HPF is not marked as 'Superseded' if delinked from clinician contract manually

**Tech Stack**: Not specified

**Solution Preview**: Remove the delete button for the Greyed Out PNCs...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6098 (Sprint 14)

**Summary**: PROD Enhancement: Clinician Onboarding tasks - Populate 'Name' (WhoID)

**Tech Stack**: Not specified

**Solution Preview**: *SOLUTION:*

Update Task creation for tasks to include WhoID on creation. WhoID should be populated with the related Case.ContactName

Tasks to update are located here:
Link to SharePoint - see ‘Clinician Onboarding’ tab [+Clinician Onboarding_Offboa...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6015 (Sprint 14)

**Summary**: Compliance Rule Assignments - Needs Mapping

**Tech Stack**: Not specified

**Solution Preview**: Add the Manage Collaborative Practice Agreements Perm Set to the Data Quality Perm Set Group...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6001 (Sprint 14)

**Summary**: UAT Enhancement: Single Intake Completion (No Repeat Intake on Stage/Opportunity Movement)

**Tech Stack**: Not specified

**Solution Preview**: Amend Intake Case creation logic to check for an existing Intake Case with a Completed Status for the same Clinician

If none is found, create new Case and assessmentEnvelopes as is done today.

If an existing Intake Case is Found, create a new intak...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5859 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare303 - EE/Employed clinicians not receiving Certification of Competency 

**Tech Stack**: Apex

**Solution Preview**: Adjust the Apex and Omni for Intake for functionality as per AC

ClinicianIntakeFormAssessmentController.cls

Build Question for Omni using the Assessment Questions 

Add new Omnis Script for the assessment 



The question need to look similar to wh...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5728 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare243 - Provider Contracting needs access to Practice Operations

**Tech Stack**: Not specified

**Solution Preview**: Update dynamic visibility on the element named “ClinicianContractPOComparisonSummaryContainer” on the Contract Lightning Page “Clinician Contract Record Page”...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-243 (Sprint 2)

**Summary**: External Client Apps APP for Mulesoft

**Tech Stack**: Not specified

**Solution Preview**: Create a External Client Apps...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-560 (Sprint 4)

**Summary**: View Preventive Care Agreement on Contract Payment Agreement

**Tech Stack**: Not specified

**Solution Preview**: Create a flexcard to replicate related list functionality since this feature does not display properly...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-386 (Sprint 4)

**Summary**: Update NPI Management

**Tech Stack**: Not specified

**Solution Preview**: AC1: ok to present name in proper case in the UI as well as when saved, but main requirement is upon updating the clinician record the name must be saved in proper case....

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-236 (Sprint 4)

**Summary**: Portal Login

**Tech Stack**: Not specified

**Solution Preview**: * Ensure that we use the attached logo (without the tagline)
* Remove the “SCP Health employee? Log In”. Employee’s will login via Okta
* update theme to Jepson...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-208 (Sprint 4)

**Summary**: View Provider Network Contract on Contract Record

**Tech Stack**: Not specified

**Solution Preview**: Create a flexcard to replicate related list functionality since this feature does not display properly

Provider Network Contract: ProviderNetworkContract.Name

Healthcare Practitioner Facility: HealthcarePractitionerFacility.Name...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-882 (Sprint 5)

**Summary**: Facility Rate Creation - Summary tab - Shift updates

**Tech Stack**: Not specified

**Solution Preview**: Grouping (update in purple)

# *Type of Rate* (Contract Payment Agreement.Type)
# *Type*
## If {color:#403294}*ContractPaymentAgreement.Type = Shift, then Preventive Care Agreement.Shift.FullName*{color}
## If {color:#403294}*ContractPaymentAgreement...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-840 (Sprint 5)

**Summary**: Clinician Experience Specialist Test User

**Tech Stack**: Not specified

**Solution Preview**: Create the used based on Security Matrix...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-835 (Sprint 5)

**Summary**: Update Initiate Early Onboarding - SCP Error Message

**Tech Stack**: Not specified

**Solution Preview**: Follow solution approach as defined story 822 and included validations/messages from this story accordingly....

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-809 (Sprint 5)

**Summary**: Configure Case Page - Onboarding

**Tech Stack**: Not specified

**Solution Preview**: configure Clinician Onboarding LRP according to data dictionary and AC...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-796 (Sprint 5)

**Summary**: Integration User - View Encrypted Data

**Tech Stack**: Not specified

**Solution Preview**: * [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesforce%20team%20Deliverables/Architecture...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-777 (Sprint 5)

**Summary**: Facility Rate Creation - Rate Rules/Validations

**Tech Stack**: Not specified

**Solution Preview**: Add a visibility filter to the button for the corresponding Status New in one side, Submitted, In Progress, Executed, Abandoned

!Captura de pantalla 2025-07-15 a la(s) 10.05.36 p.m..png|width=1470,height=788,alt="Captura de pantalla 2025-07-15 a la(...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-707 (Sprint 5)

**Summary**: Attach Files During Risk Review

**Tech Stack**: Not specified

**Solution Preview**: Update OS to add ability to upload files

Show all the Assessment records without the need to click View All (Make it 30)

Upload the File to Assessment Record 

Assessment Attachment should be visible under the Response Tab under the Assessment reco...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-617 (Sprint 5)

**Summary**: Standardize Care Taxonomy Records

**Tech Stack**: Not specified

**Solution Preview**: delete existing Care Specialty records

create Care Specialty records as specified in Health Cloud Records sheet...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-616 (Sprint 5)

**Summary**: Standardize Care Specialty Records

**Tech Stack**: Not specified

**Solution Preview**: delete existing Care Specialty records

create Care Specialty records as specified in Health Cloud Records sheet...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-486 (Sprint 5)

**Summary**: Facility Rate Creation - Type of Rate = Shift: Add Shift Type

**Tech Stack**: Not specified

**Solution Preview**: * Dependent upon [https://salesforce.atlassian.net/browse/PR1050558-697|https://salesforce.atlassian.net/browse/PR1050558-697|smart-link] 

Create the following records related to the Contract Payment Agreement record; create one per Facility Title &...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-326 (Sprint 5)

**Summary**: Manage Primary Taxonomy and Specialty

**Tech Stack**: Not specified

**Solution Preview**: For both Taxonomy and Specialty within the following guided experiences:

* Update NPI -  update existing/create new record as primary & uncheck primary from all other records. Do not delete taxonomy records.
* Create HPF -  update existing/create ne...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1635 (Sprint 6)

**Summary**: Clinician Application Visibility - Update Permissions

**Tech Stack**: Not specified

**Solution Preview**: Use “User Access Policies” to manage the new users. 

Assign following via the “User Access Policies”

# Portal User
# Omnistudio Experience Cloud User
# OmniStudio Community Ext...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1368 (Sprint 6)

**Summary**: Add Banner to HC Portal

**Tech Stack**: Not specified

**Solution Preview**: Add the banner image to the Asset Libraries

Add the banner image to the Compact Header Image of the Experience Site...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1172 (Sprint 6)

**Summary**: Enrollment Specialist - Update Test User

**Tech Stack**: Not specified

**Solution Preview**: * update Enrollment Specialist test user (Toni Morrison) to add another Public group = Manage Cases
* Retest [https://salesforce.atlassian.net/browse/PR1050558-857|https://salesforce.atlassian.net/browse/PR1050558-857|smart-link] to ensure still work...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1072 (Sprint 6)

**Summary**: Collaborative Practice Agreement Legal Requirements - Load Data

**Tech Stack**: Not specified

**Solution Preview**: Assign permission based on Security Matrix 

Load records into Compliance Rule Assignments ([Health Cloud Records|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?usp=sharing])...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-894 (Sprint 6)

**Summary**: Clinician Contract Request: Summary Screen

**Tech Stack**: Not specified

**Solution Preview**: Follow solution approach used in Client Contract *SpecifyRates_SummaryContractScreen* flexcard which is built for Client Contract and render records as per below mock UI

!image-20250728-140903.png|width=707,height=671,alt="image-20250728-140903.png"...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-890 (Sprint 6)

**Summary**: Clinician Application Visibility - HC Portal

**Tech Stack**: Not specified

**Solution Preview**: Use Experience Cloud Sharing Set to share ATS Applicant and Job Request 

Create a Flex Card to Display the ATS Applicant Record(s)

* Parent Record ID = person account for the logged in user
** Job Name = bpats__Job__c.Name
** Application Date = bpa...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-841 (Sprint 6)

**Summary**: Code Set List Views

**Tech Stack**: Not specified

**Solution Preview**: create list views and share with all users...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-326 (Sprint 6)

**Summary**: Manage Primary Taxonomy and Specialty

**Tech Stack**: Not specified

**Solution Preview**: For both Taxonomy and Specialty within the following guided experiences:

* Update NPI -  update existing/create new record as primary & uncheck primary from all other records. Do not delete taxonomy records.
* Create HPF -  update existing/create ne...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-302 (Sprint 6)

**Summary**: Collaborative Practice Agreement Review UI

**Tech Stack**: Not specified

**Solution Preview**: Create a Omni Script with Multi Select functionality Mass Update the CPA records.

Use Edit Block to display records 

Display CPA records based on relationship Case > CPA Review > CPA...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-2436 (Sprint 7)

**Summary**: Enhanced Clinician Inactivation: Case and Task Closure

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2089 (Sprint 7)

**Summary**: Clinician Contract Request: Update Naming Convention for Contract Payment Agreement

**Tech Stack**: Not specified

**Solution Preview**: Clinician Contract:
ContractPaymentAgreement. Name = Contractnumber-Global_Account_Id-ratetype...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2016 (Sprint 7)

**Summary**: Update Facility Title Record for Ambassador NP/PA

**Tech Stack**: Not specified

**Solution Preview**: update the Ambassador NP/PA record according to the Health Cloud records sheet

update any deployment steps for upstream environments...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1703 (Sprint 7)

**Summary**: Corporate Entity Mismatch Queue

**Tech Stack**: Not specified

**Solution Preview**: Create Queue *Corporate Entity Mismatch Queue*

Add some user for testing.

Testing: when you assign to a specific user, then Approval Work Item should be visible in Assigned Approval Work Items & My Outstanding Approvals (unsure if this got fixed)....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1628 (Sprint 7)

**Summary**: Approval Work Items

**Tech Stack**: Not specified

**Solution Preview**: Update the record page according to Data Dictionary...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1583 (Sprint 7)

**Summary**: Add SCP Logo to Prospect Portal

**Tech Stack**: Not specified

**Solution Preview**: Add the HCP logo to Experience Builder...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1580 (Sprint 7)

**Summary**: Enhanced Clinician Inactivation: HPF Status Updates

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1368 (Sprint 7)

**Summary**: Add Banner to HC Portal

**Tech Stack**: Not specified

**Solution Preview**: Add the banner image to the Asset Libraries

Add the banner image to the Compact Header Image of the Experience Site...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1172 (Sprint 7)

**Summary**: Enrollment Specialist - Update Test User

**Tech Stack**: Not specified

**Solution Preview**: * update Enrollment Specialist test user (Toni Morrison) to add another Public group = Manage Cases
* Retest [https://salesforce.atlassian.net/browse/PR1050558-857|https://salesforce.atlassian.net/browse/PR1050558-857|smart-link] to ensure still work...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-326 (Sprint 7)

**Summary**: Manage Primary Taxonomy and Specialty

**Tech Stack**: Not specified

**Solution Preview**: For both Taxonomy and Specialty within the following guided experiences:

* Update NPI -  update existing/create new record as primary & uncheck primary from all other records. Do not delete taxonomy records.
* Create HPF -  update existing/create ne...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-302 (Sprint 7)

**Summary**: Collaborative Practice Agreement Review UI

**Tech Stack**: Not specified

**Solution Preview**: Create a Omni Script with Multi Select functionality Mass Update the CPA records.

Use Edit Block to display records 

Display CPA records based on relationship Case > CPA Review > CPA...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2450 (Sprint 8)

**Summary**: Enhanced Clinician Inactivation: Case and Task Closure

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2436 (Sprint 8)

**Summary**: Enhanced Clinician Inactivation: Case and Task Closure

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2228 (Sprint 8)

**Summary**: Improve Provider Network Contract related list component look & feel

**Tech Stack**: Not specified

**Solution Preview**: Change Flexcard structure to accomodate PNC icon so taht it looks and feel is more similar to other related lists. Change DR to retrieve the PNC count for a given contract....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2152 (Sprint 8)

**Summary**: Services Object - Set History Tracking & Layout Updates

**Tech Stack**: Not specified

**Solution Preview**: * Personas:
** Business Development Associate
** Sales VP
** Sales Operations
** VP Sales Operations
** Implementation Specialist
** Finance
** Marketing...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1792 (Sprint 8)

**Summary**: Approval Work Items - List View Updates

**Tech Stack**: Not specified

**Solution Preview**: Update the record page according to Data Dictionary...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1703 (Sprint 8)

**Summary**: Corporate Entity Mismatch Queue

**Tech Stack**: Not specified

**Solution Preview**: Create Queue *Corporate Entity Mismatch Queue*

Add some user for testing.

Testing: when you assign to a specific user, then Approval Work Item should be visible in Assigned Approval Work Items & My Outstanding Approvals (unsure if this got fixed)....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1653 (Sprint 8)

**Summary**: Clinician "At a Glance" - Offboarding

**Tech Stack**: Not specified

**Solution Preview**: See split from stories for solutions....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1628 (Sprint 8)

**Summary**: Approval Work Items

**Tech Stack**: Not specified

**Solution Preview**: Update the record page according to Data Dictionary...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1583 (Sprint 8)

**Summary**: Add SCP Logo to Prospect Portal

**Tech Stack**: Not specified

**Solution Preview**: Add the HCP logo to Experience Builder...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1580 (Sprint 8)

**Summary**: Enhanced Clinician Inactivation: HPF Status Updates

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-487 (Sprint 8)

**Summary**: CDC Channel Update - Clinician Contract Executed/Start Admin Work

**Tech Stack**: Not specified

**Solution Preview**: Add the condition to existing CDC (for employee type IC or employee)

((emptype == ‘Employee’ OR emptype=='IC' ) && (Status == ‘executed’ and hiredate!= null) ) OR (status = executed)...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2949 (Sprint 9)

**Summary**: New Custom button “Create Clinician Change” - Screen flow, to capture the fields was not available i

**Tech Stack**: Not specified

**Solution Preview**: the solution as given differently at the first place. Later it got change as a part of this defect...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2941 (Sprint 9)

**Summary**: Issue with Bonus type rate configuration on clinician contract

**Tech Stack**: Not specified

**Solution Preview**: This was not included in the solution....

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2526 (Sprint 9)

**Summary**: Clinician Contract Request: Add hide/show logic for "Submit Contract Request" button

**Tech Stack**: Not specified

**Solution Preview**: On the ClinicianContractSummaryScreen flexcard,
add conditional visibility for the three buttons ( Add HPF, Submit COntract request, Configure rates) to show the buttons only when 
Where Contract.RecordType Name = Clinician AND
Contract.status = Draf...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2468 (Sprint 9)

**Summary**: Collaborative Practice Agreement Review UI: Name Fields

**Tech Stack**: Not specified

**Solution Preview**: Create a Omni Script with Multi Select functionality Mass Update the CPA records.

Use Edit Block to display records 

NPPA Name: Collaborative Practice Agreement -> NP/PA Healthcare Practitioner Facility -> Practitioner ->Name

Physician Name: Colla...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2450 (Sprint 9)

**Summary**: Enhanced Clinician Inactivation: Case and Task Closure

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2237 (Sprint 9)

**Summary**: Clinician Onboarding Case & Task Updates

**Tech Stack**: Not specified

**Solution Preview**: [https://docs.google.com/spreadsheets/d/1YC9vi1-hRUZfYPY3doZwSIxczV2HtMeLl6jcUrI-qKY/edit?usp=sharing|https://docs.google.com/spreadsheets/d/1YC9vi1-hRUZfYPY3doZwSIxczV2HtMeLl6jcUrI-qKY/edit?usp=sharing|smart-link] 

Rename the task subject  “*Create...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2152 (Sprint 9)

**Summary**: Services Object - Set History Tracking & Layout Updates

**Tech Stack**: Not specified

**Solution Preview**: * Personas:
** Business Development Associate
** Sales VP
** Sales Operations
** VP Sales Operations
** Implementation Specialist
** Finance
** Marketing...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1792 (Sprint 9)

**Summary**: Approval Work Items - List View Updates

**Tech Stack**: Not specified

**Solution Preview**: Update the record page according to Data Dictionary...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1580 (Sprint 9)

**Summary**: Enhanced Clinician Inactivation: HPF Status Updates

**Tech Stack**: Apex

**Solution Preview**: single place for IT to adjust time from 12 months (ex. to 6 months)

Create an apex batch job that runs daily. It will query all related sites for the clinician and then look for the HPF’s belonging to that sites. If the Last Worked  Date is more tah...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1096 (Sprint 9)

**Summary**: Intake Form Case - CCPA Notice

**Tech Stack**: Not specified

**Solution Preview**: TBD...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-487 (Sprint 9)

**Summary**: CDC Channel Update - Clinician Contract Executed/Start Admin Work

**Tech Stack**: Not specified

**Solution Preview**: Add the condition to existing CDC (for employee type IC or employee)

((emptype == ‘Employee’ OR emptype=='IC' ) && (Status == ‘executed’ and hiredate!= null) ) OR (status = executed)...

*Full Solution: See Sprint 9 HTML file*

---

### Apex Development (178 stories)

#### PR1050558-3187 (Sprint 10)

**Summary**: Facility Change Request: Coverage Change - Only Pay Code Change - Auto Update Executed Clinician Con

**Tech Stack**: Apex

**Solution Preview**: As part of the batch class built for 2916, in the start method, we would have gotten the PO CPA where Rate_Pay_Code_Remove_c or Rate_Pay_Code_Added_c > 0.
Add method to Get Client RatePayCodes
Query for RatePaycode, where Is_Newly_Added > 0 or Is_Del...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2950 (Sprint 10)

**Summary**: Offboarding Tasks - Facility Specific - Update Task

**Tech Stack**: Apex

**Solution Preview**: Modifications to existing solution that was built as part of 1728
Only for one particular Task, that was part of task creation automation


||*Field*||*Old*||*New*||
|Task.Subject|Review Contract for Termination|Update Records and Notify Teams|
|Task...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2906 (Sprint 10)

**Summary**: Facility Change Request: Rates & Coverage 2 of 2

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: All Changes to Apply to Practice Operation Contract

Create a validation rule in Shift__c to make sure only same shift type can be added when Contract.Shift_Coverage_Change__c = true

* Validation Rule:
** Validation Rule to prevent the user from edi...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2830 (Sprint 10)

**Summary**: Integration Platform Event: Re-Trigger Integration

**Tech Stack**: Apex, Flow

**Solution Preview**: Integration_Log__c.Status__c 

Picklist Value

* Delete: Pending, In Progress, Retried
* Add New Values: Retry

Create new Platform Event: Retry Integration Exception

* Platform Event Fields, Name = Retry_Integration_Exception__c
** IntegrationLogId...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2827 (Sprint 10)

**Summary**: HPF Updates & Platform Event: First Clinical Shift and Active (Integration)

**Tech Stack**: Apex, Flow, REST

**Solution Preview**: Update the Flow to HPF Updates Triggered Flow



Change 1:

Add new Condition with below Criteria to restrict Platform Event Type (Note: The original condition If_date_First_Clinical_Shift_is_changed should remain unchanged)

Employee
Independent Con...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2673 (Sprint 10)

**Summary**: Military Status Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: These are manual changes.
Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Military Status Change

Add the fields mentioned below to layout and LRP.

* Subject = Military Status change for <Clinician> (system to set u...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2672 (Sprint 10)

**Summary**: Business Entity Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Business Entity Change

Add the fields mentioned below to layout and LRP.

* Subject =  Business Entity change for <Clinician> (system to set upon save)
* Description =...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2670 (Sprint 10)

**Summary**: Clinician Name Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Name Change

Add the fields mentioned below to layout and LRP.

* Subject = Clinician Name change for <Clinician> (system to set upon save)
* Description = <user insert...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2659 (Sprint 10)

**Summary**: Clinicians Contract Request: Fields Needed to Determine Addendum

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: Object = *Contract* 

* NPPA_Tier_Changed__c → Formula

Object = *Shift*

* Existing Shift Type Added?
* New Shift Type Added?
* New Shift Bonus Type Added 
* Is Deleted?

Create a Record Triggered Flow for Shift Object Record New or Update Records:
...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2558 (Sprint 10)

**Summary**: Clinician Contract Date Alignment

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow on Contract, When a new Contract is Executed, and there is an existing contract that is executed,
If Contract.CompanySignedDate >= Contract.StartDate
If Existing Active Contract. End Date is populated and Employment Type of old ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2462 (Sprint 10)

**Summary**: Enable Integration to Workday for SCP Offboarding - 2 of 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Event 

*  Name: Clinician Offboarding Request (Use same API name in Story - Integration Dependency)
** API Name: Clinician_Offboarding_Request__c
* Fields
** Type: Type__c, Text(200)
** Business Entity Name: Business_Entity_Name__c...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2418 (Sprint 10)

**Summary**: Insurance Provided By Validation Rule

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: Create new field Insurance Provided By on HPF. Add to layout.

Add a row to existing Custom Metadata, to capture the table of Facility title and Insurance provided by.
When HPF is created ( using flow trigger),
Use the custom metadata, to auto-popula...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2239 (Sprint 10)

**Summary**: Clinician Contracting - Job Requisition Handoff to Asymbl

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Service__c.Account__c to get the Service Account

Use the records triggered flow for Update Opportunity

Create Task records based on AC

Story to cover

!image-20250904-021151.png|width=1101,height=530,alt="image-20250904-021151.png"!...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1750 (Sprint 10)

**Summary**: Clinician Agreement Approval Process: VPO

**Tech Stack**: Apex, Flow

**Solution Preview**: h2. *Use same Autolaunched Orchestrator (no trigger) Approval Flow process*

extend and reuse flow built for [https://salesforce.atlassian.net/browse/PR1050558-301|https://salesforce.atlassian.net/browse/PR1050558-301|smart-link] 

Step 3: 
Flow on C...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1677 (Sprint 10)

**Summary**: Automatically Update the Opportunity Status

**Tech Stack**: Apex, Flow

**Solution Preview**: * Record Triggered flow...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1584 (Sprint 10)

**Summary**: Clinician Contract Auto Populate Client Rate

**Tech Stack**: Apex

**Solution Preview**: Context: When a clinician contract is created, and the rates (that are derived from practice operations contract) are modified, an approval process is triggered. The approvers want the ability to view the old rate (from PO contract that was changed) ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-842 (Sprint 10)

**Summary**: IT Support Ticket

**Tech Stack**: Apex, Flow

**Solution Preview**: Ensure IT Support Queue exists, if not create one for Case object.
Add IT Support to Case.Type  if it does not exist
Create Global Action - Create record - Case. Record Type : Support
Use Before trigger flow on Case, to check the Type = IT Support an...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3545 (Sprint 11)

**Summary**: Tech - SSO Flow - Send Clinician Info to Okta

**Tech Stack**: Apex, Flow

**Solution Preview**: [https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_loc=685%2C-134%2C3062%2C1543%2C0_0&invitationId=inv_16c3408e-a23f-43cc-b337-68cc38c29be9|https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3383 (Sprint 11)

**Summary**: Add Additional Fields

**Tech Stack**: Apex, Flow

**Solution Preview**: * For newly added fields, see the DD for layout and update FLS for permission sets that have access to the object. 



Record Triggered flow in PNC: 

# When ProviderNetworkContract.Contract.Contract_Type__c = “Master” AND ProviderNetworkContract.Cli...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3240 (Sprint 11)

**Summary**: Client Onboarding - Set PMT Task “Task Completion %” field

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the record triggered flow [Task After Flow|https://corehc--dev1.sandbox.my.salesforce-setup.com/builder_platform_interaction/flowBuilder.app?flowId=3017x00001NS9PHAA1]

# When the Task.Status is updated to Completed or Canceled or Open check i...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3207 (Sprint 11)

**Summary**: Facility Change Request: Practice Operation Contract - Auto End Date

**Tech Stack**: Apex, Flow

**Solution Preview**: * Then *on the 'Start Date'* of the *new* Executed Practice Operations Contract, the system will automatically update the active contract’s:
** Use scheduled Flow that run every DAY that update the Contract Record → Record Type: Practice Operation
**...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3190 (Sprint 11)

**Summary**: Facility Change Request: Coverage Change - Only Shift change & Pay Code Change - Platform event trig

**Tech Stack**: Apex

**Solution Preview**: As part of the same batch class (related to the associated stories 2916 and 3187),
When either of the conditions (of ac1 or ac2) satisfies, 
Create a platform event for each HPF of the clinician contract (using the PNC>HPF>Account = PO Contract.Accou...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3187 (Sprint 11)

**Summary**: Facility Change Request: Coverage Change - Only Pay Code Change - Auto Update Executed Clinician Con

**Tech Stack**: Apex

**Solution Preview**: As part of the batch class built for 2916, in the start method, we would have gotten the PO CPA where Rate_Pay_Code_Remove_c or Rate_Pay_Code_Added_c > 0.
Add method to Get Client RatePayCodes
Query for RatePaycode, where Is_Newly_Added > 0 or Is_Del...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3027 (Sprint 11)

**Summary**: Client Onboarding - PMT Project, PMT Phase, & PMT Task

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: * Field creation part of [https://salesforce.atlassian.net/browse/PR1050558-2924|https://salesforce.atlassian.net/browse/PR1050558-2924|smart-link] 
* Security -
** Persona that have Edit access PMT = Implementation Specialist
** Permission Set = *Ma...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2906 (Sprint 11)

**Summary**: Facility Change Request: Rates & Coverage 2 of 2

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: All Changes to Apply to Practice Operation Contract

Create a validation rule in Shift__c to make sure only same shift type can be added when Contract.Shift_Coverage_Change__c = true

* Validation Rule:
** Validation Rule to prevent the user from edi...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2659 (Sprint 11)

**Summary**: Clinicians Contract Request: Fields Needed to Determine Addendum

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: Object = *Contract* 

* NPPA_Tier_Changed__c → Formula

Object = *Shift*

* Existing Shift Type Added?
* New Shift Type Added?
* New Shift Bonus Type Added 
* Is Deleted?

Create a Record Triggered Flow for Shift Object Record New or Update Records:
...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2151 (Sprint 11)

**Summary**: Auto Create Client Contract (Practice Operations) - Task Creation

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create/Reuse a after save Record triggered flow on Contract, when Contract Record Type is Practice Operations, Pro Forma Model Status = Approved for Contracting and the Opportunity.Services__c has at least one in Status = -Active then use the de...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2139 (Sprint 11)

**Summary**: Client Onboarding - Auto Task Creation - LOI Executed

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a update record triggered flow on Opportunity (flow should only trigger when record is updated to meet the condition)

Opportunity.LOI_Complete__c = true and Opportunity.PMT_Project__c = null

Create a task record as specified in the AC...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2087 (Sprint 11)

**Summary**: Client Onboarding - Auto Task Creation -  “Green Light for Client Outreach”

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a update record triggered flow on Opportunity (flow should only trigger when record is updated to meet the condition)

Opportunity.Green_Light_for_Client_Outreach__c = true and Opportunity.PMT_Project__c = null

Create a task record as specified ...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1683 (Sprint 11)

**Summary**: Facility Term: Auto Create Cases

**Tech Stack**: Apex, Flow

**Solution Preview**: * Story includes new Case Record type creation, fields, layout and permissions
* Create new case & task queue: 
** IT Infrastructure Queue  (IT users will be added to this queue)
* For all the Case set
** Case.Account =   *Service Account*
* Security...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1682 (Sprint 11)

**Summary**: Facility Change Request: Clinician Side Manual  Change Management tasks

**Tech Stack**: Apex, Flow, JavaScript

**Solution Preview**: * you will be using attributes fields(fields created in 2659) on the CPA to determine to send a task or not. 
** To test, manually update the field to checked.
* Refer use cased for Manual Task (WHEN Logic = Manual) [https://docs.google.com/spreadshe...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1679 (Sprint 11)

**Summary**: Client Onboarding - Trigger Auto task creation

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow for Update in PMT Task object

# When the Status of inov8__PMT_Task__c.inov8__Status__c = “In Progress”
## Get the PMT Task Name of the inov8__PMT_Task__c.Name and query for matching name in ActionPlanTemplateVersion to find the...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1678 (Sprint 11)

**Summary**: Client Onboarding - Auto Task Creation - Contract Status = Executed

**Tech Stack**: Apex, Flow

**Solution Preview**: NOTE: for Dev/Testing purposes, since story [https://salesforce.atlassian.net/browse/PR1050558-3351|https://salesforce.atlassian.net/browse/PR1050558-3351] has not been developed, you can login as a system admin and update the Client Contract Status
...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1073 (Sprint 11)

**Summary**: Update Agreement Request - Email Alert

**Tech Stack**: Apex, Flow

**Solution Preview**: -Update the Omni Script InitiateContractingRequest to add the step to send the email as per AC-

Use a record triggered flow to send the email for Case record with Record Type =  Client Agreement Request *is created*



custom label named : [+DLClien...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4198 (Sprint 12)

**Summary**: Client Change Management - Update Client Change Management Status based on Task Status

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Record Triggered Flow in Object Task, update the Client Change Management records

AC2: Update Sharing Setting in Field

AC3: Enable Tracking History...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4143 (Sprint 12)

**Summary**: Regression bug: Clinician Facility Offboarding case is not getting created for MSL user.

**Tech Stack**: Apex, Flow

**Solution Preview**: h3. *Create a Platform Event:* 

* Name: Clone Record
* API Name: Clone_Record__e
* Field
** Id of Record To Clone
** sObject Name
** Attribute 1
** Attribute 2
** Attribute 3



h3. Create Platform Event:

***Remove the Existing Logic to Create the ...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4051 (Sprint 12)

**Summary**: Client Contract - Updates to support allowing multiple Masters with the same Service Accounts

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Add new picklist value and inactivate the ones as listed in AC

AC2: Make changes to record page 

AC3: Add Record Type to the criteria in the flow built as part of [+PR1050558-887+|https://salesforce.atlassian.net/browse/PR1050558-887]

AC4: Up...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3993 (Sprint 12)

**Summary**: Client Onboarding - Trigger Task Creation - Ensure Task Record Type = Default

**Tech Stack**: Apex, Flow

**Solution Preview**: Note: Since the Record Triggered flow is running in System User the default RT is created as Sales which was not correct.

Update the flow PMT Task : Action Plan and Record Updation Flow   

Update All the Task Record Type that is selected as part of...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3614 (Sprint 12)

**Summary**: Tech - SSO Flow - Send Clinician Info to Okta - UPDATE - change criteria and send 'Fed ID'

**Tech Stack**: Apex, Flow

**Solution Preview**: [https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_loc=685%2C-134%2C3062%2C1543%2C0_0&invitationId=inv_16c3408e-a23f-43cc-b337-68cc38c29be9|https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3574 (Sprint 12)

**Summary**: Client Change Management - Clinician Contract Executed between PO Contracts

**Tech Stack**: Apex, Flow

**Solution Preview**: Use an asynchronous path of record triggered flow for update  *(Offset: 1 minute after the record updated)* 

When Contract.RecordType=Clinician AND Contract.Status = Executed

For Each HPF in the Contract>PNC>HPF see if there is a forward Contract

...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3545 (Sprint 12)

**Summary**: Tech - SSO Flow - Send Clinician Info to Okta

**Tech Stack**: Apex, Flow

**Solution Preview**: [https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_loc=685%2C-134%2C3062%2C1543%2C0_0&invitationId=inv_16c3408e-a23f-43cc-b337-68cc38c29be9|https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3451 (Sprint 12)

**Summary**: Client Onboarding - Auto Task Creation for Onboarding Task related to PMT Phase

**Tech Stack**: Apex, Flow

**Solution Preview**: Enable Activity for Object PMT_Phase__c

When the PMT_Phase__c.Service_Account__c is updated from Blank to a value 

# Tun a Record Triggered Flow in  PMT_Phase__c
## Create the Task based on AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3388 (Sprint 12)

**Summary**: Client Change Management - Create Records

**Tech Stack**: Apex

**Solution Preview**: Created by Gemini

h3. ## Part 1: Analyze Contract Changes



This first part kicks off automatically when a contract's status is set to "Executed." Its job is to analyze all the detailed changes in the contract and sort them into organized groups.

...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3347 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Action = Expire Contract

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: *AC1 & 2:* 

*Name:* Client Contract Scheduled Flow

Use Scheduled Flow in Contract Object and Filter Conditions for RT: Client Contract AND Contract_Type__c = “Terms & Renewals” AND (Internal Renewal Start Date = Today() OR Renewal Notice Date = Tod...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3240 (Sprint 12)

**Summary**: Client Onboarding - Set PMT Task “Task Completion %” field

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the record triggered flow [Task After Flow|https://corehc--dev1.sandbox.my.salesforce-setup.com/builder_platform_interaction/flowBuilder.app?flowId=3017x00001NS9PHAA1]

# When the Task.Status is updated to Completed or Canceled or Open check i...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3190 (Sprint 12)

**Summary**: Facility Change Request: Coverage Change - Only Shift change & Pay Code Change - Platform event trig

**Tech Stack**: Apex

**Solution Preview**: As part of the same batch class (related to the associated stories 2916 and 3187),
When either of the conditions (of ac1 or ac2) satisfies, 
Create a platform event for each HPF of the clinician contract (using the PNC>HPF>Account = PO Contract.Accou...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3027 (Sprint 12)

**Summary**: Client Onboarding - PMT Project, PMT Phase, & PMT Task

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: * Field creation part of [https://salesforce.atlassian.net/browse/PR1050558-2924|https://salesforce.atlassian.net/browse/PR1050558-2924|smart-link] 
* Security -
** Persona that have Edit access PMT = Implementation Specialist
** Permission Set = *Ma...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2807 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Status & Key Date Updates

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Set the Status value for Record Type = Client Contract 



AC2: 

Requested Date: When the Contract is initially created from Case using “Configure Contract” (handled as part of [https://salesforce.atlassian.net/browse/PR1050558-3021|https://sal...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2442 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Status & Key Date Updates

**Tech Stack**: Apex, Flow

**Solution Preview**: * Update Contract (RT:Letter of Intent)
** Field = Status - update the values
** Read only on page/layout



Record Triggered Flow on Case RT: Letter of Intent

Requested Date → CreatedDate

Date Sent For Internal Review → When Contract.Status = “Sub...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2151 (Sprint 12)

**Summary**: Auto Create Client Contract (Practice Operations) - Task Creation

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create/Reuse a after save Record triggered flow on Contract, when Contract Record Type is Practice Operations, Pro Forma Model Status = Approved for Contracting and the Opportunity.Services__c has at least one in Status = -Active then use the de...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2139 (Sprint 12)

**Summary**: Client Onboarding - Auto Task Creation - LOI Executed

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a update record triggered flow on Opportunity (flow should only trigger when record is updated to meet the condition)

Opportunity.LOI_Complete__c = true and Opportunity.PMT_Project__c = null

Create a task record as specified in the AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2087 (Sprint 12)

**Summary**: Client Onboarding - Auto Task Creation -  “Green Light for Client Outreach”

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a update record triggered flow on Opportunity (flow should only trigger when record is updated to meet the condition)

Opportunity.Green_Light_for_Client_Outreach__c = true and Opportunity.PMT_Project__c = null

Create a task record as specified ...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1683 (Sprint 12)

**Summary**: Facility Term: Auto Create Cases

**Tech Stack**: Apex, Flow

**Solution Preview**: * Story includes new Case Record type creation, fields, layout and permissions
* Create new case & task queue: 
** IT Infrastructure Queue  (IT users will be added to this queue)
* For all the Case set
** Case.Account =   *Service Account*
* Security...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1682 (Sprint 12)

**Summary**: Facility Change Request: Clinician Side Manual  Change Management tasks

**Tech Stack**: Apex, Flow, JavaScript

**Solution Preview**: * you will be using attributes fields(fields created in 2659) on the CPA to determine to send a task or not. 
** To test, manually update the field to checked.
* Refer use cased for Manual Task (WHEN Logic = Manual) [https://docs.google.com/spreadshe...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1679 (Sprint 12)

**Summary**: Client Onboarding - Trigger Auto task creation

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow for Update in PMT Task object

# When the Status of inov8__PMT_Task__c.inov8__Status__c = “In Progress”
## Get the PMT Task Name of the inov8__PMT_Task__c.Name and query for matching name in ActionPlanTemplateVersion to find the...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1678 (Sprint 12)

**Summary**: Client Onboarding - Auto Task Creation - Contract Status = Executed

**Tech Stack**: Apex, Flow

**Solution Preview**: NOTE: for Dev/Testing purposes, since story [https://salesforce.atlassian.net/browse/PR1050558-3351|https://salesforce.atlassian.net/browse/PR1050558-3351] has not been developed, you can login as a system admin and update the Client Contract Status
...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-1073 (Sprint 12)

**Summary**: Update Agreement Request - Email Alert

**Tech Stack**: Apex, Flow

**Solution Preview**: -Update the Omni Script InitiateContractingRequest to add the step to send the email as per AC-

Use a record triggered flow to send the email for Case record with Record Type =  Client Agreement Request *is created*



custom label named : [+DLClien...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-5221 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT393 Incorrect Effective From Date Populating on Rehire HPF

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the record triggered flow existing logic to new logic.

Check for condition HPF.Status is != Prospect *AND*  HPF.Status != *Inactive*...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5117 (Sprint 12.1)

**Summary**: UAT Enhancement: Prevent Clinician Contract with Same Start Date

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Record Triggered Flow Flow  to check  the dates and throw a validation error as per AC

Both Insert and Update...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5091 (Sprint 12.1)

**Summary**: UAT Enhancement - Adjust Manual Create HPF Experience and HPF View/Edit

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Record Triggered Flow...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5090 (Sprint 12.1)

**Summary**: UAT Enhancement - Date Validation for Automated Create HPF from Job

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Record Triggered Flow...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5064 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT335 Populate Intake Form Answers to Clinician Person Account

**Tech Stack**: Apex, Flow

**Solution Preview**: # -Create the Invocable Apex Class, which accepts AssessmentId.-
# Query Assessment Question Response records for *Clinician Profile Updates assessment*
# Read the value of assessment question response records and Update it
## Professional Title (Con...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4980 (Sprint 12.1)

**Summary**: UAT Enhancement - Date Validation for Manual Create HPF

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Record Triggered Flow...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4948 (Sprint 12.1)

**Summary**: UAT Enhancement : Clone the Acknowledge Flag field while Cloning the contract

**Tech Stack**: Apex

**Solution Preview**: Contract_Trigger__chn should fire for all

This should only apply for  Contract_HireDate_Trigger__chn...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4935 (Sprint 12.1)

**Summary**: Platform Event Update - 'HPFUpdate' - trigger based on Credentialing Status

**Tech Stack**: Apex, Flow

**Solution Preview**: Support document, Tab = Rates Update: [https://lucid.app/lucidchart/d9435ec9-bde0-4114-b4a5-179c8d1a1311/edit?viewport_loc=-902%2C-268%2C3326%2C1664%2CW_kVz9_YbP6-&invitationId=inv_b1258f02-4b88-49c3-832a-a57531d8dfee|https://lucid.app/lucidchart/d94...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4907 (Sprint 12.1)

**Summary**: UAT Enhancement: Prevent Duplicate Email addresses for Active Clinician Portal Users

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Use Record Triggered Flow

AC2: Use a Flow to validate in User Object...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4862 (Sprint 12.1)

**Summary**: UAT Enhancement: Convert Data Type for ID Fields

**Tech Stack**: Apex, Flow

**Solution Preview**: {color:#bf2600}*THis field though its a Text its going to have numbers so when testing please use NUMBERS and no alfa numeric or plain Text*{color}



Background: SCP is running into issues when trying to covert Global_Contact_ID__c, Global_Account_I...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4861 (Sprint 12.1)

**Summary**: UAT Enhancement: Update CDC Channel - add fields and update triggers

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create new field in Contract Object as per Data Dictionary

AC2: Update the CDC event Contract_Trigger__chn with new condition

AC2: Update the CDC event Contract_HireDate_Trigger__chn with new condition



Mule will update the fields respective...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4748 (Sprint 12.1)

**Summary**: Clinician Hire Date

**Tech Stack**: Apex, Flow

**Solution Preview**: *Regular Clinician*

Record Triggered Flow for Update in HPF

When HPF.First_Clinical_Shift__c is Updated Check if the Contract.Hire_Date__c = NULL then Update  Contract.Hire_Date__c = HPF.First_Clinical_Shift_Date__c

Query to Identify Contract: Sel...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4727 (Sprint 12.1)

**Summary**: E2E Bug: CDC Channel Update

**Tech Stack**: Apex

**Solution Preview**: *Update* the condition for CDC Channel Contract_Trigger__chn

filterExpression: (Status = &apos;Executed&apos;) 



Create a *new* CDC Channel Name: Contract_HireDate_Trigger__chn

filterExpression: (Status = &apos;Executed&apos; AND Hire_Date__c != ...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4705 (Sprint 12.1)

**Summary**: UAT Enhancement: Update Integration to Workday for SCP Offboarding - EE add Global Provider ID

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the Case flow with the existing platform event (Create or Update a Record Triggers Flow Case for *Update)*

* Condition: Record Type = Clinician Offboarding and Type = SCP is updated so that Status = Closed and Closed Reason = Complete

# Case...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4674 (Sprint 12.1)

**Summary**: Hire Date when Employment Type is Changing

**Tech Stack**: Apex, Flow

**Solution Preview**: Update a record triggered flow for Contract when Contract is Record is created (Fast Field Update)

Check if the Contract has any Executed Contract with Different Type

Query: Select Count(Id) from Contract where Contract.AccountId = NewContract.Acco...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4432 (Sprint 12.1)

**Summary**: UAT Enhancement: Automated Onboarding Task Record Closure - I9 Update

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow in Contact Object when IP Status is updated...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4198 (Sprint 12.1)

**Summary**: Client Change Management - Update Client Change Management Status based on Task Status

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Record Triggered Flow in Object Task, update the Client Change Management records

AC2: Update Sharing Setting in Field

AC3: Enable Tracking History...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4051 (Sprint 12.1)

**Summary**: Client Contract - Updates to support allowing multiple Masters with the same Service Accounts

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Add new picklist value and inactivate the ones as listed in AC

AC2: Make changes to record page 

AC3: Add Record Type to the criteria in the flow built as part of [+PR1050558-887+|https://salesforce.atlassian.net/browse/PR1050558-887]

AC4: Up...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3614 (Sprint 12.1)

**Summary**: Tech - SSO Flow - Send Clinician Info to Okta - UPDATE - change criteria and send 'Fed ID'

**Tech Stack**: Apex, Flow

**Solution Preview**: [https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_loc=685%2C-134%2C3062%2C1543%2C0_0&invitationId=inv_16c3408e-a23f-43cc-b337-68cc38c29be9|https://lucid.app/lucidchart/3e2874f0-f9bf-4fa1-8510-7474dc192fb4/edit?viewport_...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3451 (Sprint 12.1)

**Summary**: Client Onboarding - Auto Task Creation for Onboarding Task related to PMT Phase

**Tech Stack**: Apex, Flow

**Solution Preview**: Enable Activity for Object PMT_Phase__c

When the PMT_Phase__c.Service_Account__c is updated from Blank to a value 

# Tun a Record Triggered Flow in  PMT_Phase__c
## Create the Task based on AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3347 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Action = Expire Contract

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: *AC1 & 2:* 

*Name:* Client Contract Scheduled Flow

Use Scheduled Flow in Contract Object and Filter Conditions for RT: Client Contract AND Contract_Type__c = “Terms & Renewals” AND (Internal Renewal Start Date = Today() OR Renewal Notice Date = Tod...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2908 (Sprint 12.1)

**Summary**: UAT Enhancement: Enable Integration to Workday for SCP Offboarding - IC Delay 120 Days

**Tech Stack**: Apex, Flow

**Solution Preview**: Remove the path of Flow  that sends the Platform Event for IC built as part of [https://salesforce.atlassian.net/browse/PR1050558-2462|https://salesforce.atlassian.net/browse/PR1050558-2462|smart-link] 

Create a Scheduled Triggered Flow that trigger...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2813 (Sprint 12.1)

**Summary**: New Clinician Athena Notification

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a Record Triggered Flow When HPF is updated check below condition (Flow = HPF Updates Triggered Flow)

* HPF > *Anticipated First Shift* [First_Scheduled_Date__c] is populated
* HPF Service Account > *Billing Company* = “EMBCC”
* HPF > *Credentia...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2807 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Status & Key Date Updates

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Set the Status value for Record Type = Client Contract 



AC2: 

Requested Date: When the Contract is initially created from Case using “Configure Contract” (handled as part of [https://salesforce.atlassian.net/browse/PR1050558-3021|https://sal...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2442 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Status & Key Date Updates

**Tech Stack**: Apex, Flow

**Solution Preview**: * Update Contract (RT:Letter of Intent)
** Field = Status - update the values
** Read only on page/layout



Record Triggered Flow on Case RT: Letter of Intent

Requested Date → CreatedDate

Date Sent For Internal Review → When Contract.Status = “Sub...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5117 (Sprint 12.2)

**Summary**: UAT Enhancement: Prevent Clinician Contract with Same Start Date

**Tech Stack**: Apex, Flow

**Solution Preview**: Use Record Triggered Flow Flow  to check  the dates and throw a validation error as per AC

Both Insert and Update...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4948 (Sprint 12.2)

**Summary**: UAT Enhancement : Clone the Acknowledge Flag field while Cloning the contract

**Tech Stack**: Apex

**Solution Preview**: Contract_Trigger__chn should fire for all

This should only apply for  Contract_HireDate_Trigger__chn...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4907 (Sprint 12.2)

**Summary**: UAT Enhancement: Prevent Duplicate Email addresses for Active Clinician Portal Users

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Use Record Triggered Flow

AC2: Use a Flow to validate in User Object...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4705 (Sprint 12.2)

**Summary**: UAT Enhancement: Update Integration to Workday for SCP Offboarding - EE add Global Provider ID

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the Case flow with the existing platform event (Create or Update a Record Triggers Flow Case for *Update)*

* Condition: Record Type = Clinician Offboarding and Type = SCP is updated so that Status = Closed and Closed Reason = Complete

# Case...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4674 (Sprint 12.2)

**Summary**: Hire Date when Employment Type is Changing

**Tech Stack**: Apex, Flow

**Solution Preview**: Update a record triggered flow for Contract when Contract is Record is created (Fast Field Update)

Check if the Contract has any Executed Contract with Different Type

Query: Select Count(Id) from Contract where Contract.AccountId = NewContract.Acco...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4198 (Sprint 12.2)

**Summary**: Client Change Management - Update Client Change Management Status based on Task Status

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Record Triggered Flow in Object Task, update the Client Change Management records

AC2: Update Sharing Setting in Field

AC3: Enable Tracking History...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5580 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare133 - HPF 'Status' is getting set to 'Inactive' before the 'Effective T

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: AC1: Validation Rule in Case

AC2: Record Triggered Flow validation as we need to check other records are completed from Case as well as Task

*AC3* Update the existing record triggered flow that updates the HPF



Create a Activity Record Type : Exi...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5221 (Sprint 12.3)

**Summary**: UAT Bug: C&CUAT393 Incorrect Effective From Date Populating on Rehire HPF

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the record triggered flow existing logic to new logic.

Check for condition HPF.Status is != Prospect *AND*  HPF.Status != *Inactive*...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5792 (Sprint 12.4)

**Summary**: PROD Enhancement: UPHypercare268 - HPF termination date for what may have been a facility title chan

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: *As an Admin, I can update an HPF Facility’s Facility Title (CodeSet) lookup value to reflect that a clinician’s role at a particular HPF facility has changed but not ended.* 

Currently the batch close process that deactivates HPFs on their “Effecti...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-6260 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email - 2 of 3

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create a new Email Template for *mySCP Instructions Email*, update verbiage for Locum, Leased, & Managed



AC2, AC3, AC4: Update the Record Trigger Flow HPFScheduledPathFlows 

When HPF Facility Title Employment Type from Code Set = [Locum or L...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5873 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email 1 of 3

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create a new Email Template for *mySCP Instructions Email*, update verbiage for Locum, Leased, & Managed



AC2, AC3, AC4: Update the Record Trigger Flow HPFScheduledPathFlows (remember this flow need to process records in BULK) - Split to [+PR1...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5792 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare268 - HPF termination date for what may have been a facility title chan

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: *As an Admin, I can update an HPF Facility’s Facility Title (CodeSet) lookup value to reflect that a clinician’s role at a particular HPF facility has changed but not ended.* 

Currently the batch close process that deactivates HPFs on their “Effecti...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5580 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare133 - HPF 'Status' is getting set to 'Inactive' before the 'Effective T

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: AC1: Validation Rule in Case

AC2: Record Triggered Flow validation as we need to check other records are completed from Case as well as Task

*AC3* Update the existing record triggered flow that updates the HPF



Create a Activity Record Type : Exi...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5232 (Sprint 12.5)

**Summary**: UAT Enhancement: C&CUAT402 Validation Rule Needed: Any Parent Case should not be able to be complete

**Tech Stack**: Apex, Flow

**Solution Preview**: When creating the Child case Use the Case.ParentId field to populate the Parent Case 

Record Triggered Flow Use in Case after update ((Type = SCP, RT = _Clinician_Offboarding_, Case.Status = Closed)  use Case.ParentId to query the child records stat...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5231 (Sprint 12.5)

**Summary**: UAT Enhancement: C&CUAT401 Validation Rule Needed: SCP Offboarding Case Should not be able to comple

**Tech Stack**: Apex, Flow

**Solution Preview**: When creating the Child (Type = Facility, RT = Clinician_Offboarding) case Use the SCP case Case.Id field to populate the Parent Case on the Facilty case Case.ParentId

Existing Logic: All Child Task(s) for Case (Type = SCP, RT = Clinician_Offboardin...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-6000 (Sprint 13)

**Summary**: PROD Enhancement: Intake Status Auto-Update on Assessment Completion

**Tech Stack**: Apex, Flow

**Solution Preview**: *Record Triggered Flow:* Assessment -  After Insert (Update this Flow) - Write the logic in Asynch Path 
Any time an AssessmentEnvelopeItem is updated to status = Completed, query for any other AssessmentEnvelopesItem and when each of them are comple...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5998 (Sprint 13)

**Summary**: UAT Enhancement: Registration URL Exposure (Recruiter Backup Access Path)

**Tech Stack**: Apex

**Solution Preview**: Add record triggered on User object to create a copy of the Experience Site Welcome Email as a closed activity on the Person Account. 

On Create / On Update 
IsChanged(active) = TRUE &&
License = Customer Community Plus &&
Profile Name = -Core HC Cu...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5580 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare133 - HPF 'Status' is getting set to 'Inactive' before the 'Effective T

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: AC1: Validation Rule in Case

AC2: Record Triggered Flow validation as we need to check other records are completed from Case as well as Task

*AC3* Update the existing record triggered flow that updates the HPF



Create a Activity Record Type : Exi...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6260 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email - 2 of 3

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create a new Email Template for *mySCP Instructions Email*, update verbiage for Locum, Leased, & Managed



AC2, AC3, AC4: Update the Record Trigger Flow HPFScheduledPathFlows 

When HPF Facility Title Employment Type from Code Set = [Locum or L...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6235 (Sprint 14)

**Summary**: PROD Enhancement: Update HPF Status from "Superseded" to "Inactive"

**Tech Stack**: Apex

**Solution Preview**: When HPF Status = Inactive

Query all HPF with Status = Superseded with PractitionerId = Current.HPF.PractitionerId and AccountId = Current.HPF.AccountId and Id != Current.HPF.Id

Update Status = Inactive

And a Platform Event Name = HPFUpdates, Type...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6148 (Sprint 14)

**Summary**: Client Change Management: Update Canceled Status criteria for Process Type = Agent

**Tech Stack**: Apex

**Solution Preview**: *Class:* ClinicianContractSyncService

Add CCM logic block: 

# Query CCMs: Process_Type = 'Agent'  AND Status = 'New'    
# Query PO PCAs where Existing_Rate_Increased__c = TRUE (the rates that triggered Agent)
# Query Clinician Contracts filtered t...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6000 (Sprint 14)

**Summary**: PROD Enhancement: Intake Status Auto-Update on Assessment Completion

**Tech Stack**: Apex, Flow

**Solution Preview**: *Record Triggered Flow:* Assessment -  After Insert (Update this Flow) - Write the logic in Asynch Path 
Any time an AssessmentEnvelopeItem is updated to status = Completed, query for any other AssessmentEnvelopesItem and when each of them are comple...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5998 (Sprint 14)

**Summary**: UAT Enhancement: Registration URL Exposure (Recruiter Backup Access Path)

**Tech Stack**: Apex

**Solution Preview**: Add record triggered on User object to create a copy of the Experience Site Welcome Email as a closed activity on the Person Account. 

On Create / On Update 
IsChanged(active) = TRUE &&
License = Customer Community Plus &&
Profile Name = -Core HC Cu...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5873 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email 1 of 3

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Create a new Email Template for *mySCP Instructions Email*, update verbiage for Locum, Leased, & Managed



AC2, AC3, AC4: Update the Record Trigger Flow HPFScheduledPathFlows (remember this flow need to process records in BULK) - Split to [+PR1...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5792 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare268 - HPF termination date for what may have been a facility title chan

**Tech Stack**: Apex, Flow, Formula Field

**Solution Preview**: *As an Admin, I can update an HPF Facility’s Facility Title (CodeSet) lookup value to reflect that a clinician’s role at a particular HPF facility has changed but not ended.* 

Currently the batch close process that deactivates HPFs on their “Effecti...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5648 (Sprint 14)

**Summary**: PROD Enhancement: HPF Inactive Date Trigger to Qgenda - Update when an HPF inactivated and no other 

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the Flow HPF_Updates_Triggered_Flow

|*Is_Inactive*|{{Status__c}} = *Inactive* *and* {{Status__c}} *IsChanged* = true
AND Previous {{Status__c}} !=*Superseded*
AND TerminationDate != null|→ Assign_PE_instance_for_Inactive_HPF|

Send the Platfo...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5580 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare133 - HPF 'Status' is getting set to 'Inactive' before the 'Effective T

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: AC1: Validation Rule in Case

AC2: Record Triggered Flow validation as we need to check other records are completed from Case as well as Task

*AC3* Update the existing record triggered flow that updates the HPF



Create a Activity Record Type : Exi...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-195 (Sprint 2)

**Summary**: Guided Clinician Creation

**Tech Stack**: Apex, Flow

**Solution Preview**: *field mappings*:

* Name (Salutation, FirstName, MiddleName, LastName, Suffix) _PERSON ACCOUNT_
* Professional Title _PERSON ACCOUNT_
* NPI _PERSON ACCOUNT_
** triggers creation of Healthcare Provider NPI record and task (if necessary) as described ...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-370 (Sprint 3)

**Summary**: Generic Error Logger for Application Errors

**Tech Stack**: Apex

**Solution Preview**: Create a Custom Object {{Error_Log__c}}

Enhance the utility class to create the error debugger.

Going forward all IP will utilize the custom error class for logging error.

Update all existing IPs with the error class

Clinician_NPICheckIP
Clinicia...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-332 (Sprint 3)

**Summary**: Automatically Assign the "Portal User" Permission Set

**Tech Stack**: Apex, Flow

**Solution Preview**: Utilize a record triggered flow for User Object to update the Permission Set

Criteria: Check for the Contact record Type is Clinician that is related to the user....

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-235 (Sprint 3)

**Summary**: CDC Channel

**Tech Stack**: Apex

**Solution Preview**: Custom CDC Name: ContractTrigger

Filter: Status= Execute OR Start_Admin_Work_Ahead_of_Clinical_Work__c = true

Document unit testing

QA testing done in coordination with Mulesoft team OR test via postman...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-622 (Sprint 4)

**Summary**: Clinician Onboarding Record Automation - SCP Onboarding - Child Cases (Manually Triggered)

**Tech Stack**: Apex

**Solution Preview**: * CET: Clinician Experience Team, supports Clinician once contract is complete. 
* need story 210 to test auto trigger of cases - Contract status is equal to “Executed”
* _clinician onboarding sheet_ - [https://docs.google.com/spreadsheets/d/1YC9vi1-...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-621 (Sprint 4)

**Summary**: Clinician Onboarding Record Automation - Facility Onboarding - Child Cases (Manually Triggered)

**Tech Stack**: Apex, Flow

**Solution Preview**: * CET: Clinician Experience Team, supports Clinician once contract is complete.
* need story 210 to test auto trigger of cases - Contract status is equal to “Executed”
* _clinician onboarding sheet_ - [https://docs.google.com/spreadsheets/d/1YC9vi1-h...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-610 (Sprint 4)

**Summary**: Clinician Onboarding Record Automation - Facility Onboarding - Parent (Manually Triggered)

**Tech Stack**: Apex, Flow

**Solution Preview**: * CET: Clinician Experience Team, supports Clinician once contract is complete. 
* need story 210 to test auto trigger of cases - Contract status is equal to “Executed”
* _clinician onboarding sheet_ - [https://docs.google.com/spreadsheets/d/1YC9vi1-...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-572 (Sprint 4)

**Summary**: Agreement Request - Email Alert

**Tech Stack**: Apex, Flow

**Solution Preview**: create two roles as specified in security matrix

Create a record triggered flow to look for searching the Role and get the all Users associated to the Role  Client Contracting, VP Sales Operations and send out the email using *Email Alert*.

*Trigge...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-562 (Sprint 4)

**Summary**: Clinician Onboarding Record Automation - SCP Onboarding - Parent (Manually Triggered)

**Tech Stack**: Apex

**Solution Preview**: * CET: Clinician Experience Team, supports Clinician once contract is complete.
* need story 210 to test auto trigger of cases - Contract status is equal to “Executed”
* _clinician onboarding sheet_ - [https://docs.google.com/spreadsheets/d/1YC9vi1-h...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-473 (Sprint 4)

**Summary**: Automatically Create Healthcare Provider & Healthcare Payer Network Records

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Record Triggered Flow for new Record Creation running in System Mode to auto create the records

Update *Permission Sets* for the Healthcare Provider & Healthcare Payer Network objects per Security Matrix:

* System Administrator
** Healthca...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-852 (Sprint 5)

**Summary**: Intake Form Automation - Closed

**Tech Stack**: Apex, Flow

**Solution Preview**: When user update the Declined Reason field on an ATS Applicant record to *Applicant Declined or SCP Declined*

Use a same Record Triggered Flow for Update on Object ATS Applicant built for [https://salesforce.atlassian.net/browse/PR1050558-615|https:...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-811 (Sprint 5)

**Summary**: Automatically Provision HC Portal Access

**Tech Stack**: Apex, Flow, REST

**Solution Preview**: Use a Record Triggered Flow for Update on Object *ATS Applicant*

Flow need to run with the User Permission not System Permission

* First Search for User Record exist if it exist EXIT the Flow
** bpats__ATS_Applicant__c.bpats__ATS_Applicant__c
* If ...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-702 (Sprint 5)

**Summary**: Clinician Contract Executed Automation (Field Creation)

**Tech Stack**: Apex, Flow

**Solution Preview**: Create the fields “Lastest Contract Signed Date” and “Anticipated Termination Date” in Object “Healthcare Practioner Facility” as per the DD.

Build a record triggered flow which is executed when Contract status is set to Executed. Query all related ...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-615 (Sprint 5)

**Summary**: Intake Form Automation - Send

**Tech Stack**: Apex, Flow

**Solution Preview**: *When I update the ATS Stage field on an ATS Applicant record to Awaiting Intake Form*

Use a Record Triggered Flow for Update on Object ATS Applicant,  Field = ATS Stage, Value = Awaiting Intake Form

* Search for Case Record with RT = *Clinician In...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-246 (Sprint 5)

**Summary**: Risk Review Approvals - Submit

**Tech Stack**: Apex, Flow

**Solution Preview**: When the SR is Created immediately  use the a Record-Triggered Flow Approval Process to launch the approval process

[https://help.salesforce.com/s/articleView?id=platform.automate_automated_approvals_concepts_type.htm&type=5|https://help.salesforce....

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1589 (Sprint 6)

**Summary**: Platform Event - First Scheduled Date

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Even Name = HPFUpdates

Fields

# HPFId = HealthcarePractitionerFacility.Id
# GlobalProviderId = HealthcarePractitionerFacility.PractitionerId.Global_Provider_ID__pc
# GlobalFacilityId = HealthcarePractitionerFacility.AccountId.Glob...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1364 (Sprint 6)

**Summary**: Clinician Onboarding Record Automation - SCP Onboarding - Update Case Owner for Parent & Child Cases

**Tech Stack**: Apex

**Solution Preview**: * CET: Clinician Experience Team, supports Clinician once contract is complete.
* _clinician onboarding sheet_ - [https://docs.google.com/spreadsheets/d/1YC9vi1-hRUZfYPY3doZwSIxczV2HtMeLl6jcUrI-qKY/edit?usp=sharing|https://docs.google.com/spreadsheet...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1256 (Sprint 6)

**Summary**: Contract Selection During Manually Initiated Onboarding

**Tech Stack**: Apex

**Solution Preview**: Initiate Early Onboarding is triggered from OS ClinicianManualOnboardingOS. From what I found current DM only queries Prospect status (this is the ONLY change). We need to add other Status (*_New, Draft, Submitted, or Approved_*)

!Captura de pantall...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-823 (Sprint 6)

**Summary**: Create HPF from Job

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a record triggered flow 

Check if there is a HPF already associated ATS Applicant (bpats_ATS_Applicant_c.Id = HealthcarePractitionerFacility.Job_Applicant__c)

If Exists do Nothing

If Not then Create a HPF record based on mapping in AC...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-702 (Sprint 6)

**Summary**: Clinician Contract Executed Automation (Field Creation)

**Tech Stack**: Apex, Flow

**Solution Preview**: Create the fields “Lastest Contract Signed Date” and “Anticipated Termination Date” in Object “Healthcare Practioner Facility” as per the DD.

Build a record triggered flow which is executed when Contract status is set to Executed. Query all related ...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-2011 (Sprint 7)

**Summary**: Automated Onboarding Task Record Closure: Facility Onboarding

**Tech Stack**: Apex, Flow

**Solution Preview**: Create/reuse record trigger flow on HPP. Look for the Case using the Case.HpfhealthcarePractitionerId  and then look for the task using CaseId and subject. 
Update Task status to Completed according to the field updates provided. 

* Testing: ok to u...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1789 (Sprint 7)

**Summary**: Automatically Provision HC Portal Access: Update ATS Stage

**Tech Stack**: Apex, Flow, REST

**Solution Preview**: Use a Record Triggered Flow for Update on Object *ATS Applicant*

Flow need to run with the User Permission not System Permission

* First Search for User Record exist if it exist EXIT the Flow
** bpats__ATS_Applicant__c.bpats__ATS_Applicant__c
* If ...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1772 (Sprint 7)

**Summary**: CDC Channel: Update ContractTrigger

**Tech Stack**: Apex

**Solution Preview**: Custom CDC Name: ContractTrigger

Filter: Status= Execute -OR Start_Admin_Work_Ahead_of_Clinical_Work__c = true-

Document unit testing

QA testing done in coordination with Mulesoft team OR test via postman...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1719 (Sprint 7)

**Summary**: Healthcare Practitioner Facility Status Automation

**Tech Stack**: Apex, Flow

**Solution Preview**: Record triggered flow on HPF, with the following conditional updates

IF HPF.Contract_Status = “Executed”    THEN  HPF.Status = Candidate
IF HPF.Hospital_Application_Sent_Date__c is populated (blank to value) THEN HPF.Credentialling_Status__c = Pendi...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1718 (Sprint 7)

**Summary**: Clinician Contract Management

**Tech Stack**: Apex, Flow

**Solution Preview**: *Duplicate Executed Contract with Same Employment Type*
  Record triggered flow on Contract, when Contract is -created- updated, query for other contracts (of record type = Contract) with the same employee Type, for the Clinician and check the status...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1589 (Sprint 7)

**Summary**: Platform Event - First Scheduled Date

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Even Name = HPFUpdates

Fields

# HPFId = HealthcarePractitionerFacility.Id
# GlobalProviderId = HealthcarePractitionerFacility.PractitionerId.Global_Provider_ID__pc
# GlobalFacilityId = HealthcarePractitionerFacility.AccountId.Glob...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1369 (Sprint 7)

**Summary**: Automatic Corporate Entity Association at HPF Create

**Tech Stack**: Apex, Flow

**Solution Preview**: {color:#bf2600}Need to fix the logic on {color}[https://salesforce.atlassian.net/browse/PR1050558-1070|https://salesforce.atlassian.net/browse/PR1050558-1070|smart-link]{color:#bf2600}  to pull the Healthcare Payer network from Corporate entity inste...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1256 (Sprint 7)

**Summary**: Contract Selection During Manually Initiated Onboarding

**Tech Stack**: Apex

**Solution Preview**: Initiate Early Onboarding is triggered from OS ClinicianManualOnboardingOS. From what I found current DM only queries Prospect status (this is the ONLY change). We need to add other Status (*_New, Draft, Submitted, or Approved_*)

!Captura de pantall...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1168 (Sprint 7)

**Summary**: Risk Review - Auto Inactivate HPFs when denied

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow on Case of Record Type : Risk Review where Closed_Reason__c was updated to ‘Not approved' , then query the related HPF record (using Healthcare_Practitioner_Facility__c) and update the  HPF.Status__c to 'Inactive’
Create a Task,...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-823 (Sprint 7)

**Summary**: Create HPF from Job

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a record triggered flow 

Check if there is a HPF already associated ATS Applicant (bpats_ATS_Applicant_c.Id = HealthcarePractitionerFacility.Job_Applicant__c)

If Exists do Nothing

If Not then Create a HPF record based on mapping in AC...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-810 (Sprint 7)

**Summary**: Automatically Create Healthcare Provider Records - Client

**Tech Stack**: Apex, Flow

**Solution Preview**: this requirement came from creating Provider Network Contract for client contracts

Create a record trigger flow to create the Healthcare Provider object as mentioned....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-620 (Sprint 7)

**Summary**: Automated Onboarding Case Record Closure

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a record triggered flow (reuse existing flow if possible) on Task
When task status is updated to ‘Completed’, and the related Case is of record type “*Clinician Onboarding*” ( and its a parent case)
Get all child tasks of the Case and check if th...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-619 (Sprint 7)

**Summary**: Automated Onboarding Record Creation (When Contract is Executed)

**Tech Stack**: Apex, Flow

**Solution Preview**: Use a record triggered flow and reuse the existing Child Case Creation Flow

* When the Clinician Contract Status changes to Executed Search for Query HPF Record with Status = Prospect or Candidate with below criteria 
** Contract > ProviderNetworkCo...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-559 (Sprint 7)

**Summary**: Automated Onboarding Task Creation - SCP Onboarding

**Tech Stack**: Apex, Flow

**Solution Preview**: Create Decision Matrix that has the following columns
Name: Task Creation Decision
CaseSubject (Input, Text)
TaskSubject(Output, Text)
RelatedToType (Output, Text)
RelatedTo (output, Text)
AssignedToType (Output, Text)
AssignedTo (Output, Text)
Recor...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-301 (Sprint 7)

**Summary**: Clinician Agreement Approval Process: Mismatch & Tactical

**Tech Stack**: Apex, Flow

**Solution Preview**: Add a button *Submit Contract Request* in Contract page and display the button when Contract.Status = Draft and Contract.RecordType = Clinician



h2. *Use Autolaunched Orchestrator (no trigger) Approval Flow process* 

*Step 1:*  

# *IF Contract.Re...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-247 (Sprint 7)

**Summary**: Automated Onboarding Task Creation - Facility Onboarding

**Tech Stack**: Apex, Flow

**Solution Preview**: Create Decision Matrix that has the following columns
Name: Task Creation Decision
CaseSubject (Input, Text)
TaskSubject(Output, Text)
RelatedToType (Output, Text)
RelatedTo (output, Text)
AssignedToType (Output, Text)
AssignedTo (Output, Text)
Recor...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2208 (Sprint 8)

**Summary**: HPF Inactive Date Trigger to Qgenda

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Even Name = HPFUpdates

Fields

# HPFId = [HealthcarePractitionerFacility.Id|http://HealthcarePractitionerFacility.Id]
# GlobalProviderId = HealthcarePractitionerFacility.PractitionerId.Global_Provider_ID__pc
# GlobalFacilityId = He...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2182 (Sprint 8)

**Summary**: Enable Integration to Workday for SCP Offboarding - 1 of 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Event 

*  Name: Clinician Offboarding Request (Use same API name in Story - Integration Dependency)
** API Name: Clinician_Offboarding_Request__c
* Fields
** Type: Type__c, Text(200)
** Business Entity Name: Business_Entity_Name__c...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2137 (Sprint 8)

**Summary**: Auto Create Client Contract (Practice Operations)

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Record Triggered Flow in Pro_Forma_Model__c Object 

Event: When a Record is Updated to the Status__c = Approved for Contracting

Create Contract Records 

Query all Opportunity Service Record(s) for the  Opportunity 

Services__c.Opportunit...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2119 (Sprint 8)

**Summary**: New HPF for Already Active Clinicians

**Tech Stack**: Apex, Flow

**Solution Preview**: New fields to be created: Certificate of Insurance Start, Certificate of Insurance Expiration, and Insurance Provided By, {color:#ff991f}Hospital Privilege Expiration Date {color}
FSL : MSL persona 

Record triggered flow on HPF (new record creation)...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1798 (Sprint 8)

**Summary**: Client Needs Questionnaire - Auto Task Creation for Internal Info Due Process

**Tech Stack**: Apex, Flow

**Solution Preview**: Enable Activity for Service__c Object 

!image-20250821-215257.png|width=359,height=143,alt="image-20250821-215257.png"!



* Add new value for “Type” for the Task object (RT: Default)
* Story covers this part of the future state:

!image-20250813-20...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1772 (Sprint 8)

**Summary**: CDC Channel: Update ContractTrigger

**Tech Stack**: Apex

**Solution Preview**: Custom CDC Name: ContractTrigger

Filter: Status= Execute -OR Start_Admin_Work_Ahead_of_Clinical_Work__c = true-

Document unit testing

QA testing done in coordination with Mulesoft team OR test via postman...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1733 (Sprint 8)

**Summary**: Offboarding Tasks - SCP

**Tech Stack**: Apex, Flow

**Solution Preview**: Create/Reuse Record triggered flow on Case when case is created
condition : when Case record type if offboarding 
Based on the case subject, create tasks (as mentioned in the sheet)

Use the decision matrix that was created as part of story (PR105055...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1728 (Sprint 8)

**Summary**: Offboarding Tasks - Facility Specific

**Tech Stack**: Apex, Flow

**Solution Preview**: Create/Reuse Record triggered flow on Case when case is created
condition : when Case record type if offboarding 
Based on the case subject, create tasks (as mentioned in the sheet)

Use the decision matrix that was created as part of story (PR105055...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1722 (Sprint 8)

**Summary**: Executed Contract: Automate Task Creation for Locums

**Tech Stack**: Apex, Flow

**Solution Preview**: Use existing record triggered flow on Contract
When status = Executed and  Contract > Employee Type = Locum 
For each of the HPF, create task with details given above.
Use Decisio matric for task if needed...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1720 (Sprint 8)

**Summary**: Intake Form: Automated Task Creation to Review Corporation and Tax Info

**Tech Stack**: Apex, Flow

**Solution Preview**: Record triggered flow on Intake form, where Employment Type = Independent Contractor and Status does not equal Inactive, create a task with the details mentioned above.
Subject = Review Corporation and Tax Information

* Record Type = Default
* Assig...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1717 (Sprint 8)

**Summary**: Healthcare Practitioner Facility Management

**Tech Stack**: Apex, Flow

**Solution Preview**: Record triggered flow on HPF update (when status is made Active)
Query for other HPF for the current HPF’s Clinician Account (PractitionerId) and Service Account (AccountId)

If any of them are active, and having the same Employment Type, check for b...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1589 (Sprint 8)

**Summary**: Platform Event - First Scheduled Date

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Even Name = HPFUpdates

Fields

# HPFId = HealthcarePractitionerFacility.Id
# GlobalProviderId = HealthcarePractitionerFacility.PractitionerId.Global_Provider_ID__pc
# GlobalFacilityId = HealthcarePractitionerFacility.AccountId.Glob...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1369 (Sprint 8)

**Summary**: Automatic Corporate Entity Association at HPF Create

**Tech Stack**: Apex, Flow

**Solution Preview**: {color:#bf2600}Need to fix the logic on {color}[https://salesforce.atlassian.net/browse/PR1050558-1070|https://salesforce.atlassian.net/browse/PR1050558-1070|smart-link]{color:#bf2600}  to pull the Healthcare Payer network from Corporate entity inste...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-810 (Sprint 8)

**Summary**: Automatically Create Healthcare Provider Records - Client

**Tech Stack**: Apex, Flow

**Solution Preview**: this requirement came from creating Provider Network Contract for client contracts

Create a record trigger flow to create the Healthcare Provider object as mentioned....

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2830 (Sprint 9)

**Summary**: Integration Platform Event: Re-Trigger Integration

**Tech Stack**: Apex, Flow

**Solution Preview**: Integration_Log__c.Status__c 

Picklist Value

* Delete: Pending, In Progress, Retried
* Add New Values: Retry

Create new Platform Event: Retry Integration Exception

* Platform Event Fields, Name = Retry_Integration_Exception__c
** IntegrationLogId...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2673 (Sprint 9)

**Summary**: Military Status Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: These are manual changes.
Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Military Status Change

Add the fields mentioned below to layout and LRP.

* Subject = Military Status change for <Clinician> (system to set u...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2672 (Sprint 9)

**Summary**: Business Entity Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Business Entity Change

Add the fields mentioned below to layout and LRP.

* Subject =  Business Entity change for <Clinician> (system to set upon save)
* Description =...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2670 (Sprint 9)

**Summary**: Clinician Name Change Requests

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a new Record type of Case: Clinician Change
Add picklist option to Type  : Name Change

Add the fields mentioned below to layout and LRP.

* Subject = Clinician Name change for <Clinician> (system to set upon save)
* Description = <user insert...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2623 (Sprint 9)

**Summary**: Notification to Workday for First Clinical Shift Change

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow on HPF on update, when First Clinican Shift is updated/changed

Send email to the receipient mentioned above, with the details mentioned.
If there is an existing custom metadata object that holds emails, please use that....

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2593 (Sprint 9)

**Summary**: Clinician Contract Request: Contract Changes - Cloning updates (Bonus Rates & Initial Effective Date

**Tech Stack**: Apex, Validation Rule

**Solution Preview**: Trigger : Contract Request OS > Start from Previous active contract
Condition : If executed contract already exists,
Clone Functionality : 
Query the Contract, PractitionerNetworkContract, PreventiveCareAgreement, Contract Payment Agreement. EXCEPT :...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2558 (Sprint 9)

**Summary**: Clinician Contract Date Alignment

**Tech Stack**: Apex, Flow

**Solution Preview**: Record Triggered Flow on Contract, When a new Contract is Executed, and there is an existing contract that is executed,
If Contract.CompanySignedDate >= Contract.StartDate
If Existing Active Contract. End Date is populated and Employment Type of old ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2462 (Sprint 9)

**Summary**: Enable Integration to Workday for SCP Offboarding - 2 of 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Event 

*  Name: Clinician Offboarding Request (Use same API name in Story - Integration Dependency)
** API Name: Clinician_Offboarding_Request__c
* Fields
** Type: Type__c, Text(200)
** Business Entity Name: Business_Entity_Name__c...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2418 (Sprint 9)

**Summary**: Insurance Provided By Validation Rule

**Tech Stack**: Apex, Flow, Validation Rule

**Solution Preview**: Create new field Insurance Provided By on HPF. Add to layout.

Add a row to existing Custom Metadata, to capture the table of Facility title and Insurance provided by.
When HPF is created ( using flow trigger),
Use the custom metadata, to auto-popula...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2182 (Sprint 9)

**Summary**: Enable Integration to Workday for SCP Offboarding - 1 of 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Platform Event 

*  Name: Clinician Offboarding Request (Use same API name in Story - Integration Dependency)
** API Name: Clinician_Offboarding_Request__c
* Fields
** Type: Type__c, Text(200)
** Business Entity Name: Business_Entity_Name__c...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2137 (Sprint 9)

**Summary**: Auto Create Client Contract (Practice Operations)

**Tech Stack**: Apex, Flow

**Solution Preview**: Create a Record Triggered Flow in Pro_Forma_Model__c Object 

Event: When a Record is Updated to the Status__c = Approved for Contracting

Create Contract Records 

Query all Opportunity Service Record(s) for the  Opportunity 

Services__c.Opportunit...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2119 (Sprint 9)

**Summary**: New HPF for Already Active Clinicians

**Tech Stack**: Apex, Flow

**Solution Preview**: New fields to be created: Certificate of Insurance Start, Certificate of Insurance Expiration, and Insurance Provided By, {color:#ff991f}Hospital Privilege Expiration Date {color}
FSL : MSL persona 

Record triggered flow on HPF (new record creation)...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1798 (Sprint 9)

**Summary**: Client Needs Questionnaire - Auto Task Creation for Internal Info Due Process

**Tech Stack**: Apex, Flow

**Solution Preview**: Enable Activity for Service__c Object 

!image-20250821-215257.png|width=359,height=143,alt="image-20250821-215257.png"!



* Add new value for “Type” for the Task object (RT: Default)
* Story covers this part of the future state:

!image-20250813-20...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1733 (Sprint 9)

**Summary**: Offboarding Tasks - SCP

**Tech Stack**: Apex, Flow

**Solution Preview**: Create/Reuse Record triggered flow on Case when case is created
condition : when Case record type if offboarding 
Based on the case subject, create tasks (as mentioned in the sheet)

Use the decision matrix that was created as part of story (PR105055...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1728 (Sprint 9)

**Summary**: Offboarding Tasks - Facility Specific

**Tech Stack**: Apex, Flow

**Solution Preview**: Create/Reuse Record triggered flow on Case when case is created
condition : when Case record type if offboarding 
Based on the case subject, create tasks (as mentioned in the sheet)

Use the decision matrix that was created as part of story (PR105055...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1722 (Sprint 9)

**Summary**: Executed Contract: Automate Task Creation for Locums

**Tech Stack**: Apex, Flow

**Solution Preview**: Use existing record triggered flow on Contract
When status = Executed and  Contract > Employee Type = Locum 
For each of the HPF, create task with details given above.
Use Decisio matric for task if needed...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1720 (Sprint 9)

**Summary**: Intake Form: Automated Task Creation to Review Corporation and Tax Info

**Tech Stack**: Apex, Flow

**Solution Preview**: Record triggered flow on Intake form, where Employment Type = Independent Contractor and Status does not equal Inactive, create a task with the details mentioned above.
Subject = Review Corporation and Tax Information

* Record Type = Default
* Assig...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1677 (Sprint 9)

**Summary**: Automatically Update the Opportunity Status

**Tech Stack**: Apex, Flow

**Solution Preview**: * Record Triggered flow...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-842 (Sprint 9)

**Summary**: IT Support Ticket

**Tech Stack**: Apex, Flow

**Solution Preview**: Ensure IT Support Queue exists, if not create one for Case object.
Add IT Support to Case.Type  if it does not exist
Create Global Action - Create record - Case. Record Type : Support
Use Before trigger flow on Case, to check the Type = IT Support an...

*Full Solution: See Sprint 9 HTML file*

---

### Flow Automation (154 stories)

#### PR1050558-2947 (Sprint 10)

**Summary**: Clinician Contract Request: Contract Roll up of "Anticipated Clinical Hours"

**Tech Stack**: Flow

**Solution Preview**: Contract.Anticipated Clinical Hours 
Flow on HPF - when the No of hours anticipated to work, is edited/populated,
Get all the PNCs and HPF via the Contract and calculate the sum of No of hours anticipated , and add to Contract.Anticipated Hours. 

{c...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2928 (Sprint 10)

**Summary**: Clinician Contract Date Alignment - No Employment Type Change

**Tech Stack**: Flow

**Solution Preview**: [^Clinician-LDD-Integration - Contract Date and Status Update.pdf]

(CompanySignedDate < StartDate)

Scheduled Flow on Clinician Contract, where Executed and StartDate = TODAY,  (new contract)
and If there is an existing contract (Old contract) of th...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2815 (Sprint 10)

**Summary**: Notification for Employment Type Changes

**Tech Stack**: Flow

**Solution Preview**: # [See Onboarding Scenarios |https://docs.google.com/spreadsheets/d/1-OKSaLgsop5bWkGbMPjIVo2Ru6du-HTr/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true] The Salesforce team will review and provide an update on status of these items.
## C...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2785 (Sprint 10)

**Summary**: NP/PA Tier Management: Clinician 2 of 2

**Tech Stack**: Flow

**Solution Preview**: As part of the existing Clinician Contract submit request OS,
*non full time employee NP/PA clinician* // Clinician Prof title = NP or PA (Code Set Shift Type = NP/PA), Contract.Employment_Type__c = Employee and Contract.Time_Type__C != full time
In ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2678 (Sprint 10)

**Summary**: Facility Term: Date of Client Termination Triggers Auto Clinician Offboarding Process

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow Name - PNC Scheduled FLow
-Scheduled Flow or Batch job-
Query for PNC records where Termination Date = TODAY
NOTE: PNC contains HPF (which contains Practitioner/Clinician and Service Account) and Clinician Contract,
Query for PNC where...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2473 (Sprint 10)

**Summary**: Clinician Offboarding: Termination Updates

**Tech Stack**: Flow

**Solution Preview**: Updating of the newly created Offboarding Decision is manual by the user

Use one of the existing flow on Case , Record update flow
Filter for offboarding case record type, where case type = SCP,
If Offboarding Decision is updated to “No longer Exiti...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2421 (Sprint 10)

**Summary**: Automated Case Record Closure: Offboarding

**Tech Stack**: Flow

**Solution Preview**: reuse automation already built to close onboarding cases.
Check if existing logic works for this scenario as well. If not, 
Flow on task, 
status updated to closed , where WhatId = Case (of recordtype Clinician Offboarding)
check for any open tasks f...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1726 (Sprint 10)

**Summary**: Inactivation Alert Automated Email

**Tech Stack**: Flow

**Solution Preview**: Create report on HPF, with the fields mentioned and filter on Status = Inactive and Termination Date = YESTERDAY. Group report by Service account and sorted by practitioner name.
Flow : 
Object: HPF  
Query for HPF where status = inactive. If there a...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1028 (Sprint 10)

**Summary**: Intake Form Automation - Send Reminder after 3 days

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow on Assessment Envelope Record
Filter for Status = in progress, Today = CreatedDate + 3 ( 3 days since the intake form was assigned to the Clincian), and bpats__ATS_Applicant__c.ATS_stage = ' Awaiting intake form'
and Assessment record ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-199 (Sprint 10)

**Summary**: Guided Screening Call Field Updates

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Create a guided screen flow / omniscript with multiple screens. Create a 
one screen per section mentioned above
Create screen fields of the type mentioned on the AC. They get mapped to the - to be created new fields on ATS Applicant object. (To be a...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3623 (Sprint 11)

**Summary**: UAT Bug: C&CUAT19 EE NPPA rate fields are populated on a Contract Record for an IC Physician

**Tech Stack**: Flow, REST

**Solution Preview**: Restrict the flow built as part of ([https://salesforce.atlassian.net/browse/PR1050558-2785|https://salesforce.atlassian.net/browse/PR1050558-2785|smart-link] ) that updates below fields restricted only to *Code Set Sub Type*=Employee AND *Shift Type...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3570 (Sprint 11)

**Summary**: SIT: C&CSIT05 Post risk review_ Close Out Genda_No Event is being sent from SF HC

**Tech Stack**: Flow

**Solution Preview**: Need to update the flow which sends HPF inactive PE, to send PE only when all HPFs for the Practitioner are inactive
select id, Status__c from HealthcarePractitionerFacility where PractitionerId  = ‘003gP000006jWwLQAU' and Status__c != 'Inactive’ - i...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3384 (Sprint 11)

**Summary**: IC NP/PA Terminate on Anniversary Date

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow on Contract 

Look for Clinician RT: Clinician,  Employee_Type__c = “Independent Contractor” and Contract.EndDate = Today() and Clinician*.*Account.Professional_Title__pc = _NP or PA_


For Each Contract that is expiring today 

Step 1...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2928 (Sprint 11)

**Summary**: Clinician Contract Date Alignment - No Employment Type Change

**Tech Stack**: Flow

**Solution Preview**: [^Clinician-LDD-Integration - Contract Date and Status Update.pdf]

(CompanySignedDate < StartDate)

Scheduled Flow on Clinician Contract, where Executed and StartDate = TODAY,  (new contract)
and If there is an existing contract (Old contract) of th...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2815 (Sprint 11)

**Summary**: Notification for Employment Type Changes

**Tech Stack**: Flow

**Solution Preview**: # [See Onboarding Scenarios |https://docs.google.com/spreadsheets/d/1-OKSaLgsop5bWkGbMPjIVo2Ru6du-HTr/edit?usp=sharing&ouid=107332607889089087961&rtpof=true&sd=true] The Salesforce team will review and provide an update on status of these items.
## C...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2678 (Sprint 11)

**Summary**: Facility Term: Date of Client Termination Triggers Auto Clinician Offboarding Process

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow Name - PNC Scheduled FLow
-Scheduled Flow or Batch job-
Query for PNC records where Termination Date = TODAY
NOTE: PNC contains HPF (which contains Practitioner/Clinician and Service Account) and Clinician Contract,
Query for PNC where...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2638 (Sprint 11)

**Summary**: Facility Term: Offboarding Email

**Tech Stack**: Flow

**Solution Preview**: * New field creation:
** Object = Provider Network Contract
*** ‘Services Sold’ (multi-select) [~accountid:61f8618e8d9e3c00688e380b] can we make this a global picklist, I need it for Letter of Intent and maybe PMT Phase
*** “Client Termination Date” ...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2637 (Sprint 11)

**Summary**: Facility Term: Auto Close Cases

**Tech Stack**: Flow

**Solution Preview**: Check if Flow Close Related Cases is already covering the Case Close if not update the Flow...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-905 (Sprint 11)

**Summary**: SUN Orchestration - Trigger Case Creation

**Tech Stack**: Flow, REST

**Solution Preview**: Add new Case Record Type = Client Onboarding, See DD

* Create fields and layout
* Add new ‘Type’ values for Record Type =  ‘SUN - Preliminary’, ‘SUN - Revision’, or ‘SUN - Final’ 
* Support Process should follow DD ‘Status’ field
* Security Matrix:
...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-317 (Sprint 11)

**Summary**: Facility Term

**Tech Stack**: Flow

**Solution Preview**: Create a button Begin Facility Termination that is visible only in Contract (API Name: Client_Contract) and Conract_Type__c = Master

Button launch as Use a Screen Flow  

New field Case (RT: Client Offboarding): 

* Termination Request Time
* Update...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4191 (Sprint 12)

**Summary**: Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Permission

**Tech Stack**: Flow

**Solution Preview**: AC 1
In the existing Applicant_After_Insert_After_Update_Flow,
//Check if inactive user exists for that Applicant Account.
Get user record where AccountId = Applicant Id ({!$Record.bpats__ATS_Applicant__r.Account.}) and User.IsActive = false.
if reco...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4094 (Sprint 12)

**Summary**: Submit Pro Forma Model for Approval - Send Rejection Email to VP Sales Ops DL

**Tech Stack**: Flow

**Solution Preview**: AC1: Update the DL Email in the Approval Flow

Custom Metadata> Email Address Configuration> *SalesVP*

AC2: Record Page Modification...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3939 (Sprint 12)

**Summary**: UI Enhancement: HC Clinician Portal UI Enhancements

**Tech Stack**: Flow

**Solution Preview**: * Security Matrix - Added App Permission = Run Flows (used to display the Global Provider ID) to the Portal User permission set...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3619 (Sprint 12)

**Summary**: Client Contract Request - Add New Provider Network Contracts

**Tech Stack**: Flow

**Solution Preview**: * Remove the New Button in Provide Network Contract Related List 



* Screen Flow based on Action: Add Provider Network Contract
** Display all the Opportunity Service Records not linked to current Contract PNC 
** -Query: Select Account__r.Name, Ac...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3573 (Sprint 12)

**Summary**: Tech - SSO Flow - Reactivate User & Update Platform Event

**Tech Stack**: Flow

**Solution Preview**: AC 1
In the existing Applicant_After_Insert_After_Update_Flow,
//Check if inactive user exists for that Applicant Account.
Get user record where AccountId = Applicant Id ({!$Record.bpats__ATS_Applicant__r.Account.}) and User.IsActive = false.
if reco...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3520 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Action = Terminate Contract

**Tech Stack**: Flow, Validation Rule

**Solution Preview**: Flow Action in Contract.RT: Terminate Contract

Update: Contract.Status = “Terminated”



Inactivate Validation Rule for Contract: 

* Termination_Reason_not_chosen
* Termination_Date_not_in_future
* Termination_Date_Null
* Termination_Justification_...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3517 (Sprint 12)

**Summary**: SUN Orchestration - Trigger Task Creation

**Tech Stack**: Flow, REST

**Solution Preview**: Action Plan Template for SUN Tasks (built in separate [user story|https://salesforce.atlassian.net/browse/PR1050558-886])

Create the action Buttons in PMT Phase 

# ‘SUN - Preliminary’
# ‘SUN - Revision’
# ‘SUN - Final’

Upon clicking the button che...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3468 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Action = Activate Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action in Contract RT: Letter of Intent

Name: Activate Contract

Contract.ActivatedDate →  Activated Date (Today)

Contract.ActivatedById → Activated By(Current User)

Update Contract Record 



And the system shall locate the *previous contrac...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3467 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Action = Expire Contract

**Tech Stack**: Flow, Formula Field

**Solution Preview**: Flow Action Contract.RT: Letter of Intent

Update all related Contract using the formula field 

* Contract..Ultiamte_Parent_Id__c = CURRENT.Contract.Ultiamte_Parent_Id__c (field build in [https://salesforce.atlassian.net/browse/PR1050558-3521|https:...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3466 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Action = Amend Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action: Amend Contract

UI Inout Element

* Contract.Name → Contract Name: Field Field
* Contract.Description → - Populate with ‘Description’ captured in guided experience

Default setup

* PreviousContractId = CURRENT.Contract.Id
* Contract.Sta...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3465 (Sprint 12)

**Summary**: Client Contract Request - Letter of Intent - Action = Cancel Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action Contract.RT: Letter of Intent

Update: Contract.Status = 'Abandoned’...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3384 (Sprint 12)

**Summary**: IC NP/PA Terminate on Anniversary Date

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow on Contract 

Look for Clinician RT: Clinician,  Employee_Type__c = “Independent Contractor” and Contract.EndDate = Today() and Clinician*.*Account.Professional_Title__pc = _NP or PA_


For Each Contract that is expiring today 

Step 1...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3343 (Sprint 12)

**Summary**: Client Contract Request - Client Contract - Action = Amend Contract

**Tech Stack**: Flow

**Solution Preview**: Create a Action in for Contract RT: Client Contract

Use a Screen Flow:

Get User Input

* Contract Name
* Description



Use a Auto Launched Flow for Clone Contract Creation

Clone the entire Contract 

# Contract.Contract_Type__c = “Master”
## Cont...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3338 (Sprint 12)

**Summary**: Client Onboarding - Create Task based on Service Line

**Tech Stack**: Flow

**Solution Preview**: AC1 Solution: (build on top of [https://salesforce.atlassian.net/browse/PR1050558-1679|https://salesforce.atlassian.net/browse/PR1050558-1679|smart-link] )

# Update the Flow: “PMT Task After Save Flow” to send the PMT Phase → Service Account → Servi...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2638 (Sprint 12)

**Summary**: Facility Term: Offboarding Email

**Tech Stack**: Flow

**Solution Preview**: * New field creation:
** Object = Provider Network Contract
*** ‘Services Sold’ (multi-select) [~accountid:61f8618e8d9e3c00688e380b] can we make this a global picklist, I need it for Letter of Intent and maybe PMT Phase
*** “Client Termination Date” ...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2637 (Sprint 12)

**Summary**: Facility Term: Auto Close Cases

**Tech Stack**: Flow

**Solution Preview**: Check if Flow Close Related Cases is already covering the Case Close if not update the Flow...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-2120 (Sprint 12)

**Summary**: Workday Hire Date Change

**Tech Stack**: Flow

**Solution Preview**: Flow Object : Contract
Condition : When contract is created
Scenario 1: Contract has been created first time for Practitioner

Check if the Contract does not have Hire date populated .

On the updated contract ( when status = executed), get the HPF v...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-905 (Sprint 12)

**Summary**: SUN Orchestration - Trigger Case Creation

**Tech Stack**: Flow, REST

**Solution Preview**: Add new Case Record Type = Client Onboarding, See DD

* Create fields and layout
* Add new ‘Type’ values for Record Type =  ‘SUN - Preliminary’, ‘SUN - Revision’, or ‘SUN - Final’ 
* Support Process should follow DD ‘Status’ field
* Security Matrix:
...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-887 (Sprint 12)

**Summary**: SUN Orchestration - Email Alert

**Tech Stack**: Flow

**Solution Preview**: Query 1: SOQL Select Services_Sold__c, Leased_Employee__c, If_Leased_Employees_Ins_Provided_By__c, Client_Statup_Date__c, Facility_Start_Up_Time__c, Client_Start_Up_Time_Zone__c, ContractId FROM  ProviderNetworkContract WHERE ProviderNetworkContract....

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-317 (Sprint 12)

**Summary**: Facility Term

**Tech Stack**: Flow

**Solution Preview**: Create a button Begin Facility Termination that is visible only in Contract (API Name: Client_Contract) and Conract_Type__c = Master

Button launch as Use a Screen Flow  

New field Case (RT: Client Offboarding): 

* Termination Request Time
* Update...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-5183 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT383 Term Sheet Status not updated appropriately to Not Applicable on Clinicia

**Tech Stack**: Flow

**Solution Preview**: Update the Flow:  Clinician Contract Review Action Handler

When the Status is set to Approved then 

if PreviousContract.Employment_Type__c = Same as Current Contract then Set  *Term Sheet Status* = *‘Not Applicable’ (only for EE and IC)*

if Previo...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5080 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT345 Terming provider in salesforce shows a closed case if the offboarding fai

**Tech Stack**: Flow

**Solution Preview**: *Platform Event Change:*

Add Case Id to Clinician_Offboarding_Request__e [https://salesforce.atlassian.net/browse/PR1050558-4705|https://salesforce.atlassian.net/browse/PR1050558-4705|smart-link] 

# Type = “Employee”
# Employee ID = Case.Contact.Em...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4973 (Sprint 12.1)

**Summary**: Intake Form Criteria Update: Update Logic from HPF to Job

**Tech Stack**: Flow

**Solution Preview**: Update the flow based on above criteria...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4954 (Sprint 12.1)

**Summary**: UAT Enhancement: Clinician Contract - Facility Title Change - HPF Updates to OLD HPF

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Use a scheduled flow and move the complex piece to APEX

AC2: To update Status when new HPF Created is Runtime Flow (Key use he HPF.AccountId) Update the field Process_Previous_HPF_Inactivation__c once the contract is processed in the (final met...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4927 (Sprint 12.1)

**Summary**: UAT Bug: Clinician Offboarding: Termination Updates

**Tech Stack**: Flow

**Solution Preview**: Flow = Case Creation After Flow...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4917 (Sprint 12.1)

**Summary**: UAT Enhancement :Update HPF Contracting Status When Contract is Executed

**Tech Stack**: Flow

**Solution Preview**: Modify the Flow Update the Contract

When Contract.Status = “Executed” 

Set the related HPF in Contract via PNC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4894 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT291 Experience Cloud log in requesting username in error

**Tech Stack**: Flow, Formula Field

**Solution Preview**: Update the Flow that sends the email and the portal field

Use the Contact.Professional_Title__c for Provider to determine MD/DO/NP/PA/RN/LPN

Also check if User.isActive flag is = true 

New User formula field = Display Name...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4856 (Sprint 12.1)

**Summary**: UAT Enhancement : Clinician Contract Approvals

**Tech Stack**: Flow

**Solution Preview**: Merge the NPPA Tier Approval Flow into the Normal Approval flow that has all other approval process 

# Clinician Contract Review Action Handler Flow - Merge the Logic
# Clinician Contract Review Approval Flow - Merge the Logic
# Contract NPPA Mismat...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4839 (Sprint 12.1)

**Summary**: Platform Event Update - Case Creation After Flow

**Tech Stack**: Flow

**Solution Preview**: Case Creation After Flow...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4667 (Sprint 12.1)

**Summary**: UAT Enhancement: EE NPPA Salary Calculation Update part 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Update the Apex in the flow that calculates the $ value based on AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4548 (Sprint 12.1)

**Summary**: On Client Contract upon entering start and end date in Past, an error message is displayed.

**Tech Stack**: Flow

**Solution Preview**: Update the Flow

if start date changed , make sync pnc and contract start date in sync
if end date is not blank in contract, then update the contract end date in pnc.

client , clinical & PO contracts



Fix the Compact Layout and Record Page for Pro...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4536 (Sprint 12.1)

**Summary**: UAT Bug: Update Welcome Clinician Onboarding Email Flow to handle 'Null'

**Tech Stack**: Flow

**Solution Preview**: To Address for the Email should be 

Contract.Email

# Update flow = Welcome Clinician Onboarding Email Flow to handle if Clinician’s email is blank or NULL
# Remove the condition to check if the Clinician Email is NOT present under “Check if CES is ...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4367 (Sprint 12.1)

**Summary**: UAT Enhancement: Update PNC fields = "Client Termination Time" & "Client Start Up Time" to a picklis

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Change the field type to picklist



AC2: Update reference to below fields in Apex, Flow, Omni 

* "Client Termination Time" = Facility_Termination_Time__c
* Client Start Up Time" = Facility_Start_Up_Time__c...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4347 (Sprint 12.1)

**Summary**: UAT Enhancement: Remove Primary Reason Field & Populate Reason for Termination

**Tech Stack**: Flow

**Solution Preview**: Repoint the Field  Case.Primary_Reason__c and use the field Case.Reason_for_Termination__c

Check if the fields Case.Primary_Reason__c is used in Omni Studio Code base like IP, Flex Card etc.

Impacted 

Flow: Case Creation After Flow 

Logic: Update...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4345 (Sprint 12.1)

**Summary**: Client Contract - Action = Amend Contract: not cloning child Contract Types

**Tech Stack**: Flow

**Solution Preview**: Use the correct ParentContractId field in the Amend Contract flow so the system can identify and clone all child contracts properly....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4191 (Sprint 12.1)

**Summary**: Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Permission

**Tech Stack**: Flow

**Solution Preview**: AC 1
In the existing Applicant_After_Insert_After_Update_Flow,
//Check if inactive user exists for that Applicant Account.
Get user record where AccountId = Applicant Id ({!$Record.bpats__ATS_Applicant__r.Account.}) and User.IsActive = false.
if reco...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4094 (Sprint 12.1)

**Summary**: Submit Pro Forma Model for Approval - Send Rejection Email to VP Sales Ops DL

**Tech Stack**: Flow

**Solution Preview**: AC1: Update the DL Email in the Approval Flow

Custom Metadata> Email Address Configuration> *SalesVP*

AC2: Record Page Modification...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4014 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT88 Recruiters need the ability to withdraw a Contract request

**Tech Stack**: Flow

**Solution Preview**: Update the Clinician Contract Approval Flow to perform the update 

NOTE: Steps to view Recall Comments:

# Click on the ‘Approval Submission’ record for the recalled work item
# On the Approval Submission record, click on the Related tab
# Click on ...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3939 (Sprint 12.1)

**Summary**: UI Enhancement: HC Clinician Portal UI Enhancements

**Tech Stack**: Flow

**Solution Preview**: * Security Matrix - Added App Permission = Run Flows (used to display the Global Provider ID) to the Portal User permission set...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3619 (Sprint 12.1)

**Summary**: Client Contract Request - Add New Provider Network Contracts

**Tech Stack**: Flow

**Solution Preview**: * Remove the New Button in Provide Network Contract Related List 



* Screen Flow based on Action: Add Provider Network Contract
** Display all the Opportunity Service Records not linked to current Contract PNC 
** -Query: Select Account__r.Name, Ac...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3573 (Sprint 12.1)

**Summary**: Tech - SSO Flow - Reactivate User & Update Platform Event

**Tech Stack**: Flow

**Solution Preview**: AC 1
In the existing Applicant_After_Insert_After_Update_Flow,
//Check if inactive user exists for that Applicant Account.
Get user record where AccountId = Applicant Id ({!$Record.bpats__ATS_Applicant__r.Account.}) and User.IsActive = false.
if reco...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3520 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Action = Terminate Contract

**Tech Stack**: Flow, Validation Rule

**Solution Preview**: Flow Action in Contract.RT: Terminate Contract

Update: Contract.Status = “Terminated”



Inactivate Validation Rule for Contract: 

* Termination_Reason_not_chosen
* Termination_Date_not_in_future
* Termination_Date_Null
* Termination_Justification_...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3517 (Sprint 12.1)

**Summary**: SUN Orchestration - Trigger Task Creation

**Tech Stack**: Flow, REST

**Solution Preview**: Action Plan Template for SUN Tasks (built in separate [user story|https://salesforce.atlassian.net/browse/PR1050558-886])

Create the action Buttons in PMT Phase 

# ‘SUN - Preliminary’
# ‘SUN - Revision’
# ‘SUN - Final’

Upon clicking the button che...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3468 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Action = Activate Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action in Contract RT: Letter of Intent

Name: Activate Contract

Contract.ActivatedDate →  Activated Date (Today)

Contract.ActivatedById → Activated By(Current User)

Update Contract Record 



And the system shall locate the *previous contrac...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3467 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Action = Expire Contract

**Tech Stack**: Flow, Formula Field

**Solution Preview**: Flow Action Contract.RT: Letter of Intent

Update all related Contract using the formula field 

* Contract..Ultiamte_Parent_Id__c = CURRENT.Contract.Ultiamte_Parent_Id__c (field build in [https://salesforce.atlassian.net/browse/PR1050558-3521|https:...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3466 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Action = Amend Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action: Amend Contract

UI Inout Element

* Contract.Name → Contract Name: Field Field
* Contract.Description → - Populate with ‘Description’ captured in guided experience

Default setup

* PreviousContractId = CURRENT.Contract.Id
* Contract.Sta...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3465 (Sprint 12.1)

**Summary**: Client Contract Request - Letter of Intent - Action = Cancel Contract

**Tech Stack**: Flow

**Solution Preview**: Flow Action Contract.RT: Letter of Intent

Update: Contract.Status = 'Abandoned’...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3384 (Sprint 12.1)

**Summary**: IC NP/PA Terminate on Anniversary Date

**Tech Stack**: Flow

**Solution Preview**: Scheduled Flow on Contract 

Look for Clinician RT: Clinician,  Employee_Type__c = “Independent Contractor” and Contract.EndDate = Today() and Clinician*.*Account.Professional_Title__pc = _NP or PA_


For Each Contract that is expiring today 

Step 1...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3343 (Sprint 12.1)

**Summary**: Client Contract Request - Client Contract - Action = Amend Contract

**Tech Stack**: Flow

**Solution Preview**: Create a Action in for Contract RT: Client Contract

Use a Screen Flow:

Get User Input

* Contract Name
* Description



Use a Auto Launched Flow for Clone Contract Creation

Clone the entire Contract 

# Contract.Contract_Type__c = “Master”
## Cont...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3338 (Sprint 12.1)

**Summary**: Client Onboarding - Create Task based on Service Line

**Tech Stack**: Flow

**Solution Preview**: AC1 Solution: (build on top of [https://salesforce.atlassian.net/browse/PR1050558-1679|https://salesforce.atlassian.net/browse/PR1050558-1679|smart-link] )

# Update the Flow: “PMT Task After Save Flow” to send the PMT Phase → Service Account → Servi...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-2120 (Sprint 12.1)

**Summary**: Workday Hire Date Change

**Tech Stack**: Flow

**Solution Preview**: Flow Object : Contract
Condition : When contract is created
Scenario 1: Contract has been created first time for Practitioner

Check if the Contract does not have Hire date populated .

On the updated contract ( when status = executed), get the HPF v...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-887 (Sprint 12.1)

**Summary**: SUN Orchestration - Email Alert

**Tech Stack**: Flow

**Solution Preview**: Query 1: SOQL Select Services_Sold__c, Leased_Employee__c, If_Leased_Employees_Ins_Provided_By__c, Client_Statup_Date__c, Facility_Start_Up_Time__c, Client_Start_Up_Time_Zone__c, ContractId FROM  ProviderNetworkContract WHERE ProviderNetworkContract....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5391 (Sprint 12.2)

**Summary**: TECH Only Flow Optimization

**Tech Stack**: Flow

**Solution Preview**: Fix Contract_Scheduled_Flow by removing the object from the flow  and creating the conditional record criteria...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5367 (Sprint 12.2)

**Summary**: UAT Bug: C&CUAT426 - UAT1 - Experience Cloud Tracker is invalid

**Tech Stack**: Flow

**Solution Preview**: Per security matrix, setup for an Active Clinician: 

!image-20260202-161411.png|width=1017,alt="image-20260202-161411.png"!

*User License* = 'Customer Community Plus'

*Profile* = ‘Core HC Customer Community Plus User’

*Permission Set Group* = ‘Po...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5346 (Sprint 12.2)

**Summary**: UAT Bug: Prevent Clinician Contract with Same Start Date - Cancel

**Tech Stack**: Flow

**Solution Preview**: Flow: Contract Before Save Flow (Same start date error) should be only relevant when Start Date Change add condition to check start date changed

Flow: Case Creation After Flow (Step Update_Contract) should only update Executed Contract)...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5080 (Sprint 12.2)

**Summary**: UAT Enhancement: C&CUAT345 Terming provider in salesforce shows a closed case if the offboarding fai

**Tech Stack**: Flow

**Solution Preview**: *Platform Event Change:*

Add Case Id to Clinician_Offboarding_Request__e [https://salesforce.atlassian.net/browse/PR1050558-4705|https://salesforce.atlassian.net/browse/PR1050558-4705|smart-link] 

# Type = “Employee”
# Employee ID = Case.Contact.Em...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4973 (Sprint 12.2)

**Summary**: Intake Form Criteria Update: Update Logic from HPF to Job

**Tech Stack**: Flow

**Solution Preview**: Update the flow based on above criteria...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4954 (Sprint 12.2)

**Summary**: UAT Enhancement: Clinician Contract - Facility Title Change - HPF Updates to OLD HPF

**Tech Stack**: Apex, Flow

**Solution Preview**: AC1: Use a scheduled flow and move the complex piece to APEX

AC2: To update Status when new HPF Created is Runtime Flow (Key use he HPF.AccountId) Update the field Process_Previous_HPF_Inactivation__c once the contract is processed in the (final met...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4917 (Sprint 12.2)

**Summary**: UAT Enhancement :Update HPF Contracting Status When Contract is Executed

**Tech Stack**: Flow

**Solution Preview**: Modify the Flow Update the Contract

When Contract.Status = “Executed” 

Set the related HPF in Contract via PNC...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4856 (Sprint 12.2)

**Summary**: UAT Enhancement : Clinician Contract Approvals

**Tech Stack**: Flow

**Solution Preview**: Merge the NPPA Tier Approval Flow into the Normal Approval flow that has all other approval process 

# Clinician Contract Review Action Handler Flow - Merge the Logic
# Clinician Contract Review Approval Flow - Merge the Logic
# Contract NPPA Mismat...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4839 (Sprint 12.2)

**Summary**: Platform Event Update - Case Creation After Flow

**Tech Stack**: Flow

**Solution Preview**: Case Creation After Flow...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4191 (Sprint 12.2)

**Summary**: Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Permission

**Tech Stack**: Flow

**Solution Preview**: AC 1
In the existing Applicant_After_Insert_After_Update_Flow,
//Check if inactive user exists for that Applicant Account.
Get user record where AccountId = Applicant Id ({!$Record.bpats__ATS_Applicant__r.Account.}) and User.IsActive = false.
if reco...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5829 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare133 - Add validation on SCP Case field = Offboarding Decision

**Tech Stack**: Flow

**Solution Preview**: Flow = Case Creation after flow...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5828 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare133 - Add Case History

**Tech Stack**: Flow

**Solution Preview**: Add ‘Related’ tab to layout (where needed, see AC) and within the ‘Related' tab display the Case History related list.

Add Audit fields

3/27 per discussion with Sakthi: For Case RT: Exit Interview, need to update the screen flow = Create Exit Inter...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5617 (Sprint 12.3)

**Summary**: PROD Bug: System is creating duplicate HealthcareProvider records

**Tech Stack**: Flow

**Solution Preview**: Remove the logic for creation of HealthcareProvider record from Healthcare Practitioner Facility After Insert Flow ({{SCP_Healthcare_Practitioner_Facility_After_Insert_Flow.flow-meta.xml}}) and also Account After Insert Flow ({{Account_After_Insert_F...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5456 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare26 Update task Subject = 'Populate the Shift Map & Rates template'

**Tech Stack**: Flow

**Solution Preview**: Modify the flow and change to new queue...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5399 (Sprint 12.3)

**Summary**: TECH Only Flow Optimization - Part 2

**Tech Stack**: Apex, Flow

**Solution Preview**: Moe the same logic to a scheduled batch apex 

the flow need to be decommissioned...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5391 (Sprint 12.3)

**Summary**: TECH Only Flow Optimization

**Tech Stack**: Flow

**Solution Preview**: Fix Contract_Scheduled_Flow by removing the object from the flow  and creating the conditional record criteria...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5220 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT392 Edits needed to: Review Overlapping HPF effective dates , Activity

**Tech Stack**: Flow

**Solution Preview**: Update the flow...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5183 (Sprint 12.3)

**Summary**: UAT Enhancement: C&CUAT383 Term Sheet Status not updated appropriately to Not Applicable on Clinicia

**Tech Stack**: Flow

**Solution Preview**: Update the Flow:  Clinician Contract Review Action Handler

When the Status is set to Approved then 

if PreviousContract.Employment_Type__c = Same as Current Contract then Set  *Term Sheet Status* = *‘Not Applicable’ (only for EE and IC)*

if Previo...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5793 (Sprint 12.4)

**Summary**: PROD Enhancement: UPHypercare269 - Transition Specialist Queue has a column for Name, but values are

**Tech Stack**: Flow

**Solution Preview**: As a Clincian Contacting Specialist I can view a list view of Tasks called “Transition Specialist Queue” that shows the name of Task.WhatID.Case.ContactName

*SOLUTION:*

Update Task creation for tasks “Update Records and Notify Teams” and “Employee ...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5617 (Sprint 12.4)

**Summary**: PROD Bug: System is creating duplicate HealthcareProvider records

**Tech Stack**: Flow

**Solution Preview**: Remove the logic for creation of HealthcareProvider record from Healthcare Practitioner Facility After Insert Flow ({{SCP_Healthcare_Practitioner_Facility_After_Insert_Flow.flow-meta.xml}}) and also Account After Insert Flow ({{Account_After_Insert_F...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5456 (Sprint 12.4)

**Summary**: PROD Enhancement: UPHypercare26 Update task Subject = 'Populate the Shift Map & Rates template'

**Tech Stack**: Flow

**Solution Preview**: Modify the flow and change to new queue...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5183 (Sprint 12.4)

**Summary**: UAT Enhancement: C&CUAT383 Term Sheet Status not updated appropriately to Not Applicable on Clinicia

**Tech Stack**: Flow

**Solution Preview**: Update the Flow:  Clinician Contract Review Action Handler

When the Status is set to Approved then 

if PreviousContract.Employment_Type__c = Same as Current Contract then Set  *Term Sheet Status* = *‘Not Applicable’ (only for EE and IC)*

if Previo...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-6237 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email -- 3 of 3 Platform

**Tech Stack**: Flow

**Solution Preview**: Update Scheduled Path Flow : HPFScheduledPathFlows

Update the Flow to Run only when Facility Title’s (using Code Set) Employment Type = ‘Employee’ or ‘Independent Contractor’ or ‘Partner’...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5914 (Sprint 12.5)

**Summary**: PROD Enhancement: HPF - Updated 'Time Type' picklist value from 'On Call' to 'On-Call'

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Modify the picklsit value On Call to On-Call to make it same like in Qgenda. no new value as the old records in the system need to be  changed as well

Also check in any omniscript or flow that is using this field...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5874 (Sprint 12.5)

**Summary**: PROD Enhancement: Platform Event = HPFUpdate, Type = Rate for HPF - Add Locum

**Tech Stack**: Flow

**Solution Preview**: Update the flow to include Locum 

!image-20260224-180642.png|width=889,alt="image-20260224-180642.png"!



Update the flow to include Locum: Contract_After_Save

!image-20260225-141804.png|width=889,alt="image-20260225-141804.png"!...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5848 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare295 - Update SCP Onboarding Tasks

**Tech Stack**: Flow

**Solution Preview**: +*AC1 -- HR Setup: remove 2 tasks, conditionalize I9 + case creation*+
  Flow 1: {{Case_Creation_After_Insert_Flow}}
  • Add a new Get Records element: query HealthcarePractitionerFacility where:
    • PractitionerId = Clinician's ContactId
    • Emp...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5831 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare287 - Remove Legal Client Contracting from Practice Operations approval

**Tech Stack**: Flow

**Solution Preview**: Update Flow “Client Contract Review Approval Process”

Remove Step 3 Client Contracting Approval 

Ensure the flow from Existing Step 2 Flows to Existing Step 4 after the removal



!image-20260311-122520.png|width=594,alt="image-20260311-122520.png"...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5828 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare133 - Add Case History

**Tech Stack**: Flow

**Solution Preview**: Add ‘Related’ tab to layout (where needed, see AC) and within the ‘Related' tab display the Case History related list.

Add Audit fields

3/27 per discussion with Sakthi: For Case RT: Exit Interview, need to update the screen flow = Create Exit Inter...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5793 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare269 - Transition Specialist Queue has a column for Name, but values are

**Tech Stack**: Flow

**Solution Preview**: As a Clincian Contacting Specialist I can view a list view of Tasks called “Transition Specialist Queue” that shows the name of Task.WhatID.Case.ContactName

*SOLUTION:*

Update Task creation for tasks “Update Records and Notify Teams” and “Employee ...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5693 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare223 - PO Contract Overview not populating

**Tech Stack**: Flow

**Solution Preview**: Update Flow “Clone_Contract” to add the fields in the AC to the “Set New Contract Fields” element


!image-20260225-131741.png|width=620,alt="image-20260225-131741.png"!...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5692 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare221 - Start-up Practice Operations

**Tech Stack**: Flow, Integration Procedure, Formula Field

**Solution Preview**: h3. *AC1: Start New Contract Request*

* User enters *Contract Start Date* and *Description* (required). (first screen - existing functionality)
* When the message _"No previous contract found to perform a change to clone from"_ appears, add a *"Star...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5521 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare68 - Update logic on Contract Status - Contracts with same Start Date a

**Tech Stack**: Flow

**Solution Preview**: Flow: Contract Before Save Flow

Element Position
Start>Update or Create>IsCreate>Check Record Type>IsClinician>GetClinicianContracts…

!image-20260227-133101.png|width=620,alt="image-20260227-133101.png"!


The Get Clinician Contracts Status Matchin...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5917 (Sprint 12.6)

**Summary**: PROD Enhancement: PCA - Updated 'Time Type' picklist value from 'On Call' to 'On-Call'

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Modify the picklsit value On Call to On-Call to make it same like in Qgenda. no new value as the old records in the system need to be  changed as well

Also check in any omniscript or flow that is using this field...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5914 (Sprint 12.6)

**Summary**: PROD Enhancement: HPF - Updated 'Time Type' picklist value from 'On Call' to 'On-Call'

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Modify the picklsit value On Call to On-Call to make it same like in Qgenda. no new value as the old records in the system need to be  changed as well

Also check in any omniscript or flow that is using this field...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5693 (Sprint 12.6)

**Summary**: PROD Enhancement: UPHypercare223 - PO Contract Overview not populating

**Tech Stack**: Flow

**Solution Preview**: Update Flow “Clone_Contract” to add the fields in the AC to the “Set New Contract Fields” element


!image-20260225-131741.png|width=620,alt="image-20260225-131741.png"!...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5521 (Sprint 12.6)

**Summary**: PROD Enhancement: UPHypercare68 - Update logic on Contract Status - Contracts with same Start Date a

**Tech Stack**: Flow

**Solution Preview**: Flow: Contract Before Save Flow

Element Position
Start>Update or Create>IsCreate>Check Record Type>IsClinician>GetClinicianContracts…

!image-20260227-133101.png|width=620,alt="image-20260227-133101.png"!


The Get Clinician Contracts Status Matchin...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-6146 (Sprint 13)

**Summary**: Cloned Clinician Contract - Term Sheet Status field not getting set to Not Applicable

**Tech Stack**: Flow

**Solution Preview**: Not all Contact goes for Approval so the original story solution need to change to 





When the User *Submit the Contract  (Submit Contract Button)*

if PreviousContract.Employment_Type__c = Same as Current Contract then Set  *Term Sheet Status* = ...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6141 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare380 - Clinician Updates to QGenda Credentialing - HC Work

**Tech Stack**: Flow

**Solution Preview**: Platform Event Name:  Clinician Updates

Platform Event Fields:

* HomePhone
* MobilePhone
* Global Provider ID 
* AccountRecordId

When any of the fields is updated



* Create or Reuse a synchronous Brach for Account Record Update Flow
** When the ...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6096 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare380 - Service Account Address Updates to QGenda Credentialing - HC Work

**Tech Stack**: Flow

**Solution Preview**: Platform Event Name:  Account Updates

Platform Event Fields:

* Name
* BillingStreet
* BillingCity
* BillingStateCode
* BillingState
* BillingZipPostalCode
* County
* BillingCountryCode
* BillingCountry
* GlobalFacilityID
* AccountRecordId
* RecordT...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6002 (Sprint 13)

**Summary**: PROD Enhancement: PERMISSIONS – Assessment Object Visibility for Compliance & Data Quality (Unlock E

**Tech Stack**: Flow

**Solution Preview**: Expose Only Record Page Account for Clinician

Create a Flow as Button in Person Account Page that will invoke a Platform Event (Run the Platform Even as System User) 

Consume the Platform Event in a Flow that unlocked the User Records

{color:#ff99...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5831 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare287 - Remove Legal Client Contracting from Practice Operations approval

**Tech Stack**: Flow

**Solution Preview**: Update Flow “Client Contract Review Approval Process”

Remove Step 3 Client Contracting Approval 

Ensure the flow from Existing Step 2 Flows to Existing Step 4 after the removal



!image-20260311-122520.png|width=594,alt="image-20260311-122520.png"...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5828 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare133 - Add Case History

**Tech Stack**: Flow

**Solution Preview**: Add ‘Related’ tab to layout (where needed, see AC) and within the ‘Related' tab display the Case History related list.

Add Audit fields

3/27 per discussion with Sakthi: For Case RT: Exit Interview, need to update the screen flow = Create Exit Inter...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5793 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare269 - Transition Specialist Queue has a column for Name, but values are

**Tech Stack**: Flow

**Solution Preview**: As a Clincian Contacting Specialist I can view a list view of Tasks called “Transition Specialist Queue” that shows the name of Task.WhatID.Case.ContactName

*SOLUTION:*

Update Task creation for tasks “Update Records and Notify Teams” and “Employee ...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5692 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare221 - Start-up Practice Operations

**Tech Stack**: Flow, Integration Procedure, Formula Field

**Solution Preview**: h3. *AC1: Start New Contract Request*

* User enters *Contract Start Date* and *Description* (required). (first screen - existing functionality)
* When the message _"No previous contract found to perform a change to clone from"_ appears, add a *"Star...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6237 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare311 - Remove Locum clinicians from the welcome email -- 3 of 3 Platform

**Tech Stack**: Flow

**Solution Preview**: Update Scheduled Path Flow : HPFScheduledPathFlows

Update the Flow to Run only when Facility Title’s (using Code Set) Employment Type = ‘Employee’ or ‘Independent Contractor’ or ‘Partner’...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6141 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare380 - Clinician Updates to QGenda Credentialing - HC Work

**Tech Stack**: Flow

**Solution Preview**: Platform Event Name:  Clinician Updates

Platform Event Fields:

* HomePhone
* MobilePhone
* Global Provider ID 
* AccountRecordId

When any of the fields is updated



* Create or Reuse a synchronous Brach for Account Record Update Flow
** When the ...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6096 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare380 - Service Account Address Updates to QGenda Credentialing - HC Work

**Tech Stack**: Flow

**Solution Preview**: Platform Event Name:  Account Updates

Platform Event Fields:

* Name
* BillingStreet
* BillingCity
* BillingStateCode
* BillingState
* BillingZipPostalCode
* County
* BillingCountryCode
* BillingCountry
* GlobalFacilityID
* AccountRecordId
* RecordT...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6082 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare403 - Copy CES to on the Welcome to Clinician

**Tech Stack**: Flow

**Solution Preview**: Remove the Functionality from Communities Site welcome email and implement it in the Flow

2 Flows Impacted:

# HPF when the Provider System Status was updated
# When the Contract is executed

!image-20260323-193141.png|width=889,alt="image-20260323-...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6002 (Sprint 14)

**Summary**: PROD Enhancement: PERMISSIONS – Assessment Object Visibility for Compliance & Data Quality (Unlock E

**Tech Stack**: Flow

**Solution Preview**: Expose Only Record Page Account for Clinician

Create a Flow as Button in Person Account Page that will invoke a Platform Event (Run the Platform Even as System User) 

Consume the Platform Event in a Flow that unlocked the User Records

{color:#ff99...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5831 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare287 - Remove Legal Client Contracting from Practice Operations approval

**Tech Stack**: Flow

**Solution Preview**: Update Flow “Client Contract Review Approval Process”

Remove Step 3 Client Contracting Approval 

Ensure the flow from Existing Step 2 Flows to Existing Step 4 after the removal



!image-20260311-122520.png|width=594,alt="image-20260311-122520.png"...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5828 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare133 - Add Case History

**Tech Stack**: Flow

**Solution Preview**: Add ‘Related’ tab to layout (where needed, see AC) and within the ‘Related' tab display the Case History related list.

Add Audit fields

3/27 per discussion with Sakthi: For Case RT: Exit Interview, need to update the screen flow = Create Exit Inter...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5793 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare269 - Transition Specialist Queue has a column for Name, but values are

**Tech Stack**: Flow

**Solution Preview**: As a Clincian Contacting Specialist I can view a list view of Tasks called “Transition Specialist Queue” that shows the name of Task.WhatID.Case.ContactName

*SOLUTION:*

Update Task creation for tasks “Update Records and Notify Teams” and “Employee ...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5708 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare233 - Adjust cloning logic related to entity, when adding or removing H

**Tech Stack**: Flow, Formula Field

**Solution Preview**: *AC1: Start New Request — Move Evaluation to Submit*

  Changes:

# Modify `Clinician_CreateContractAndPNC` (IP):

* Remove the checkCorporateEntityList / contractCorporatingEntity formula logic that pre-populates Contracting_Corporate_Entity__c.
* A...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5692 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare221 - Start-up Practice Operations

**Tech Stack**: Flow, Integration Procedure, Formula Field

**Solution Preview**: h3. *AC1: Start New Contract Request*

* User enters *Contract Start Date* and *Description* (required). (first screen - existing functionality)
* When the message _"No previous contract found to perform a change to clone from"_ appears, add a *"Star...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-123 (Sprint 2)

**Summary**: Guided Create HPF: Clinician Info

**Tech Stack**: Flow

**Solution Preview**: Use a Salesforce Flow

*field mappings*:

* Professional Title _PERSON ACCOUNT_
* Practicing Specialty _HEALTHCARE PROVIDER SPECIALTY - sub specialty field = checked_
* Primary Specialty _HEALTHCARE PROVIDER SPECIALTY - primary board specialty field ...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-219 (Sprint 3)

**Summary**: Clinician Risk Review

**Tech Stack**: Flow, OmniScript, REST

**Solution Preview**: [risk review questions|https://schumachergroup.sharepoint.com/:w:/r/teams/UnifiedPlatform-ReGenesis/_layouts/15/Doc.aspx?sourcedoc=%7B5ED4B28C-6E52-4476-9572-5179882F9CA5%7D&file=Provider%20Risk%20Review%20rev%202-12-25%20for%20Docusign%20template%20...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-822 (Sprint 5)

**Summary**: Enforce Contract to Manually Initiate Onboarding

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Implement using OmniScript as is more powerful than Screen flow and the user story is complex.

In following step change the message as required. 

!Captura de pantalla 2025-07-18 a la(s) 5.43.40 a.m..png|width=761,height=654,alt="Captura de pantalla...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1366 (Sprint 6)

**Summary**: Facility Rate Creation - Add Error Message if no available Shifts

**Tech Stack**: Flow, OmniScript

**Solution Preview**: In OmniScript ServiceAcc/FacilityRateCreation/English add a condition 

When IP FetchShiftAndFacilityTitle returns No Record for Rate Type = Shift then Show

*Please add Shift record(s) to proceed.  To add a Shift, go to the Related tab and click “Ne...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1317 (Sprint 6)

**Summary**: Clinician Contract - Prevent Active EE/IC at the same time

**Tech Stack**: Flow

**Solution Preview**: Use Employment_Type to know if Contract will be IC or EE. 

Query ALL the active Contracts for the given Clinician. Per following Diagram we Query using the Person Account Id in Contract object. 

!Captura de pantalla 2025-07-30 a la(s) 9.20.17 p.m.....

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1240 (Sprint 6)

**Summary**: Clinician Contract Summary UI - Connect Clinician Rate to Facility Rate

**Tech Stack**: Flow

**Solution Preview**: * Data Dictionary: add fields, update layout and fields should be made visible on permission sets that have object access.
** Preventive Care Agreement tab
*** Add Field = Facility Rate, Previous Rate, Facility Level Rate 
**** Permission Sets with v...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-822 (Sprint 6)

**Summary**: Enforce Contract to Manually Initiate Onboarding

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Implement using OmniScript as is more powerful than Screen flow and the user story is complex.

In following step change the message as required. 

!Captura de pantalla 2025-07-18 a la(s) 5.43.40 a.m..png|width=761,height=654,alt="Captura de pantalla...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-821 (Sprint 6)

**Summary**: Risk Review Approvals - Notification to Payroll

**Tech Stack**: Flow

**Solution Preview**: Add Final step to Risk Review Approvals Flow

When the Everyone has Approved in the End of the Flow create the Notification to Payroll Step.

Use custom metadata to store the email Ids to send emails to for avoiding hardcoding

Use the Final Decision...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-299 (Sprint 6)

**Summary**: Clinician Contract Summary UI - Cloned Indicator

**Tech Stack**: Flow

**Solution Preview**: * Data Dictionary: add fields, update layout and fields should be made visible on permission sets that have object access.
** Preventive Care Agreement 
*** Field = Cloned From
**** Permission Sets with visibility to object = Preventive Care Agreemen...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1660 (Sprint 7)

**Summary**: Initiate Clinical Match Process

**Tech Stack**: Flow

**Solution Preview**: * Custom buttom Initiate Clinical Match that launches screen flow with the above mentioned fields and creates Case record. Data mapping per the data dictionary
* Assigned to a queue Clinical Match Queue
* Public group for sharing of this case?
* Add ...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1419 (Sprint 7)

**Summary**: Client Rate Configuration - Cloning and Editing

**Tech Stack**: Flow

**Solution Preview**: *Step 1: Screen Flow*

# Configure a button in Contract Object that launches an Screen Flow
## Button should be visible only for Contract RecordType = “Client”
# Clone the Contract Entire Contract Record with all fields 
## Status = Draft
## Previous...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1317 (Sprint 7)

**Summary**: Clinician Contract - Prevent Active EE/IC at the same time

**Tech Stack**: Flow

**Solution Preview**: Use Employment_Type to know if Contract will be IC or EE. 

Query ALL the active Contracts for the given Clinician. Per following Diagram we Query using the Person Account Id in Contract object. 

!Captura de pantalla 2025-07-30 a la(s) 9.20.17 p.m.....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-309 (Sprint 7)

**Summary**: Open Shift APAY Request

**Tech Stack**: Flow

**Solution Preview**: # Create a button *Open Shift APAY* in HealthcarePractitionerFacility object and add it to the record page  
# Use Screen Flow 
## Contract record: Contract.Status  = ‘Executed’ and Contract.Employment_Type__c = HealthcarePractitionerFacility.Facilit...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2118 (Sprint 8)

**Summary**: Clinician Contract: Auto Populate Contracting Corporate Entity

**Tech Stack**: Flow

**Solution Preview**: Use the flow created in [https://salesforce.atlassian.net/browse/PR1050558-301|https://salesforce.atlassian.net/browse/PR1050558-301|smart-link] 

Use the Guided flow when creating a new HPF to add the Corporate entity value to Contract’s Corporate e...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2108 (Sprint 8)

**Summary**: Error Log: Workday Duplicate Tax ID

**Tech Stack**: Flow

**Solution Preview**: Dependency : Workday has to create error log record with the Type : Integration and error message containing the word “Workday” and the error message specified above.
Create a report on Error log object
Create a conditional subscription to the report...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1727 (Sprint 8)

**Summary**: Offboarding Cases

**Tech Stack**: Flow, OmniScript

**Solution Preview**: As part of the guided offboardidng omniscript, create cases

Check if there are existing Case (of record type = Clinician Offboarding and Type = Facility) for the HPF record.
If NO, then create Case
Subject = "Facility Offboarding-<Account Name>"
Own...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1696 (Sprint 8)

**Summary**: Clinician Contract: Set Start Date

**Tech Stack**: Flow

**Solution Preview**: Add two date fields in the Contract request process, in the Contract selection screen
Start Date (Required), End Date (optional)
In the OS, check if the facility title IS is Nurse Practitioner or Physician Assistant and if End date is not populated, ...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-884 (Sprint 8)

**Summary**: Exit Interview Feedback Capture

**Tech Stack**: Flow

**Solution Preview**: Navigation
Clinician 
    Offboarding  Case(SCP level)
         Exit Interview (Child Task) - Button: Exit Interview
            
This button opens a Screen flow
Check if the user belongs to one (is a member of) of the Case team mentioned above. 
NOT...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-309 (Sprint 8)

**Summary**: Open Shift APAY Request

**Tech Stack**: Flow

**Solution Preview**: # Create a button *Open Shift APAY* in HealthcarePractitionerFacility object and add it to the record page  
# Use Screen Flow 
## Contract record: Contract.Status  = ‘Executed’ and Contract.Employment_Type__c = HealthcarePractitionerFacility.Facilit...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2793 (Sprint 9)

**Summary**: Facility Change Request: Approvals 2 of 2

**Tech Stack**: Flow

**Solution Preview**: * Ensure we can easily update the threshold $ amount to bypass approval step 5U
** Setup a Custom Setting to get the the Threshold Amount
* Use Approval Flow
** In Step 5 Use the Custom Setting to set the Threshold Amount
* Add new fields and update ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2473 (Sprint 9)

**Summary**: Clinician Offboarding: Termination Updates

**Tech Stack**: Flow

**Solution Preview**: Updating of the newly created Offboarding Decision is manual by the user

Use one of the existing flow on Case , Record update flow
Filter for offboarding case record type, where case type = SCP,
If Offboarding Decision is updated to “No longer Exiti...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2421 (Sprint 9)

**Summary**: Automated Case Record Closure: Offboarding

**Tech Stack**: Flow

**Solution Preview**: reuse automation already built to close onboarding cases.
Check if existing logic works for this scenario as well. If not, 
Flow on task, 
status updated to closed , where WhatId = Case (of recordtype Clinician Offboarding)
check for any open tasks f...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2235 (Sprint 9)

**Summary**: NP/PA Tier Management: Clinician 1 of 2

**Tech Stack**: Flow, OmniScript

**Solution Preview**: On the existing, Contract request omniscript - (when a new contract for clinician, it displays HPFs for selection and the Add HPF omniscript). Check if the Employment_Type__c is Employee Time_Type__c is Full time, and clinician Professional_Title__c ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2118 (Sprint 9)

**Summary**: Clinician Contract: Auto Populate Contracting Corporate Entity

**Tech Stack**: Flow

**Solution Preview**: Use the flow created in [https://salesforce.atlassian.net/browse/PR1050558-301|https://salesforce.atlassian.net/browse/PR1050558-301|smart-link] 

Use the Guided flow when creating a new HPF to add the Corporate entity value to Contract’s Corporate e...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1740 (Sprint 9)

**Summary**: Facility Change Request: Approvals

**Tech Stack**: Flow

**Solution Preview**: * Ensure we can easily update the threshold $ amount to bypass approval step 5U
** Setup a Custom Setting to get the the Threshold Amount
* Use Approval Flow
** In Step 5 Use the Custom Setting to set the Threshold Amount
* Add new fields and update ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1727 (Sprint 9)

**Summary**: Offboarding Cases

**Tech Stack**: Flow, OmniScript

**Solution Preview**: As part of the guided offboardidng omniscript, create cases

Check if there are existing Case (of record type = Clinician Offboarding and Type = Facility) for the HPF record.
If NO, then create Case
Subject = "Facility Offboarding-<Account Name>"
Own...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1726 (Sprint 9)

**Summary**: Inactivation Alert Automated Email

**Tech Stack**: Flow

**Solution Preview**: Create report on HPF, with the fields mentioned and filter on Status = Inactive and Termination Date = YESTERDAY. Group report by Service account and sorted by practitioner name.
Flow : 
Object: HPF  
Query for HPF where status = inactive. If there a...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-199 (Sprint 9)

**Summary**: Guided Screening Call Field Updates

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Create a guided screen flow / omniscript with multiple screens. Create a 
one screen per section mentioned above
Create screen fields of the type mentioned on the AC. They get mapped to the - to be created new fields on ATS Applicant object. (To be a...

*Full Solution: See Sprint 9 HTML file*

---

### LWC/Aura Component (59 stories)

#### PR1050558-2675 (Sprint 10)

**Summary**: Case (RT: Clinician Change) & “Data Quality” queue

**Tech Stack**: Not specified

**Solution Preview**: Create list view on Case

* Filter: Case Record Type = Clinician Change, Status ≠ Closed
* Fields to Display: Case Number, Subject, Type, Status, Priority, Owner Name, Date/Time Opened

Create Case page layout/LRP fields as mentioned in DD

* Header
...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2474 (Sprint 10)

**Summary**: Clinician Offboarding: Connect Termination and Clinical Match Processes

**Tech Stack**: LWC, Flow, OmniScript

**Solution Preview**: Existing Screen flow of Initiate Clinical Match
Add a checkbox at the end of the screen?
 *Initiate Termination (help text: If checked, after clinical match you can specify facility specific or SCP termination request)*
If checked, launch the Initiat...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1725 (Sprint 10)

**Summary**: Clinician Support Case

**Tech Stack**: Not specified

**Solution Preview**: Create a new button on Person Account (Clinician)
The button launches a record create action, which has the following elements
Subject: Text box
Description: Long text
Owner : Auto-populate current user 
On submit, Create Case

* Case Record Type = S...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3546 (Sprint 11)

**Summary**: Tech - SSO Flow - Update Portal Login

**Tech Stack**: LWC, Apex

**Solution Preview**: Input text box - email address ( with the placeholder username@scp.com) 
Apex/Logic - to query for user based on email address. 
If user is found and fedId is present, redirect to okta sso url,
If user is found and FedId is not present, display passw...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3389 (Sprint 11)

**Summary**: Client Change Management - Update the Batch job to use Process Type = "Automation"

**Tech Stack**: Apex

**Solution Preview**: Run the Job around 9 PM every day

Change the starting point of the Batch Job from Contract to Client Change Management record. 



# Pick the records from Client_Change_Management__c.Contract.StartDate - 1 <= Today() AND Client_Change_Management__c....

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-2474 (Sprint 11)

**Summary**: Clinician Offboarding: Connect Termination and Clinical Match Processes

**Tech Stack**: LWC, Flow, OmniScript

**Solution Preview**: Existing Screen flow of Initiate Clinical Match
Add a checkbox at the end of the screen?
 *Initiate Termination (help text: If checked, after clinical match you can specify facility specific or SCP termination request)*
If checked, launch the Initiat...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4109 (Sprint 12)

**Summary**: Client Contract -  Update 'child' contract page (Contract Type ≠ Master) & Actions

**Tech Stack**: Not specified

**Solution Preview**: Update the Record Page for Contract.RT = Client Contract

All the changes is handled via Record page by using conditional filters with duplicate components if needed 

*Highlight Panel* → Create 2 highlights panel and show based on Contract.Contract_...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3950 (Sprint 12)

**Summary**: Remove 'Term Sheet Executed' field and Related Components

**Tech Stack**: Not specified

**Solution Preview**: Remove/ Delete the component and button as per AC...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3924 (Sprint 12)

**Summary**: Client Contract Request - Configurations tab - Edit

**Tech Stack**: Not specified

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3546 (Sprint 12)

**Summary**: Tech - SSO Flow - Update Portal Login

**Tech Stack**: LWC, Apex

**Solution Preview**: Input text box - email address ( with the placeholder username@scp.com) 
Apex/Logic - to query for user based on email address. 
If user is found and fedId is present, redirect to okta sso url,
If user is found and FedId is not present, display passw...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3519 (Sprint 12)

**Summary**: Client Contract Request - Configurations tab - View & Delete Configuration

**Tech Stack**: LWC, OmniScript

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3022 (Sprint 12)

**Summary**: Client Contract Request - View Client Contract

**Tech Stack**: Not specified

**Solution Preview**: #  view Provider Network Contract(s) -Service Account(s)- linked to this contract on new tab = “Service Account” (flex card)
## Modify the PNC flex card “DisplayProviderNtwrkContract” based on Contract.RecordType = Client Contract and display the fie...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-479 (Sprint 12)

**Summary**: Submit Pro Forma Model for Approval

**Tech Stack**: Flow, Validation Rule, Formula Field, REST

**Solution Preview**: story [https://salesforce.atlassian.net/browse/PR1050558-1305|https://salesforce.atlassian.net/browse/PR1050558-1305|smart-link]  must be completed first since Pro Forma Model fields must be created/updated for approval thresholds

# Build a Screen F...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-3950 (Sprint 12.1)

**Summary**: Remove 'Term Sheet Executed' field and Related Components

**Tech Stack**: Not specified

**Solution Preview**: Remove/ Delete the component and button as per AC...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3924 (Sprint 12.1)

**Summary**: Client Contract Request - Configurations tab - Edit

**Tech Stack**: Not specified

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3546 (Sprint 12.1)

**Summary**: Tech - SSO Flow - Update Portal Login

**Tech Stack**: LWC, Apex

**Solution Preview**: Input text box - email address ( with the placeholder username@scp.com) 
Apex/Logic - to query for user based on email address. 
If user is found and fedId is present, redirect to okta sso url,
If user is found and FedId is not present, display passw...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3519 (Sprint 12.1)

**Summary**: Client Contract Request - Configurations tab - View & Delete Configuration

**Tech Stack**: LWC, OmniScript

**Solution Preview**: Link to Figma - [https://www.figma.com/proto/ox5QRZi1T0SOd6rnYbDbmE/SCP-Health?node-id=106-10463&p=f&viewport=370%2C-117%2C0.3&t=38DfkTkE53cqseWL-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=106%3A8246&show-proto-sidebar=1|https://...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-3022 (Sprint 12.1)

**Summary**: Client Contract Request - View Client Contract

**Tech Stack**: Not specified

**Solution Preview**: #  view Provider Network Contract(s) -Service Account(s)- linked to this contract on new tab = “Service Account” (flex card)
## Modify the PNC flex card “DisplayProviderNtwrkContract” based on Contract.RecordType = Client Contract and display the fie...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-479 (Sprint 12.1)

**Summary**: Submit Pro Forma Model for Approval

**Tech Stack**: Flow, Validation Rule, Formula Field, REST

**Solution Preview**: story [https://salesforce.atlassian.net/browse/PR1050558-1305|https://salesforce.atlassian.net/browse/PR1050558-1305|smart-link]  must be completed first since Pro Forma Model fields must be created/updated for approval thresholds

# Build a Screen F...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5844 (Sprint 12.5)

**Summary**: PROD Bug: UPHypercare293 - GPID no longer showing at top of screen on Person Account

**Tech Stack**: Not specified

**Solution Preview**: # Users who do not have access to Object: HPF, shall not see just the ‘Active HPF’ section of the component
# Users who do not have access to Object: HealthcareProviderSpecialty, shall not see just the “Specialties” section of the component
## Specia...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5844 (Sprint 12.6)

**Summary**: PROD Bug: UPHypercare293 - GPID no longer showing at top of screen on Person Account

**Tech Stack**: Not specified

**Solution Preview**: # Users who do not have access to Object: HPF, shall not see just the ‘Active HPF’ section of the component
# Users who do not have access to Object: HealthcareProviderSpecialty, shall not see just the “Specialties” section of the component
## Specia...

*Full Solution: See Sprint 12.6 HTML file*

---

#### PR1050558-5863 (Sprint 13)

**Summary**: PROD Enhancement: Send individual HPF Inactivation Email

**Tech Stack**: Apex, Flow

**Solution Preview**: *SOLUTION*

# Update {{HPF_Updates_Triggered_Flow}} -- "Is Inactive" branch
After Assign_PE_instance_for_Inactive_HPF, add:
a) Decision: {{Is_TerminationDate_Populated}}
• Condition: $Record.TerminationDate IsNull = false
• Yes → proceed to Get Accou...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6349 (Sprint 14)

**Summary**: Observation: User is able to add 'Superseded' HPF to clinician contract

**Tech Stack**: Not specified

**Solution Preview**: *Components:* 

DEFetchCPAAndPCARecords - Add filter for “Superseded“ so HPFs are not being retrieve 

DEFetchContractAndPNC - Add filter for “Superseded“ so HPFs are not being retrieve

DRGetFacilityForAddHpf - Add filter for “Superseded“ so HPFs ar...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-6348 (Sprint 14)

**Summary**: Observation: Facility offboarding Guided flow is showing  HPF with status = superseded

**Tech Stack**: Not specified

**Solution Preview**: *Component(s):* 

DRGetHPFRecords - Add filter for “Superseded“ so HPFs are not being retrieve...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-5863 (Sprint 14)

**Summary**: PROD Enhancement: Send individual HPF Inactivation Email

**Tech Stack**: Apex, Flow

**Solution Preview**: *SOLUTION*

# Update {{HPF_Updates_Triggered_Flow}} -- "Is Inactive" branch
After Assign_PE_instance_for_Inactive_HPF, add:
a) Decision: {{Is_TerminationDate_Populated}}
• Condition: $Record.TerminationDate IsNull = false
• Yes → proceed to Get Accou...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-144 (Sprint 2)

**Summary**: Prospect Portal Login & Home

**Tech Stack**: Aura

**Solution Preview**: * Create Portal User permission set from security matrix
* Create a Build Your Own aura site
* Add Record List component to home page
** Layout = Full
** Object Name = Task
** Filter Name = Open Tasks
*** _Create Open Tasks list view with the columns...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-903 (Sprint 5)

**Summary**: Risk Review Approvals - Decision & Views

**Tech Stack**: Apex, Flow

**Solution Preview**: Risk Approval process will be built using Flow Approval process (not Classic approval process), so approval list and history will be shown using enhanced components.

As Approver - following are the options to view list of items needing approval

# -...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-666 (Sprint 5)

**Summary**: Update Guided Create HPF - Board Cert & Medical License

**Tech Stack**: LWC

**Solution Preview**: *  “Medical License”  to display/behave like the standard SF multi-select picklist. Use the LWC built for the Multi-Select (Pick List based LWC)
** same solution as [https://salesforce.atlassian.net/browse/PR1050558-385|https://salesforce.atlassian.n...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-614 (Sprint 5)

**Summary**: Create Account Team Roles

**Tech Stack**: Not specified

**Solution Preview**: create Account Team Roles as specified above

update Account (Service Account) layout with tabs component and related list

Update “Case Owner” field within the Manual Onboarding Case (parent and child) creation process (part of stories: : [https://s...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-210 (Sprint 5)

**Summary**: Clinician Contract Request: Shift Rates

**Tech Stack**: LWC, OmniScript, Integration Procedure

**Solution Preview**: In OmniScript built in user story [https://salesforce.atlassian.net/browse/PR1050558-893|https://salesforce.atlassian.net/browse/PR1050558-893|smart-link] , add a step after facility selection. 

This step should contain customOmniSelect LWC with typ...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1568 (Sprint 6)

**Summary**: Submit Pro Forma Model for Approval - Layout updates

**Tech Stack**: Flow

**Solution Preview**: story [https://salesforce.atlassian.net/browse/PR1050558-1305|https://salesforce.atlassian.net/browse/PR1050558-1305|smart-link]  must be completed first since Pro Forma Model fields must be created/updated for approval thresholds

# Build Autolaunch...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1138 (Sprint 6)

**Summary**: Clinician Contract Request: Leased or Locums - Create/update records

**Tech Stack**: Not specified

**Solution Preview**: A contract is Locum or Leased if the HPF field Employment_Type__c is. 

ContractRequest OS structure is following:

!Captura de pantalla 2025-07-26 a la(s) 1.53.52 p.m..png|width=1108,height=540,alt="Captura de pantalla 2025-07-26 a la(s) 1.53.52 p.m...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1110 (Sprint 6)

**Summary**: Clinician Contract Request: Leadership Incentives

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in Co...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1109 (Sprint 6)

**Summary**: Clinician Contract Request: Stipend Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in Co...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1108 (Sprint 6)

**Summary**: Clinician Contract Request: Variable Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

Reuse all the components listed there, make sure all components are parameterized to query the r...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1103 (Sprint 6)

**Summary**: Clinician Contract Request: Target Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link] 

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in C...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-614 (Sprint 6)

**Summary**: Create Account Team Roles

**Tech Stack**: Not specified

**Solution Preview**: create Account Team Roles as specified above

update Account (Service Account) layout with tabs component and related list

Update “Case Owner” field within the Manual Onboarding Case (parent and child) creation process (part of stories: : [https://s...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-468 (Sprint 6)

**Summary**: App Home Page

**Tech Stack**: Not specified

**Solution Preview**: * {color:#bf2600}NOTE: we do NOT have a home page component for Approvals, if the business wants we can add To-do list in utility bar.{color}

Clone LRP Home Page Default so that contain the mentioned components and assign it accordingly.  

!Captura...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-210 (Sprint 6)

**Summary**: Clinician Contract Request: Shift Rates

**Tech Stack**: LWC, OmniScript, Integration Procedure

**Solution Preview**: In OmniScript built in user story [https://salesforce.atlassian.net/browse/PR1050558-893|https://salesforce.atlassian.net/browse/PR1050558-893|smart-link] , add a step after facility selection. 

This step should contain customOmniSelect LWC with typ...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-194 (Sprint 6)

**Summary**: Clinician Contract Request: Bonus

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Add Health Cloud Records -[ tab Code Set (Bonus)|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?gid=287559019#gid=287559019]

Summary screen will be built in story 894 which will expose *Configure Rates* butt...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1707 (Sprint 7)

**Summary**: Clinical Match Approval

**Tech Stack**: Not specified

**Solution Preview**: *Object, Group Setup*
Create new record type on Case - ‘Clinical Match’
Create Queue for the Case object with the name 'Clinical Match Queue'
Create public group ‘Clinical Match Request Group’ [~accountid:712020:b8b82845-1665-49bb-bced-ce96d04329bd] ...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1568 (Sprint 7)

**Summary**: Submit Pro Forma Model for Approval - Layout updates

**Tech Stack**: Flow

**Solution Preview**: story [https://salesforce.atlassian.net/browse/PR1050558-1305|https://salesforce.atlassian.net/browse/PR1050558-1305|smart-link]  must be completed first since Pro Forma Model fields must be created/updated for approval thresholds

# Build Autolaunch...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1138 (Sprint 7)

**Summary**: Clinician Contract Request: Leased or Locums - Create/update records

**Tech Stack**: Not specified

**Solution Preview**: A contract is Locum or Leased if the HPF field Employment_Type__c is. 

ContractRequest OS structure is following:

!Captura de pantalla 2025-07-26 a la(s) 1.53.52 p.m..png|width=1108,height=540,alt="Captura de pantalla 2025-07-26 a la(s) 1.53.52 p.m...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1110 (Sprint 7)

**Summary**: Clinician Contract Request: Leadership Incentives

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in Co...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1109 (Sprint 7)

**Summary**: Clinician Contract Request: Stipend Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in Co...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1108 (Sprint 7)

**Summary**: Clinician Contract Request: Variable Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link]

Reuse all the components listed there, make sure all components are parameterized to query the r...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1103 (Sprint 7)

**Summary**: Clinician Contract Request: Target Rates

**Tech Stack**: Not specified

**Solution Preview**: Follow solution as described in [https://salesforce.atlassian.net/browse/PR1050558-194|https://salesforce.atlassian.net/browse/PR1050558-194|smart-link] 

The cloning process should work like below

# Using the Parent Contract (ParentContractId) in C...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-889 (Sprint 7)

**Summary**: Clinician "At a Glance" UI

**Tech Stack**: Not specified

**Solution Preview**: Screenshot is current state solution

!image-20250714-235326.png|width=416,height=548,alt="image-20250714-235326.png"!

Refer Wireframes attached to story, Wireframes provide two views - One Vertical and One Horizontal View. Please note Legend is mis...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-888 (Sprint 7)

**Summary**: Clinician “At a Glance” Display Responsive based on Audience

**Tech Stack**: Not specified

**Solution Preview**: This story is enhancement on top of 889 to show tracker view for Internal vs External User. Refer Column D and F for showing which statuses and what labels are visible for each group of users.

Filter Data in the data sources IPs of Flexcards when da...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-468 (Sprint 7)

**Summary**: App Home Page

**Tech Stack**: Not specified

**Solution Preview**: * {color:#bf2600}NOTE: we do NOT have a home page component for Approvals, if the business wants we can add To-do list in utility bar.{color}

Clone LRP Home Page Default so that contain the mentioned components and assign it accordingly.  

!Captura...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-194 (Sprint 7)

**Summary**: Clinician Contract Request: Bonus

**Tech Stack**: Flow, OmniScript

**Solution Preview**: Add Health Cloud Records -[ tab Code Set (Bonus)|https://docs.google.com/spreadsheets/d/1B6WddJnXHDZD5kx5F1mZDqEvcAwYn1wCPejZ0ZgJpP0/edit?gid=287559019#gid=287559019]

Summary screen will be built in story 894 which will expose *Configure Rates* butt...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-193 (Sprint 7)

**Summary**: Clinical Match Group Indicator

**Tech Stack**: Not specified

**Solution Preview**: 3 rich text components on Clinical Person Account lightning record page dynamically displayed based on Clinical Match Group field value

Create three rich text component on lightning record page.
*Rich text 1*
*Label* : Clinical Match Group 4 Text
*C...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2150 (Sprint 8)

**Summary**: Update Corporation and Tax Information

**Tech Stack**: Not specified

**Solution Preview**: Add Files to the related list for Corporation_and_Tax_Information__c page layout.
Add related section in the lightning record page and the Related List component

See Security Matrix

* Permission Set Groups:
** For Perm Set Group = *Data Quality*
**...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1568 (Sprint 8)

**Summary**: Submit Pro Forma Model for Approval - Layout updates

**Tech Stack**: Flow

**Solution Preview**: story [https://salesforce.atlassian.net/browse/PR1050558-1305|https://salesforce.atlassian.net/browse/PR1050558-1305|smart-link]  must be completed first since Pro Forma Model fields must be created/updated for approval thresholds

# Build Autolaunch...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1094 (Sprint 8)

**Summary**: Intake Form Case - Certification of Competency Questions

**Tech Stack**: Apex

**Solution Preview**: Create apex class and custom metadata to configure the form based on service line.
This should also map to the Document name, document id, OmniProcessId, component/question set
Create Question set for each type of document - and add the appropriate q...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2675 (Sprint 9)

**Summary**: Case (RT: Clinician Change) & “Data Quality” queue

**Tech Stack**: Not specified

**Solution Preview**: Create list view on Case

* Filter: Case Record Type = Clinician Change, Status ≠ Closed
* Fields to Display: Case Number, Subject, Type, Status, Priority, Owner Name, Date/Time Opened

Create Case page layout/LRP fields as mentioned in DD

* Header
...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2225 (Sprint 9)

**Summary**: Related Clinician Records - Add Collaborative Practice Agreement

**Tech Stack**: Not specified

**Solution Preview**: Clinical is related to HPF which is Master to Collaborative Practice agreements (CPA)
Using this relationship, Get the CPAs for an Clinician, using HPF. 
Create flex card, to display the fields mentioned above ( all of which are in CPA). (component S...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2150 (Sprint 9)

**Summary**: Update Corporation and Tax Information

**Tech Stack**: Not specified

**Solution Preview**: Add Files to the related list for Corporation_and_Tax_Information__c page layout.
Add related section in the lightning record page and the Related List component

See Security Matrix

* Permission Set Groups:
** For Perm Set Group = *Data Quality*
**...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1725 (Sprint 9)

**Summary**: Clinician Support Case

**Tech Stack**: Not specified

**Solution Preview**: Create a new button on Person Account (Clinician)
The button launches a record create action, which has the following elements
Subject: Text box
Description: Long text
Owner : Auto-populate current user 
On submit, Create Case

* Case Record Type = S...

*Full Solution: See Sprint 9 HTML file*

---

### Security Setup (52 stories)

#### PR1050558-201 (Sprint 1)

**Summary**: Corporate Support Permission Set Updates

**Tech Stack**: Not specified

**Solution Preview**: add Lightning User Experience permission to Corporate Support Permission Set

add tab access to Corporate Support Permission Set...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-168 (Sprint 1)

**Summary**: Account Edit Access

**Tech Stack**: Not specified

**Solution Preview**: Create public groups and sharing rules as specified in the [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Do...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-166 (Sprint 1)

**Summary**: Permission Set Groups

**Tech Stack**: Not specified

**Solution Preview**: Create permission set groups...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-78 (Sprint 1)

**Summary**: Corporate Support App

**Tech Stack**: Not specified

**Solution Preview**: Create Corporate Support Console app and Corporate Support Standard app

Corporate Support Console app = console navigation
Corporate Support Standard app = standard navigation

Configure navigation rules: 
Contacts open as subtabs of Account
Opportu...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-77 (Sprint 1)

**Summary**: Corporate Support Profile

**Tech Stack**: Not specified

**Solution Preview**: Create Corporate Support profile from clone of Minimum Access Salesforce profile and update to match AC...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-19 (Sprint 1)

**Summary**: Test Users

**Tech Stack**: Not specified

**Solution Preview**: Create users (skip clinician users: Applicant, Active Clinician, and Inactive Clinician)

Assign Role, User License, Profile, Permission Set Groups, and Public Groups

Enable “Login As” setting...

*Full Solution: See Sprint 1 HTML file*

---

#### PR1050558-2636 (Sprint 10)

**Summary**: Deal Team/Account Team Role Updates

**Tech Stack**: Not specified

**Solution Preview**: Modify Account Team Role based on AC...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2552 (Sprint 10)

**Summary**: Update Permissions for List Views

**Tech Stack**: Not specified

**Solution Preview**: Ensure Create and Customize List Views is enabled for Corporate support user permission set...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2224 (Sprint 10)

**Summary**: Open Shift APAY Request - Security Matrix updates

**Tech Stack**: Not specified

**Solution Preview**: * See Security Matrix:
** Tab = User Setup
*** Liz Bennet (Clinician Experience Specialist)
*** Zelta Fitz (Scheduler)
** Tab = Permission Set Groups
*** Clinician Onboarding
* Remove permission set 'Manage Clinician Contracts' from User
Add permissi...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1723 (Sprint 11)

**Summary**: Executed Contract: Automate Email to Clinician with mySCP Instructions

**Tech Stack**: Not specified

**Solution Preview**: When Clinician contract record Status = Executed

Check if the most most recently added HPF to the executed Contract using 

# Contract.ProviderNetworkContract.Healthcare_Practitioner_Facility__r.Practitioner.PersonContactId Order By Contract.Provide...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-1723 (Sprint 12)

**Summary**: Executed Contract: Automate Email to Clinician with mySCP Instructions

**Tech Stack**: Not specified

**Solution Preview**: When Clinician contract record Status = Executed

Check if the most most recently added HPF to the executed Contract using 

# Contract.ProviderNetworkContract.Healthcare_Practitioner_Facility__r.Practitioner.PersonContactId Order By Contract.Provide...

*Full Solution: See Sprint 12 HTML file*

---

#### PR1050558-4594 (Sprint 12.1)

**Summary**: Update Role Hierarchy

**Tech Stack**: Not specified

**Solution Preview**: Build Role based on Security Matrix...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4538 (Sprint 12.1)

**Summary**: UAT Bug: C&CUAT187 Finance Unable to edit fields

**Tech Stack**: Not specified

**Solution Preview**: Update “Finance” Permission Set Group.

* Remove 'View Client Contracts' permission set
* Add ‘Manage Client Contracts’ permission set...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4532 (Sprint 12.1)

**Summary**: Unable to Log In to Specific Users

**Tech Stack**: Not specified

**Solution Preview**: Re-enabled the required Lightning Experience permissions in the *‘Corporate Support’* permission set....

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-1723 (Sprint 12.1)

**Summary**: Executed Contract: Automate Email to Clinician with mySCP Instructions

**Tech Stack**: Not specified

**Solution Preview**: When Clinician contract record Status = Executed

Check if the most most recently added HPF to the executed Contract using 

# Contract.ProviderNetworkContract.Healthcare_Practitioner_Facility__r.Practitioner.PersonContactId Order By Contract.Provide...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5318 (Sprint 12.2)

**Summary**: UAT Bug - C&CUAT416 - UAT1 - Unable to generate term sheet

**Tech Stack**: Not specified

**Solution Preview**: Go to Setup
Go to Permission Set Group
Look for Clinician Recruitng
Add below perm set in group
DocGen Runtime USer
DocGen User Ext
Save

Do the same for Clinician Contracing and IT permission set group...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-4594 (Sprint 12.2)

**Summary**: Update Role Hierarchy

**Tech Stack**: Not specified

**Solution Preview**: Build Role based on Security Matrix...

*Full Solution: See Sprint 12.2 HTML file*

---

#### PR1050558-5493 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare37 - Data Quality Needs Access to Create, Edit and Delete Account Team 

**Tech Stack**: Not specified

**Solution Preview**: create new Permission Set = ‘Data Quality Extension' & add to the 'Data Quality’ Permission Set Group....

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5791 (Sprint 12.4)

**Summary**: PROD Bug: UPHypercare267 - Review CPA Relationship not populating with physicians - Immediate/PROD o

**Tech Stack**: Not specified

**Solution Preview**: * AC1: The permission sets
** -Manage Client Contracts-
** -View Client BD-
** -View Client Rates- 
** Manage Collaborative Practice Agreements


are added tot he following Permission Set Groups (3/5/26 Britni confirm permission set was added to all ...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5924 (Sprint 12.5)

**Summary**: PROD Enhancement: UPHypercare338 - Update how Rates are displayed in the Summary Tab

**Tech Stack**: CSS

**Solution Preview**: *AC1 - Update rate display layout*

• DataRaptor (loads PCA records into Summary tab) -- add Previous_Rate__c, Facility_Level_Rate__c, Unit_of_Measure__c, Time_Type__c to extract output for UI Card

• OmniUI Card SpecifyRates_SummaryContractScreen (n...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5791 (Sprint 12.5)

**Summary**: PROD Bug: UPHypercare267 - Review CPA Relationship not populating with physicians - Immediate/PROD o

**Tech Stack**: Not specified

**Solution Preview**: * AC1: The permission sets
** -Manage Client Contracts-
** -View Client BD-
** -View Client Rates- 
** Manage Collaborative Practice Agreements


are added tot he following Permission Set Groups (3/5/26 Britni confirm permission set was added to all ...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-5791 (Sprint 13)

**Summary**: PROD Bug: UPHypercare267 - Review CPA Relationship not populating with physicians - Immediate/PROD o

**Tech Stack**: Not specified

**Solution Preview**: * AC1: The permission sets
** -Manage Client Contracts-
** -View Client BD-
** -View Client Rates- 
** Manage Collaborative Practice Agreements


are added tot he following Permission Set Groups (3/5/26 Britni confirm permission set was added to all ...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-6322 (Sprint 14)

**Summary**: PROD Bug: TeamRole - Off Boarding Tasks Flow missing Metadata during deployment

**Tech Stack**: REST

**Solution Preview**: Restore TeamRole “RN/LPN Manager” and deploy from lower to higher orgs...

*Full Solution: See Sprint 14 HTML file*

---

#### PR1050558-217 (Sprint 2)

**Summary**: Add LRP and Page Layouts to System Administrator

**Tech Stack**: Not specified

**Solution Preview**: Update LRP assignment for existing pages to add access for System Administrator profile...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-248 (Sprint 3)

**Summary**: OmniStudio Permission Set

**Tech Stack**: Not specified

**Solution Preview**: Add OmniStudio User Extension permission set to Corporate Support Permission Set Group...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-245 (Sprint 3)

**Summary**: Update Related Lists on Clinician Record

**Tech Stack**: Not specified

**Solution Preview**: update LRP with related lists and tabs specified in the story

update permission set according to security matrix (Manage Clinician Identifiers, Credentials, Specialties)...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-232 (Sprint 3)

**Summary**: Integration Profile and Permission Set

**Tech Stack**: Not specified

**Solution Preview**: Assing the Profile and Permission set to Integration Mulesoft...

*Full Solution: See Sprint 3 HTML file*

---

#### PR1050558-573 (Sprint 4)

**Summary**: Initial Role Hierarchy

**Tech Stack**: Not specified

**Solution Preview**: [Security Matrix.xlsx|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesforce%20team%20Deliverables/Architect...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-566 (Sprint 4)

**Summary**: MSL-CC Queue

**Tech Stack**: Not specified

**Solution Preview**: create Medical Staff Liaison role (see [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesfor...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-563 (Sprint 4)

**Summary**: Enrollment Specialist Queue

**Tech Stack**: Not specified

**Solution Preview**: create Enrollment Specialist role (see [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesfor...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-226 (Sprint 4)

**Summary**: Salesforce App Cleanup

**Tech Stack**: Not specified

**Solution Preview**: Configure assigned apps for the Corporate Support profile, default app set to Corporate Support...

*Full Solution: See Sprint 4 HTML file*

---

#### PR1050558-857 (Sprint 5)

**Summary**: Enrollment Specialist Queue - Support Cases

**Tech Stack**: Not specified

**Solution Preview**: create Enrollment Specialist role (see [Security Matrix|https://schumachergroup.sharepoint.com/:x:/r/teams/UnifiedPlatform-ReGenesis/Shared%20Documents/Program%20Documentation/Program%20Planning/Discovery%20Deliverables%20%26%20Documentation/Salesfor...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-712 (Sprint 5)

**Summary**: Create Permission Set for AffectLayer Apps

**Tech Stack**: Not specified

**Solution Preview**: * add access to “Manage Client BD” permission set for both AffectLayer Reports and Chorus Settings apps
* add access to “System Administrator” permission set for both AffectLayer Reports and Chorus Settings apps
* Ensure within the Copado story the m...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-700 (Sprint 5)

**Summary**: Specify Corporate Entity Type

**Tech Stack**: Not specified

**Solution Preview**: update columns on Corporate Entity and Service Account related lists

Update layout per Data Dictionary (tab = Account Account Relationship)

add new Party Role Relationship records as specified in the [Health Cloud Records|https://docs.google.com/sp...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-1709 (Sprint 6)

**Summary**: Role Hierarchy - Add VP DB Finance & SVP Growth

**Tech Stack**: Not specified

**Solution Preview**: For Testing can we please create 2 new Test Users (setup with Sales VP persona to ensure they have the correct access) and assign to the following roles. 

# Role = SVP Growth
## Created *Erica Rollins* - you need to update the Role once available 
#...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1387 (Sprint 6)

**Summary**: Integration User Access

**Tech Stack**: Not specified

**Solution Preview**: update access on Integration permission set...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1257 (Sprint 6)

**Summary**: Update Test Users - Add Public Groups

**Tech Stack**: Not specified

**Solution Preview**: * Update Security Matrix
** Tab = User Setup
** Tab = Permission Set Group
* opens visibility related to: [https://salesforce.atlassian.net/browse/PR1050558-621|https://salesforce.atlassian.net/browse/PR1050558-621|smart-link] [https://salesforce.atl...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-2013 (Sprint 7)

**Summary**: Update Role Name to VP BD Finance

**Tech Stack**: Not specified

**Solution Preview**: update the name of the already created role from VP DB Finance to VP BD Finance...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1787 (Sprint 7)

**Summary**: Add Account Contact Relationship to Service Account

**Tech Stack**: Not specified

**Solution Preview**: * On the Account (RT: Service Account)
** Tab = Account Team
*** Add Related List = Related Contact
**** Roles should match AC...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1709 (Sprint 7)

**Summary**: Role Hierarchy - Add VP DB Finance & SVP Growth

**Tech Stack**: Not specified

**Solution Preview**: For Testing can we please create 2 new Test Users (setup with Sales VP persona to ensure they have the correct access) and assign to the following roles. 

# Role = SVP Growth
## Created *Erica Rollins* - you need to update the Role once available 
#...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1387 (Sprint 7)

**Summary**: Integration User Access

**Tech Stack**: Not specified

**Solution Preview**: update access on Integration permission set...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1257 (Sprint 7)

**Summary**: Update Test Users - Add Public Groups

**Tech Stack**: Not specified

**Solution Preview**: * Update Security Matrix
** Tab = User Setup
** Tab = Permission Set Group
* opens visibility related to: [https://salesforce.atlassian.net/browse/PR1050558-621|https://salesforce.atlassian.net/browse/PR1050558-621|smart-link] [https://salesforce.atl...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2624 (Sprint 8)

**Summary**: Sales VP Persona don't have access to Edit the Green Light for Client Outreach field on Opportunity 

**Tech Stack**: Not specified

**Solution Preview**: Solution change and permission set adjustments...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2112 (Sprint 8)

**Summary**: Review User Profile Key Field

**Tech Stack**: Not specified

**Solution Preview**: Update CoreHC Mapping to Qgenda interface PUT Scheduling to determine UserProfileKey



No BUILD Required in Salesforce.

[https://schumachergroup-my.sharepoint.com/:x:/r/personal/ronald_gregg_tsged_com/_layouts/15/Doc.aspx?sourcedoc=%7BAC536B24-FFB5...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2081 (Sprint 8)

**Summary**: Opportunity Team (Deal Team)

**Tech Stack**: Not specified

**Solution Preview**: Add the Account/ Opportunity Team Role based on above list

[https://corehc--dev1.sandbox.my.salesforce-setup.com/lightning/setup/OpportunityTeamMemberRoles/home|https://corehc--dev1.sandbox.my.salesforce-setup.com/lightning/setup/OpportunityTeamMemb...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1787 (Sprint 8)

**Summary**: Add Account Contact Relationship to Service Account

**Tech Stack**: Not specified

**Solution Preview**: * On the Account (RT: Service Account)
** Tab = Account Team
*** Add Related List = Related Contact
**** Roles should match AC...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-883 (Sprint 8)

**Summary**: Exit Interview Feedback Security

**Tech Stack**: Not specified

**Solution Preview**: * OWD for Case = Private
* Add case team for exit interivew case record and add the account team members in the roles specified above as case team members, with read/edit permission. ( navigate to Case > Clinician > All HPF> All SA - account team rol...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2636 (Sprint 9)

**Summary**: Deal Team/Account Team Role Updates

**Tech Stack**: Not specified

**Solution Preview**: Modify Account Team Role based on AC...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2552 (Sprint 9)

**Summary**: Update Permissions for List Views

**Tech Stack**: Not specified

**Solution Preview**: Ensure Create and Customize List Views is enabled for Corporate support user permission set...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2224 (Sprint 9)

**Summary**: Open Shift APAY Request - Security Matrix updates

**Tech Stack**: Not specified

**Solution Preview**: * See Security Matrix:
** Tab = User Setup
*** Liz Bennet (Clinician Experience Specialist)
*** Zelta Fitz (Scheduler)
** Tab = Permission Set Groups
*** Clinician Onboarding
* Remove permission set 'Manage Clinician Contracts' from User
Add permissi...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2112 (Sprint 9)

**Summary**: Review User Profile Key Field

**Tech Stack**: Not specified

**Solution Preview**: Update CoreHC Mapping to Qgenda interface PUT Scheduling to determine UserProfileKey



No BUILD Required in Salesforce.

[https://schumachergroup-my.sharepoint.com/:x:/r/personal/ronald_gregg_tsged_com/_layouts/15/Doc.aspx?sourcedoc=%7BAC536B24-FFB5...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2081 (Sprint 9)

**Summary**: Opportunity Team (Deal Team)

**Tech Stack**: Not specified

**Solution Preview**: Add the Account/ Opportunity Team Role based on above list

[https://corehc--dev1.sandbox.my.salesforce-setup.com/lightning/setup/OpportunityTeamMemberRoles/home|https://corehc--dev1.sandbox.my.salesforce-setup.com/lightning/setup/OpportunityTeamMemb...

*Full Solution: See Sprint 9 HTML file*

---

### OmniStudio (50 stories)

#### PR1050558-3212 (Sprint 10)

**Summary**: View Practice Operations rate on Configure Rates

**Tech Stack**: OmniScript

**Solution Preview**: As discussed over 1:1 , In the Configure rates omniscript - where we display rates - 
As part of clone process - update the Facility rate as well, so that it is easier to get the PO contract. (Currently the first time a clinician contract is created,...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2955 (Sprint 10)

**Summary**: Clinician Contract Request: SCP to book Travel

**Tech Stack**: OmniScript

**Solution Preview**: * Field creation part of 2924
Ensure the field SCP to Book travel is already created on Contract. If not create it as per [https://salesforce.atlassian.net/browse/PR1050558-2924|https://salesforce.atlassian.net/browse/PR1050558-2924|smart-link] 

In ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2551 (Sprint 10)

**Summary**: Conditional Requirements for Clinician NPI

**Tech Stack**: OmniScript

**Solution Preview**: In the existing Create HPF omniscript, in Clinician Information screen ,  
Placement of the checkbox and validation - Update NPI - screen, (existing)


Add a new checkbox ‘No NPI number’
Query for task related to Clinician of type “NPI Number missing...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2471 (Sprint 10)

**Summary**: Clinician Offboarding - Termination Details Update

**Tech Stack**: OmniScript

**Solution Preview**: on Case, Reason for Termination - the options mentioned should be added.

On the omniscript created as part of 306, 
update placement of last day field to after Termination Request Date
Add Backfill Recommended field (checkbox, optional)
Ensure Clini...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2467 (Sprint 10)

**Summary**: Clinician Contract: Leased and Locums Update to Executed Status

**Tech Stack**: OmniScript

**Solution Preview**: Existing omniscript for Submit contract request,
If employee type selected is Leased or Locums, and goes through the contract request process, on final submit , create/update the contract in executed status. 
NOTE: This story is to skip the approval ...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-2238 (Sprint 10)

**Summary**: Clinician Contract Update: Rate Pay Code

**Tech Stack**: OmniScript

**Solution Preview**: Use the existing omniscript of creating PCA record, where we get the rates from the client contract (that are executed, and there is a Create PCA and CPA step.
For these Client Contracts, Get Contract Payment Agreement > Preventive Care Agreement > R...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-1739 (Sprint 10)

**Summary**: Facility Change Request: Rates & Coverage 1 of 2

**Tech Stack**: OmniScript

**Solution Preview**: Create a new button Change Request on Service Account record, that launches a omniscript.
Launches a screen
Do you want to make coverage changes? (radio button)
Yes
No

On Practice Operatiosn contract, create a new field (Type of Change) - Picklist -...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-472 (Sprint 10)

**Summary**: Client Agreement Request

**Tech Stack**: OmniScript

**Solution Preview**: * Create new Queue = Client Contracting Queue (supported Objects: Case)
* Create New Case Record Type = Client Contract Request
* See DD
** Add new fields to Case (Client Contract Request)
** Create new layout
* Security Matrix
** Permission Set tab,...

*Full Solution: See Sprint 10 HTML file*

---

#### PR1050558-3620 (Sprint 11)

**Summary**: UAT Bug: C&CUAT16 Contract Request Bonus Configuration not saving to record and system allowing user

**Tech Stack**: OmniScript

**Solution Preview**: The IP CreatePreventiveCareAgreementRecords is used by two Omniscripts ( Clinician ConfigureRates and ServiceAccFacilityRateCreation). As part of the changes for *ServiceAccFacilityRateCreation*, a flag isShiftCoverage was passed over and checked at ...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-3212 (Sprint 11)

**Summary**: View Practice Operations rate on Configure Rates

**Tech Stack**: OmniScript

**Solution Preview**: As discussed over 1:1 , In the Configure rates omniscript - where we display rates - 
As part of clone process - update the Facility rate as well, so that it is easier to get the PO contract. (Currently the first time a clinician contract is created,...

*Full Solution: See Sprint 11 HTML file*

---

#### PR1050558-4629 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT233 Practice Operations Contract not End Dated and causing multi/duplicate ra

**Tech Stack**: Integration Procedure

**Solution Preview**: Update the Integration Procedure ContractRate_FacilityToClinician

# Add a condition to filter criteria PreventiveCareAgreement.Is_Deleted__c = false
# Add a Filter condition to DREGetPCAandClientContractDiffFacility to include ContractId [Practice O...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4175 (Sprint 12.1)

**Summary**: RUL - Security

**Tech Stack**: OmniScript, Integration Procedure, REST

**Solution Preview**: Profile “Health Cloud Restricted User - Corporate Support” (Cloned from current corporate support profile)

Permission Set Group “Health Cloud Restricted User Group”

Permission Set “Health Cloud Restricted User - Corporate Support Permission” 

* En...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-5594 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare147 - Risk Review Process not pulling correct HPFs

**Tech Stack**: OmniScript

**Solution Preview**: Modify OmniScript *ClinicianRiskReviewOS*

add the filter criteria as per defect to set Status != Inactive...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-209 (Sprint 2)

**Summary**: Guided Create HPF: Facility Selection

**Tech Stack**: OmniScript

**Solution Preview**: OmniScript

Reuse the solution built for [https://salesforce.atlassian.net/browse/PR1050558-192|https://salesforce.atlassian.net/browse/PR1050558-192|smart-link] 

Healthcare Practitioner Facility Type Ahead 

Choose only Account Record Type Service ...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-192 (Sprint 2)

**Summary**: NPI Management

**Tech Stack**: OmniScript, Validation Rule

**Solution Preview**: OmniScript

* When NPI field on Contact is updated
* Check if Healthcare Provider NPI record exists for this contact
** If a record exists: update NPI field on Healthcare Provider NPI record with the value from the NPI contact field
** If a record do...

*Full Solution: See Sprint 2 HTML file*

---

#### PR1050558-1056 (Sprint 5)

**Summary**: Facility Rate Creation - Update Summary Tab Record Visibility

**Tech Stack**: OmniScript, Integration Procedure

**Solution Preview**: *TESTING NOTE: Right now, we are NOT able to validate for Contract status = Executed.*

Solution:

* In OmniScript *ServiceAccFacilityRateCreation* add condition in following Step:

!Captura de pantalla 2025-07-17 a la(s) 10.22.24 p.m..png|width=776,...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-893 (Sprint 5)

**Summary**: Clinician Contract Request: HPF Selection

**Tech Stack**: OmniScript, Integration Procedure

**Solution Preview**: Create an action in Account called Contract Request which will call an Omniscript. 

!Captura de pantalla 2025-07-15 a la(s) 10.26.12 p.m..png|width=1243,height=689,alt="Captura de pantalla 2025-07-15 a la(s) 10.26.12 p.m..png"!

Add the action to th...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-892 (Sprint 5)

**Summary**: Clinician Contract Request: Leased or Locums

**Tech Stack**: OmniScript

**Solution Preview**: * add Skip Contracting checkbox to Code Set object and update records according to AC 
** See Data Dictionary for field (ensure all permission sets with access to object have visibility to this field).
** See [Health Cloud Records|https://docs.google...

*Full Solution: See Sprint 5 HTML file*

---

#### PR1050558-2086 (Sprint 6)

**Summary**: Clinician Contract Request: Bonus - Enforce additional bonus on 1 Facility/HPF

**Tech Stack**: OmniScript, Formula Field

**Solution Preview**: Remove required from Type field on the omniscript/screen
Use messaging (formula validation) to check if more than one “Additional Bonus” is added and Display Validation message , and prevent the user from adding more than one additional bonus....

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1332 (Sprint 6)

**Summary**: Clinician Contract Request: Select Employment Type

**Tech Stack**: OmniScript

**Solution Preview**: Update the Omniscript Clinician/ContractRequest to add the first screen and show picklist values from Employment Type field from Contract. The existing validation for checking if any HPF should remain the same as is built before even showing this scr...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-1113 (Sprint 6)

**Summary**: Risk Review - Populate AccountId with Service Account

**Tech Stack**: Integration Procedure

**Solution Preview**: In ClinicianRiskReviewOS we have Integration Procedure Action ClinicianCreateRiskReviewIP which calls Clinician_CreateRiskReviewIP:

!Captura de pantalla 2025-07-24 a la(s) 2.41.30 p.m..png|width=858,height=863,alt="Captura de pantalla 2025-07-24 a l...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-893 (Sprint 6)

**Summary**: Clinician Contract Request: HPF Selection

**Tech Stack**: OmniScript, Integration Procedure

**Solution Preview**: Create an action in Account called Contract Request which will call an Omniscript. 

!Captura de pantalla 2025-07-15 a la(s) 10.26.12 p.m..png|width=1243,height=689,alt="Captura de pantalla 2025-07-15 a la(s) 10.26.12 p.m..png"!

Add the action to th...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-892 (Sprint 6)

**Summary**: Clinician Contract Request: Leased or Locums

**Tech Stack**: OmniScript

**Solution Preview**: * add Skip Contracting checkbox to Code Set object and update records according to AC 
** See Data Dictionary for field (ensure all permission sets with access to object have visibility to this field).
** See [Health Cloud Records|https://docs.google...

*Full Solution: See Sprint 6 HTML file*

---

#### PR1050558-2086 (Sprint 7)

**Summary**: Clinician Contract Request: Bonus - Enforce additional bonus on 1 Facility/HPF

**Tech Stack**: OmniScript, Formula Field

**Solution Preview**: Remove required from Type field on the omniscript/screen
Use messaging (formula validation) to check if more than one “Additional Bonus” is added and Display Validation message , and prevent the user from adding more than one additional bonus....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1392 (Sprint 7)

**Summary**: Update Clinician Taxonomy Selection

**Tech Stack**: OmniScript

**Solution Preview**: Change the DR and IP and OmniScript to get and show the description field...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-1334 (Sprint 7)

**Summary**: Clinician "At a Glance" Status Calculation

**Tech Stack**: Integration Procedure

**Solution Preview**: Refer poc_OnboardingData Integration procedure in the Demo environment as starting point to derive required logic for displaying section headers, status described in the attached reference document.

screenshot of wireframe from  [https://salesforce....

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-701 (Sprint 7)

**Summary**: Clinician Offboarding - Facility Selection

**Tech Stack**: OmniScript

**Solution Preview**: Use Omniscript ( where this is first screen) ,to display list of HPF records that are not inactive 
Display the records as a edit block (check box) list. 
Display the fields on HPF Name , HPF Status__c, Last_Date_Worked__c 
(Query HPF records using P...

*Full Solution: See Sprint 7 HTML file*

---

#### PR1050558-2447 (Sprint 8)

**Summary**: Set up Discovery framework - Configuration

**Tech Stack**: OmniScript

**Solution Preview**: [https://help.salesforce.com/s/articleView?id=ind.grant_digital_experience_guest_user_access_to_discovery_framework_omniscripts.htm&type=5|https://help.salesforce.com/s/articleView?id=ind.grant_digital_experience_guest_user_access_to_discovery_framew...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2220 (Sprint 8)

**Summary**: Intake Form: Automated Task Creation to Review NPI

**Tech Stack**: OmniScript

**Solution Preview**: As part of the Omniscript used to display NPI form ( part of [231|https://salesforce.atlassian.net/browse/PR1050558-231]) , 
Retrieve the Contact’s NPI information
when the NPI field from form does not match the Contact’s NPI 
At the end, after the a...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2219 (Sprint 8)

**Summary**: Intake Form: Automated Task Creation to Review Name Change

**Tech Stack**: OmniScript

**Solution Preview**: As part of the Omniscript that (is used for Intake form as part of discovery framework) 
Compare the Legal name with the Clinician’s Name 
if there is a difference, 
Create a Task based on the above condition. (If feasible use the Decision matrix)...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2021 (Sprint 8)

**Summary**: Clinician Offboarding: EE Involuntary Termination

**Tech Stack**: OmniScript

**Solution Preview**: Where? On the second screen of omniscript
Query for HPF.Facility_Title__r.Code_Set_Sub_Type__c = 'Employee'
When the HPF Facility Title is Employee and Voluntary termination field is not checked, 
Conditionally display  the message on the screen 'You...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2015 (Sprint 8)

**Summary**: Clinician Offboarding - Termination Details for Locums

**Tech Stack**: OmniScript

**Solution Preview**: On the omniscript (used in story [701|https://salesforce.atlassian.net/browse/PR1050558-701]), after the HPF are selected,
Check if the selected HPF match the criteria
status is not Prospect or Inactive AND Employment Type is Locums
Then display the ...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1721 (Sprint 8)

**Summary**: Clinician Contract Request: Start Admin Work Ahead of Clinical

**Tech Stack**: OmniScript

**Solution Preview**: In the Contract request omniscript, conditionally display a checkbox field “Start Admin Work Ahead of Clinical Work” on screen 3, based on the conditions
selected employee type is Employee or Independent Contractor
AND
Selected Facility (HPF.Facility...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-1392 (Sprint 8)

**Summary**: Update Clinician Taxonomy Selection

**Tech Stack**: OmniScript

**Solution Preview**: Change the DR and IP and OmniScript to get and show the description field...

*Full Solution: See Sprint 8 HTML file*

---

#### PR1050558-2592 (Sprint 9)

**Summary**: Clinician Contract Request: Bonus Details - Update Payments

**Tech Stack**: OmniScript

**Solution Preview**: On the existing omniscript for Configure rates, Add a option to the picklist value field Payments - 3 Payments
Add the option value to Preventive Care Agreement > Payments__c as well - 3 Payments
Updated in DD...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2559 (Sprint 9)

**Summary**: Clinician Contract Update: Add Time Type

**Tech Stack**: OmniScript

**Solution Preview**: Add ‘Not Applicable’ to the picklist Time Type field.
On the existing submit Contract request button/omniscript on clinician record, 
Add Time type picklist value on the first screen
Based on the Employee Type selected, the Time Type value is default...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2557 (Sprint 9)

**Summary**: Initiate Leadership Change from Service Account

**Tech Stack**: OmniScript

**Solution Preview**: On Service Account - Create a new button that launches a omniscript (error message if user is NOT a VPO: Only the VP Operations can initiate this change. )
Omniscript - Display two options as radio button
Adjust Current leadership
Add New Leader
Next...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2551 (Sprint 9)

**Summary**: Conditional Requirements for Clinician NPI

**Tech Stack**: OmniScript

**Solution Preview**: In the existing Create HPF omniscript, in Clinician Information screen ,  
Placement of the checkbox and validation - Update NPI - screen, (existing)


Add a new checkbox ‘No NPI number’
Query for task related to Clinician of type “NPI Number missing...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2528 (Sprint 9)

**Summary**: Clinician Contract Request: Shift Rate Details - Populate Type field

**Tech Stack**: OmniScript

**Solution Preview**: For rates of type Shift, Add Client Contract’s Shift record’s full name .
For other rates types, the current type can be displayed. 
on the existing omniscript for (Configure rates), display Shift full name conditionally for shift rate type. 
Remove ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2471 (Sprint 9)

**Summary**: Clinician Offboarding - Termination Details Update

**Tech Stack**: OmniScript

**Solution Preview**: on Case, Reason for Termination - the options mentioned should be added.

On the omniscript created as part of 306, 
update placement of last day field to after Termination Request Date
Add Backfill Recommended field (checkbox, optional)
Ensure Clini...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2467 (Sprint 9)

**Summary**: Clinician Contract: Leased and Locums Update to Executed Status

**Tech Stack**: OmniScript

**Solution Preview**: Existing omniscript for Submit contract request,
If employee type selected is Leased or Locums, and goes through the contract request process, on final submit , create/update the contract in executed status. 
NOTE: This story is to skip the approval ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2447 (Sprint 9)

**Summary**: Set up Discovery framework - Configuration

**Tech Stack**: OmniScript

**Solution Preview**: [https://help.salesforce.com/s/articleView?id=ind.grant_digital_experience_guest_user_access_to_discovery_framework_omniscripts.htm&type=5|https://help.salesforce.com/s/articleView?id=ind.grant_digital_experience_guest_user_access_to_discovery_framew...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2238 (Sprint 9)

**Summary**: Clinician Contract Update: Rate Pay Code

**Tech Stack**: OmniScript

**Solution Preview**: Use the existing omniscript of creating PCA record, where we get the rates from the client contract (that are executed, and there is a Create PCA and CPA step.
For these Client Contracts, Get Contract Payment Agreement > Preventive Care Agreement > R...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2220 (Sprint 9)

**Summary**: Intake Form: Automated Task Creation to Review NPI

**Tech Stack**: OmniScript

**Solution Preview**: As part of the Omniscript used to display NPI form ( part of [231|https://salesforce.atlassian.net/browse/PR1050558-231]) , 
Retrieve the Contact’s NPI information
when the NPI field from form does not match the Contact’s NPI 
At the end, after the a...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2219 (Sprint 9)

**Summary**: Intake Form: Automated Task Creation to Review Name Change

**Tech Stack**: OmniScript

**Solution Preview**: As part of the Omniscript that (is used for Intake form as part of discovery framework) 
Compare the Legal name with the Clinician’s Name 
if there is a difference, 
Create a Task based on the above condition. (If feasible use the Decision matrix)...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2021 (Sprint 9)

**Summary**: Clinician Offboarding: EE Involuntary Termination

**Tech Stack**: OmniScript

**Solution Preview**: Where? On the second screen of omniscript
Query for HPF.Facility_Title__r.Code_Set_Sub_Type__c = 'Employee'
When the HPF Facility Title is Employee and Voluntary termination field is not checked, 
Conditionally display  the message on the screen 'You...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2018 (Sprint 9)

**Summary**: NP/PA Tier Management: Client

**Tech Stack**: OmniScript

**Solution Preview**: *Contract (Client - Practice Operations) (Use same API Name due to integration mapping)*

NPPA_Tier__c

*Contract (Clinician)*

NPPA_Tier__c

EE_NP_PA_Full_Time_Monthly_Blended__c -NPPA_Blended_Salary__c-

EE_NP_PA_Hourly_Blended__c -NPPA_Blended_Rat...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-2015 (Sprint 9)

**Summary**: Clinician Offboarding - Termination Details for Locums

**Tech Stack**: OmniScript

**Solution Preview**: On the omniscript (used in story [701|https://salesforce.atlassian.net/browse/PR1050558-701]), after the HPF are selected,
Check if the selected HPF match the criteria
status is not Prospect or Inactive AND Employment Type is Locums
Then display the ...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-1721 (Sprint 9)

**Summary**: Clinician Contract Request: Start Admin Work Ahead of Clinical

**Tech Stack**: OmniScript

**Solution Preview**: In the Contract request omniscript, conditionally display a checkbox field “Start Admin Work Ahead of Clinical Work” on screen 3, based on the conditions
selected employee type is Employee or Independent Contractor
AND
Selected Facility (HPF.Facility...

*Full Solution: See Sprint 9 HTML file*

---

#### PR1050558-472 (Sprint 9)

**Summary**: Client Agreement Request

**Tech Stack**: OmniScript

**Solution Preview**: * Create new Queue = Client Contracting Queue (supported Objects: Case)
* Create New Case Record Type = Client Contract Request
* See DD
** Add new fields to Case (Client Contract Request)
** Create new layout
* Security Matrix
** Permission Set tab,...

*Full Solution: See Sprint 9 HTML file*

---

### Reporting (4 stories)

#### PR1050558-5167 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT263 Permissions to run reports

**Tech Stack**: Not specified

**Solution Preview**: Provide Access to Report and Dashboard 

Use Security Matrix's (PSGs: Data Quality, Clinician Contracting, Clinician Onboarding)...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-4749 (Sprint 12.1)

**Summary**: UAT Enhancement: C&CUAT263 Legal - Client Contracting - Legal needs permissions to run reports (and 

**Tech Stack**: Not specified

**Solution Preview**: Provide Access to Report and Dashboard 

Use Security Matrix's...

*Full Solution: See Sprint 12.1 HTML file*

---

#### PR1050558-6314 (Sprint 12.5)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 3 of 3 (Send Daily Em

**Tech Stack**: Not specified

**Solution Preview**: Collect the Data and Send the report as per AC...

*Full Solution: See Sprint 12.5 HTML file*

---

#### PR1050558-6314 (Sprint 14)

**Summary**: PROD Enhancement: Update the Clinician Inactivation Process & 3 month report - 3 of 3 (Send Daily Em

**Tech Stack**: Not specified

**Solution Preview**: Collect the Data and Send the report as per AC...

*Full Solution: See Sprint 14 HTML file*

---

### Declarative Logic (4 stories)

#### PR1050558-5588 (Sprint 12.3)

**Summary**: PROD Enhancement: UPHypercare139 - First Clinical Shift integration is encountering an error

**Tech Stack**: Validation Rule

**Solution Preview**: Remove Lookup Filter from Facility Title and Make it as Validation Rule

Logic: 

Validation Rule for Facility Title: When Facility Title is created new or updated check if Active Flag is True...

*Full Solution: See Sprint 12.3 HTML file*

---

#### PR1050558-5588 (Sprint 12.4)

**Summary**: PROD Enhancement: UPHypercare139 - First Clinical Shift integration is encountering an error

**Tech Stack**: Validation Rule

**Solution Preview**: Remove Lookup Filter from Facility Title and Make it as Validation Rule

Logic: 

Validation Rule for Facility Title: When Facility Title is created new or updated check if Active Flag is True...

*Full Solution: See Sprint 12.4 HTML file*

---

#### PR1050558-5709 (Sprint 13)

**Summary**: PROD Enhancement: UPHypercare234 - Need the system to check if candidate has an email address before

**Tech Stack**: Validation Rule

**Solution Preview**: A new validation rule on ATS Applicant

Name: Awaiting Intake Stage
Logic:
If isChanged(bpats__ATS_Stage__c) && bpats__ATS_Stage__c.bpats__Sequence__c = “3” && ISNULL(bpats__Applicant_Email__c) 

Error Location: Top of Page
Error Message: “Please pro...

*Full Solution: See Sprint 13 HTML file*

---

#### PR1050558-5709 (Sprint 14)

**Summary**: PROD Enhancement: UPHypercare234 - Need the system to check if candidate has an email address before

**Tech Stack**: Validation Rule

**Solution Preview**: A new validation rule on ATS Applicant

Name: Awaiting Intake Stage
Logic:
If isChanged(bpats__ATS_Stage__c) && bpats__ATS_Stage__c.bpats__Sequence__c = “3” && ISNULL(bpats__Applicant_Email__c) 

Error Location: Top of Page
Error Message: “Please pro...

*Full Solution: See Sprint 14 HTML file*

---

### Integration (1 stories)

#### PR1050558-204 (Sprint 4)

**Summary**: Prospect Portal Home Page & Record Detail

**Tech Stack**: REST

**Solution Preview**: * General mock layout for Home page attached. For this story we will need to adjust the layout to add a right side column to hold the SCP links. See my task for an example.
* In the future we may need to add visibility restrictions to specific set of...

*Full Solution: See Sprint 4 HTML file*

---


## All Stories with Solutions (Alphabetical)

- **PR1050558-1028** (Sprint 10) - Flow Automation | Tech: Flow | Intake Form Automation - Send Reminder after 3 days
- **PR1050558-1056** (Sprint 5) - OmniStudio | Tech: OmniScript, Integration Procedure | Facility Rate Creation - Update Summary Tab Record Visibilit
- **PR1050558-107** (Sprint 1) - General | Tech: N/A | Duplicate Clinician Records
- **PR1050558-1070** (Sprint 6) - Configuration | Tech: N/A | Clinician Contract Request: Contract Changes
- **PR1050558-1072** (Sprint 6) - General | Tech: N/A | Collaborative Practice Agreement Legal Requirements - Load D
- **PR1050558-1073** (Sprint 11) - Apex Development | Tech: Apex, Flow | Update Agreement Request - Email Alert
- **PR1050558-1073** (Sprint 12) - Apex Development | Tech: Apex, Flow | Update Agreement Request - Email Alert
- **PR1050558-1074** (Sprint 6) - Configuration | Tech: N/A | Add Files on Contract
- **PR1050558-1074** (Sprint 7) - Configuration | Tech: N/A | Add Files on Contract
- **PR1050558-1094** (Sprint 8) - LWC/Aura Component | Tech: Apex | Intake Form Case - Certification of Competency Questions
- **PR1050558-1095** (Sprint 8) - Configuration | Tech: N/A | Intake Form Case - Conflict of Interest Form
- **PR1050558-1096** (Sprint 9) - General | Tech: N/A | Intake Form Case - CCPA Notice
- **PR1050558-1097** (Sprint 8) - Configuration | Tech: REST | Intake Form Case - Load Assessment Questions & Capture Quest
- **PR1050558-1103** (Sprint 6) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Target Rates
- **PR1050558-1103** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Target Rates
- **PR1050558-1108** (Sprint 6) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Variable Rates
- **PR1050558-1108** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Variable Rates
- **PR1050558-1109** (Sprint 6) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Stipend Rates
- **PR1050558-1109** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Stipend Rates
- **PR1050558-1110** (Sprint 6) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Leadership Incentives
- **PR1050558-1110** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Leadership Incentives
- **PR1050558-1111** (Sprint 6) - Configuration | Tech: N/A | Standardize Service Line Records
- **PR1050558-1112** (Sprint 6) - Configuration | Tech: N/A | Update Case layout - Clinician Intake Form & Risk Review
- **PR1050558-1112** (Sprint 7) - Configuration | Tech: N/A | Update Case layout - Clinician Intake Form & Risk Review
- **PR1050558-1113** (Sprint 6) - OmniStudio | Tech: Integration Procedure | Risk Review - Populate AccountId with Service Account
- **PR1050558-1138** (Sprint 6) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Leased or Locums - Create/update
- **PR1050558-1138** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician Contract Request: Leased or Locums - Create/update
- **PR1050558-1168** (Sprint 7) - Apex Development | Tech: Apex, Flow | Risk Review - Auto Inactivate HPFs when denied
- **PR1050558-1172** (Sprint 6) - General | Tech: N/A | Enrollment Specialist - Update Test User
- **PR1050558-1172** (Sprint 7) - General | Tech: N/A | Enrollment Specialist - Update Test User
- **PR1050558-1173** (Sprint 6) - Configuration | Tech: N/A | Pay Code Association to Client/Clinician
- **PR1050558-123** (Sprint 2) - Flow Automation | Tech: Flow | Guided Create HPF: Clinician Info
- **PR1050558-1240** (Sprint 6) - Flow Automation | Tech: Flow | Clinician Contract Summary UI - Connect Clinician Rate to Fa
- **PR1050558-1243** (Sprint 6) - Configuration | Tech: N/A | Client Contract Update - Pay Code Association
- **PR1050558-1256** (Sprint 6) - Apex Development | Tech: Apex | Contract Selection During Manually Initiated Onboarding
- **PR1050558-1256** (Sprint 7) - Apex Development | Tech: Apex | Contract Selection During Manually Initiated Onboarding
- **PR1050558-1257** (Sprint 6) - Security Setup | Tech: N/A | Update Test Users - Add Public Groups
- **PR1050558-1257** (Sprint 7) - Security Setup | Tech: N/A | Update Test Users - Add Public Groups
- **PR1050558-1305** (Sprint 6) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-1317** (Sprint 6) - Flow Automation | Tech: Flow | Clinician Contract - Prevent Active EE/IC at the same time
- **PR1050558-1317** (Sprint 7) - Flow Automation | Tech: Flow | Clinician Contract - Prevent Active EE/IC at the same time
- **PR1050558-1332** (Sprint 6) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Select Employment Type
- **PR1050558-1334** (Sprint 7) - OmniStudio | Tech: Integration Procedure | Clinician "At a Glance" Status Calculation
- **PR1050558-1364** (Sprint 6) - Apex Development | Tech: Apex | Clinician Onboarding Record Automation - SCP Onboarding - Up
- **PR1050558-1366** (Sprint 6) - Flow Automation | Tech: Flow, OmniScript | Facility Rate Creation - Add Error Message if no available S
- **PR1050558-1367** (Sprint 6) - Configuration | Tech: N/A | Pay Code Data Load
- **PR1050558-1368** (Sprint 6) - General | Tech: N/A | Add Banner to HC Portal
- **PR1050558-1368** (Sprint 7) - General | Tech: N/A | Add Banner to HC Portal
- **PR1050558-1369** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automatic Corporate Entity Association at HPF Create
- **PR1050558-1369** (Sprint 8) - Apex Development | Tech: Apex, Flow | Automatic Corporate Entity Association at HPF Create
- **PR1050558-1387** (Sprint 6) - Security Setup | Tech: N/A | Integration User Access
- **PR1050558-1387** (Sprint 7) - Security Setup | Tech: N/A | Integration User Access
- **PR1050558-1389** (Sprint 6) - Configuration | Tech: N/A | Clinician Contract Request: Summary Screen - Add HPF
- **PR1050558-1392** (Sprint 7) - OmniStudio | Tech: OmniScript | Update Clinician Taxonomy Selection
- **PR1050558-1392** (Sprint 8) - OmniStudio | Tech: OmniScript | Update Clinician Taxonomy Selection
- **PR1050558-1415** (Sprint 7) - Configuration | Tech: N/A | Creating Shifts - Physician or NP/PA
- **PR1050558-1419** (Sprint 7) - Flow Automation | Tech: Flow | Client Rate Configuration - Cloning and Editing
- **PR1050558-1435** (Sprint 6) - Configuration | Tech: N/A | Auto Create Relationship Records for CPA - CPA Review Object
- **PR1050558-144** (Sprint 2) - LWC/Aura Component | Tech: Aura | Prospect Portal Login & Home
- **PR1050558-145** (Sprint 4) - Configuration | Tech: N/A | Manual Onboarding Case Creation
- **PR1050558-146** (Sprint 7) - Configuration | Tech: Apex, Validation Rule | Auto Create Relationship Records for CPA - Nurse Practitione
- **PR1050558-147** (Sprint 2) - Configuration | Tech: N/A | CPA Relationship and Contract Records
- **PR1050558-1568** (Sprint 6) - LWC/Aura Component | Tech: Flow | Submit Pro Forma Model for Approval - Layout updates
- **PR1050558-1568** (Sprint 7) - LWC/Aura Component | Tech: Flow | Submit Pro Forma Model for Approval - Layout updates
- **PR1050558-1568** (Sprint 8) - LWC/Aura Component | Tech: Flow | Submit Pro Forma Model for Approval - Layout updates
- **PR1050558-1580** (Sprint 7) - General | Tech: Apex | Enhanced Clinician Inactivation: HPF Status Updates
- **PR1050558-1580** (Sprint 8) - General | Tech: Apex | Enhanced Clinician Inactivation: HPF Status Updates
- **PR1050558-1580** (Sprint 9) - General | Tech: Apex | Enhanced Clinician Inactivation: HPF Status Updates
- **PR1050558-1582** (Sprint 7) - Configuration | Tech: N/A | Tactical Team Queue
- **PR1050558-1583** (Sprint 7) - General | Tech: N/A | Add SCP Logo to Prospect Portal
- **PR1050558-1583** (Sprint 8) - General | Tech: N/A | Add SCP Logo to Prospect Portal
- **PR1050558-1584** (Sprint 10) - Apex Development | Tech: Apex | Clinician Contract Auto Populate Client Rate
- **PR1050558-1589** (Sprint 6) - Apex Development | Tech: Apex, Flow | Platform Event - First Scheduled Date
- **PR1050558-1589** (Sprint 7) - Apex Development | Tech: Apex, Flow | Platform Event - First Scheduled Date
- **PR1050558-1589** (Sprint 8) - Apex Development | Tech: Apex, Flow | Platform Event - First Scheduled Date
- **PR1050558-1628** (Sprint 7) - General | Tech: N/A | Approval Work Items
- **PR1050558-1628** (Sprint 8) - General | Tech: N/A | Approval Work Items
- **PR1050558-1635** (Sprint 6) - General | Tech: N/A | Clinician Application Visibility - Update Permissions
- **PR1050558-164** (Sprint 1) - General | Tech: N/A | Project Management Tool Installation
- **PR1050558-165** (Sprint 1) - Configuration | Tech: N/A | Permission Sets
- **PR1050558-1651** (Sprint 7) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-1651** (Sprint 8) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-1653** (Sprint 8) - General | Tech: N/A | Clinician "At a Glance" - Offboarding
- **PR1050558-1655** (Sprint 7) - Configuration | Tech: Apex, Validation Rule | Auto Create Relationship Records for CPA - Physician
- **PR1050558-1659** (Sprint 7) - Configuration | Tech: N/A | Clinician Contract Special Terms
- **PR1050558-166** (Sprint 1) - Security Setup | Tech: N/A | Permission Set Groups
- **PR1050558-1660** (Sprint 7) - Flow Automation | Tech: Flow | Initiate Clinical Match Process
- **PR1050558-1666** (Sprint 7) - Configuration | Tech: N/A | Clinician Contract: Other Bonus Details
- **PR1050558-1667** (Sprint 10) - Configuration | Tech: N/A | Add Account Contact Relationship
- **PR1050558-1667** (Sprint 9) - Configuration | Tech: N/A | Add Account Contact Relationship
- **PR1050558-167** (Sprint 6) - Configuration | Tech: N/A | Collaborative Practice Agreement Legal Requirements
- **PR1050558-1675** (Sprint 8) - Configuration | Tech: N/A | Client Needs Questionnaire - Data Collection
- **PR1050558-1675** (Sprint 9) - Configuration | Tech: N/A | Client Needs Questionnaire - Data Collection
- **PR1050558-1676** (Sprint 8) - Configuration | Tech: N/A | Client Contracting - “LOI Request”
- **PR1050558-1676** (Sprint 9) - Configuration | Tech: N/A | Client Contracting - “LOI Request”
- **PR1050558-1677** (Sprint 10) - Apex Development | Tech: Apex, Flow | Automatically Update the Opportunity Status
- **PR1050558-1677** (Sprint 9) - Apex Development | Tech: Apex, Flow | Automatically Update the Opportunity Status
- **PR1050558-1678** (Sprint 11) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation - Contract Status = E
- **PR1050558-1678** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation - Contract Status = E
- **PR1050558-1679** (Sprint 11) - Apex Development | Tech: Apex, Flow | Client Onboarding - Trigger Auto task creation
- **PR1050558-1679** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Trigger Auto task creation
- **PR1050558-168** (Sprint 1) - Security Setup | Tech: N/A | Account Edit Access
- **PR1050558-1682** (Sprint 11) - Apex Development | Tech: Apex, Flow, JavaScript | Facility Change Request: Clinician Side Manual  Change Manag
- **PR1050558-1682** (Sprint 12) - Apex Development | Tech: Apex, Flow, JavaScript | Facility Change Request: Clinician Side Manual  Change Manag
- **PR1050558-1683** (Sprint 11) - Apex Development | Tech: Apex, Flow | Facility Term: Auto Create Cases
- **PR1050558-1683** (Sprint 12) - Apex Development | Tech: Apex, Flow | Facility Term: Auto Create Cases
- **PR1050558-1684** (Sprint 11) - General | Tech: N/A | Facility Term: Auto Create Tasks
- **PR1050558-1684** (Sprint 12) - General | Tech: N/A | Facility Term: Auto Create Tasks
- **PR1050558-1696** (Sprint 8) - Flow Automation | Tech: Flow | Clinician Contract: Set Start Date
- **PR1050558-1703** (Sprint 7) - General | Tech: N/A | Corporate Entity Mismatch Queue
- **PR1050558-1703** (Sprint 8) - General | Tech: N/A | Corporate Entity Mismatch Queue
- **PR1050558-1704** (Sprint 7) - Configuration | Tech: N/A | View HPFs from Clinician Contract
- **PR1050558-1704** (Sprint 8) - Configuration | Tech: N/A | View HPFs from Clinician Contract
- **PR1050558-1707** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinical Match Approval
- **PR1050558-1708** (Sprint 7) - Configuration | Tech: Validation Rule, Formula Field, REST | Manage Sister Relationships
- **PR1050558-1709** (Sprint 6) - Security Setup | Tech: N/A | Role Hierarchy - Add VP DB Finance & SVP Growth
- **PR1050558-1709** (Sprint 7) - Security Setup | Tech: N/A | Role Hierarchy - Add VP DB Finance & SVP Growth
- **PR1050558-1710** (Sprint 6) - Configuration | Tech: N/A | Integration User - Edit HPF
- **PR1050558-1710** (Sprint 7) - Configuration | Tech: N/A | Integration User - Edit HPF
- **PR1050558-1712** (Sprint 7) - Configuration | Tech: N/A | Update Sharing Settings
- **PR1050558-1717** (Sprint 8) - Apex Development | Tech: Apex, Flow | Healthcare Practitioner Facility Management
- **PR1050558-1718** (Sprint 7) - Apex Development | Tech: Apex, Flow | Clinician Contract Management
- **PR1050558-1719** (Sprint 7) - Apex Development | Tech: Apex, Flow | Healthcare Practitioner Facility Status Automation
- **PR1050558-1720** (Sprint 8) - Apex Development | Tech: Apex, Flow | Intake Form: Automated Task Creation to Review Corporation a
- **PR1050558-1720** (Sprint 9) - Apex Development | Tech: Apex, Flow | Intake Form: Automated Task Creation to Review Corporation a
- **PR1050558-1721** (Sprint 8) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Start Admin Work Ahead of Clinic
- **PR1050558-1721** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Start Admin Work Ahead of Clinic
- **PR1050558-1722** (Sprint 8) - Apex Development | Tech: Apex, Flow | Executed Contract: Automate Task Creation for Locums
- **PR1050558-1722** (Sprint 9) - Apex Development | Tech: Apex, Flow | Executed Contract: Automate Task Creation for Locums
- **PR1050558-1723** (Sprint 11) - Security Setup | Tech: N/A | Executed Contract: Automate Email to Clinician with mySCP In
- **PR1050558-1723** (Sprint 12) - Security Setup | Tech: N/A | Executed Contract: Automate Email to Clinician with mySCP In
- **PR1050558-1723** (Sprint 12.1) - Security Setup | Tech: N/A | Executed Contract: Automate Email to Clinician with mySCP In
- **PR1050558-1725** (Sprint 10) - LWC/Aura Component | Tech: N/A | Clinician Support Case
- **PR1050558-1725** (Sprint 9) - LWC/Aura Component | Tech: N/A | Clinician Support Case
- **PR1050558-1726** (Sprint 10) - Flow Automation | Tech: Flow | Inactivation Alert Automated Email
- **PR1050558-1726** (Sprint 9) - Flow Automation | Tech: Flow | Inactivation Alert Automated Email
- **PR1050558-1727** (Sprint 8) - Flow Automation | Tech: Flow, OmniScript | Offboarding Cases
- **PR1050558-1727** (Sprint 9) - Flow Automation | Tech: Flow, OmniScript | Offboarding Cases
- **PR1050558-1728** (Sprint 8) - Apex Development | Tech: Apex, Flow | Offboarding Tasks - Facility Specific
- **PR1050558-1728** (Sprint 9) - Apex Development | Tech: Apex, Flow | Offboarding Tasks - Facility Specific
- **PR1050558-1733** (Sprint 8) - Apex Development | Tech: Apex, Flow | Offboarding Tasks - SCP
- **PR1050558-1733** (Sprint 9) - Apex Development | Tech: Apex, Flow | Offboarding Tasks - SCP
- **PR1050558-1736** (Sprint 12) - General | Tech: N/A | Client Contract Request View for Legal
- **PR1050558-1736** (Sprint 12.1) - General | Tech: N/A | Client Contract Request View for Legal
- **PR1050558-1739** (Sprint 10) - OmniStudio | Tech: OmniScript | Facility Change Request: Rates & Coverage 1 of 2
- **PR1050558-1740** (Sprint 9) - Flow Automation | Tech: Flow | Facility Change Request: Approvals
- **PR1050558-1747** (Sprint 6) - Configuration | Tech: Formula Field | Integration User - Add New Provider Network Contract fields
- **PR1050558-1747** (Sprint 7) - Configuration | Tech: Formula Field | Integration User - Add New Provider Network Contract fields
- **PR1050558-1749** (Sprint 7) - Configuration | Tech: Formula Field | Integration User - Remove old Provider Network Contract fiel
- **PR1050558-1750** (Sprint 10) - Apex Development | Tech: Apex, Flow | Clinician Agreement Approval Process: VPO
- **PR1050558-1772** (Sprint 7) - Apex Development | Tech: Apex | CDC Channel: Update ContractTrigger
- **PR1050558-1772** (Sprint 8) - Apex Development | Tech: Apex | CDC Channel: Update ContractTrigger
- **PR1050558-1773** (Sprint 8) - Configuration | Tech: N/A | Client Shift Rate Configuration
- **PR1050558-1775** (Sprint 7) - Configuration | Tech: N/A | Offboarding Case Record Type Setup
- **PR1050558-1775** (Sprint 8) - Configuration | Tech: N/A | Offboarding Case Record Type Setup
- **PR1050558-1787** (Sprint 7) - Security Setup | Tech: N/A | Add Account Contact Relationship to Service Account
- **PR1050558-1787** (Sprint 8) - Security Setup | Tech: N/A | Add Account Contact Relationship to Service Account
- **PR1050558-1789** (Sprint 7) - Apex Development | Tech: Apex, Flow, REST | Automatically Provision HC Portal Access: Update ATS Stage
- **PR1050558-1792** (Sprint 8) - General | Tech: N/A | Approval Work Items - List View Updates
- **PR1050558-1792** (Sprint 9) - General | Tech: N/A | Approval Work Items - List View Updates
- **PR1050558-1794** (Sprint 10) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-1794** (Sprint 11) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-1798** (Sprint 8) - Apex Development | Tech: Apex, Flow | Client Needs Questionnaire - Auto Task Creation for Internal
- **PR1050558-1798** (Sprint 9) - Apex Development | Tech: Apex, Flow | Client Needs Questionnaire - Auto Task Creation for Internal
- **PR1050558-1799** (Sprint 8) - Configuration | Tech: REST | Client Contracting - Early Start Confirmed
- **PR1050558-1799** (Sprint 9) - Configuration | Tech: REST | Client Contracting - Early Start Confirmed
- **PR1050558-1800** (Sprint 11) - Configuration | Tech: N/A | Facility Term: Review Clinician Roster
- **PR1050558-1800** (Sprint 12) - Configuration | Tech: N/A | Facility Term: Review Clinician Roster
- **PR1050558-1809** (Sprint 10) - General | Tech: N/A | Clinician Contract List Views - Update All Clinician Contrac
- **PR1050558-19** (Sprint 1) - Security Setup | Tech: N/A | Test Users
- **PR1050558-192** (Sprint 2) - OmniStudio | Tech: OmniScript, Validation Rule | NPI Management
- **PR1050558-193** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinical Match Group Indicator
- **PR1050558-194** (Sprint 6) - LWC/Aura Component | Tech: Flow, OmniScript | Clinician Contract Request: Bonus
- **PR1050558-194** (Sprint 7) - LWC/Aura Component | Tech: Flow, OmniScript | Clinician Contract Request: Bonus
- **PR1050558-195** (Sprint 2) - Apex Development | Tech: Apex, Flow | Guided Clinician Creation
- **PR1050558-199** (Sprint 10) - Flow Automation | Tech: Flow, OmniScript | Guided Screening Call Field Updates
- **PR1050558-199** (Sprint 9) - Flow Automation | Tech: Flow, OmniScript | Guided Screening Call Field Updates
- **PR1050558-20** (Sprint 1) - General | Tech: N/A | OmniStudio Installation
- **PR1050558-201** (Sprint 1) - Security Setup | Tech: N/A | Corporate Support Permission Set Updates
- **PR1050558-2011** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automated Onboarding Task Record Closure: Facility Onboardin
- **PR1050558-2013** (Sprint 7) - Security Setup | Tech: N/A | Update Role Name to VP BD Finance
- **PR1050558-2015** (Sprint 8) - OmniStudio | Tech: OmniScript | Clinician Offboarding - Termination Details for Locums
- **PR1050558-2015** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Offboarding - Termination Details for Locums
- **PR1050558-2016** (Sprint 7) - General | Tech: N/A | Update Facility Title Record for Ambassador NP/PA
- **PR1050558-2018** (Sprint 9) - OmniStudio | Tech: OmniScript | NP/PA Tier Management: Client
- **PR1050558-2021** (Sprint 8) - OmniStudio | Tech: OmniScript | Clinician Offboarding: EE Involuntary Termination
- **PR1050558-2021** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Offboarding: EE Involuntary Termination
- **PR1050558-2023** (Sprint 10) - General | Tech: N/A | Approval Work Item - Replace Approval Trace component
- **PR1050558-204** (Sprint 4) - Integration | Tech: REST | Prospect Portal Home Page & Record Detail
- **PR1050558-205** (Sprint 1) - Configuration | Tech: N/A | Configure Service Line Object
- **PR1050558-208** (Sprint 4) - General | Tech: N/A | View Provider Network Contract on Contract Record
- **PR1050558-2081** (Sprint 8) - Security Setup | Tech: N/A | Opportunity Team (Deal Team)
- **PR1050558-2081** (Sprint 9) - Security Setup | Tech: N/A | Opportunity Team (Deal Team)
- **PR1050558-2086** (Sprint 6) - OmniStudio | Tech: OmniScript, Formula Field | Clinician Contract Request: Bonus - Enforce additional bonus
- **PR1050558-2086** (Sprint 7) - OmniStudio | Tech: OmniScript, Formula Field | Clinician Contract Request: Bonus - Enforce additional bonus
- **PR1050558-2087** (Sprint 11) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation -  “Green Light for C
- **PR1050558-2087** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation -  “Green Light for C
- **PR1050558-2088** (Sprint 11) - General | Tech: N/A | Client Onboarding - Auto Task Creation - Manually Confirm On
- **PR1050558-2088** (Sprint 12) - General | Tech: N/A | Client Onboarding - Auto Task Creation - Manually Confirm On
- **PR1050558-2089** (Sprint 7) - General | Tech: N/A | Clinician Contract Request: Update Naming Convention for Con
- **PR1050558-209** (Sprint 2) - OmniStudio | Tech: OmniScript | Guided Create HPF: Facility Selection
- **PR1050558-210** (Sprint 5) - LWC/Aura Component | Tech: LWC, OmniScript, Integration Procedure | Clinician Contract Request: Shift Rates
- **PR1050558-210** (Sprint 6) - LWC/Aura Component | Tech: LWC, OmniScript, Integration Procedure | Clinician Contract Request: Shift Rates
- **PR1050558-2108** (Sprint 8) - Flow Automation | Tech: Flow | Error Log: Workday Duplicate Tax ID
- **PR1050558-2112** (Sprint 8) - Security Setup | Tech: N/A | Review User Profile Key Field
- **PR1050558-2112** (Sprint 9) - Security Setup | Tech: N/A | Review User Profile Key Field
- **PR1050558-2113** (Sprint 8) - Configuration | Tech: N/A | Review Bootcamp and Proctor Fields
- **PR1050558-2113** (Sprint 9) - Configuration | Tech: N/A | Review Bootcamp and Proctor Fields
- **PR1050558-2114** (Sprint 10) - Configuration | Tech: N/A | Review Credentialling Fields
- **PR1050558-2114** (Sprint 9) - Configuration | Tech: N/A | Review Credentialling Fields
- **PR1050558-2118** (Sprint 8) - Flow Automation | Tech: Flow | Clinician Contract: Auto Populate Contracting Corporate Enti
- **PR1050558-2118** (Sprint 9) - Flow Automation | Tech: Flow | Clinician Contract: Auto Populate Contracting Corporate Enti
- **PR1050558-2119** (Sprint 8) - Apex Development | Tech: Apex, Flow | New HPF for Already Active Clinicians
- **PR1050558-2119** (Sprint 9) - Apex Development | Tech: Apex, Flow | New HPF for Already Active Clinicians
- **PR1050558-2120** (Sprint 12) - Flow Automation | Tech: Flow | Workday Hire Date Change
- **PR1050558-2120** (Sprint 12.1) - Flow Automation | Tech: Flow | Workday Hire Date Change
- **PR1050558-2123** (Sprint 8) - Configuration | Tech: N/A | Clinician Contract Request: Bonus Details
- **PR1050558-2126** (Sprint 9) - Configuration | Tech: N/A | HC Portal Flip from Login to SSO
- **PR1050558-2137** (Sprint 8) - Apex Development | Tech: Apex, Flow | Auto Create Client Contract (Practice Operations)
- **PR1050558-2137** (Sprint 9) - Apex Development | Tech: Apex, Flow | Auto Create Client Contract (Practice Operations)
- **PR1050558-2139** (Sprint 11) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation - LOI Executed
- **PR1050558-2139** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation - LOI Executed
- **PR1050558-2142** (Sprint 8) - Configuration | Tech: N/A | Contract Object Record Type Setup
- **PR1050558-2142** (Sprint 9) - Configuration | Tech: N/A | Contract Object Record Type Setup
- **PR1050558-2143** (Sprint 8) - Configuration | Tech: N/A | Opportunity & Services Objects Info Due Updates
- **PR1050558-2143** (Sprint 9) - Configuration | Tech: N/A | Opportunity & Services Objects Info Due Updates
- **PR1050558-2150** (Sprint 8) - LWC/Aura Component | Tech: N/A | Update Corporation and Tax Information
- **PR1050558-2150** (Sprint 9) - LWC/Aura Component | Tech: N/A | Update Corporation and Tax Information
- **PR1050558-2151** (Sprint 11) - Apex Development | Tech: Apex, Flow | Auto Create Client Contract (Practice Operations) - Task Cre
- **PR1050558-2151** (Sprint 12) - Apex Development | Tech: Apex, Flow | Auto Create Client Contract (Practice Operations) - Task Cre
- **PR1050558-2152** (Sprint 8) - General | Tech: N/A | Services Object - Set History Tracking & Layout Updates
- **PR1050558-2152** (Sprint 9) - General | Tech: N/A | Services Object - Set History Tracking & Layout Updates
- **PR1050558-2162** (Sprint 8) - Configuration | Tech: N/A | Clinician Attributes from Workday to Salesforce
- **PR1050558-2162** (Sprint 9) - Configuration | Tech: N/A | Clinician Attributes from Workday to Salesforce
- **PR1050558-217** (Sprint 2) - Security Setup | Tech: N/A | Add LRP and Page Layouts to System Administrator
- **PR1050558-2182** (Sprint 8) - Apex Development | Tech: Apex, Flow | Enable Integration to Workday for SCP Offboarding - 1 of 2
- **PR1050558-2182** (Sprint 9) - Apex Development | Tech: Apex, Flow | Enable Integration to Workday for SCP Offboarding - 1 of 2
- **PR1050558-2186** (Sprint 8) - Configuration | Tech: N/A | Clinical Match Case Record Type - Update Sharing Rule
- **PR1050558-2186** (Sprint 9) - Configuration | Tech: N/A | Clinical Match Case Record Type - Update Sharing Rule
- **PR1050558-219** (Sprint 3) - Flow Automation | Tech: Flow, OmniScript, REST | Clinician Risk Review
- **PR1050558-2208** (Sprint 8) - Apex Development | Tech: Apex, Flow | HPF Inactive Date Trigger to Qgenda
- **PR1050558-2210** (Sprint 9) - Configuration | Tech: N/A | Clinician Contract Request: Update CPA naming
- **PR1050558-2219** (Sprint 8) - OmniStudio | Tech: OmniScript | Intake Form: Automated Task Creation to Review Name Change
- **PR1050558-2219** (Sprint 9) - OmniStudio | Tech: OmniScript | Intake Form: Automated Task Creation to Review Name Change
- **PR1050558-2220** (Sprint 8) - OmniStudio | Tech: OmniScript | Intake Form: Automated Task Creation to Review NPI
- **PR1050558-2220** (Sprint 9) - OmniStudio | Tech: OmniScript | Intake Form: Automated Task Creation to Review NPI
- **PR1050558-2224** (Sprint 10) - Security Setup | Tech: N/A | Open Shift APAY Request - Security Matrix updates
- **PR1050558-2224** (Sprint 9) - Security Setup | Tech: N/A | Open Shift APAY Request - Security Matrix updates
- **PR1050558-2225** (Sprint 9) - LWC/Aura Component | Tech: N/A | Related Clinician Records - Add Collaborative Practice Agree
- **PR1050558-2227** (Sprint 10) - Configuration | Tech: N/A | Client Rate Configuration - Cloning and Editing - "Re-Add"
- **PR1050558-2228** (Sprint 8) - General | Tech: N/A | Improve Provider Network Contract related list component loo
- **PR1050558-2235** (Sprint 9) - Flow Automation | Tech: Flow, OmniScript | NP/PA Tier Management: Clinician 1 of 2
- **PR1050558-2237** (Sprint 10) - General | Tech: N/A | Clinician Onboarding Case & Task Updates
- **PR1050558-2237** (Sprint 9) - General | Tech: N/A | Clinician Onboarding Case & Task Updates
- **PR1050558-2238** (Sprint 10) - OmniStudio | Tech: OmniScript | Clinician Contract Update: Rate Pay Code
- **PR1050558-2238** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract Update: Rate Pay Code
- **PR1050558-2239** (Sprint 10) - Apex Development | Tech: Apex, Flow | Clinician Contracting - Job Requisition Handoff to Asymbl
- **PR1050558-226** (Sprint 4) - Security Setup | Tech: N/A | Salesforce App Cleanup
- **PR1050558-227** (Sprint 4) - Configuration | Tech: N/A | Account Hierarchy Columns
- **PR1050558-23** (Sprint 1) - Configuration | Tech: N/A | Create Clinician Person Accounts
- **PR1050558-231** (Sprint 8) - Configuration | Tech: N/A | Intake Form - Clinician Profile Updates
- **PR1050558-232** (Sprint 3) - Security Setup | Tech: N/A | Integration Profile and Permission Set
- **PR1050558-234** (Sprint 3) - Configuration | Tech: N/A | Standardize State Picklist Values
- **PR1050558-235** (Sprint 3) - Apex Development | Tech: Apex | CDC Channel
- **PR1050558-236** (Sprint 4) - General | Tech: N/A | Portal Login
- **PR1050558-2418** (Sprint 10) - Apex Development | Tech: Apex, Flow, Validation Rule | Insurance Provided By Validation Rule
- **PR1050558-2418** (Sprint 9) - Apex Development | Tech: Apex, Flow, Validation Rule | Insurance Provided By Validation Rule
- **PR1050558-242** (Sprint 2) - Configuration | Tech: N/A | Update Standard Care Fee Agreement to Preventive Care Agreem
- **PR1050558-2421** (Sprint 10) - Flow Automation | Tech: Flow | Automated Case Record Closure: Offboarding
- **PR1050558-2421** (Sprint 9) - Flow Automation | Tech: Flow | Automated Case Record Closure: Offboarding
- **PR1050558-2422** (Sprint 10) - Configuration | Tech: N/A | Service Account Attributes
- **PR1050558-2422** (Sprint 9) - Configuration | Tech: N/A | Service Account Attributes
- **PR1050558-2423** (Sprint 8) - Configuration | Tech: N/A | Clinician Contract: Set Start Date for Cloned Contract
- **PR1050558-243** (Sprint 2) - General | Tech: N/A | External Client Apps APP for Mulesoft
- **PR1050558-2430** (Sprint 9) - Configuration | Tech: N/A | Update Bonus Configuration for Client and Clinician
- **PR1050558-2431** (Sprint 10) - Configuration | Tech: N/A | Update Clinician Visa Data Model
- **PR1050558-2431** (Sprint 9) - Configuration | Tech: N/A | Update Clinician Visa Data Model
- **PR1050558-2436** (Sprint 7) - General | Tech: Apex | Enhanced Clinician Inactivation: Case and Task Closure
- **PR1050558-2436** (Sprint 8) - General | Tech: Apex | Enhanced Clinician Inactivation: Case and Task Closure
- **PR1050558-2441** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Client Agreement Request Case Layo
- **PR1050558-2441** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Client Agreement Request Case Layo
- **PR1050558-2442** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Contract Request - Letter of Intent - Status & Key Da
- **PR1050558-2442** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Client Contract Request - Letter of Intent - Status & Key Da
- **PR1050558-2447** (Sprint 8) - OmniStudio | Tech: OmniScript | Set up Discovery framework - Configuration
- **PR1050558-2447** (Sprint 9) - OmniStudio | Tech: OmniScript | Set up Discovery framework - Configuration
- **PR1050558-245** (Sprint 3) - Security Setup | Tech: N/A | Update Related Lists on Clinician Record
- **PR1050558-2450** (Sprint 8) - General | Tech: Apex | Enhanced Clinician Inactivation: Case and Task Closure
- **PR1050558-2450** (Sprint 9) - General | Tech: Apex | Enhanced Clinician Inactivation: Case and Task Closure
- **PR1050558-246** (Sprint 5) - Apex Development | Tech: Apex, Flow | Risk Review Approvals - Submit
- **PR1050558-2462** (Sprint 10) - Apex Development | Tech: Apex, Flow | Enable Integration to Workday for SCP Offboarding - 2 of 2
- **PR1050558-2462** (Sprint 9) - Apex Development | Tech: Apex, Flow | Enable Integration to Workday for SCP Offboarding - 2 of 2
- **PR1050558-2467** (Sprint 10) - OmniStudio | Tech: OmniScript | Clinician Contract: Leased and Locums Update to Executed Sta
- **PR1050558-2467** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract: Leased and Locums Update to Executed Sta
- **PR1050558-2468** (Sprint 10) - General | Tech: N/A | Collaborative Practice Agreement Review UI: Name Fields
- **PR1050558-2468** (Sprint 9) - General | Tech: N/A | Collaborative Practice Agreement Review UI: Name Fields
- **PR1050558-2469** (Sprint 10) - Configuration | Tech: Formula Field | Open Shift APAY Request: Approval
- **PR1050558-2469** (Sprint 9) - Configuration | Tech: Formula Field | Open Shift APAY Request: Approval
- **PR1050558-247** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automated Onboarding Task Creation - Facility Onboarding
- **PR1050558-2471** (Sprint 10) - OmniStudio | Tech: OmniScript | Clinician Offboarding - Termination Details Update
- **PR1050558-2471** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Offboarding - Termination Details Update
- **PR1050558-2472** (Sprint 12) - Configuration | Tech: N/A | Clinician Offboarding: Backfill Needed
- **PR1050558-2472** (Sprint 12.1) - Configuration | Tech: N/A | Clinician Offboarding: Backfill Needed
- **PR1050558-2473** (Sprint 10) - Flow Automation | Tech: Flow | Clinician Offboarding: Termination Updates
- **PR1050558-2473** (Sprint 9) - Flow Automation | Tech: Flow | Clinician Offboarding: Termination Updates
- **PR1050558-2474** (Sprint 10) - LWC/Aura Component | Tech: LWC, Flow, OmniScript | Clinician Offboarding: Connect Termination and Clinical Matc
- **PR1050558-2474** (Sprint 11) - LWC/Aura Component | Tech: LWC, Flow, OmniScript | Clinician Offboarding: Connect Termination and Clinical Matc
- **PR1050558-248** (Sprint 3) - Security Setup | Tech: N/A | OmniStudio Permission Set
- **PR1050558-249** (Sprint 6) - Configuration | Tech: N/A | Pay Code Management
- **PR1050558-2526** (Sprint 9) - General | Tech: N/A | Clinician Contract Request: Add hide/show logic for "Submit 
- **PR1050558-2527** (Sprint 9) - Configuration | Tech: N/A | Clinician Contract - Update Related Lists (Approval Work Ite
- **PR1050558-2528** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Shift Rate Details - Populate Ty
- **PR1050558-2551** (Sprint 10) - OmniStudio | Tech: OmniScript | Conditional Requirements for Clinician NPI
- **PR1050558-2551** (Sprint 9) - OmniStudio | Tech: OmniScript | Conditional Requirements for Clinician NPI
- **PR1050558-2552** (Sprint 10) - Security Setup | Tech: N/A | Update Permissions for List Views
- **PR1050558-2552** (Sprint 9) - Security Setup | Tech: N/A | Update Permissions for List Views
- **PR1050558-2554** (Sprint 10) - Configuration | Tech: N/A | Locums Rate Management
- **PR1050558-2554** (Sprint 9) - Configuration | Tech: N/A | Locums Rate Management
- **PR1050558-2557** (Sprint 9) - OmniStudio | Tech: OmniScript | Initiate Leadership Change from Service Account
- **PR1050558-2558** (Sprint 10) - Apex Development | Tech: Apex, Flow | Clinician Contract Date Alignment
- **PR1050558-2558** (Sprint 9) - Apex Development | Tech: Apex, Flow | Clinician Contract Date Alignment
- **PR1050558-2559** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract Update: Add Time Type
- **PR1050558-2592** (Sprint 9) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Bonus Details - Update Payments
- **PR1050558-2593** (Sprint 9) - Apex Development | Tech: Apex, Validation Rule | Clinician Contract Request: Contract Changes - Cloning updat
- **PR1050558-2616** (Sprint 10) - Configuration | Tech: N/A | Update Case Related Lists on Clinician Record
- **PR1050558-2616** (Sprint 9) - Configuration | Tech: N/A | Update Case Related Lists on Clinician Record
- **PR1050558-2620** (Sprint 8) - Configuration | Tech: N/A | Incorrect picklist values in Status field using Contract Rec
- **PR1050558-2623** (Sprint 9) - Apex Development | Tech: Apex, Flow | Notification to Workday for First Clinical Shift Change
- **PR1050558-2624** (Sprint 8) - Security Setup | Tech: N/A | Sales VP Persona don't have access to Edit the Green Light f
- **PR1050558-2630** (Sprint 10) - General | Tech: N/A | Contracts Page Update - Add Path
- **PR1050558-2634** (Sprint 10) - General | Tech: N/A | Contract (Client Contract) - Add Case Related List
- **PR1050558-2635** (Sprint 10) - Configuration | Tech: N/A | Account (Service Account) - Add Case Related List
- **PR1050558-2636** (Sprint 10) - Security Setup | Tech: N/A | Deal Team/Account Team Role Updates
- **PR1050558-2636** (Sprint 9) - Security Setup | Tech: N/A | Deal Team/Account Team Role Updates
- **PR1050558-2637** (Sprint 11) - Flow Automation | Tech: Flow | Facility Term: Auto Close Cases
- **PR1050558-2637** (Sprint 12) - Flow Automation | Tech: Flow | Facility Term: Auto Close Cases
- **PR1050558-2638** (Sprint 11) - Flow Automation | Tech: Flow | Facility Term: Offboarding Email
- **PR1050558-2638** (Sprint 12) - Flow Automation | Tech: Flow | Facility Term: Offboarding Email
- **PR1050558-2659** (Sprint 10) - Apex Development | Tech: Apex, Flow, Formula Field | Clinicians Contract Request: Fields Needed to Determine Adde
- **PR1050558-2659** (Sprint 11) - Apex Development | Tech: Apex, Flow, Formula Field | Clinicians Contract Request: Fields Needed to Determine Adde
- **PR1050558-2670** (Sprint 10) - Apex Development | Tech: Apex, Flow | Clinician Name Change Requests
- **PR1050558-2670** (Sprint 9) - Apex Development | Tech: Apex, Flow | Clinician Name Change Requests
- **PR1050558-2672** (Sprint 10) - Apex Development | Tech: Apex, Flow | Business Entity Change Requests
- **PR1050558-2672** (Sprint 9) - Apex Development | Tech: Apex, Flow | Business Entity Change Requests
- **PR1050558-2673** (Sprint 10) - Apex Development | Tech: Apex, Flow | Military Status Change Requests
- **PR1050558-2673** (Sprint 9) - Apex Development | Tech: Apex, Flow | Military Status Change Requests
- **PR1050558-2675** (Sprint 10) - LWC/Aura Component | Tech: N/A | Case (RT: Clinician Change) & “Data Quality” queue
- **PR1050558-2675** (Sprint 9) - LWC/Aura Component | Tech: N/A | Case (RT: Clinician Change) & “Data Quality” queue
- **PR1050558-2676** (Sprint 10) - Configuration | Tech: N/A | Clinician Offboarding - Termination Details Updates for Locu
- **PR1050558-2676** (Sprint 9) - Configuration | Tech: N/A | Clinician Offboarding - Termination Details Updates for Locu
- **PR1050558-2677** (Sprint 10) - Configuration | Tech: N/A | Clinician Offboarding - Termination Details Updates for Part
- **PR1050558-2677** (Sprint 9) - Configuration | Tech: N/A | Clinician Offboarding - Termination Details Updates for Part
- **PR1050558-2678** (Sprint 10) - Flow Automation | Tech: Flow | Facility Term: Date of Client Termination Triggers Auto Clin
- **PR1050558-2678** (Sprint 11) - Flow Automation | Tech: Flow | Facility Term: Date of Client Termination Triggers Auto Clin
- **PR1050558-2785** (Sprint 10) - Flow Automation | Tech: Flow | NP/PA Tier Management: Clinician 2 of 2
- **PR1050558-2790** (Sprint 9) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Stipend - Add "Stipe
- **PR1050558-2791** (Sprint 9) - Configuration | Tech: N/A | Clinician Contract Request: Capture "Anticipated Clinical Ho
- **PR1050558-2793** (Sprint 9) - Flow Automation | Tech: Flow | Facility Change Request: Approvals 2 of 2
- **PR1050558-2807** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Contract Request - Client Contract - Status & Key Dat
- **PR1050558-2807** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Client Contract Request - Client Contract - Status & Key Dat
- **PR1050558-2810** (Sprint 9) - Configuration | Tech: REST | Update HPF Field = Temporary Inactive Reason
- **PR1050558-2811** (Sprint 10) - Configuration | Tech: N/A | Generate Term Sheet - Term Sheet Generation
- **PR1050558-2811** (Sprint 11) - Configuration | Tech: N/A | Generate Term Sheet - Term Sheet Generation
- **PR1050558-2813** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | New Clinician Athena Notification
- **PR1050558-2815** (Sprint 10) - Flow Automation | Tech: Flow | Notification for Employment Type Changes
- **PR1050558-2815** (Sprint 11) - Flow Automation | Tech: Flow | Notification for Employment Type Changes
- **PR1050558-2822** (Sprint 10) - Configuration | Tech: N/A | Clinician Contract Request: Copy rates from Old HPF to New
- **PR1050558-2827** (Sprint 10) - Apex Development | Tech: Apex, Flow, REST | HPF Updates & Platform Event: First Clinical Shift and Activ
- **PR1050558-2828** (Sprint 10) - Configuration | Tech: N/A | HPF Updates & Platform Event: Contract becomes Active
- **PR1050558-2830** (Sprint 10) - Apex Development | Tech: Apex, Flow | Integration Platform Event: Re-Trigger Integration
- **PR1050558-2830** (Sprint 9) - Apex Development | Tech: Apex, Flow | Integration Platform Event: Re-Trigger Integration
- **PR1050558-2832** (Sprint 10) - Configuration | Tech: N/A | Term Sheet Generation - Trigger Contract Generation
- **PR1050558-2892** (Sprint 9) - Configuration | Tech: N/A | Initiate Leadership Change - Create Case RT: Leadership Chan
- **PR1050558-2906** (Sprint 10) - Apex Development | Tech: Apex, Flow, Validation Rule | Facility Change Request: Rates & Coverage 2 of 2
- **PR1050558-2906** (Sprint 11) - Apex Development | Tech: Apex, Flow, Validation Rule | Facility Change Request: Rates & Coverage 2 of 2
- **PR1050558-2907** (Sprint 12) - Configuration | Tech: N/A | Term Sheet Generation - “Send Term Sheet for Signature” & Li
- **PR1050558-2907** (Sprint 12.1) - Configuration | Tech: N/A | Term Sheet Generation - “Send Term Sheet for Signature” & Li
- **PR1050558-2908** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Enable Integration to Workday for SCP Offbo
- **PR1050558-291** (Sprint 5) - Configuration | Tech: REST | Create HPF: Facility Selection & Specify Facility Title
- **PR1050558-2916** (Sprint 10) - General | Tech: N/A | Facility Change Request: Coverage Change - Only Shift change
- **PR1050558-2916** (Sprint 11) - General | Tech: N/A | Facility Change Request: Coverage Change - Only Shift change
- **PR1050558-2928** (Sprint 10) - Flow Automation | Tech: Flow | Clinician Contract Date Alignment - No Employment Type Chang
- **PR1050558-2928** (Sprint 11) - Flow Automation | Tech: Flow | Clinician Contract Date Alignment - No Employment Type Chang
- **PR1050558-2941** (Sprint 9) - General | Tech: N/A | Issue with Bonus type rate configuration on clinician contra
- **PR1050558-2947** (Sprint 10) - Flow Automation | Tech: Flow | Clinician Contract Request: Contract Roll up of "Anticipated
- **PR1050558-2949** (Sprint 9) - General | Tech: N/A | New Custom button “Create Clinician Change” - Screen flow, t
- **PR1050558-2950** (Sprint 10) - Apex Development | Tech: Apex | Offboarding Tasks - Facility Specific - Update Task
- **PR1050558-2955** (Sprint 10) - OmniStudio | Tech: OmniScript | Clinician Contract Request: SCP to book Travel
- **PR1050558-2965** (Sprint 12) - Configuration | Tech: N/A | Clinician Contract - Update Cloning to include Rate Pay Code
- **PR1050558-298** (Sprint 3) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Shift
- **PR1050558-2983** (Sprint 9) - Configuration | Tech: N/A | Integration log object status picklist value not updated.
- **PR1050558-2988** (Sprint 11) - Configuration | Tech: N/A | Facility Change Request: No Hard Deletes & Exclude "Is Delet
- **PR1050558-299** (Sprint 6) - Flow Automation | Tech: Flow | Clinician Contract Summary UI - Cloned Indicator
- **PR1050558-30** (Sprint 1) - General | Tech: N/A | Organization Wide Defaults
- **PR1050558-301** (Sprint 7) - Apex Development | Tech: Apex, Flow | Clinician Agreement Approval Process: Mismatch & Tactical
- **PR1050558-3013** (Sprint 12) - General | Tech: N/A | Tech - SSO Flow - Experience Cloud Welcome Email
- **PR1050558-3013** (Sprint 12.1) - General | Tech: N/A | Tech - SSO Flow - Experience Cloud Welcome Email
- **PR1050558-3017** (Sprint 10) - General | Tech: N/A | Facility Change Request: Practice Operation Contract - Rules
- **PR1050558-3017** (Sprint 11) - General | Tech: N/A | Facility Change Request: Practice Operation Contract - Rules
- **PR1050558-3018** (Sprint 11) - Configuration | Tech: N/A | Facility Change Request: Practice Operation Contract - Send 
- **PR1050558-3019** (Sprint 12) - General | Tech: N/A | Client Contract Request - View related Client Contracts on A
- **PR1050558-302** (Sprint 6) - General | Tech: N/A | Collaborative Practice Agreement Review UI
- **PR1050558-302** (Sprint 7) - General | Tech: N/A | Collaborative Practice Agreement Review UI
- **PR1050558-3020** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Expanded View
- **PR1050558-3020** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Expanded View
- **PR1050558-3021** (Sprint 12) - General | Tech: N/A | Client Contract Request - New Client Contract
- **PR1050558-3021** (Sprint 12.1) - General | Tech: N/A | Client Contract Request - New Client Contract
- **PR1050558-3022** (Sprint 12) - LWC/Aura Component | Tech: N/A | Client Contract Request - View Client Contract
- **PR1050558-3022** (Sprint 12.1) - LWC/Aura Component | Tech: N/A | Client Contract Request - View Client Contract
- **PR1050558-3023** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Edit Client Contract (Add Configur
- **PR1050558-3023** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Edit Client Contract (Add Configur
- **PR1050558-3024** (Sprint 11) - General | Tech: Apex | Facility Change Request: Sync Practice Operations Contract r
- **PR1050558-3024** (Sprint 12) - General | Tech: Apex | Facility Change Request: Sync Practice Operations Contract r
- **PR1050558-3026** (Sprint 11) - General | Tech: N/A | Client Onboarding - Implementation Queue
- **PR1050558-3026** (Sprint 12) - General | Tech: N/A | Client Onboarding - Implementation Queue
- **PR1050558-3027** (Sprint 11) - Apex Development | Tech: Apex, Flow, Validation Rule | Client Onboarding - PMT Project, PMT Phase, & PMT Task
- **PR1050558-3027** (Sprint 12) - Apex Development | Tech: Apex, Flow, Validation Rule | Client Onboarding - PMT Project, PMT Phase, & PMT Task
- **PR1050558-306** (Sprint 7) - Configuration | Tech: N/A | Clinician Offboarding - Termination Details
- **PR1050558-309** (Sprint 7) - Flow Automation | Tech: Flow | Open Shift APAY Request
- **PR1050558-309** (Sprint 8) - Flow Automation | Tech: Flow | Open Shift APAY Request
- **PR1050558-310** (Sprint 8) - Configuration | Tech: N/A | Opportunity (Growth Oppty) Object
- **PR1050558-310** (Sprint 9) - Configuration | Tech: N/A | Opportunity (Growth Oppty) Object
- **PR1050558-313** (Sprint 11) - Configuration | Tech: N/A | Client Onboarding - Update PMT Layout
- **PR1050558-313** (Sprint 12) - Configuration | Tech: N/A | Client Onboarding - Update PMT Layout
- **PR1050558-314** (Sprint 11) - Configuration | Tech: Formula Field | Client Onboarding - Action Plan Template
- **PR1050558-314** (Sprint 12) - Configuration | Tech: Formula Field | Client Onboarding - Action Plan Template
- **PR1050558-317** (Sprint 11) - Flow Automation | Tech: Flow | Facility Term
- **PR1050558-317** (Sprint 12) - Flow Automation | Tech: Flow | Facility Term
- **PR1050558-3187** (Sprint 10) - Apex Development | Tech: Apex | Facility Change Request: Coverage Change - Only Pay Code Cha
- **PR1050558-3187** (Sprint 11) - Apex Development | Tech: Apex | Facility Change Request: Coverage Change - Only Pay Code Cha
- **PR1050558-319** (Sprint 10) - Configuration | Tech: N/A | Employee Self-Service Experience (Link to MySCP - Employee A
- **PR1050558-319** (Sprint 11) - Configuration | Tech: N/A | Employee Self-Service Experience (Link to MySCP - Employee A
- **PR1050558-319** (Sprint 12) - Configuration | Tech: N/A | Employee Self-Service Experience (Link to MySCP - Employee A
- **PR1050558-319** (Sprint 8) - Configuration | Tech: N/A | Employee Self-Service Experience (Link to MySCP - Employee A
- **PR1050558-319** (Sprint 9) - Configuration | Tech: N/A | Employee Self-Service Experience (Link to MySCP - Employee A
- **PR1050558-3190** (Sprint 11) - Apex Development | Tech: Apex | Facility Change Request: Coverage Change - Only Shift change
- **PR1050558-3190** (Sprint 12) - Apex Development | Tech: Apex | Facility Change Request: Coverage Change - Only Shift change
- **PR1050558-3201** (Sprint 12) - Configuration | Tech: N/A | Generate Term Sheet - Term Sheet Generation - Add Other Type
- **PR1050558-3201** (Sprint 12.1) - Configuration | Tech: N/A | Generate Term Sheet - Term Sheet Generation - Add Other Type
- **PR1050558-3204** (Sprint 11) - General | Tech: N/A | Queues to Support Onboarding/SUN process - Queue Creation
- **PR1050558-3204** (Sprint 12) - General | Tech: N/A | Queues to Support Onboarding/SUN process - Queue Creation
- **PR1050558-3205** (Sprint 11) - General | Tech: N/A | Queues to Support Onboarding/SUN process - List Views
- **PR1050558-3205** (Sprint 12) - General | Tech: N/A | Queues to Support Onboarding/SUN process - List Views
- **PR1050558-3207** (Sprint 11) - Apex Development | Tech: Apex, Flow | Facility Change Request: Practice Operation Contract - Auto 
- **PR1050558-3211** (Sprint 10) - General | Tech: N/A | Comparison View - Clinician Contract
- **PR1050558-3211** (Sprint 11) - General | Tech: N/A | Comparison View - Clinician Contract
- **PR1050558-3212** (Sprint 10) - OmniStudio | Tech: OmniScript | View Practice Operations rate on Configure Rates
- **PR1050558-3212** (Sprint 11) - OmniStudio | Tech: OmniScript | View Practice Operations rate on Configure Rates
- **PR1050558-3233** (Sprint 10) - General | Tech: N/A | Permission for Integration User - Rate Pay Code, Contract Po
- **PR1050558-3233** (Sprint 11) - General | Tech: N/A | Permission for Integration User - Rate Pay Code, Contract Po
- **PR1050558-3240** (Sprint 11) - Apex Development | Tech: Apex, Flow | Client Onboarding - Set PMT Task “Task Completion %” field
- **PR1050558-3240** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Set PMT Task “Task Completion %” field
- **PR1050558-326** (Sprint 5) - General | Tech: N/A | Manage Primary Taxonomy and Specialty
- **PR1050558-326** (Sprint 6) - General | Tech: N/A | Manage Primary Taxonomy and Specialty
- **PR1050558-326** (Sprint 7) - General | Tech: N/A | Manage Primary Taxonomy and Specialty
- **PR1050558-332** (Sprint 3) - Apex Development | Tech: Apex, Flow | Automatically Assign the "Portal User" Permission Set
- **PR1050558-3338** (Sprint 12) - Flow Automation | Tech: Flow | Client Onboarding - Create Task based on Service Line
- **PR1050558-3338** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Onboarding - Create Task based on Service Line
- **PR1050558-3339** (Sprint 12) - General | Tech: N/A | Client Contract Request - Client Contract - Action = Cancel 
- **PR1050558-3339** (Sprint 12.1) - General | Tech: N/A | Client Contract Request - Client Contract - Action = Cancel 
- **PR1050558-3343** (Sprint 12) - Flow Automation | Tech: Flow | Client Contract Request - Client Contract - Action = Amend C
- **PR1050558-3343** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract Request - Client Contract - Action = Amend C
- **PR1050558-3347** (Sprint 12) - Apex Development | Tech: Apex, Flow, Formula Field | Client Contract Request - Client Contract - Action = Expire 
- **PR1050558-3347** (Sprint 12.1) - Apex Development | Tech: Apex, Flow, Formula Field | Client Contract Request - Client Contract - Action = Expire 
- **PR1050558-3351** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Client Contract - Action = Activat
- **PR1050558-3351** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Client Contract - Action = Activat
- **PR1050558-337** (Sprint 3) - Configuration | Tech: N/A | Standardize Facility Title Values
- **PR1050558-3374** (Sprint 10) - General | Tech: N/A | Clinician Portal User License
- **PR1050558-3374** (Sprint 11) - General | Tech: N/A | Clinician Portal User License
- **PR1050558-3375** (Sprint 12) - General | Tech: N/A | Tech - HC Portal Configuration - Update Sender and Portal Ad
- **PR1050558-3375** (Sprint 12.1) - General | Tech: N/A | Tech - HC Portal Configuration - Update Sender and Portal Ad
- **PR1050558-3383** (Sprint 11) - Apex Development | Tech: Apex, Flow | Add Additional Fields
- **PR1050558-3384** (Sprint 11) - Flow Automation | Tech: Flow | IC NP/PA Terminate on Anniversary Date
- **PR1050558-3384** (Sprint 12) - Flow Automation | Tech: Flow | IC NP/PA Terminate on Anniversary Date
- **PR1050558-3384** (Sprint 12.1) - Flow Automation | Tech: Flow | IC NP/PA Terminate on Anniversary Date
- **PR1050558-3388** (Sprint 12) - Apex Development | Tech: Apex | Client Change Management - Create Records
- **PR1050558-3389** (Sprint 11) - LWC/Aura Component | Tech: Apex | Client Change Management - Update the Batch job to use Proce
- **PR1050558-3391** (Sprint 11) - Configuration | Tech: N/A | Client Change Management Object
- **PR1050558-3392** (Sprint 11) - General | Tech: N/A | Facility Rate Creation - Clean Up - Remove "Shift" from Cont
- **PR1050558-340** (Sprint 3) - Configuration | Tech: N/A | Update the Account Account Relationship
- **PR1050558-3444** (Sprint 11) - General | Tech: N/A | Clinicians Contract Request: Mixed Bag Shift Rates?
- **PR1050558-3444** (Sprint 12) - General | Tech: N/A | Clinicians Contract Request: Mixed Bag Shift Rates?
- **PR1050558-3449** (Sprint 11) - Configuration | Tech: N/A | Facility Change Request: Reset flags when cloning a Practice
- **PR1050558-3451** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation for Onboarding Task r
- **PR1050558-3451** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Client Onboarding - Auto Task Creation for Onboarding Task r
- **PR1050558-3459** (Sprint 11) - Configuration | Tech: N/A | Client Onboarding - Configure Action Plan Template
- **PR1050558-3459** (Sprint 12) - Configuration | Tech: N/A | Client Onboarding - Configure Action Plan Template
- **PR1050558-3463** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - Update LOI guid
- **PR1050558-3463** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - Update LOI guid
- **PR1050558-3464** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - View & Edit
- **PR1050558-3464** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - View & Edit
- **PR1050558-3465** (Sprint 12) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Cancel
- **PR1050558-3465** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Cancel
- **PR1050558-3466** (Sprint 12) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Amend 
- **PR1050558-3466** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Amend 
- **PR1050558-3467** (Sprint 12) - Flow Automation | Tech: Flow, Formula Field | Client Contract Request - Letter of Intent - Action = Expire
- **PR1050558-3467** (Sprint 12.1) - Flow Automation | Tech: Flow, Formula Field | Client Contract Request - Letter of Intent - Action = Expire
- **PR1050558-3468** (Sprint 12) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Activa
- **PR1050558-3468** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract Request - Letter of Intent - Action = Activa
- **PR1050558-3469** (Sprint 12) - General | Tech: N/A | Client Contract Request - Letter of Intent - Email Alert
- **PR1050558-3469** (Sprint 12.1) - General | Tech: N/A | Client Contract Request - Letter of Intent - Email Alert
- **PR1050558-3474** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Client Contract - Action = Termina
- **PR1050558-3474** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Client Contract - Action = Termina
- **PR1050558-3478** (Sprint 14) - Configuration | Tech: N/A | Agentforce Clinician Rate Change Notices Use Case - Enhancem
- **PR1050558-3517** (Sprint 12) - Flow Automation | Tech: Flow, REST | SUN Orchestration - Trigger Task Creation
- **PR1050558-3517** (Sprint 12.1) - Flow Automation | Tech: Flow, REST | SUN Orchestration - Trigger Task Creation
- **PR1050558-3518** (Sprint 11) - Configuration | Tech: N/A | Client Contract Request - Create new fields
- **PR1050558-3518** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Create new fields
- **PR1050558-3519** (Sprint 12) - LWC/Aura Component | Tech: LWC, OmniScript | Client Contract Request - Configurations tab - View & Delete
- **PR1050558-3519** (Sprint 12.1) - LWC/Aura Component | Tech: LWC, OmniScript | Client Contract Request - Configurations tab - View & Delete
- **PR1050558-3520** (Sprint 12) - Flow Automation | Tech: Flow, Validation Rule | Client Contract Request - Letter of Intent - Action = Termin
- **PR1050558-3520** (Sprint 12.1) - Flow Automation | Tech: Flow, Validation Rule | Client Contract Request - Letter of Intent - Action = Termin
- **PR1050558-3521** (Sprint 12) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-3521** (Sprint 12.1) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-3545** (Sprint 11) - Apex Development | Tech: Apex, Flow | Tech - SSO Flow - Send Clinician Info to Okta
- **PR1050558-3545** (Sprint 12) - Apex Development | Tech: Apex, Flow | Tech - SSO Flow - Send Clinician Info to Okta
- **PR1050558-3546** (Sprint 11) - LWC/Aura Component | Tech: LWC, Apex | Tech - SSO Flow - Update Portal Login
- **PR1050558-3546** (Sprint 12) - LWC/Aura Component | Tech: LWC, Apex | Tech - SSO Flow - Update Portal Login
- **PR1050558-3546** (Sprint 12.1) - LWC/Aura Component | Tech: LWC, Apex | Tech - SSO Flow - Update Portal Login
- **PR1050558-3565** (Sprint 11) - Configuration | Tech: N/A | Practice Operation Change Object
- **PR1050558-3570** (Sprint 11) - Flow Automation | Tech: Flow | SIT: C&CSIT05 Post risk review_ Close Out Genda_No Event is 
- **PR1050558-3572** (Sprint 11) - Configuration | Tech: N/A | Update HPF Temporary Inactive Reason data type
- **PR1050558-3572** (Sprint 12) - Configuration | Tech: N/A | Update HPF Temporary Inactive Reason data type
- **PR1050558-3573** (Sprint 12) - Flow Automation | Tech: Flow | Tech - SSO Flow - Reactivate User & Update Platform Event
- **PR1050558-3573** (Sprint 12.1) - Flow Automation | Tech: Flow | Tech - SSO Flow - Reactivate User & Update Platform Event
- **PR1050558-3574** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Change Management - Clinician Contract Executed betwe
- **PR1050558-358** (Sprint 3) - Configuration | Tech: N/A | Assessment & Assessment Question Response Object
- **PR1050558-3585** (Sprint 12) - Configuration | Tech: N/A | Update permissions to Opportunity records
- **PR1050558-3585** (Sprint 12.1) - Configuration | Tech: N/A | Update permissions to Opportunity records
- **PR1050558-359** (Sprint 4) - Configuration | Tech: N/A | Create Default Task Record Type and Page Layout
- **PR1050558-3614** (Sprint 12) - Apex Development | Tech: Apex, Flow | Tech - SSO Flow - Send Clinician Info to Okta - UPDATE - cha
- **PR1050558-3614** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Tech - SSO Flow - Send Clinician Info to Okta - UPDATE - cha
- **PR1050558-3616** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Corporation and Tax Information Updates
- **PR1050558-3619** (Sprint 12) - Flow Automation | Tech: Flow | Client Contract Request - Add New Provider Network Contracts
- **PR1050558-3619** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract Request - Add New Provider Network Contracts
- **PR1050558-3620** (Sprint 11) - OmniStudio | Tech: OmniScript | UAT Bug: C&CUAT16 Contract Request Bonus Configuration not s
- **PR1050558-3623** (Sprint 11) - Flow Automation | Tech: Flow, REST | UAT Bug: C&CUAT19 EE NPPA rate fields are populated on a Con
- **PR1050558-370** (Sprint 3) - Apex Development | Tech: Apex | Generic Error Logger for Application Errors
- **PR1050558-374** (Sprint 3) - Configuration | Tech: N/A | Code Set Object
- **PR1050558-3768** (Sprint 12) - Configuration | Tech: N/A | Contract Provider Network Relation Object
- **PR1050558-3777** (Sprint 12) - Configuration | Tech: N/A | Facility Change Request: No Hard Deletes & Exclude "Is Delet
- **PR1050558-379** (Sprint 4) - Configuration | Tech: N/A | Client Division (Operational Structure)
- **PR1050558-3803** (Sprint 12) - Configuration | Tech: N/A | Facility Term: Add Case related list to Client Offboarding C
- **PR1050558-382** (Sprint 3) - Configuration | Tech: N/A | Facility Rate Creation - Summary Screen
- **PR1050558-384** (Sprint 8) - Configuration | Tech: N/A | HC Portal Helpful Links Visibility
- **PR1050558-385** (Sprint 4) - Configuration | Tech: N/A | Update Guided Clinician Creation - Geographic Preference
- **PR1050558-386** (Sprint 4) - General | Tech: N/A | Update NPI Management
- **PR1050558-3924** (Sprint 12) - LWC/Aura Component | Tech: N/A | Client Contract Request - Configurations tab - Edit
- **PR1050558-3924** (Sprint 12.1) - LWC/Aura Component | Tech: N/A | Client Contract Request - Configurations tab - Edit
- **PR1050558-3931** (Sprint 12) - General | Tech: N/A | TECH - Clinician Contract Request: Summary Screen - Add HPF 
- **PR1050558-3939** (Sprint 12) - Flow Automation | Tech: Flow | UI Enhancement: HC Clinician Portal UI Enhancements
- **PR1050558-3939** (Sprint 12.1) - Flow Automation | Tech: Flow | UI Enhancement: HC Clinician Portal UI Enhancements
- **PR1050558-3950** (Sprint 12) - LWC/Aura Component | Tech: N/A | Remove 'Term Sheet Executed' field and Related Components
- **PR1050558-3950** (Sprint 12.1) - LWC/Aura Component | Tech: N/A | Remove 'Term Sheet Executed' field and Related Components
- **PR1050558-3993** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Onboarding - Trigger Task Creation - Ensure Task Reco
- **PR1050558-4001** (Sprint 12) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Bonus Approval Updates
- **PR1050558-4005** (Sprint 12) - General | Tech: N/A | UAT Enhancement: Allow $0 Rates on Clinician Contracts
- **PR1050558-4005** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Allow $0 Rates on Clinician Contracts
- **PR1050558-4012** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT86 HPF and Agreement history sections
- **PR1050558-4014** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT88 Recruiters need the ability to wit
- **PR1050558-4051** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Contract - Updates to support allowing multiple Maste
- **PR1050558-4051** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Client Contract - Updates to support allowing multiple Maste
- **PR1050558-4065** (Sprint 12) - General | Tech: N/A | Client Contract Request - Configurations tab - Layout
- **PR1050558-4065** (Sprint 12.1) - General | Tech: N/A | Client Contract Request - Configurations tab - Layout
- **PR1050558-4094** (Sprint 12) - Flow Automation | Tech: Flow | Submit Pro Forma Model for Approval - Send Rejection Email t
- **PR1050558-4094** (Sprint 12.1) - Flow Automation | Tech: Flow | Submit Pro Forma Model for Approval - Send Rejection Email t
- **PR1050558-4107** (Sprint 12) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - Update Design f
- **PR1050558-4107** (Sprint 12.1) - Configuration | Tech: N/A | Client Contract Request - Letter of Intent - Update Design f
- **PR1050558-4109** (Sprint 12) - LWC/Aura Component | Tech: N/A | Client Contract -  Update 'child' contract page (Contract Ty
- **PR1050558-4143** (Sprint 12) - Apex Development | Tech: Apex, Flow | Regression bug: Clinician Facility Offboarding case is not g
- **PR1050558-4175** (Sprint 12.1) - OmniStudio | Tech: OmniScript, Integration Procedure, REST | RUL - Security
- **PR1050558-4191** (Sprint 12) - Flow Automation | Tech: Flow | Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Perm
- **PR1050558-4191** (Sprint 12.1) - Flow Automation | Tech: Flow | Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Perm
- **PR1050558-4191** (Sprint 12.2) - Flow Automation | Tech: Flow | Tech - SSO Flow - TESTING ONLY - Okta to Add/Remove SSO Perm
- **PR1050558-4198** (Sprint 12) - Apex Development | Tech: Apex, Flow | Client Change Management - Update Client Change Management S
- **PR1050558-4198** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Client Change Management - Update Client Change Management S
- **PR1050558-4198** (Sprint 12.2) - Apex Development | Tech: Apex, Flow | Client Change Management - Update Client Change Management S
- **PR1050558-4203** (Sprint 12.1) - General | Tech: Apex | UAT Enhancement: View Clinicians from Service Account Record
- **PR1050558-421** (Sprint 3) - Configuration | Tech: N/A | Clinician Risk Review - Record Type & Layout
- **PR1050558-425** (Sprint 7) - Configuration | Tech: N/A | Clinician Contract List Views
- **PR1050558-429** (Sprint 4) - Configuration | Tech: N/A | Credentialing & Scheduling Attributes from QGenda
- **PR1050558-430** (Sprint 4) - Configuration | Tech: N/A | Clinician Attributes in Salesforce to Send to Workday
- **PR1050558-4308** (Sprint 12.1) - Configuration | Tech: N/A | Training Enhancement: Contract Field Visibility and Edit Acc
- **PR1050558-4309** (Sprint 12.1) - Configuration | Tech: N/A | Training Enhancement: Update Related Lists on Clinician and 
- **PR1050558-4345** (Sprint 12.1) - Flow Automation | Tech: Flow | Client Contract - Action = Amend Contract: not cloning child
- **PR1050558-4347** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement: Remove Primary Reason Field & Populate Reas
- **PR1050558-4362** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: Add Additional Fields
- **PR1050558-4366** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: Update HPF field = "Received Current Comple
- **PR1050558-4367** (Sprint 12.1) - Flow Automation | Tech: Apex, Flow | UAT Enhancement: Update PNC fields = "Client Termination Tim
- **PR1050558-4375** (Sprint 12.1) - General | Tech: N/A | Regression Bug - I9 Update tasks is not closing when I9 Stat
- **PR1050558-4391** (Sprint 12.1) - General | Tech: N/A | UAT Bug: C&CUAT157 Cannot add Contact Role to Opportunity
- **PR1050558-4409** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Generate Term Sheet - Term Sheet Generation
- **PR1050558-4432** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Automated Onboarding Task Record Closure - 
- **PR1050558-4433** (Sprint 12.1) - Configuration | Tech: Validation Rule | UAT Enhancement: Contract - Add validation that Start can NO
- **PR1050558-4512** (Sprint 12.1) - Configuration | Tech: N/A | While working on LOI and Client Contract with status Draft -
- **PR1050558-4513** (Sprint 12.1) - Configuration | Tech: N/A | SFO Persona is unable to update the Contract End Date field.
- **PR1050558-4521** (Sprint 12.1) - Configuration | Tech: N/A | UAT Bug: C&CUAT183 Error message when viewing all tasks for 
- **PR1050558-4532** (Sprint 12.1) - Security Setup | Tech: N/A | Unable to Log In to Specific Users
- **PR1050558-4536** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Bug: Update Welcome Clinician Onboarding Email Flow to h
- **PR1050558-4538** (Sprint 12.1) - Security Setup | Tech: N/A | UAT Bug: C&CUAT187 Finance Unable to edit fields
- **PR1050558-4548** (Sprint 12.1) - Flow Automation | Tech: Flow | On Client Contract upon entering start and end date in Past,
- **PR1050558-4553** (Sprint 12.1) - Configuration | Tech: N/A | Clinician NP/PA Tier Updates
- **PR1050558-4553** (Sprint 12.2) - Configuration | Tech: N/A | Clinician NP/PA Tier Updates
- **PR1050558-4556** (Sprint 12.1) - General | Tech: N/A | Failed to update Healthcare Practitioner Facility History
- **PR1050558-4569** (Sprint 12.1) - Configuration | Tech: N/A | HPF Field History Tracking
- **PR1050558-4578** (Sprint 12.1) - Configuration | Tech: Formula Field | UAT Enhancement: C&CUAT202 Edit functionality needed for all
- **PR1050558-4580** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT204 View of Contracts from Opportunit
- **PR1050558-4583** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT207 Letter of Intent Request - Letter
- **PR1050558-4593** (Sprint 12.1) - Configuration | Tech: N/A | NP/PA Onboarding Comments field on HPF
- **PR1050558-4593** (Sprint 12.2) - Configuration | Tech: N/A | NP/PA Onboarding Comments field on HPF
- **PR1050558-4594** (Sprint 12.1) - Security Setup | Tech: N/A | Update Role Hierarchy
- **PR1050558-4594** (Sprint 12.2) - Security Setup | Tech: N/A | Update Role Hierarchy
- **PR1050558-4621** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT229 Missing Validation between Contra
- **PR1050558-4628** (Sprint 12.1) - Configuration | Tech: Formula Field | UAT Enhancement: C&CUAT232 Client Contract Term & Renewal Co
- **PR1050558-4628** (Sprint 12.2) - Configuration | Tech: Formula Field | UAT Enhancement: C&CUAT232 Client Contract Term & Renewal Co
- **PR1050558-4629** (Sprint 12.1) - OmniStudio | Tech: Integration Procedure | UAT Enhancement: C&CUAT233 Practice Operations Contract not 
- **PR1050558-4630** (Sprint 12.1) - General | Tech: Apex | UAT Enhancement: Update matching logic for "Refresh Client R
- **PR1050558-4630** (Sprint 12.2) - General | Tech: Apex | UAT Enhancement: Update matching logic for "Refresh Client R
- **PR1050558-4638** (Sprint 12.1) - Configuration | Tech: N/A | Some personas don't have access to view Time Type of HPF rel
- **PR1050558-4667** (Sprint 12.1) - Flow Automation | Tech: Apex, Flow | UAT Enhancement: EE NPPA Salary Calculation Update part 2
- **PR1050558-467** (Sprint 4) - Configuration | Tech: N/A | Intake Form Case
- **PR1050558-4674** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Hire Date when Employment Type is Changing
- **PR1050558-4674** (Sprint 12.2) - Apex Development | Tech: Apex, Flow | Hire Date when Employment Type is Changing
- **PR1050558-468** (Sprint 6) - LWC/Aura Component | Tech: N/A | App Home Page
- **PR1050558-468** (Sprint 7) - LWC/Aura Component | Tech: N/A | App Home Page
- **PR1050558-4683** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT243 Update Practice Operations fields
- **PR1050558-4685** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT245 SCP Contracting entities
- **PR1050558-469** (Sprint 4) - Configuration | Tech: N/A | Add Additional Fields
- **PR1050558-470** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Leadership Incentive
- **PR1050558-4705** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Update Integration to Workday for SCP Offbo
- **PR1050558-4705** (Sprint 12.2) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Update Integration to Workday for SCP Offbo
- **PR1050558-471** (Sprint 5) - Configuration | Tech: Validation Rule | Pro Forma Outputs
- **PR1050558-471** (Sprint 6) - Configuration | Tech: Validation Rule | Pro Forma Outputs
- **PR1050558-472** (Sprint 10) - OmniStudio | Tech: OmniScript | Client Agreement Request
- **PR1050558-472** (Sprint 9) - OmniStudio | Tech: OmniScript | Client Agreement Request
- **PR1050558-4727** (Sprint 12.1) - Apex Development | Tech: Apex | E2E Bug: CDC Channel Update
- **PR1050558-473** (Sprint 4) - Apex Development | Tech: Apex, Flow | Automatically Create Healthcare Provider & Healthcare Payer 
- **PR1050558-4739** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement :Task to Clear QGenda for Reactivating a Cli
- **PR1050558-4744** (Sprint 12.4) - Configuration | Tech: Formula Field | Contract Payment Agreement Related List Columns
- **PR1050558-4746** (Sprint 12.1) - General | Tech: N/A | UAT Bug: C&CUAT261 Cloned contract pulling in incorrect cont
- **PR1050558-4748** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Clinician Hire Date
- **PR1050558-4749** (Sprint 12.1) - Reporting | Tech: N/A | UAT Enhancement: C&CUAT263 Legal - Client Contracting - Lega
- **PR1050558-4750** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: NP/PA Tier Process
- **PR1050558-4763** (Sprint 12.1) - General | Tech: N/A | Observation bug: During Clinician contract request - Active 
- **PR1050558-4765** (Sprint 12.1) - General | Tech: N/A | UAT Bug: Clinician Contract Cloning should use Start Date no
- **PR1050558-4780** (Sprint 14) - Configuration | Tech: N/A | UAT Enhancement: Optimize Clinician Contract Views
- **PR1050558-479** (Sprint 12) - LWC/Aura Component | Tech: Flow, Validation Rule, Formula Field | Submit Pro Forma Model for Approval
- **PR1050558-479** (Sprint 12.1) - LWC/Aura Component | Tech: Flow, Validation Rule, Formula Field | Submit Pro Forma Model for Approval
- **PR1050558-4839** (Sprint 12.1) - Flow Automation | Tech: Flow | Platform Event Update - Case Creation After Flow
- **PR1050558-4839** (Sprint 12.2) - Flow Automation | Tech: Flow | Platform Event Update - Case Creation After Flow
- **PR1050558-4844** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: NP/PA Tier Process - Add HPF
- **PR1050558-485** (Sprint 3) - Configuration | Tech: N/A | Integration Log Object
- **PR1050558-4856** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement : Clinician Contract Approvals
- **PR1050558-4856** (Sprint 12.2) - Flow Automation | Tech: Flow | UAT Enhancement : Clinician Contract Approvals
- **PR1050558-486** (Sprint 5) - General | Tech: N/A | Facility Rate Creation - Type of Rate = Shift: Add Shift Typ
- **PR1050558-4861** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Update CDC Channel - add fields and update 
- **PR1050558-4862** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Convert Data Type for ID Fields
- **PR1050558-4863** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4863** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-487** (Sprint 8) - General | Tech: N/A | CDC Channel Update - Clinician Contract Executed/Start Admin
- **PR1050558-487** (Sprint 9) - General | Tech: N/A | CDC Channel Update - Clinician Contract Executed/Start Admin
- **PR1050558-488** (Sprint 8) - Configuration | Tech: N/A | Record Type Cleanup
- **PR1050558-488** (Sprint 9) - Configuration | Tech: N/A | Record Type Cleanup
- **PR1050558-4891** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4891** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4892** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4892** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4893** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4893** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: Clinician Contract - Include PO Contract St
- **PR1050558-4894** (Sprint 12.1) - Flow Automation | Tech: Flow, Formula Field | UAT Enhancement: C&CUAT291 Experience Cloud log in requestin
- **PR1050558-4897** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT294 Data Quality, MSL, and PE Team Pe
- **PR1050558-4897** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: C&CUAT294 Data Quality, MSL, and PE Team Pe
- **PR1050558-4902** (Sprint 12.1) - Configuration | Tech: Validation Rule | UAT Enhancement: Practice Operations Contract - NPPA Tier, C
- **PR1050558-4902** (Sprint 12.2) - Configuration | Tech: Validation Rule | UAT Enhancement: Practice Operations Contract - NPPA Tier, C
- **PR1050558-4907** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Prevent Duplicate Email addresses for Activ
- **PR1050558-4907** (Sprint 12.2) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Prevent Duplicate Email addresses for Activ
- **PR1050558-4917** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement :Update HPF Contracting Status When Contract
- **PR1050558-4917** (Sprint 12.2) - Flow Automation | Tech: Flow | UAT Enhancement :Update HPF Contracting Status When Contract
- **PR1050558-4918** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Practice Operations Contract - NPPA Tier & 
- **PR1050558-4918** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: Practice Operations Contract - NPPA Tier & 
- **PR1050558-4921** (Sprint 12.5) - General | Tech: N/A | UAT Enhancement: C&CUAT301 On the CPA screen in Clinician On
- **PR1050558-4927** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Bug: Clinician Offboarding: Termination Updates
- **PR1050558-4935** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | Platform Event Update - 'HPFUpdate' - trigger based on Crede
- **PR1050558-4942** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Refresh Client Rate button: Deleting Rates 
- **PR1050558-4948** (Sprint 12.1) - Apex Development | Tech: Apex | UAT Enhancement : Clone the Acknowledge Flag field while Clo
- **PR1050558-4948** (Sprint 12.2) - Apex Development | Tech: Apex | UAT Enhancement : Clone the Acknowledge Flag field while Clo
- **PR1050558-4954** (Sprint 12.1) - Flow Automation | Tech: Apex, Flow | UAT Enhancement: Clinician Contract - Facility Title Change 
- **PR1050558-4954** (Sprint 12.2) - Flow Automation | Tech: Apex, Flow | UAT Enhancement: Clinician Contract - Facility Title Change 
- **PR1050558-4970** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: Risk Review - Add visibility to the Assessm
- **PR1050558-4970** (Sprint 12.2) - Configuration | Tech: N/A | UAT Enhancement: Risk Review - Add visibility to the Assessm
- **PR1050558-4973** (Sprint 12.1) - Flow Automation | Tech: Flow | Intake Form Criteria Update: Update Logic from HPF to Job
- **PR1050558-4973** (Sprint 12.2) - Flow Automation | Tech: Flow | Intake Form Criteria Update: Update Logic from HPF to Job
- **PR1050558-4980** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement - Date Validation for Manual Create HPF
- **PR1050558-4998** (Sprint 12.1) - Configuration | Tech: Formula Field | UAT Enhancement: Add Blended Rates ("EE NP/PA Hourly Blended
- **PR1050558-5001** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT328 Experience Cloud - Change Your Pa
- **PR1050558-5064** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: C&CUAT335 Populate Intake Form Answers to C
- **PR1050558-5068** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: Include Active HPFs in Clinician Contract
- **PR1050558-5075** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT341 Rate Active Date - Net New Field
- **PR1050558-5080** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT345 Terming provider in salesforce sh
- **PR1050558-5080** (Sprint 12.2) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT345 Terming provider in salesforce sh
- **PR1050558-5083** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: C&CUAT348 Candidate Tracker not Updating pr
- **PR1050558-5083** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: C&CUAT348 Candidate Tracker not Updating pr
- **PR1050558-5083** (Sprint 12.4) - General | Tech: N/A | UAT Enhancement: C&CUAT348 Candidate Tracker not Updating pr
- **PR1050558-5090** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement - Date Validation for Automated Create HPF f
- **PR1050558-5091** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement - Adjust Manual Create HPF Experience and HP
- **PR1050558-5093** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: Add Time Type to Pay Codes Layout
- **PR1050558-5093** (Sprint 12.2) - Configuration | Tech: N/A | UAT Enhancement: Add Time Type to Pay Codes Layout
- **PR1050558-5104** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on P
- **PR1050558-5104** (Sprint 12.3) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on P
- **PR1050558-5104** (Sprint 12.4) - Configuration | Tech: N/A | UAT Enhancement: C&CUAT359 Stipend Tier and Admin Hours on P
- **PR1050558-5117** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Prevent Clinician Contract with Same Start 
- **PR1050558-5117** (Sprint 12.2) - Apex Development | Tech: Apex, Flow | UAT Enhancement: Prevent Clinician Contract with Same Start 
- **PR1050558-5118** (Sprint 12.1) - General | Tech: N/A | UAT Bug: C&CUAT364 Warning Message in Error - Experience Clo
- **PR1050558-5118** (Sprint 12.2) - General | Tech: N/A | UAT Bug: C&CUAT364 Warning Message in Error - Experience Clo
- **PR1050558-5120** (Sprint 12.1) - Configuration | Tech: Validation Rule | UAT Enhancement : Grant Payroll Access for Pay Codes
- **PR1050558-5152** (Sprint 12.1) - Configuration | Tech: N/A | UAT Enhancement: Activate Services Object Record Types
- **PR1050558-5153** (Sprint 12.3) - General | Tech: N/A | UAT Enhancement: C&CUAT368 Add Time Type to Summary Tab on P
- **PR1050558-5167** (Sprint 12.1) - Reporting | Tech: N/A | UAT Enhancement: C&CUAT263 Permissions to run reports
- **PR1050558-5173** (Sprint 12.1) - Configuration | Tech: JavaScript | UAT Enhancement - Facility Change Request: Coverage Change U
- **PR1050558-5173** (Sprint 12.3) - Configuration | Tech: JavaScript | UAT Enhancement - Facility Change Request: Coverage Change U
- **PR1050558-5173** (Sprint 12.4) - Configuration | Tech: JavaScript | UAT Enhancement - Facility Change Request: Coverage Change U
- **PR1050558-5173** (Sprint 12.5) - Configuration | Tech: JavaScript | UAT Enhancement - Facility Change Request: Coverage Change U
- **PR1050558-5183** (Sprint 12.1) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT383 Term Sheet Status not updated app
- **PR1050558-5183** (Sprint 12.3) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT383 Term Sheet Status not updated app
- **PR1050558-5183** (Sprint 12.4) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT383 Term Sheet Status not updated app
- **PR1050558-5202** (Sprint 12.1) - General | Tech: N/A | UAT Enhancement: HPF Effective Dates UPDATE
- **PR1050558-5202** (Sprint 12.2) - General | Tech: N/A | UAT Enhancement: HPF Effective Dates UPDATE
- **PR1050558-5206** (Sprint 12.3) - Configuration | Tech: N/A | UAT Enhancement: Update Intake Form State Input
- **PR1050558-5206** (Sprint 12.4) - Configuration | Tech: N/A | UAT Enhancement: Update Intake Form State Input
- **PR1050558-5208** (Sprint 12.1) - Configuration | Tech: Formula Field | UAT Enhancement: C&CUAT390 From the Service Account Missing 
- **PR1050558-5208** (Sprint 12.3) - Configuration | Tech: Formula Field | UAT Enhancement: C&CUAT390 From the Service Account Missing 
- **PR1050558-5220** (Sprint 12.3) - Flow Automation | Tech: Flow | UAT Enhancement: C&CUAT392 Edits needed to: Review Overlappi
- **PR1050558-5221** (Sprint 12.1) - Apex Development | Tech: Apex, Flow | UAT Bug: C&CUAT393 Incorrect Effective From Date Populating 
- **PR1050558-5221** (Sprint 12.3) - Apex Development | Tech: Apex, Flow | UAT Bug: C&CUAT393 Incorrect Effective From Date Populating 
- **PR1050558-5227** (Sprint 12.3) - General | Tech: N/A | UAT Enhancement: C&CUAT398 Contract Request - Time Type Visi
- **PR1050558-5231** (Sprint 12.5) - Apex Development | Tech: Apex, Flow | UAT Enhancement: C&CUAT401 Validation Rule Needed: SCP Offbo
- **PR1050558-5232** (Sprint 12.5) - Apex Development | Tech: Apex, Flow | UAT Enhancement: C&CUAT402 Validation Rule Needed: Any Paren
- **PR1050558-5288** (Sprint 12.2) - Configuration | Tech: Validation Rule | UAT Bug: C&CUAT405 When ClinicianCoverageUpdateBatch ran it 
- **PR1050558-5318** (Sprint 12.2) - Security Setup | Tech: N/A | UAT Bug - C&CUAT416 - UAT1 - Unable to generate term sheet
- **PR1050558-5346** (Sprint 12.2) - Flow Automation | Tech: Flow | UAT Bug: Prevent Clinician Contract with Same Start Date - C
- **PR1050558-5367** (Sprint 12.2) - Flow Automation | Tech: Flow | UAT Bug: C&CUAT426 - UAT1 - Experience Cloud Tracker is inva
- **PR1050558-5383** (Sprint 12.2) - General | Tech: N/A | UAT Bug: C&C437 - UAT1 - Start from Previous Active on Clini
- **PR1050558-5391** (Sprint 12.2) - Flow Automation | Tech: Flow | TECH Only Flow Optimization
- **PR1050558-5391** (Sprint 12.3) - Flow Automation | Tech: Flow | TECH Only Flow Optimization
- **PR1050558-5399** (Sprint 12.3) - Flow Automation | Tech: Apex, Flow | TECH Only Flow Optimization - Part 2
- **PR1050558-5410** (Sprint 12.2) - General | Tech: N/A | Observation Bug - IC NPPA Termination - Cases are created wi
- **PR1050558-5441** (Sprint 12.3) - General | Tech: N/A | PROD Enhancement: C&CUAT466 Payroll Report Building Access
- **PR1050558-5456** (Sprint 12.3) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare26 Update task Subject = 'Popul
- **PR1050558-5456** (Sprint 12.4) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare26 Update task Subject = 'Popul
- **PR1050558-5457** (Sprint 12.5) - Configuration | Tech: Formula Field | UAT Enhancement: Intake Form: Clinician Profile Assessment C
- **PR1050558-5470** (Sprint 12.3) - Configuration | Tech: N/A | PROD Bug: Training object - Integration user needs access to
- **PR1050558-5474** (Sprint 12.3) - Configuration | Tech: N/A | PROD Bug: Integration User needs ability to update/create Tr
- **PR1050558-5493** (Sprint 12.3) - Security Setup | Tech: N/A | PROD Enhancement: UPHypercare37 - Data Quality Needs Access 
- **PR1050558-5521** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare68 - Update logic on Contract S
- **PR1050558-5521** (Sprint 12.6) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare68 - Update logic on Contract S
- **PR1050558-5525** (Sprint 12.5) - General | Tech: N/A | PROD Enhancement: UPHypercare73 - Need a solution for recrui
- **PR1050558-5580** (Sprint 12.3) - Apex Development | Tech: Apex, Flow, Validation Rule | PROD Enhancement: UPHypercare133 - HPF 'Status' is getting s
- **PR1050558-5580** (Sprint 12.5) - Apex Development | Tech: Apex, Flow, Validation Rule | PROD Enhancement: UPHypercare133 - HPF 'Status' is getting s
- **PR1050558-5580** (Sprint 13) - Apex Development | Tech: Apex, Flow, Validation Rule | PROD Enhancement: UPHypercare133 - HPF 'Status' is getting s
- **PR1050558-5580** (Sprint 14) - Apex Development | Tech: Apex, Flow, Validation Rule | PROD Enhancement: UPHypercare133 - HPF 'Status' is getting s
- **PR1050558-5588** (Sprint 12.3) - Declarative Logic | Tech: Validation Rule | PROD Enhancement: UPHypercare139 - First Clinical Shift inte
- **PR1050558-5588** (Sprint 12.4) - Declarative Logic | Tech: Validation Rule | PROD Enhancement: UPHypercare139 - First Clinical Shift inte
- **PR1050558-559** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automated Onboarding Task Creation - SCP Onboarding
- **PR1050558-5594** (Sprint 12.3) - OmniStudio | Tech: OmniScript | PROD Enhancement: UPHypercare147 - Risk Review Process not p
- **PR1050558-5597** (Sprint 12.5) - General | Tech: N/A | PROD Permissions: UPhypercare151: Access to Leadership Chang
- **PR1050558-560** (Sprint 4) - General | Tech: N/A | View Preventive Care Agreement on Contract Payment Agreement
- **PR1050558-561** (Sprint 4) - Configuration | Tech: N/A | Clinician Onboarding Case & Task Templates
- **PR1050558-5617** (Sprint 12.3) - Flow Automation | Tech: Flow | PROD Bug: System is creating duplicate HealthcareProvider re
- **PR1050558-5617** (Sprint 12.4) - Flow Automation | Tech: Flow | PROD Bug: System is creating duplicate HealthcareProvider re
- **PR1050558-562** (Sprint 4) - Apex Development | Tech: Apex | Clinician Onboarding Record Automation - SCP Onboarding - Pa
- **PR1050558-563** (Sprint 4) - Security Setup | Tech: N/A | Enrollment Specialist Queue
- **PR1050558-5634** (Sprint 12.3) - General | Tech: N/A | PROD Enhancement: UPHypercare186 - Receiving error when gene
- **PR1050558-5641** (Sprint 12.5) - Configuration | Tech: Apex | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-5641** (Sprint 14) - Configuration | Tech: Apex | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-5642** (Sprint 12.3) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare189 - Special Terms in Contract
- **PR1050558-5642** (Sprint 12.5) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare189 - Special Terms in Contract
- **PR1050558-5642** (Sprint 12.6) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare189 - Special Terms in Contract
- **PR1050558-5648** (Sprint 14) - Apex Development | Tech: Apex, Flow | PROD Enhancement: HPF Inactive Date Trigger to Qgenda - Upda
- **PR1050558-566** (Sprint 4) - Security Setup | Tech: N/A | MSL-CC Queue
- **PR1050558-5692** (Sprint 12.5) - Flow Automation | Tech: Flow, Integration Procedure, Formula Field | PROD Enhancement: UPHypercare221 - Start-up Practice Operati
- **PR1050558-5692** (Sprint 13) - Flow Automation | Tech: Flow, Integration Procedure, Formula Field | PROD Enhancement: UPHypercare221 - Start-up Practice Operati
- **PR1050558-5692** (Sprint 14) - Flow Automation | Tech: Flow, Integration Procedure, Formula Field | PROD Enhancement: UPHypercare221 - Start-up Practice Operati
- **PR1050558-5693** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare223 - PO Contract Overview not 
- **PR1050558-5693** (Sprint 12.6) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare223 - PO Contract Overview not 
- **PR1050558-5703** (Sprint 12.4) - Configuration | Tech: Formula Field, REST | PROD Bug: UPHypercare228 - Missing service lines used for fi
- **PR1050558-5703** (Sprint 12.6) - Configuration | Tech: Formula Field, REST | PROD Bug: UPHypercare228 - Missing service lines used for fi
- **PR1050558-5708** (Sprint 14) - Flow Automation | Tech: Flow, Formula Field | PROD Enhancement: UPHypercare233 - Adjust cloning logic rela
- **PR1050558-5709** (Sprint 13) - Declarative Logic | Tech: Validation Rule | PROD Enhancement: UPHypercare234 - Need the system to check 
- **PR1050558-5709** (Sprint 14) - Declarative Logic | Tech: Validation Rule | PROD Enhancement: UPHypercare234 - Need the system to check 
- **PR1050558-572** (Sprint 4) - Apex Development | Tech: Apex, Flow | Agreement Request - Email Alert
- **PR1050558-5726** (Sprint 12.4) - Configuration | Tech: N/A | Preventive Care Agreement - Add Field History
- **PR1050558-5728** (Sprint 12.5) - General | Tech: N/A | PROD Enhancement: UPHypercare243 - Provider Contracting need
- **PR1050558-5728** (Sprint 13) - General | Tech: N/A | PROD Enhancement: UPHypercare243 - Provider Contracting need
- **PR1050558-5728** (Sprint 14) - General | Tech: N/A | PROD Enhancement: UPHypercare243 - Provider Contracting need
- **PR1050558-573** (Sprint 4) - Security Setup | Tech: N/A | Initial Role Hierarchy
- **PR1050558-5733** (Sprint 12.5) - General | Tech: N/A | PROD Enhancement: UPHypercare250 - NPPA 'Call' shift with pe
- **PR1050558-5733** (Sprint 12.6) - General | Tech: N/A | PROD Enhancement: UPHypercare250 - NPPA 'Call' shift with pe
- **PR1050558-5734** (Sprint 12.4) - Configuration | Tech: Validation Rule | PROD Enhancement: UPHypercare251 - Need 2 decimal places on 
- **PR1050558-5788** (Sprint 12.4) - General | Tech: N/A | PROD Permissions: UPHypercare264 - Operation Finance financi
- **PR1050558-5788** (Sprint 12.5) - General | Tech: N/A | PROD Permissions: UPHypercare264 - Operation Finance financi
- **PR1050558-5788** (Sprint 12.6) - General | Tech: N/A | PROD Permissions: UPHypercare264 - Operation Finance financi
- **PR1050558-5791** (Sprint 12.4) - Security Setup | Tech: N/A | PROD Bug: UPHypercare267 - Review CPA Relationship not popul
- **PR1050558-5791** (Sprint 12.5) - Security Setup | Tech: N/A | PROD Bug: UPHypercare267 - Review CPA Relationship not popul
- **PR1050558-5791** (Sprint 13) - Security Setup | Tech: N/A | PROD Bug: UPHypercare267 - Review CPA Relationship not popul
- **PR1050558-5792** (Sprint 12.4) - Apex Development | Tech: Apex, Flow, Formula Field | PROD Enhancement: UPHypercare268 - HPF termination date for 
- **PR1050558-5792** (Sprint 12.5) - Apex Development | Tech: Apex, Flow, Formula Field | PROD Enhancement: UPHypercare268 - HPF termination date for 
- **PR1050558-5792** (Sprint 14) - Apex Development | Tech: Apex, Flow, Formula Field | PROD Enhancement: UPHypercare268 - HPF termination date for 
- **PR1050558-5793** (Sprint 12.4) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare269 - Transition Specialist Que
- **PR1050558-5793** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare269 - Transition Specialist Que
- **PR1050558-5793** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare269 - Transition Specialist Que
- **PR1050558-5793** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare269 - Transition Specialist Que
- **PR1050558-5822** (Sprint 12.5) - Configuration | Tech: REST | PROD Enhancement: 'Risk Management' Account Team Role
- **PR1050558-5823** (Sprint 12.5) - Configuration | Tech: N/A | PROD Enhancement: HPF - Add Section = 'Insurance Information
- **PR1050558-5828** (Sprint 12.3) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare133 - Add Case History
- **PR1050558-5828** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare133 - Add Case History
- **PR1050558-5828** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare133 - Add Case History
- **PR1050558-5828** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare133 - Add Case History
- **PR1050558-5829** (Sprint 12.3) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare133 - Add validation on SCP Cas
- **PR1050558-5831** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare287 - Remove Legal Client Contr
- **PR1050558-5831** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare287 - Remove Legal Client Contr
- **PR1050558-5831** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare287 - Remove Legal Client Contr
- **PR1050558-5840** (Sprint 13) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare289 - Risk Team - Needs Access 
- **PR1050558-5840** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare289 - Risk Team - Needs Access 
- **PR1050558-5844** (Sprint 12.5) - LWC/Aura Component | Tech: N/A | PROD Bug: UPHypercare293 - GPID no longer showing at top of 
- **PR1050558-5844** (Sprint 12.6) - LWC/Aura Component | Tech: N/A | PROD Bug: UPHypercare293 - GPID no longer showing at top of 
- **PR1050558-5848** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare295 - Update SCP Onboarding Tas
- **PR1050558-5853** (Sprint 12.6) - Configuration | Tech: N/A | PROD Permissions: UPHypercare298: Unable to edit bootcamp da
- **PR1050558-5859** (Sprint 12.5) - General | Tech: Apex | PROD Enhancement: UPHypercare303 - EE/Employed clinicians no
- **PR1050558-5859** (Sprint 13) - General | Tech: Apex | PROD Enhancement: UPHypercare303 - EE/Employed clinicians no
- **PR1050558-5859** (Sprint 14) - General | Tech: Apex | PROD Enhancement: UPHypercare303 - EE/Employed clinicians no
- **PR1050558-5863** (Sprint 13) - LWC/Aura Component | Tech: Apex, Flow | PROD Enhancement: Send individual HPF Inactivation Email
- **PR1050558-5863** (Sprint 14) - LWC/Aura Component | Tech: Apex, Flow | PROD Enhancement: Send individual HPF Inactivation Email
- **PR1050558-5873** (Sprint 12.5) - Apex Development | Tech: Apex, Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-5873** (Sprint 14) - Apex Development | Tech: Apex, Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-5874** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: Platform Event = HPFUpdate, Type = Rate fo
- **PR1050558-5914** (Sprint 12.5) - Flow Automation | Tech: Flow, OmniScript | PROD Enhancement: HPF - Updated 'Time Type' picklist value f
- **PR1050558-5914** (Sprint 12.6) - Flow Automation | Tech: Flow, OmniScript | PROD Enhancement: HPF - Updated 'Time Type' picklist value f
- **PR1050558-5917** (Sprint 12.6) - Flow Automation | Tech: Flow, OmniScript | PROD Enhancement: PCA - Updated 'Time Type' picklist value f
- **PR1050558-592** (Sprint 4) - Configuration | Tech: N/A | Create Default Task Record Type and Page Layout - Portal
- **PR1050558-5921** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: Service Account, HPF and Clinician Contrac
- **PR1050558-5924** (Sprint 12.5) - Security Setup | Tech: CSS | PROD Enhancement: UPHypercare338 - Update how Rates are disp
- **PR1050558-5947** (Sprint 12.5) - General | Tech: N/A | PROD Bug: UPHypercare340 - QGenda Scheduling Event Firing To
- **PR1050558-5950** (Sprint 12.6) - General | Tech: Apex | PROD Enhancement: Facility Change Request - Coverage Change 
- **PR1050558-5984** (Sprint 13) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare369 - HPF Termination Date not 
- **PR1050558-5984** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare369 - HPF Termination Date not 
- **PR1050558-5998** (Sprint 13) - Apex Development | Tech: Apex | UAT Enhancement: Registration URL Exposure (Recruiter Backup
- **PR1050558-5998** (Sprint 14) - Apex Development | Tech: Apex | UAT Enhancement: Registration URL Exposure (Recruiter Backup
- **PR1050558-5999** (Sprint 13) - Configuration | Tech: N/A | PROD Enhancement: Recruiter Self-Service: Password Reset Lin
- **PR1050558-5999** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: Recruiter Self-Service: Password Reset Lin
- **PR1050558-6000** (Sprint 13) - Apex Development | Tech: Apex, Flow | PROD Enhancement: Intake Status Auto-Update on Assessment Co
- **PR1050558-6000** (Sprint 14) - Apex Development | Tech: Apex, Flow | PROD Enhancement: Intake Status Auto-Update on Assessment Co
- **PR1050558-6001** (Sprint 13) - General | Tech: N/A | UAT Enhancement: Single Intake Completion (No Repeat Intake 
- **PR1050558-6001** (Sprint 14) - General | Tech: N/A | UAT Enhancement: Single Intake Completion (No Repeat Intake 
- **PR1050558-6002** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: PERMISSIONS – Assessment Object Visibility
- **PR1050558-6002** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: PERMISSIONS – Assessment Object Visibility
- **PR1050558-6015** (Sprint 13) - General | Tech: N/A | Compliance Rule Assignments - Needs Mapping
- **PR1050558-6015** (Sprint 14) - General | Tech: N/A | Compliance Rule Assignments - Needs Mapping
- **PR1050558-605** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Stipend
- **PR1050558-606** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Variable
- **PR1050558-608** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Bonus
- **PR1050558-6082** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare403 - Copy CES to on the Welcom
- **PR1050558-6096** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare380 - Service Account Address U
- **PR1050558-6096** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare380 - Service Account Address U
- **PR1050558-6097** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: UPHypercare410 - Unable to check the Noctu
- **PR1050558-6098** (Sprint 13) - General | Tech: N/A | PROD Enhancement: Clinician Onboarding tasks - Populate 'Nam
- **PR1050558-6098** (Sprint 14) - General | Tech: N/A | PROD Enhancement: Clinician Onboarding tasks - Populate 'Nam
- **PR1050558-610** (Sprint 4) - Apex Development | Tech: Apex, Flow | Clinician Onboarding Record Automation - Facility Onboarding
- **PR1050558-614** (Sprint 5) - LWC/Aura Component | Tech: N/A | Create Account Team Roles
- **PR1050558-614** (Sprint 6) - LWC/Aura Component | Tech: N/A | Create Account Team Roles
- **PR1050558-6141** (Sprint 13) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare380 - Clinician Updates to QGen
- **PR1050558-6141** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare380 - Clinician Updates to QGen
- **PR1050558-6146** (Sprint 13) - Flow Automation | Tech: Flow | Cloned Clinician Contract - Term Sheet Status field not gett
- **PR1050558-6148** (Sprint 14) - Apex Development | Tech: Apex | Client Change Management: Update Canceled Status criteria fo
- **PR1050558-615** (Sprint 5) - Apex Development | Tech: Apex, Flow | Intake Form Automation - Send
- **PR1050558-616** (Sprint 5) - General | Tech: N/A | Standardize Care Specialty Records
- **PR1050558-6163** (Sprint 14) - Configuration | Tech: N/A | Client Change Management: Update Permission Set = Manage Cli
- **PR1050558-617** (Sprint 5) - General | Tech: N/A | Standardize Care Taxonomy Records
- **PR1050558-619** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automated Onboarding Record Creation (When Contract is Execu
- **PR1050558-620** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automated Onboarding Case Record Closure
- **PR1050558-6208** (Sprint 14) - Configuration | Tech: N/A | PROD Enhancement: Remove ability for Recruiters to create Ac
- **PR1050558-621** (Sprint 4) - Apex Development | Tech: Apex, Flow | Clinician Onboarding Record Automation - Facility Onboarding
- **PR1050558-622** (Sprint 4) - Apex Development | Tech: Apex | Clinician Onboarding Record Automation - SCP Onboarding - Ch
- **PR1050558-6235** (Sprint 14) - Apex Development | Tech: Apex | PROD Enhancement: Update HPF Status from "Superseded" to "In
- **PR1050558-6237** (Sprint 12.5) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-6237** (Sprint 14) - Flow Automation | Tech: Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-6252** (Sprint 13) - General | Tech: N/A | HPF Validation Rule Update
- **PR1050558-6260** (Sprint 12.5) - Apex Development | Tech: Apex, Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-6260** (Sprint 14) - Apex Development | Tech: Apex, Flow | PROD Enhancement: UPHypercare311 - Remove Locum clinicians f
- **PR1050558-6264** (Sprint 14) - Configuration | Tech: N/A | Create two fields on Integration_Log__c - Error_Code__c and 
- **PR1050558-6307** (Sprint 12.5) - Configuration | Tech: Apex | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-6307** (Sprint 14) - Configuration | Tech: Apex | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-6314** (Sprint 12.5) - Reporting | Tech: N/A | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-6314** (Sprint 14) - Reporting | Tech: N/A | PROD Enhancement: Update the Clinician Inactivation Process 
- **PR1050558-6322** (Sprint 14) - Security Setup | Tech: REST | PROD Bug: TeamRole - Off Boarding Tasks Flow missing Metadat
- **PR1050558-6348** (Sprint 14) - LWC/Aura Component | Tech: N/A | Observation: Facility offboarding Guided flow is showing  HP
- **PR1050558-6349** (Sprint 14) - LWC/Aura Component | Tech: N/A | Observation: User is able to add 'Superseded' HPF to clinici
- **PR1050558-6354** (Sprint 14) - General | Tech: N/A | Observation: Old HPF is not marked as 'Superseded' if delink
- **PR1050558-666** (Sprint 5) - LWC/Aura Component | Tech: LWC | Update Guided Create HPF - Board Cert & Medical License
- **PR1050558-697** (Sprint 5) - Configuration | Tech: N/A | Shift Custom Object & PCA Cleanup
- **PR1050558-700** (Sprint 5) - Security Setup | Tech: N/A | Specify Corporate Entity Type
- **PR1050558-701** (Sprint 7) - OmniStudio | Tech: OmniScript | Clinician Offboarding - Facility Selection
- **PR1050558-702** (Sprint 5) - Apex Development | Tech: Apex, Flow | Clinician Contract Executed Automation (Field Creation)
- **PR1050558-702** (Sprint 6) - Apex Development | Tech: Apex, Flow | Clinician Contract Executed Automation (Field Creation)
- **PR1050558-703** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Button and Record Creation
- **PR1050558-707** (Sprint 5) - General | Tech: N/A | Attach Files During Risk Review
- **PR1050558-712** (Sprint 5) - Security Setup | Tech: N/A | Create Permission Set for AffectLayer Apps
- **PR1050558-715** (Sprint 4) - Configuration | Tech: N/A | Facility Rate Creation - Summary tab
- **PR1050558-716** (Sprint 4) - Configuration | Tech: N/A | Update Guided Clinician Creation
- **PR1050558-77** (Sprint 1) - Security Setup | Tech: N/A | Corporate Support Profile
- **PR1050558-774** (Sprint 5) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Variable: Modify Typ
- **PR1050558-775** (Sprint 8) - Configuration | Tech: N/A | Corporate Compliance Status
- **PR1050558-775** (Sprint 9) - Configuration | Tech: N/A | Corporate Compliance Status
- **PR1050558-776** (Sprint 4) - Configuration | Tech: N/A | SPIKE - Pro Forma Outputs - POC for Option 1
- **PR1050558-777** (Sprint 5) - General | Tech: N/A | Facility Rate Creation - Rate Rules/Validations
- **PR1050558-78** (Sprint 1) - Security Setup | Tech: N/A | Corporate Support App
- **PR1050558-79** (Sprint 1) - Configuration | Tech: N/A | Create Facility Records
- **PR1050558-796** (Sprint 5) - General | Tech: N/A | Integration User - View Encrypted Data
- **PR1050558-80** (Sprint 1) - Configuration | Tech: N/A | Facility Contract and Rate Records
- **PR1050558-809** (Sprint 5) - General | Tech: N/A | Configure Case Page - Onboarding
- **PR1050558-81** (Sprint 1) - Configuration | Tech: N/A | Initial Clinician Record
- **PR1050558-810** (Sprint 7) - Apex Development | Tech: Apex, Flow | Automatically Create Healthcare Provider Records - Client
- **PR1050558-810** (Sprint 8) - Apex Development | Tech: Apex, Flow | Automatically Create Healthcare Provider Records - Client
- **PR1050558-811** (Sprint 5) - Apex Development | Tech: Apex, Flow, REST | Automatically Provision HC Portal Access
- **PR1050558-821** (Sprint 6) - Flow Automation | Tech: Flow | Risk Review Approvals - Notification to Payroll
- **PR1050558-822** (Sprint 5) - Flow Automation | Tech: Flow, OmniScript | Enforce Contract to Manually Initiate Onboarding
- **PR1050558-822** (Sprint 6) - Flow Automation | Tech: Flow, OmniScript | Enforce Contract to Manually Initiate Onboarding
- **PR1050558-823** (Sprint 6) - Apex Development | Tech: Apex, Flow | Create HPF from Job
- **PR1050558-823** (Sprint 7) - Apex Development | Tech: Apex, Flow | Create HPF from Job
- **PR1050558-827** (Sprint 4) - Configuration | Tech: N/A | Configure Case Page - Intake Form
- **PR1050558-83** (Sprint 2) - Configuration | Tech: N/A | Clinician Contract Records
- **PR1050558-833** (Sprint 5) - Configuration | Tech: Formula Field | Update Code Set Object and Facility Title Records
- **PR1050558-835** (Sprint 5) - General | Tech: N/A | Update Initiate Early Onboarding - SCP Error Message
- **PR1050558-836** (Sprint 5) - Configuration | Tech: Formula Field | Update Employment Type on Healthcare Practitioner Facility
- **PR1050558-838** (Sprint 5) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = Variable, Stipend & 
- **PR1050558-839** (Sprint 5) - Configuration | Tech: N/A | Facility Rate Creation - Type of Rate = All: Add Override Pr
- **PR1050558-840** (Sprint 5) - General | Tech: N/A | Clinician Experience Specialist Test User
- **PR1050558-841** (Sprint 6) - General | Tech: N/A | Code Set List Views
- **PR1050558-842** (Sprint 10) - Apex Development | Tech: Apex, Flow | IT Support Ticket
- **PR1050558-842** (Sprint 9) - Apex Development | Tech: Apex, Flow | IT Support Ticket
- **PR1050558-852** (Sprint 5) - Apex Development | Tech: Apex, Flow | Intake Form Automation - Closed
- **PR1050558-857** (Sprint 5) - Security Setup | Tech: N/A | Enrollment Specialist Queue - Support Cases
- **PR1050558-86** (Sprint 1) - Configuration | Tech: N/A | Initial National, Facility, and Service Line Account Records
- **PR1050558-87** (Sprint 1) - General | Tech: N/A | Related Clinician Records
- **PR1050558-88** (Sprint 1) - Configuration | Tech: N/A | Create Service Records
- **PR1050558-882** (Sprint 5) - General | Tech: N/A | Facility Rate Creation - Summary tab - Shift updates
- **PR1050558-883** (Sprint 8) - Security Setup | Tech: N/A | Exit Interview Feedback Security
- **PR1050558-884** (Sprint 8) - Flow Automation | Tech: Flow | Exit Interview Feedback Capture
- **PR1050558-886** (Sprint 12) - Configuration | Tech: N/A | SUN Task Template Setup
- **PR1050558-886** (Sprint 12.1) - Configuration | Tech: N/A | SUN Task Template Setup
- **PR1050558-887** (Sprint 12) - Flow Automation | Tech: Flow | SUN Orchestration - Email Alert
- **PR1050558-887** (Sprint 12.1) - Flow Automation | Tech: Flow | SUN Orchestration - Email Alert
- **PR1050558-888** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician “At a Glance” Display Responsive based on Audience
- **PR1050558-889** (Sprint 7) - LWC/Aura Component | Tech: N/A | Clinician "At a Glance" UI
- **PR1050558-890** (Sprint 6) - General | Tech: N/A | Clinician Application Visibility - HC Portal
- **PR1050558-891** (Sprint 6) - Configuration | Tech: N/A | Clinician Application Withdrawal - HC Portal
- **PR1050558-891** (Sprint 7) - Configuration | Tech: N/A | Clinician Application Withdrawal - HC Portal
- **PR1050558-892** (Sprint 5) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Leased or Locums
- **PR1050558-892** (Sprint 6) - OmniStudio | Tech: OmniScript | Clinician Contract Request: Leased or Locums
- **PR1050558-893** (Sprint 5) - OmniStudio | Tech: OmniScript, Integration Procedure | Clinician Contract Request: HPF Selection
- **PR1050558-893** (Sprint 6) - OmniStudio | Tech: OmniScript, Integration Procedure | Clinician Contract Request: HPF Selection
- **PR1050558-894** (Sprint 6) - General | Tech: N/A | Clinician Contract Request: Summary Screen
- **PR1050558-903** (Sprint 5) - LWC/Aura Component | Tech: Apex, Flow | Risk Review Approvals - Decision & Views
- **PR1050558-905** (Sprint 11) - Flow Automation | Tech: Flow, REST | SUN Orchestration - Trigger Case Creation
- **PR1050558-905** (Sprint 12) - Flow Automation | Tech: Flow, REST | SUN Orchestration - Trigger Case Creation

---

## Usage Notes

- Use this index to find similar technical solutions
- Categories and tech stack are auto-detected
- For full solution details, refer to sprint HTML files
- For story details, see `MASTER-STORY-INDEX.md`
