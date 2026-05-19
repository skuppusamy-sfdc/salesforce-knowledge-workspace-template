# Component Dependency Graph

**Purpose**: Understand component relationships and dependencies for impact analysis.

**Last Updated**: April 22, 2026  
**Apex Dependencies**: 1570  
**LWC Dependencies**: 0  
**Flow Dependencies**: 35  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find component dependencies**: Ctrl+F for component name
- **Impact analysis**: See what components depend on a specific component
- **Change planning**: Identify affected components before making changes

---

## Dependency Statistics

| Type | Components Analyzed | Dependencies Found |
|------|--------------------|--------------------|
| Apex Classes | 137 | 1570 |
| LWC Components | 0 | 0 |
| Flows | 19 | 35 |

---

## Apex Class Dependencies

*Classes that reference other classes*

### AccountDetails

**Depends on**: InvocableOutput

### AccountDetailsTest

**Depends on**: AccountDetails, TestDataFactory

### AllVisualForceTest

**Depends on**: Account, CompetitorsExtension, CreateCompetitorExtension, Lead, LeadScoreCardbyAccount__c, Opportunity, PageReference, ScoreCardMatrix__c, SystemTreeExtension

### CIFormAssessmentControllerTest

**Depends on**: Account, Accounts, Case, ClinicianIntakeFormAssessmentController, DataFactory, OmniProcess, Processes, Service_Line__c, TestDataFactory

### CPARelationshipRecordsGenerator

**Depends on**: CPARelationshipRecordsGeneratorQueuable, Ids

### CPARelationshipRecordsGeneratorQueuable

**Depends on**: AccToOtherClinicianHPFidsMap, AccountId, AccountIdHPFId, CPAIds, CPARelationshipRecordsGeneratorQueuable, CPAReviewCaseGenerator, CPAs, ClinicianHPFidsList, CliniciansCPAsHPFsIdSet, Collaborative_Practice_Agreement__c, ErrorLogUtil, IdToOtherAccountIdMap, JSON, PncList, RecordsToInsert, RecordsToUpdate, RecordsToUpsert

### CPARelationshipRecordsGeneratorTest

**Depends on**: Account, AccountTeamMember, CPARelationshipRecordsGenerator, CPAReviewCaseGenerator, Case, Cases, Class, CodeSet, Collaborative_Practice_Agreement__c, Contract, CpaIds, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, IdsFromReviews, PermissionSetAssignment, ProviderNetworkContract, Reviews, User, Userinfo

### CPAReviewCaseGenerator

**Depends on**: AccountToClinicianHPFMap, CPACase, CPAReviewCaseGenerator, CPA_Review__c, Case, ErrorLogUtil, FacilityAccountIds, HPFIds, IdSet, IdToCaseMap, IdToCaseOwnerMap, IdToServiceAccountIdMap, JSON, RecordsToProcess, ReviewsToInsert

### CalculateNPPARates

**Depends on**: InvocableOutput, ListForEachHpf, MapOfCountAndSumOfRates, MapOfHPFIdToPCA, ToAdd

### CalculateNPPARatesTest

**Depends on**: CalculateNPPARates, List1, PCAList, TDF, TestDataFactoryCore

### CheckRatesForServiceAccFacility

**Depends on**: Codes, Result, TitleIds

### CheckRatesForServiceAccFacility_Test

**Depends on**: CheckRatesForServiceAccFacility, CodeSet, Contract, ContractPaymentAgreement, PreventiveCareAgreement, Shift__c, TDF, TestDataFactoryCore, Time

### ClinicalManagerController

**Depends on**: AccountIds, AuraHandledException, Body, ClinicalDataWrapper, ClinicalManagerController, ClinicalManagerList, ClinicalManagerRequest, ClinicalManagerResponse, ClinicalRecord, Clinical_Rate_Change__c, ClinicianData, ClinicianIdStrings, Contacts, ContractIds, Data, DataList, Error, Ids, JSON, LightningResponse, Object, PersonAccIdVsOverRate, PractIdsFromHPF, RateChangeQueryService, Record, Records, Response, SelectedClinicianIds, Wrapper

### ClinicalManagerControllerTest

**Depends on**: Account, CRC, Client_Change_Management__c, ClinicalManagerController, Clinical_Rate_Change__c, Contacts, Contracts, DataList, GetAllIds, GetData, GetSummary, HPF, RecordIds, TestDataFactory

### ClinicianContractCloneService

**Depends on**: CPAs, CPAtoNewCPA, CalloutException, ClinicianContractCloneService, ClonedPCAs, Contract, ContractByAccount, ContractClones, ContractMap, Contracts, CreatedContractIds, Desc, DmlException, Fields, Ids, Names, ObjectType, PCAs, PNCClones, PNCs, PayCodesToDelete, Pcas, PreventiveCareAgreement, RateChangeNotificationUtil, Results, ShiftPcaMap, StartDate, ToCloneMap, ToDelete, ToNewContractMap, ToNewPNCMap, ToNewPcaMap, ToUpdate, Values

### ClinicianContractCloneServiceTest

**Depends on**: ClinicianContractCloneService, Delete, Ids, Pcas, PreventiveCareAgreement, Rate_Pay_Code__c, TestData, TestDataFactory, Time, ToNew

### ClinicianContractSyncQueueable

**Depends on**: ClinicianContractSyncService, Ids

### ClinicianContractSyncQueueableTest

**Depends on**: After, Client_Change_Management__c, ClinicianContractSyncQueueable, ClinicianContractSyncService, CodeSet, Contract, Contract2, ContractPaymentAgreement, Contracts, DayPCAs, Description, Fields, IdToContractNumberMap, Ids, NightPCAs, NightPcas, PCAs, PreventiveCareAgreement, ProviderNetworkContract, Rates, Record, Records, SObjectType, Shift__c, Shifts, Task, TestDataCache, TestDataFactory, Time

### ClinicianContractSyncService

**Depends on**: AccountIds, CategoriesWithNewShifts, CcmRecords, ClinicianAccountIds, ClinicianRatesByHpf, ContractIds, ContractsForHpf, Fields, ForHPF, IdToContractIdMap, IdToContractNumberMap, IdToHPFIdMap, IdWithAccountId, IdWithCCMMap, Ids, IdsFromCCM, Name, Numbers, OfHPFToContractShiftRates, PoContractIdWithShiftTypes, PracticeOperationChangeUtil, RateMap, Rates, RatesByCategory, RatesForCategory, RatesMap, Records, SObjectType, ShiftRates, ShiftTypes, ShiftTypesForHPF, Task, ToAccountMap, ToClinicianNameMap, ToContractNumbersMap, ToInsert, ToNameMap, ToOwnerMap, ToTeamMemberMap, ToUpdate, TypeMap, Types, UpdatedRateShiftData, WithAnyExecutedContract, WithContract

### ClinicianCoverageUpdateBatch

**Depends on**: Accounts, ByCPAByServAccFacilityTitle, ByCPAByShiftType, ByKey, ByShiftType, CPAIds, CPAMap, CPAWithUpdateMap, CPAs, ClientPCAIds, ClientRPCs, ClinicianCPAIds, ClinicianCPAIdsForRatePayCodes, ClinicianCloneContext, ClinicianCloneResult, ClinicianContractSyncService, ClinicianPCAIds, Codes, ContractFacilities, ContractIds, ErrorLogUtil, EventBus, HPFUpdates__e, IdWithCPAId, IdWithPayRateChange, Ids, IdsForSync, Keys, Name, Names, NamesByCPA, OperationContracts, OperationShifts, PCA, PCAMap, PCAResult, PCAWithSerAccTitleShift, PCAs, PCAsWithShiftAdded, PayCodeResult, ProcessedCPAIds, RPCMap, RateCode, RatePayCodeChanges, RatePayCodeMap, RatePayCodes, RatePayCodesToDelete, RatesByCPA, RatesByShiftType, RecordIds, RecordsByContractFacility, RecordsToUpdate, Results, Service, ShiftNames, Titles, ToUpdate, TypeRates

### ClinicianCoverageUpdateBatchTest

**Depends on**: Client_Change_Management__c, ClinicianCoverageUpdateBatch, Contract, ErrorLogUtil, Logs, PCAs, Pay_Codes__c, Practice_Operation_Change__c, PreventiveCareAgreement, RPCs, Rate_Pay_Code__c, TestDataFactoryCore, Time

### ClinicianCoverageUpdateScheduler

**Depends on**: ClinicianCoverageUpdateBatch, ClinicianCoverageUpdateScheduler

### ClinicianCoverageUpdateSchedulerTest

**Depends on**: ClinicianCoverageUpdateScheduler

### ClinicianIntakeFormAssessmentController

**Depends on**: AssessmentEnvelope, AssessmentEnvelopeItem, DocumentWrapper, EnvItemName, NameList, NameWithConfigMap

### CloneAndDocumentQueueable

**Depends on**: ContractIds, Ids, RateChangeService

### CloneContractAction

**Depends on**: AgData, AsyncJobOutput, CalloutException, CloneQueueableInput, IdParsingUtil, IdStrings, Ids, Input, InvocableOutput, JSON, Job, RateChangeInvocableInput, RateChangeQueryService, RateChangeQueueable

### CloneHelper

**Depends on**: Desc, Fields, Values

### CommunityLoginController

**Depends on**: AuraHandledException, DefaultSiteLoginAction, LoginAction, Logins, Message, MockSiteLoginAction, Page, PageReference, Site

### CommunityLoginControllerTest

**Depends on**: CommunityLoginController, Site, User

### CongaAgreementServiceHelper

**Depends on**: AARMap, AccIdToAgreeIdMap, AccToSLToHPFMap, Account, AccountIds, AgreeIdSet, AgreeMap, CEToAccountIdsMap, CEToFacilityNamesMap, CEToSLPFacilityNamesMap, CTIContSet, CTIStatusSet, ChristusIdSet, ClinicianSet, CongaAgreementServiceHelperTest, HPFMap, IdNoCTISet, IdToAccountIdsMap, IdToAgreeIdMap, IdToCCEIdtoHrsMap, IdToContIdMap, IdToContIdNoCTIMap, IdToPCAIdMap, IdToPNCMap, NameSLPMap, NameSLPSet, NameSet, PCAMap, QueryMap, Rec, Recs, SLPIds, SObjectType, SR, ServiceAccIds, ShiftMap, TierNPPASet, TierSLSet, ToUseCorpNameMap

### CongaAgreementServiceHelperTest

**Depends on**: Account, AccountAccountRelation, Acct, Agree, Apttus__APTS_Agreement__c, CodeSet, CongaAgreementServiceHelper, Contract, ContractPaymentAgreement, Corporation_and_Tax_Information__c, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, LineRec, Opportunity, PartyRoleRelation, PreventiveCareAgreement, ProviderNetworkContract, Service_Line__c, Shift__c, Time

### CongaServiceTest

**Depends on**: Account, Apttus__APTS_Agreement__c, Case, Client_Change_Management__c, CodeSet, Contact, Contract, ContractPaymentAgreement, Contract_Agreement__c, Contracts, CreateCongaAgreementService, Formula, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, Pay_Codes__c, Practice_Operation_Change__c, PreventiveCareAgreement, ProviderNetworkContract, Rate_Pay_Code__c, Shift__c, TDF, TestDataFactoryCore, Time

### ContactSSNAction

**Depends on**: SSNInput, SSNOutputs

### ContactSSNActionTest

**Depends on**: Account, Assert, Contact

### ContractDetails

**Depends on**: InvocableOutput, Output

### ContractDetailsTest

**Depends on**: ContractDetails, TestDataFactory

### ContractSyncAction

**Depends on**: AsyncJobOutput, CalloutException, ContractIdsAndCrc, IdParsingUtil, Ids, InvocableOutput, Job, RateChangeInvocableInput, RateChangeQueryService, RateChangeQueueable

### ContractSyncRemoteAction

**Depends on**: ActiveRates, ActiveRatesByFacility, ClinicianCpaIds, ContractPaymentAgreement, Contracts, ContractsByAccountId, CpaMapByType, CpasByContractId, CpasByPncId, CpasToUpdate, ErrorLogUtil, IdToAccountIdMap, IdToBestPoContractId, IdToFacilityTitleMap, Ids, NetworkContracts, NotDeleted, OfCPA, OtherTypeActiveRates, OtherTypePcaMap, PcasByCpaId, PoContractIds, PoCpaIds, PoOtherTypePcaIdMap, PoShiftPcaIdMap, PreventiveCareAgreement, RPCToDelete, RecordsToDelete, RecordsToDeleteIdSet, RecordsToUpdate, ShiftActiveRates, ShiftPcaMap, ToDeleteIdSet, ToUpdate, TypeActiveRates, TypeActiveRatesByFacility, UpdatesMap

### ContractSyncRemoteActionTest

**Depends on**: Action, CodeSet, Contract, ContractPaymentAgreement, ContractSyncRemoteAction, CpaIdByType, Cpas, Pcas, PreventiveCareAgreement, Rate_Pay_Code__c, Shift__c, TDF, TestDataFactoryCore, Time

### ContractTerminationBatch

**Depends on**: ActiveHPFs, Case, CaseIds, CasesToInsert, HPFIds, HPFIdsToUpdate, HPFsMap, Ids, IdsForExtendingContracts, IdsToUpdate, Messages, TasksToUpdate, ToActiveHPFIdsMap, ToCancelReasonMap, ToExtendingHPFIdsMap, ToHPFIdsMap, ToPNCMap, ToUpdate, Types

### ContractTerminationBatchTest

**Depends on**: Account, Contract, ContractTerminationBatch, ContractTerminationScheduler, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, Nets, ProviderNetworkContract, Provs, Task

### ContractTerminationScheduler

**Depends on**: ContractTerminationBatch, ContractTerminationScheduler

### CreateClientChangeManagementQueueable

**Depends on**: Client_Change_Management__c, ClinicianContractSyncQueueable, ExistForHPF, Ids, OperationChangeIds, PracticeOperationChangeUtil, TitleKeys, ToInsert, ToPocs

### CreateCongaAgreementService

**Depends on**: Addendums, AddendumsToInsert, AgreementByCE, Agreements, Apttus__APTS_Agreement__c, CPAIds, CPAs, ChangeCases, CongaAgreementServiceHelper, ContractAgreements, Contract_Agreement__c, CorporateEntityIds, EntityIds, Hpf, IllegalArgumentException, JustCreated, TypeIds

### CreateCongaAgreementServiceTest

**Depends on**: Account, Apttus__APTS_Agreement__c, Case, Client_Change_Management__c, CodeSet, Contact, Contract, ContractPaymentAgreement, Contract_Agreement__c, Contracts, CreateCongaAgreementService, Formula, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, Pay_Codes__c, Practice_Operation_Change__c, PreventiveCareAgreement, ProviderNetworkContract, Rate_Pay_Code__c, Shift__c, TDF, TestDataFactoryCore, Time

### DeactivateCliniciansBatch

**Depends on**: AccId, AccIdToRltdContractMap, AccIdToSisContractMap, AccIdToUpdate, AccIdtoHPFMap, Account, AccountId, AccountIds, CaseList, Contract, Contracts, DeactivateCliniciansBatch, HPFListTpUpdate, IdAndRelatedAccId, IdToUpdate, Lst, OfServiceAccount, SistesContract, SistesHPF, WithServiceAccIdMap

### DeactivateCliniciansBatchInvoke

**Depends on**: DeactivateHPFsForClinician

### DeactivateCliniciansBatchInvokeTest

**Depends on**: DeactivateCliniciansBatchInvoke

### DeactivateCliniciansBatchTest

**Depends on**: Account, AccountAccountRelation, Case, Contract, DeactivateCliniciansBatch, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, PartyRoleRelation, PermissionSetAssignment, ProviderNetworkContract, Task, User, Userinfo

### DeactivateHPFsForClinician

**Depends on**: Account, CaseList, ClinicianToCntrctInitialEffDate, ClinicianToSisterSiteGrpToHPD, ClinicianToSisterSiteGrpToLWD, ClinicianToSisterSiteGrpToPNSD, DateWorked, ErrorLogUtil, ForScope, HPFId, HPFReportEmailUtil, HealthcarePractitionerFacility, HpfIds, IdToAccountId, IdToGroup, IdToName, IdToTerminate, Ids, IdsForEmail, InitialEffDate, ListToUpdate, ListToUpdatePermanent, PrvldDate, SisteResults, SisterSiteGroupingUtility, ToUpdate

### DeactivateHPFsForClinicianTest

**Depends on**: Account, AccountAccountRelation, Case, DataFactory, DeactivateHPFsForClinician, Hpf, PartyRoleRelation, PermissionSetAssignment, Task, TestDataFactory, Than270, User, Userinfo

### DocumentVersionTriggerHandler

**Depends on**: DocumentVersionTriggerHandler, IdToDocumentTitle, Ids, Name, NameLower, ToUpdateList, VersionToAgreementMap

### DocumentVersionTriggerHandlerTest

**Depends on**: Agreements, Apttus__APTS_Agreement__c, Apttus__APTS_Template__c, Apttus__DocumentVersion__c, DocVersions, DocumentVersionTriggerHandler, Templates

### ErrorLogUtil

**Depends on**: ErrorLogUtil, Error_Log__c

### ErrorLogUtilTest

**Depends on**: CalloutException, ErrorLogUtil, ErrorLogUtilTest, Error_Message__c, Error_Type__c, LogRequests, Logs, Source_Component__c, TestDataFactory

### GenerateAndAttachLetterAction

**Depends on**: AsyncJobOutput, GenerateLetterService, IdParsingUtil, Ids, InvocableOutput, Job, RateChangeInvocableInput, RateChangeQueryService, Result

### GenerateJobDescriptionController

**Depends on**: AuraHandledException, Facility_Name__r, Jobs, Lines, PaJobs

### GenerateJobDescriptionControllerTest

**Depends on**: Account, AccountTeamMember, Facility_Profile__c, GenerateJobDescriptionController, Job, PermissionSetAssignment, Service_Line__c, User, Userinfo

### GenerateLetterService

**Depends on**: Amount, Blob, CalloutException, ClientContractWrapper, Clinical_Rate_Change__c, ClinicianIdSet, ContentVersion, ContractIds, Contracts, Data, DocGenerationBatchProcess, DocumentGenerationProcess, GenerateAndAttachLetterResult, GenerateLetterService, Ids, JSON, Name, Rate, RateChangeNotificationUtil, RateChangeQueryService, SObjectException, ShiftTable, ToTimeTypeMap, TokenData, Update

### GenerateLetterServiceTest

**Depends on**: Blob, Clinical_Rate_Change__c, ContentVersion, Contract, Data, GenerateLetterService, Result, Table, TestData, TestDataFactory

### GetContractsToSend

**Depends on**: CalloutException, DraftContractOutput, Ids, InvocableOutput, Outputs, RateChangeContractUtil, RateChangeInvocableInput, RateChangeQueryService, WithLetter

### GetPOContractByClinicianStartDate

**Depends on**: ByAccount, Contracts, Input, JSON, POContractResult

### GetProviderNetworkControllerTest

**Depends on**: Account, Contract, GetProviderNetworkController, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, PermissionSetAssignment, Pnc, ProviderNetworkContract, Records, User, Userinfo

### GuidedClinicianCreationController

**Depends on**: Account, DuplicateRuleHeader

### GuidedClinicianCreationControllerTest

**Depends on**: GuidedClinicianCreationController, Result

### HPFReportEmailUtil

**Depends on**: CalloutException, DeactivateHPFsForClinician, Emails, ErrorLogUtil, IdMap, Ids, Math, Messaging, URL, Url

### HPFReportEmailUtilTest

**Depends on**: Account, AccountTeamMember, HPFReportEmailUtil, HealthcarePractitionerFacility, User, Users, WideEmails

### HttpMockCollectors

**Depends on**: HttpResponse

### HttpMockCollectorsFailed

**Depends on**: HttpResponse

### IdParsingUtil

**Depends on**: Data, JSON, Record, SelectedIds, Str

### JobStatusController

**Depends on**: CalloutException, JobStatusResult

### JobStatusControllerTest

**Depends on**: DocGenerationBatchProcess, JobStatusController, RateChangeQueueable

### OmniUtility

**Depends on**: Datetime, Error_Log__c, GetPOContractByClinicianStartDate, JSON, Values

### OmniUtilityTest

**Depends on**: Account, Assert, Contract, Contracts, GetPOContractByClinicianStartDate, JSON, OmniUtility, Result, Str

### OpportunityAttachmentController

**Depends on**: Attachment, AttachmentResult, Blob, Document_Type__c, Opportunity_Attachment__c, PageReference, Result, SelectOption, TypeList

### OpportunityAttachmentControllerTest

**Depends on**: Attachments, Blob, OpportunityAttachmentController, OpportunityTestDataHelper, Reference, SelectOptions

### OpportunityAttachmentTriggerHandler

**Depends on**: Contracts, DOCUMENT_TYPES, Ids, Version, Version__c

### OpportunityAttachmentTriggerHandlerTest

**Depends on**: OpportunityAttachmentTriggerHandler, OpportunityTestDataHelper, Opportunity_Attachment__c

### OpportunityHelper

**Depends on**: RequiredDocumentAttributes, RulesMap

### OpportunityTestDataHelper

**Depends on**: Account, Opportunity

### OpportunityTriggerHandler

**Depends on**: Attachment, Attachments, CurrentDocuments, MissingDocuments, OP, OPP, OWA, Opp, Opportunity, RequiredDocuments, RequiredFinal, Requireddocuments, StagingRule, TempList

### OpportunityTriggerHandlerTest

**Depends on**: Account, Attachment, Attachments, Blob, Opportunity, OpportunityTriggerHandler, Opportunity_Attachment__c, TriggerHandler

### PCATriggerHandler

**Depends on**: CapturePCA__e, EventBus

### PCATriggerHandlerTest

**Depends on**: TDF, TestDataFactoryCore

### PMT_AvailabilityResourceCreationTest

**Depends on**: PMT_AvailabilityResourceCreation

### PasswordResetController

**Depends on**: ErrorLogUtil, PasswordResetController, ResetResult, TestException

### PasswordResetControllerTest

**Depends on**: Message, PasswordResetController, TestDataFactory

### PendingRateChangeChecker

**Depends on**: AccountIds, CalloutException, Contracts, IdParsingUtil, Ids, InvocableOutput, JSON, PendingRateChangeChecker, RateChangeContractUtil, RateChangeInvocableInput, RateChangeNotificationUtil, RateChangeQueryService, WithLetter

### PostProcessRateChange

**Depends on**: AgData, DocGenerationBatchProcess, IDslocal, Ids, RateChangeService

### PostProcessRateChangeAction

**Depends on**: CalloutException, Changes, ContactIds, ContractIds, ContractStartDates, Contracts, CreatedContractIds, DocIds, DocMap, Docs, EmailBatchResult, EmailMessagesResult, EmailsSentContractIds, IdParsingUtil, Ids, Input, LinksByContract, Messaging, PostProcessInput, PostProcessRateChangeAction, RateChangeInvocableInput, RateChangeInvocableOutput, RateChangeNotificationUtil, RateChangeQueryService, Result, Strings, Task, ToCreate, ToUpdate, UserInfo, Versions

### PostProcessRateChangeTest

**Depends on**: Blob, Clinical_Rate_Change__c, ContentVersion, DocGenerationBatchProcess, DocumentGenerationProcess, PostProcessRateChange, TDF, TestDataFactory, TestTemplate

### PracticeOperationChangeQueueable

**Depends on**: CreateClientChangeManagementQueueable, EMPLOYEE_SUB_TYPE, IdWithFacilityToProcessType, IdWithFacilityToRules, NP_PA_SHIFT_TYPE, PocIds, PracticeOperationChangeUtil, Practice_Operation_Change__c, SHIFT_BONUS_CODE, ToFinalProcessType, ToInsert, ToRules, WithMixedBagFacilityTitles

### PracticeOperationChangeQueueableInvoker

**Depends on**: Ids, PracticeOperationChangeQueueable

### PracticeOperationChangeQueueableTest

**Depends on**: Acc, Account, CodeSet, Contract, CreateClientChangeManagementQueueable, Ids, IncreasedPOCs, Logs, POCs, Pay_Codes__c, PracticeOperationChangeQueueable, PracticeOperationChangeQueueableInvoker, PracticeOperationChangeQueueableTest, PracticeOperationChangeUtil, Rate_Pay_Code__c, ShiftAddedPOCs, Shift__c, TDF, TestDataFactoryCore, Time, Types

### PracticeOperationChangeUtil

**Depends on**: Error_Log__c, Ex, WithProcessType

### QueryHelper

**Depends on**: Fields, Ids, Names, ObjectType

### RateChangeActionsTest

**Depends on**: Blob, Case, CloneContractAction, ContentDocumentLink, ContentVersion, ContractSyncAction, DocGenerationBatchProcess, DocumentGenerationProcess, EmailMessage, EmailTemplate, GenerateAndAttachLetterAction, GenerateLetterService, GetContractsToSend, Ids, Job, Message, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeInvocableInput, RateChangeQueueable, RateChangeSummaryAction, Result, SaveContractSelectionAction, TestData, TestDataFactory, User, UserInfo

### RateChangeContractUtil

**Depends on**: Contracts, DocToContract, Ids, WithLetter

### RateChangeFinalProcessing

**Depends on**: AgData, FinalOut, FinalOutput, JSON, Obj, Out, RateChangeService, SelectedIdsList, SelectedIdsListString, ToLinkGenerator

### RateChangeFinalProcessingTest

**Depends on**: CRC, Contacts, Contracts, RateChangeFinalProcessing, TDF, TestDataFactory

### RateChangeHelpersTest

**Depends on**: Account, Blob, ContentDocumentLink, ContentVersion, DmlException, Error_Message__c, IdParsingUtil, JSON, RateChangeContractUtil, RateChangeInvocableInput, RateChangeNotificationUtil, TestDataFactory, UserInfo

### RateChangeInvocableClassesTest

**Depends on**: DraftContractOutput, RateChangeInvocableInput, RateChangeInvocableOutput, TestDataFactory

### RateChangeInvocableInput

**Depends on**: ValidationResult

### RateChangeNotificationUtil

**Depends on**: Err, Error_Log__c, UserInfo

### RateChangeQueryServiceTest

**Depends on**: RateChangeQueryService, TestDataFactory

### RateChangeQueueable

**Depends on**: ClinicianContractCloneService, ContractIds, ContractSyncRemoteAction, Contracts, Ids, Math, RateChangeNotificationUtil, RateChangeQueueable, Strings, Update, UserInfo

### RateChangeQueueableTest

**Depends on**: Ids, PreviewClonedContractIds__c, RateChangeQueueable, TestDataFactory

### RateChangeService

**Depends on**: Amount, CPAs, CPAtoNewCPA, Changes, ClientContractWrapper, ClinicianIdSet, ClinicianIds, CloneAndDocumentQueueable, CloneHelper, ClonedContractIds, ClonedPCAs, Contract, ContractByAccount, ContractClones, ContractIds, ContractMap, ContractStartDates, Contracts, CreatedContractIds, Data, DocGenerationBatchProcess, DocIds, DocMap, Docs, DocumentGenerationProcess, Err, Error_Log__c, Ids, JSON, LinksByContract, Messaging, PCAs, PNCClones, PNCs, PaClinicianIds, PayCodesToDelete, Pcas, PreventiveCareAgreement, PreviewClonedContractIds__c, QueryHelper, Rate, RateChangeRec, RateChangeService, Results, ShiftPcaMap, ShiftTable, StartDate, Task, ToCloneMap, ToCreate, ToDeactivate, ToDelete, ToNewContractMap, ToNewPNCMap, ToNewPcaMap, ToTimeTypeMap, ToUpdate, TokenData, Update, UserInfo, Versions

### RateChangeServiceTest

**Depends on**: Account, Blob, Clinical_Rate_Change__c, CodeSet, Contact, ContentVersion, Contract, ContractStartDates, Data, DataMD, DataNP, DocGenerationBatchProcess, EmailTemplate, JSON, Limits, PayCodes, PayCodesToDelete, Pay_Codes__c, PreventiveCareAgreement, QueryHelper, RateChangeService, RatePayCodes, Rate_Pay_Code__c, Row, SendEmailResult, ShiftTable, Shift__c, StartDate, TDF, TestDataFactory, TestDoc, Time, ToNewPcaMap, User, UserInfo

### RateChangeSummaryAction

**Depends on**: IdParsingUtil, Ids, JSON, RateChangeContractUtil, RateChangeInvocableInput, RateChangeInvocableOutput, RateChangeQueryService, SummaryItem, ToName, WithEmailSent, WithLetter

### RequestFeedbackForController

**Depends on**: Contact, Contacts, Discovery_Bots_Settings__c, Double, Http, HttpRequest, JSON, JsonList, ListVal, ListValuesList, OpportunityContactRole, Opportunity_Amount_Fields__c, RequestFeedbackForController, Result, Role, TruSales_App_Settings__c, TypesMap, User, UserInfo

### RequestFeedbackForControllerTest

**Depends on**: Account, Contact, Discovery_Bots_Settings__c, HTTPResponse, HttpCalloutMock, HttpMock, Opportunity, OpportunityAndAccountNames, OpportunityContactRole, RequestFeedbackForController, TruSales_App_Settings__c, User

### SaveContractSelectionAction

**Depends on**: AuraHandledException, ContractIds, IdParsingUtil, RateChangeQueryService

### SelectContactsController

**Depends on**: Ids, InId

### SelectContactsControllerTest

**Depends on**: Account, Contact, Opportunity, OpportunityContactRole, SelectContactsController

### SendHPFReportBatch

**Depends on**: CalloutException, Emails, ErrorLogUtil, Ids, IdsForEmail, Messages, Messaging, SCPHealth, ToUpdate, URL, Url, WideEmails

### SendHPFReportBatchTest

**Depends on**: Account, AccountTeamMember, HealthcarePractitionerFacility, Jobs, Messages, Messaging, Scope, SendHPFReportBatch, SendHPFReportScheduler, ToInsert, User, WideEmails

### SendHPFReportScheduler

**Depends on**: SendHPFReportBatch, SendHPFReportScheduler

### SendTermsheetForSignature

**Depends on**: Http, HttpRequest, JSON, Url, UserInfo

### SendTermsheetForSignatureTest

**Depends on**: HttpCalloutMock, HttpResponse, SendCalloutMock, SendTermsheetForSignature

### SisterSiteGroupingUtility

**Depends on**: AccountIds, Group, GroupingResult, IdToGroup, IdToName, ToAccountIds

### SystemTreeExtension

**Depends on**: Ctrl, Discovery, IdOnLead, IdOnOpp, Lead, SystemId, Type

### TestDataFactory

**Depends on**: Account, AccountTeamMember, AdminProfile, Clinical_Rate_Change__c, CodeSet, Contact, Contract, ContractPaymentAgreement, Datetime, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, Name, PreventiveCareAgreement, ProviderNetworkContract, Shift__c, Time, TypeInfoMap, User

### TestDataFactoryCore

**Depends on**: Account, AdminProfile, Client_Change_Management__c, CodeSet, Contact, Contract, ContractPaymentAgreement, Datetime, HealthcarePayerNetwork, HealthcarePractitionerFacility, HealthcareProvider, Name, Practice_Operation_Change__c, PreventiveCareAgreement, ProviderNetworkContract, Rate_Pay_Code__c, Shift__c, TypeInfoMap, User

### TruSalesAppController

**Depends on**: Discovery_Bots_Settings__c, Double, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c, Fields, FieldsToRetrieve, Info, Item, JSON, LineItems, Opportunity, OpportunityHistoryStage, OpportunityLineItemsForOpportunity, OpportunityLineItemsForProduct, OpportunitySyncRequest, OpportunitySyncRequestItem, OpportunitySyncRequestItemProduct, Opportunity_Amount_Fields__c, OwnerId, RecordTypeId, SalesProductMapItemsWithOpportunity, SalesProductMapItemsWithProduct, SalesUsersItems, SetWithProduct, StageName, Stages, ToRetrieve, TruSales_App_Settings__c, TypesMap, UserInfo, VoiceProducts

### TruSalesAppControllerTest

**Depends on**: Account, Discovery_Bots_Settings__c, Opportunity, OpportunityLineItem, PricebookEntry, Product2, SalesProductMapItems, Strings, TruSalesAppController, TruSales_App_Settings__c, TruSales_Product_Map_Item__c, Type, User, VoiceProducts

### TruSalesAppSettingsController

**Depends on**: Apexpages, BotsSettingsDeleted, ButtonWrapper, Describe, Discovery_Bots_Settings__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c, Entry, Field, FieldValues, FieldValuesFromOpp, FieldValuesProduct, FieldValuesProductOpp, Fields, FieldsForProductMap, FieldsNameFromProduct, FieldsNameFromProductOpp, FieldsOpp, ForViewFromOpportunity, ForViewFromProduct, Http, HttpRequest, IdStatic, Ids, Item, Items, JSON, ListOpportunity, ListSalesUsersItems, ListStrings, ListUsers, MapItemsForSave, MapItemsForSaveWithOpp, NamePicklistValue, NameValueMap, NameWithOutProduct, Names, NamesOpp, Object_name, Object_nameOpp, Opp, Opportunity, OpportunityFieldsValueView, OpportunityList, OpportunityStage, OpportunityUpdated, OpportunityValuePickListFromProductTrigger, Opportunity_Amount_Fields__c, Pattern, Picklist, PicklistNameValues, PicklistValueToStrings, Picklist_Value__c, ProductFieldsValueView, ProductList, ProductUpdated, Profiles, Records, Roles, SalesAppSettings, SalesProductMapItems, SalesProductMapItemsOpp, SalesStages, SalesUsersItems, SelectOption, SetIds, StageName, Static, TruSalesAppSettingsSave, TruSalesAppSettingsSaveFuture, TruSales_App_Settings__c, TruSales_Product_Map_Item__c, TruSales_Users_Item__c, TruVoice_Product_Id__c, Type, TypeInfo, TypeOpp, Types, UserProfilesSelected, UserRolesSelected, UsersFields, UsersFieldsList, UsersFieldsListStatic, ValuePickListFromProductTrigger, ValueToStrings, Values, ValuesFromOppProduct, ValuesSet, VoiceProducts, WithNull, WrapperProfiles, WrapperRoles, Wrappers

### TruSalesAppSettingsControllerTest

**Depends on**: Describe, Discovery_Bots_Settings__c, Entry, Fields, FieldsTest, HttpCalloutMock, HttpMockCollectors, HttpMockCollectorsFailed, Ids, JSON, Opportunity, Option, Product2, ProfileWrappers, RoleWrappers, SetIds, TruSalesAppSettingsController, TruSalesAppSettingsSaveFuture, TruSales_App_Settings__c, TypeInfo, Types, VoiceProducts

### TruSalesAppSettingsSave

**Depends on**: Discovery_Bots_Settings__c, IdStatic, JSON, Pattern, Static, TruSalesAppSettingsController, TruSales_App_Settings__c

### TruSalesAppSettingsSaveFuture

**Depends on**: PermissionSetAssignment, SetAssignmentList, SetIds

### UpdatePreviousHPFBatchInvokeTest

**Depends on**: UpdatePreviousHPFBatchInvoke

### UserActivationFlowAction

**Depends on**: ActivateUserQueueable, Ids, Item, ToActivate

### UserActivationFlowActionTest

**Depends on**: IdRequest, Math, Request, TestDataFactory, User, UserActivationFlowAction, UserRole

### fileToLinkGenerator

**Depends on**: AccIds, AgData, ContractFileResponse, ContractIds, Data, Ex, JSON, Links, Obj, ProcessedUserContacts, RateChangeService, Record, Response, SelectedIds, SelectedIdsList, TDF, TestDataFactory, URL, Urls

### fileToLinkGeneratorTest

**Depends on**: CRC, Contacts, Contracts, JSON, KeyResult, Links, List1, List2, ListResult, MapResult, Math, ObjectsResult, RateChangeService, Responses, Result, SelectIdResult, StatusContractsUpdated, TDF, TestDataFactory, ToLinkGenerator, ValueResult, ValuesResult, WithData, WithNulls

### processHPFupdatesBactchClass

**Depends on**: AccountToContractStartDate, AllRelatedHealthcarePractitionerRecords, ContactToContractIds, Contract, ContractIds, Error_Log__c, HPFIds, HPFToClinicianMapping, HpftoUpdate, IdToContractStartDate, IdToStartDate, Ids, PractitionerIds, Results, ServiceAccountIds, StartDate, ToContractIds, ToUpdate

### processHPFupdatesBatchClassTest

**Depends on**: HPFs, HPFupdatesBactchClass, TestDataFactory


---

## LWC Component Dependencies

*LWC components that import other components*

*No LWC dependencies found*

---

## Flow Dependencies

*Flows that call Apex classes or subflows*

### ATS_Applicant_add_Contract

**Uses**: Flow:UpdateClientStartUpAndEnddateOnAccount

### Agreement_Record_Triggered_Flow

**Uses**: Flow:Create_PCA_Junction

### Begin_Client_Onboarding_Flow

**Uses**: Flow:Sub_flow_to_create_Opportunity_Task

### Case_Creation_After_Insert_Flow

**Uses**: Flow:Clone_bpats_Job, Flow:Create_Facility_Term_Task_Subflow, Flow:SCP_Offibaording_Case_Update_Reason_for_Termination, Flow:Subflow_to_create_Task

### Contract_After_Save

**Uses**: Flow:ContractEmployementType_Change_Notification_Email, Flow:Create_Clinician_Onboarding_Cases, Flow:Send_notification_when_future_contract_exists, Flow:Subflow_Client_Onboarding_Task_Creation, Flow:Update_Opportunity_Subflow, Flow:Update_Previous_HPF_Records, Flow:Welcome_Clinician_Onboarding_Email_Flow

### Contract_Update_Sub_Flow

**Uses**: Flow:Sublow_Task_to_Clear_QGenda

### Create_PMT_Cases

**Uses**: Flow:SubFlow_SUN_Orchestration_Email_Alert_AutoLaunchFlow

### Create_SUN_Preliminary_PMT_Case

**Uses**: Flow:Create_PMT_Cases

### Create_SUN_Revision_PMT_Case

**Uses**: Flow:Create_PMT_Cases

### DocuSign_Status_Record_Triggered_Flow

**Uses**: Flow:DocuSign_Status_In_Agreement_And_HPF_Subflow, Flow:DocuSign_Term_Sheet_Subflow

### Execute_Contract_RecordTriggerAsyncFlow

**Uses**: Flow:Create_CCM_Records_for_Executed_Clinician_Contracts

### HPF_Updates_Triggered_Flow

**Uses**: Flow:Clinician_Post_Hire_Onboarding_Survey, Flow:Send_Email_for_Inactive_HPF, Flow:Update_Active_HPF_to_Inactive, Flow:Welcome_Email_and_User_Creation_for_Leased_Locums_Managed

### Opportunity_Create_OR_Update_RecordTriggerFlow

**Uses**: Flow:Sub_flow_to_create_Opportunity_Task

### PCA_After_Insert_and_Update_Flow

**Uses**: Flow:Calculate_Rates_on_Contract_Based_on_PCA

### PMT_Phase_After_Trigger_Flow

**Uses**: Flow:Create_Tasks_for_PMT_Phase_Flow

### PMT_Task_Action_Plan_and_Record_Updation_Flow

**Uses**: Flow:SplitCommaSeparatedValues

### PMT_Task_After_Save_Flow

**Uses**: Flow:PMT_Task_Action_Plan_and_Record_Updation_Flow

### SCP_Healthcare_Practitioner_Facility_After_Insert_Flow

**Uses**: Flow:HPF_Save_Sub_Flow, Flow:Update_Active_HPF_to_Inactive

### Task_After_Flow

**Uses**: Flow:Close_Related_Cases, Flow:SubFlow_Update_Client_Change_Mgt_Status, Flow:Update_ActionItem_and_PMT_Task_Flow


---

## Reverse Dependencies

*Components that are depended upon by others*

### Apex Classes

- **Ids** is used by: CPARelationshipRecordsGenerator, ClinicalManagerController, ClinicianContractCloneService, ClinicianContractCloneServiceTest, ClinicianContractSyncQueueable, ClinicianContractSyncQueueableTest, ClinicianContractSyncService, ClinicianCoverageUpdateBatch, CloneAndDocumentQueueable, CloneContractAction, ContractSyncAction, ContractSyncRemoteAction, ContractTerminationBatch, CreateClientChangeManagementQueueable, DeactivateHPFsForClinician, DocumentVersionTriggerHandler, GenerateAndAttachLetterAction, GenerateLetterService, GetContractsToSend, HPFReportEmailUtil, OpportunityAttachmentTriggerHandler, PendingRateChangeChecker, PostProcessRateChange, PostProcessRateChangeAction, PracticeOperationChangeQueueableInvoker, PracticeOperationChangeQueueableTest, QueryHelper, RateChangeActionsTest, RateChangeContractUtil, RateChangeQueueable, RateChangeQueueableTest, RateChangeService, RateChangeSummaryAction, SelectContactsController, SendHPFReportBatch, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest, UserActivationFlowAction, processHPFupdatesBactchClass
- **Account** is used by: AllVisualForceTest, CIFormAssessmentControllerTest, CPARelationshipRecordsGeneratorTest, ClinicalManagerControllerTest, CongaAgreementServiceHelper, CongaAgreementServiceHelperTest, CongaServiceTest, ContactSSNActionTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatch, DeactivateCliniciansBatchTest, DeactivateHPFsForClinician, DeactivateHPFsForClinicianTest, GenerateJobDescriptionControllerTest, GetProviderNetworkControllerTest, GuidedClinicianCreationController, HPFReportEmailUtilTest, OmniUtilityTest, OpportunityTestDataHelper, OpportunityTriggerHandlerTest, PracticeOperationChangeQueueableTest, RateChangeHelpersTest, RateChangeServiceTest, RequestFeedbackForControllerTest, SelectContactsControllerTest, SendHPFReportBatchTest, TestDataFactory, TestDataFactoryCore, TruSalesAppControllerTest
- **JSON** is used by: CPARelationshipRecordsGeneratorQueuable, CPAReviewCaseGenerator, ClinicalManagerController, CloneContractAction, GenerateLetterService, GetPOContractByClinicianStartDate, IdParsingUtil, OmniUtility, OmniUtilityTest, PendingRateChangeChecker, RateChangeFinalProcessing, RateChangeHelpersTest, RateChangeService, RateChangeServiceTest, RateChangeSummaryAction, RequestFeedbackForController, SendTermsheetForSignature, TruSalesAppController, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest, TruSalesAppSettingsSave, fileToLinkGenerator, fileToLinkGeneratorTest
- **TestDataFactory** is used by: AccountDetailsTest, CIFormAssessmentControllerTest, ClinicalManagerControllerTest, ClinicianContractCloneServiceTest, ClinicianContractSyncQueueableTest, ContractDetailsTest, DeactivateHPFsForClinicianTest, ErrorLogUtilTest, GenerateLetterServiceTest, PasswordResetControllerTest, PostProcessRateChangeTest, RateChangeActionsTest, RateChangeFinalProcessingTest, RateChangeHelpersTest, RateChangeInvocableClassesTest, RateChangeQueryServiceTest, RateChangeQueueableTest, RateChangeServiceTest, UserActivationFlowActionTest, fileToLinkGenerator, fileToLinkGeneratorTest, processHPFupdatesBatchClassTest
- **Contract** is used by: CPARelationshipRecordsGeneratorTest, CheckRatesForServiceAccFacility_Test, ClinicianContractCloneService, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatchTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteActionTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatch, DeactivateCliniciansBatchTest, GenerateLetterServiceTest, GetProviderNetworkControllerTest, OmniUtilityTest, PracticeOperationChangeQueueableTest, RateChangeService, RateChangeServiceTest, TestDataFactory, TestDataFactoryCore, processHPFupdatesBactchClass
- **Contracts** is used by: ClinicalManagerControllerTest, ClinicianContractCloneService, ClinicianContractSyncQueueableTest, CongaServiceTest, ContractSyncRemoteAction, CreateCongaAgreementServiceTest, DeactivateCliniciansBatch, GenerateLetterService, GetPOContractByClinicianStartDate, OmniUtilityTest, OpportunityAttachmentTriggerHandler, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeContractUtil, RateChangeFinalProcessingTest, RateChangeQueueable, RateChangeService, fileToLinkGeneratorTest
- **User** is used by: CPARelationshipRecordsGeneratorTest, CommunityLoginControllerTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest, GenerateJobDescriptionControllerTest, GetProviderNetworkControllerTest, HPFReportEmailUtilTest, RateChangeActionsTest, RateChangeServiceTest, RequestFeedbackForController, RequestFeedbackForControllerTest, SendHPFReportBatchTest, TestDataFactory, TestDataFactoryCore, TruSalesAppControllerTest, UserActivationFlowActionTest
- **PreventiveCareAgreement** is used by: CheckRatesForServiceAccFacility_Test, ClinicianContractCloneService, ClinicianContractCloneServiceTest, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatchTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteAction, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, RateChangeService, RateChangeServiceTest, TestDataFactory, TestDataFactoryCore
- **HealthcarePractitionerFacility** is used by: CPARelationshipRecordsGeneratorTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinician, GetProviderNetworkControllerTest, HPFReportEmailUtilTest, SendHPFReportBatchTest, TestDataFactory, TestDataFactoryCore
- **TDF** is used by: CalculateNPPARatesTest, CheckRatesForServiceAccFacility_Test, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PCATriggerHandlerTest, PostProcessRateChangeTest, PracticeOperationChangeQueueableTest, RateChangeFinalProcessingTest, RateChangeServiceTest, fileToLinkGenerator, fileToLinkGeneratorTest
- **Opportunity** is used by: AllVisualForceTest, CongaAgreementServiceHelperTest, OpportunityTestDataHelper, OpportunityTriggerHandler, OpportunityTriggerHandlerTest, RequestFeedbackForControllerTest, SelectContactsControllerTest, TruSalesAppController, TruSalesAppControllerTest, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **CalloutException** is used by: ClinicianContractCloneService, CloneContractAction, ContractSyncAction, ErrorLogUtilTest, GenerateLetterService, GetContractsToSend, HPFReportEmailUtil, JobStatusController, PendingRateChangeChecker, PostProcessRateChangeAction, SendHPFReportBatch
- **CodeSet** is used by: CPARelationshipRecordsGeneratorTest, CheckRatesForServiceAccFacility_Test, ClinicianContractSyncQueueableTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueableTest, RateChangeServiceTest, TestDataFactory, TestDataFactoryCore
- **ContractIds** is used by: ClinicalManagerController, ClinicianContractSyncService, ClinicianCoverageUpdateBatch, CloneAndDocumentQueueable, GenerateLetterService, PostProcessRateChangeAction, RateChangeQueueable, RateChangeService, SaveContractSelectionAction, fileToLinkGenerator, processHPFupdatesBactchClass
- **Time** is used by: CheckRatesForServiceAccFacility_Test, ClinicianContractCloneServiceTest, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatchTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueableTest, RateChangeServiceTest, TestDataFactory
- **RateChangeQueryService** is used by: ClinicalManagerController, CloneContractAction, ContractSyncAction, GenerateAndAttachLetterAction, GenerateLetterService, GetContractsToSend, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeQueryServiceTest, RateChangeSummaryAction, SaveContractSelectionAction
- **ErrorLogUtil** is used by: CPARelationshipRecordsGeneratorQueuable, CPAReviewCaseGenerator, ClinicianCoverageUpdateBatch, ClinicianCoverageUpdateBatchTest, ContractSyncRemoteAction, DeactivateHPFsForClinician, ErrorLogUtil, ErrorLogUtilTest, HPFReportEmailUtil, PasswordResetController, SendHPFReportBatch
- **RateChangeInvocableInput** is used by: CloneContractAction, ContractSyncAction, GenerateAndAttachLetterAction, GetContractsToSend, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeActionsTest, RateChangeHelpersTest, RateChangeInvocableClassesTest, RateChangeSummaryAction
- **UserInfo** is used by: PostProcessRateChangeAction, RateChangeActionsTest, RateChangeHelpersTest, RateChangeNotificationUtil, RateChangeQueueable, RateChangeService, RateChangeServiceTest, RequestFeedbackForController, SendTermsheetForSignature, TruSalesAppController
- **ToUpdate** is used by: ClinicianContractCloneService, ClinicianContractSyncService, ClinicianCoverageUpdateBatch, ContractSyncRemoteAction, ContractTerminationBatch, DeactivateHPFsForClinician, PostProcessRateChangeAction, RateChangeService, SendHPFReportBatch, processHPFupdatesBactchClass
- **ProviderNetworkContract** is used by: CPARelationshipRecordsGeneratorTest, ClinicianContractSyncQueueableTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatchTest, GetProviderNetworkControllerTest, TestDataFactory, TestDataFactoryCore
- **Result** is used by: CheckRatesForServiceAccFacility, GenerateAndAttachLetterAction, GenerateLetterServiceTest, GuidedClinicianCreationControllerTest, OmniUtilityTest, OpportunityAttachmentController, PostProcessRateChangeAction, RateChangeActionsTest, RequestFeedbackForController, fileToLinkGeneratorTest
- **Shift__c** is used by: CheckRatesForServiceAccFacility_Test, ClinicianContractSyncQueueableTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueableTest, RateChangeServiceTest, TestDataFactory, TestDataFactoryCore
- **Blob** is used by: GenerateLetterService, GenerateLetterServiceTest, OpportunityAttachmentController, OpportunityAttachmentControllerTest, OpportunityTriggerHandlerTest, PostProcessRateChangeTest, RateChangeActionsTest, RateChangeHelpersTest, RateChangeServiceTest
- **HealthcareProvider** is used by: CPARelationshipRecordsGeneratorTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatchTest, GetProviderNetworkControllerTest, TestDataFactory, TestDataFactoryCore
- **HealthcarePayerNetwork** is used by: CPARelationshipRecordsGeneratorTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractTerminationBatchTest, CreateCongaAgreementServiceTest, DeactivateCliniciansBatchTest, GetProviderNetworkControllerTest, TestDataFactory, TestDataFactoryCore
- **Case** is used by: CIFormAssessmentControllerTest, CPARelationshipRecordsGeneratorTest, CPAReviewCaseGenerator, CongaServiceTest, ContractTerminationBatch, CreateCongaAgreementServiceTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest, RateChangeActionsTest
- **ContractPaymentAgreement** is used by: CheckRatesForServiceAccFacility_Test, ClinicianContractSyncQueueableTest, CongaAgreementServiceHelperTest, CongaServiceTest, ContractSyncRemoteAction, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, TestDataFactory, TestDataFactoryCore
- **Contact** is used by: CongaServiceTest, ContactSSNActionTest, CreateCongaAgreementServiceTest, RateChangeServiceTest, RequestFeedbackForController, RequestFeedbackForControllerTest, SelectContactsControllerTest, TestDataFactory, TestDataFactoryCore
- **IdParsingUtil** is used by: CloneContractAction, ContractSyncAction, GenerateAndAttachLetterAction, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeHelpersTest, RateChangeSummaryAction, SaveContractSelectionAction
- **Fields** is used by: ClinicianContractCloneService, ClinicianContractSyncQueueableTest, ClinicianContractSyncService, CloneHelper, QueryHelper, TruSalesAppController, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **TestDataFactoryCore** is used by: CalculateNPPARatesTest, CheckRatesForServiceAccFacility_Test, ClinicianCoverageUpdateBatchTest, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PCATriggerHandlerTest, PracticeOperationChangeQueueableTest
- **Rate_Pay_Code__c** is used by: ClinicianContractCloneServiceTest, ClinicianCoverageUpdateBatchTest, CongaServiceTest, ContractSyncRemoteActionTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueableTest, RateChangeServiceTest, TestDataFactoryCore
- **InvocableOutput** is used by: AccountDetails, CalculateNPPARates, CloneContractAction, ContractDetails, ContractSyncAction, GenerateAndAttachLetterAction, GetContractsToSend, PendingRateChangeChecker
- **TruSales_App_Settings__c** is used by: RequestFeedbackForController, RequestFeedbackForControllerTest, TruSalesAppController, TruSalesAppControllerTest, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest, TruSalesAppSettingsSave
- **Discovery_Bots_Settings__c** is used by: RequestFeedbackForController, RequestFeedbackForControllerTest, TruSalesAppController, TruSalesAppControllerTest, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest, TruSalesAppSettingsSave
- **DocGenerationBatchProcess** is used by: GenerateLetterService, JobStatusControllerTest, PostProcessRateChange, PostProcessRateChangeTest, RateChangeActionsTest, RateChangeService, RateChangeServiceTest
- **Task** is used by: ClinicianContractSyncQueueableTest, ClinicianContractSyncService, ContractTerminationBatchTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest, PostProcessRateChangeAction, RateChangeService
- **Clinical_Rate_Change__c** is used by: ClinicalManagerController, ClinicalManagerControllerTest, GenerateLetterService, GenerateLetterServiceTest, PostProcessRateChangeTest, RateChangeServiceTest, TestDataFactory
- **Client_Change_Management__c** is used by: ClinicalManagerControllerTest, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatchTest, CongaServiceTest, CreateClientChangeManagementQueueable, CreateCongaAgreementServiceTest, TestDataFactoryCore
- **RateChangeService** is used by: CloneAndDocumentQueueable, PostProcessRateChange, RateChangeFinalProcessing, RateChangeService, RateChangeServiceTest, fileToLinkGenerator, fileToLinkGeneratorTest
- **Data** is used by: ClinicalManagerController, GenerateLetterService, GenerateLetterServiceTest, IdParsingUtil, RateChangeService, RateChangeServiceTest, fileToLinkGenerator
- **ContentVersion** is used by: GenerateLetterService, GenerateLetterServiceTest, PostProcessRateChangeTest, RateChangeActionsTest, RateChangeHelpersTest, RateChangeServiceTest
- **RateChangeNotificationUtil** is used by: ClinicianContractCloneService, GenerateLetterService, PendingRateChangeChecker, PostProcessRateChangeAction, RateChangeHelpersTest, RateChangeQueueable
- **PermissionSetAssignment** is used by: CPARelationshipRecordsGeneratorTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest, GenerateJobDescriptionControllerTest, GetProviderNetworkControllerTest, TruSalesAppSettingsSaveFuture
- **RateChangeQueueable** is used by: CloneContractAction, ContractSyncAction, JobStatusControllerTest, RateChangeActionsTest, RateChangeQueueable, RateChangeQueueableTest
- **AccountIds** is used by: ClinicalManagerController, ClinicianContractSyncService, CongaAgreementServiceHelper, DeactivateCliniciansBatch, PendingRateChangeChecker, SisterSiteGroupingUtility
- **Name** is used by: ClinicianContractSyncService, ClinicianCoverageUpdateBatch, DocumentVersionTriggerHandler, GenerateLetterService, TestDataFactory, TestDataFactoryCore
- **Error_Log__c** is used by: ErrorLogUtil, OmniUtility, PracticeOperationChangeUtil, RateChangeNotificationUtil, RateChangeService, processHPFupdatesBactchClass
- **PCAs** is used by: ClinicianContractCloneService, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatch, ClinicianCoverageUpdateBatchTest, RateChangeService
- **CPAs** is used by: CPARelationshipRecordsGeneratorQueuable, ClinicianContractCloneService, ClinicianCoverageUpdateBatch, CreateCongaAgreementService, RateChangeService
- **Userinfo** is used by: CPARelationshipRecordsGeneratorTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest, GenerateJobDescriptionControllerTest, GetProviderNetworkControllerTest
- **AccountTeamMember** is used by: CPARelationshipRecordsGeneratorTest, GenerateJobDescriptionControllerTest, HPFReportEmailUtilTest, SendHPFReportBatchTest, TestDataFactory
- **Job** is used by: CloneContractAction, ContractSyncAction, GenerateAndAttachLetterAction, GenerateJobDescriptionControllerTest, RateChangeActionsTest
- **Records** is used by: ClinicalManagerController, ClinicianContractSyncQueueableTest, ClinicianContractSyncService, GetProviderNetworkControllerTest, TruSalesAppSettingsController
- **Types** is used by: ClinicianContractSyncService, ContractTerminationBatch, PracticeOperationChangeQueueableTest, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **Apttus__APTS_Agreement__c** is used by: CongaAgreementServiceHelperTest, CongaServiceTest, CreateCongaAgreementService, CreateCongaAgreementServiceTest, DocumentVersionTriggerHandlerTest
- **Practice_Operation_Change__c** is used by: ClinicianCoverageUpdateBatchTest, CongaServiceTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueable, TestDataFactoryCore
- **Pay_Codes__c** is used by: ClinicianCoverageUpdateBatchTest, CongaServiceTest, CreateCongaAgreementServiceTest, PracticeOperationChangeQueueableTest, RateChangeServiceTest
- **Messaging** is used by: HPFReportEmailUtil, PostProcessRateChangeAction, RateChangeService, SendHPFReportBatch, SendHPFReportBatchTest
- **Contacts** is used by: ClinicalManagerController, ClinicalManagerControllerTest, RateChangeFinalProcessingTest, RequestFeedbackForController, fileToLinkGeneratorTest
- **RateChangeContractUtil** is used by: GetContractsToSend, PendingRateChangeChecker, RateChangeHelpersTest, RateChangeSummaryAction
- **VoiceProducts** is used by: TruSalesAppController, TruSalesAppControllerTest, TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **Values** is used by: ClinicianContractCloneService, CloneHelper, OmniUtility, TruSalesAppSettingsController
- **Results** is used by: ClinicianContractCloneService, ClinicianCoverageUpdateBatch, RateChangeService, processHPFupdatesBactchClass
- **Pcas** is used by: ClinicianContractCloneService, ClinicianContractCloneServiceTest, ContractSyncRemoteActionTest, RateChangeService
- **StartDate** is used by: ClinicianContractCloneService, RateChangeService, RateChangeServiceTest, processHPFupdatesBactchClass
- **Names** is used by: ClinicianContractCloneService, ClinicianCoverageUpdateBatch, QueryHelper, TruSalesAppSettingsController
- **DocumentGenerationProcess** is used by: GenerateLetterService, PostProcessRateChangeTest, RateChangeActionsTest, RateChangeService
- **GenerateLetterService** is used by: GenerateAndAttachLetterAction, GenerateLetterService, GenerateLetterServiceTest, RateChangeActionsTest
- **ToInsert** is used by: ClinicianContractSyncService, CreateClientChangeManagementQueueable, PracticeOperationChangeQueueable, SendHPFReportBatchTest
- **PracticeOperationChangeUtil** is used by: ClinicianContractSyncService, CreateClientChangeManagementQueueable, PracticeOperationChangeQueueable, PracticeOperationChangeQueueableTest
- **AuraHandledException** is used by: ClinicalManagerController, CommunityLoginController, GenerateJobDescriptionController, SaveContractSelectionAction
- **Math** is used by: HPFReportEmailUtil, RateChangeQueueable, UserActivationFlowActionTest, fileToLinkGeneratorTest
- **WithLetter** is used by: GetContractsToSend, PendingRateChangeChecker, RateChangeContractUtil, RateChangeSummaryAction
- **AgData** is used by: CloneContractAction, PostProcessRateChange, RateChangeFinalProcessing, fileToLinkGenerator
- **Record** is used by: ClinicalManagerController, ClinicianContractSyncQueueableTest, IdParsingUtil, fileToLinkGenerator
- **Type** is used by: SystemTreeExtension, TruSalesAppControllerTest, TruSalesAppSettingsController
- **Strings** is used by: PostProcessRateChangeAction, RateChangeQueueable, TruSalesAppControllerTest
- **PayCodesToDelete** is used by: ClinicianContractCloneService, RateChangeService, RateChangeServiceTest
- **ClinicianContractCloneService** is used by: ClinicianContractCloneService, ClinicianContractCloneServiceTest, RateChangeQueueable
- **CreatedContractIds** is used by: ClinicianContractCloneService, PostProcessRateChangeAction, RateChangeService
- **ShiftPcaMap** is used by: ClinicianContractCloneService, ContractSyncRemoteAction, RateChangeService
- **ToNewPcaMap** is used by: ClinicianContractCloneService, RateChangeService, RateChangeServiceTest
- **CPAReviewCaseGenerator** is used by: CPARelationshipRecordsGeneratorQueuable, CPARelationshipRecordsGeneratorTest, CPAReviewCaseGenerator
- **Opportunity_Attachment__c** is used by: OpportunityAttachmentController, OpportunityAttachmentTriggerHandlerTest, OpportunityTriggerHandlerTest
- **Attachment** is used by: OpportunityAttachmentController, OpportunityTriggerHandler, OpportunityTriggerHandlerTest
- **Attachments** is used by: OpportunityAttachmentControllerTest, OpportunityTriggerHandler, OpportunityTriggerHandlerTest
- **Message** is used by: CommunityLoginController, PasswordResetControllerTest, RateChangeActionsTest
- **TestData** is used by: ClinicianContractCloneServiceTest, GenerateLetterServiceTest, RateChangeActionsTest
- **SObjectType** is used by: ClinicianContractSyncQueueableTest, ClinicianContractSyncService, CongaAgreementServiceHelper
- **AccountAccountRelation** is used by: CongaAgreementServiceHelperTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest
- **PartyRoleRelation** is used by: CongaAgreementServiceHelperTest, DeactivateCliniciansBatchTest, DeactivateHPFsForClinicianTest
- **Service_Line__c** is used by: CIFormAssessmentControllerTest, CongaAgreementServiceHelperTest, GenerateJobDescriptionControllerTest
- **PageReference** is used by: AllVisualForceTest, CommunityLoginController, OpportunityAttachmentController
- **Input** is used by: CloneContractAction, GetPOContractByClinicianStartDate, PostProcessRateChangeAction
- **HPFIds** is used by: CPAReviewCaseGenerator, ContractTerminationBatch, processHPFupdatesBactchClass
- **RateChangeInvocableOutput** is used by: PostProcessRateChangeAction, RateChangeInvocableClassesTest, RateChangeSummaryAction
- **Contract_Agreement__c** is used by: CongaServiceTest, CreateCongaAgreementService, CreateCongaAgreementServiceTest
- **AsyncJobOutput** is used by: CloneContractAction, ContractSyncAction, GenerateAndAttachLetterAction
- **Datetime** is used by: OmniUtility, TestDataFactory, TestDataFactoryCore
- **Opportunity_Amount_Fields__c** is used by: RequestFeedbackForController, TruSalesAppController, TruSalesAppSettingsController
- **Item** is used by: TruSalesAppController, TruSalesAppSettingsController, UserActivationFlowAction
- **CPAIds** is used by: CPARelationshipRecordsGeneratorQueuable, ClinicianCoverageUpdateBatch, CreateCongaAgreementService
- **Logs** is used by: ClinicianCoverageUpdateBatchTest, ErrorLogUtilTest, PracticeOperationChangeQueueableTest
- **HttpResponse** is used by: HttpMockCollectors, HttpMockCollectorsFailed, SendTermsheetForSignatureTest
- **OpportunityContactRole** is used by: RequestFeedbackForController, RequestFeedbackForControllerTest, SelectContactsControllerTest
- **HttpCalloutMock** is used by: RequestFeedbackForControllerTest, SendTermsheetForSignatureTest, TruSalesAppSettingsControllerTest
- **Update** is used by: GenerateLetterService, RateChangeQueueable, RateChangeService
- **ContractStartDates** is used by: PostProcessRateChangeAction, RateChangeService, RateChangeServiceTest
- **ShiftTable** is used by: GenerateLetterService, RateChangeService, RateChangeServiceTest
- **URL** is used by: HPFReportEmailUtil, SendHPFReportBatch, fileToLinkGenerator
- **WideEmails** is used by: HPFReportEmailUtilTest, SendHPFReportBatch, SendHPFReportBatchTest
- **Url** is used by: HPFReportEmailUtil, SendHPFReportBatch, SendTermsheetForSignature
- **Messages** is used by: ContractTerminationBatch, SendHPFReportBatch, SendHPFReportBatchTest
- **DeactivateHPFsForClinician** is used by: DeactivateCliniciansBatchInvoke, DeactivateHPFsForClinicianTest, HPFReportEmailUtil
- **RecordsToUpdate** is used by: CPARelationshipRecordsGeneratorQueuable, ClinicianCoverageUpdateBatch, ContractSyncRemoteAction
- **ClinicianContractSyncService** is used by: ClinicianContractSyncQueueable, ClinicianContractSyncQueueableTest, ClinicianCoverageUpdateBatch
- **SetIds** is used by: TruSalesAppSettingsController, TruSalesAppSettingsControllerTest, TruSalesAppSettingsSaveFuture
- **HttpRequest** is used by: RequestFeedbackForController, SendTermsheetForSignature, TruSalesAppSettingsController
- **Http** is used by: RequestFeedbackForController, SendTermsheetForSignature, TruSalesAppSettingsController
- **CRC** is used by: ClinicalManagerControllerTest, RateChangeFinalProcessingTest, fileToLinkGeneratorTest
- **DmlException** is used by: ClinicianContractCloneService, RateChangeHelpersTest
- **ContentDocumentLink** is used by: RateChangeActionsTest, RateChangeHelpersTest
- **Error_Message__c** is used by: ErrorLogUtilTest, RateChangeHelpersTest
- **SalesProductMapItems** is used by: TruSalesAppControllerTest, TruSalesAppSettingsController
- **Product2** is used by: TruSalesAppControllerTest, TruSalesAppSettingsControllerTest
- **TruSales_Product_Map_Item__c** is used by: TruSalesAppControllerTest, TruSalesAppSettingsController
- **ClinicianCoverageUpdateScheduler** is used by: ClinicianCoverageUpdateScheduler, ClinicianCoverageUpdateSchedulerTest
- **ContractMap** is used by: ClinicianContractCloneService, RateChangeService
- **ContractByAccount** is used by: ClinicianContractCloneService, RateChangeService
- **ClonedPCAs** is used by: ClinicianContractCloneService, RateChangeService
- **CPAtoNewCPA** is used by: ClinicianContractCloneService, RateChangeService
- **ToDelete** is used by: ClinicianContractCloneService, RateChangeService
- **ToNewPNCMap** is used by: ClinicianContractCloneService, RateChangeService
- **PNCs** is used by: ClinicianContractCloneService, RateChangeService
- **ContractClones** is used by: ClinicianContractCloneService, RateChangeService
- **ToNewContractMap** is used by: ClinicianContractCloneService, RateChangeService
- **ToCloneMap** is used by: ClinicianContractCloneService, RateChangeService
- **Desc** is used by: ClinicianContractCloneService, CloneHelper
- **PNCClones** is used by: ClinicianContractCloneService, RateChangeService
- **ObjectType** is used by: ClinicianContractCloneService, QueryHelper
- **Collaborative_Practice_Agreement__c** is used by: CPARelationshipRecordsGeneratorQueuable, CPARelationshipRecordsGeneratorTest
- **EmailTemplate** is used by: RateChangeActionsTest, RateChangeServiceTest
- **PostProcessRateChangeAction** is used by: PostProcessRateChangeAction, RateChangeActionsTest
- **PendingRateChangeChecker** is used by: PendingRateChangeChecker, RateChangeActionsTest
- **IdToContractNumberMap** is used by: ClinicianContractSyncQueueableTest, ClinicianContractSyncService
- **Rates** is used by: ClinicianContractSyncQueueableTest, ClinicianContractSyncService
- **Static** is used by: TruSalesAppSettingsController, TruSalesAppSettingsSave
- **TruSalesAppSettingsController** is used by: TruSalesAppSettingsControllerTest, TruSalesAppSettingsSave
- **Pattern** is used by: TruSalesAppSettingsController, TruSalesAppSettingsSave
- **IdStatic** is used by: TruSalesAppSettingsController, TruSalesAppSettingsSave
- **CongaAgreementServiceHelper** is used by: CongaAgreementServiceHelperTest, CreateCongaAgreementService
- **SelectOption** is used by: OpportunityAttachmentController, TruSalesAppSettingsController
- **PCAMap** is used by: ClinicianCoverageUpdateBatch, CongaAgreementServiceHelper
- **List1** is used by: CalculateNPPARatesTest, fileToLinkGeneratorTest
- **DraftContractOutput** is used by: GetContractsToSend, RateChangeInvocableClassesTest
- **Formula** is used by: CongaServiceTest, CreateCongaAgreementServiceTest
- **CreateCongaAgreementService** is used by: CongaServiceTest, CreateCongaAgreementServiceTest
- **PreviewClonedContractIds__c** is used by: RateChangeQueueableTest, RateChangeService
- **TypeInfoMap** is used by: TestDataFactory, TestDataFactoryCore
- **AdminProfile** is used by: TestDataFactory, TestDataFactoryCore
- **Agreements** is used by: CreateCongaAgreementService, DocumentVersionTriggerHandlerTest
- **DocumentVersionTriggerHandler** is used by: DocumentVersionTriggerHandler, DocumentVersionTriggerHandlerTest
- **Enabled_Opportunity_Types__c** is used by: TruSalesAppController, TruSalesAppSettingsController
- **TypesMap** is used by: RequestFeedbackForController, TruSalesAppController
- **Enabled_Record_Types__c** is used by: TruSalesAppController, TruSalesAppSettingsController
- **SalesUsersItems** is used by: TruSalesAppController, TruSalesAppSettingsController
- **Enabled_Opportunity_Stages__c** is used by: TruSalesAppController, TruSalesAppSettingsController
- **Double** is used by: RequestFeedbackForController, TruSalesAppController
- **StageName** is used by: TruSalesAppController, TruSalesAppSettingsController
- **Hpf** is used by: CreateCongaAgreementService, DeactivateHPFsForClinicianTest
- **Lead** is used by: AllVisualForceTest, SystemTreeExtension
- **Codes** is used by: CheckRatesForServiceAccFacility, ClinicianCoverageUpdateBatch
- **Accounts** is used by: CIFormAssessmentControllerTest, ClinicianCoverageUpdateBatch
- **DataFactory** is used by: CIFormAssessmentControllerTest, DeactivateHPFsForClinicianTest
- **RequestFeedbackForController** is used by: RequestFeedbackForController, RequestFeedbackForControllerTest
- **ContractSyncRemoteAction** is used by: ContractSyncRemoteActionTest, RateChangeQueueable
- **OpportunityTestDataHelper** is used by: OpportunityAttachmentControllerTest, OpportunityAttachmentTriggerHandlerTest
- **Site** is used by: CommunityLoginController, CommunityLoginControllerTest
- **Opp** is used by: OpportunityTriggerHandler, TruSalesAppSettingsController
- **Err** is used by: RateChangeNotificationUtil, RateChangeService
- **ClientContractWrapper** is used by: GenerateLetterService, RateChangeService
- **QueryHelper** is used by: RateChangeService, RateChangeServiceTest
- **Versions** is used by: PostProcessRateChangeAction, RateChangeService
- **DocMap** is used by: PostProcessRateChangeAction, RateChangeService
- **Changes** is used by: PostProcessRateChangeAction, RateChangeService
- **Rate** is used by: GenerateLetterService, RateChangeService
- **ToCreate** is used by: PostProcessRateChangeAction, RateChangeService
- **Amount** is used by: GenerateLetterService, RateChangeService
- **DocIds** is used by: PostProcessRateChangeAction, RateChangeService
- **ToTimeTypeMap** is used by: GenerateLetterService, RateChangeService
- **LinksByContract** is used by: PostProcessRateChangeAction, RateChangeService
- **ClinicianIdSet** is used by: GenerateLetterService, RateChangeService
- **Docs** is used by: PostProcessRateChangeAction, RateChangeService
- **TokenData** is used by: GenerateLetterService, RateChangeService
- **SelectedIds** is used by: IdParsingUtil, fileToLinkGenerator
- **Ex** is used by: PracticeOperationChangeUtil, fileToLinkGenerator
- **Response** is used by: ClinicalManagerController, fileToLinkGenerator
- **SelectedIdsList** is used by: RateChangeFinalProcessing, fileToLinkGenerator
- **Links** is used by: fileToLinkGenerator, fileToLinkGeneratorTest
- **Obj** is used by: RateChangeFinalProcessing, fileToLinkGenerator
- **ClinicianContractSyncQueueable** is used by: ClinicianContractSyncQueueableTest, CreateClientChangeManagementQueueable
- **CreateClientChangeManagementQueueable** is used by: PracticeOperationChangeQueueable, PracticeOperationChangeQueueableTest
- **Emails** is used by: HPFReportEmailUtil, SendHPFReportBatch
- **IdsForEmail** is used by: DeactivateHPFsForClinician, SendHPFReportBatch
- **ClinicianCoverageUpdateBatch** is used by: ClinicianCoverageUpdateBatchTest, ClinicianCoverageUpdateScheduler
- **EventBus** is used by: ClinicianCoverageUpdateBatch, PCATriggerHandler
- **HPFReportEmailUtil** is used by: DeactivateHPFsForClinician, HPFReportEmailUtilTest
- **AccountId** is used by: CPARelationshipRecordsGeneratorQueuable, DeactivateCliniciansBatch
- **CPARelationshipRecordsGeneratorQueuable** is used by: CPARelationshipRecordsGenerator, CPARelationshipRecordsGeneratorQueuable
- **ClinicalManagerController** is used by: ClinicalManagerController, ClinicalManagerControllerTest
- **DataList** is used by: ClinicalManagerController, ClinicalManagerControllerTest
- **PasswordResetController** is used by: PasswordResetController, PasswordResetControllerTest
- **RatePayCodes** is used by: ClinicianCoverageUpdateBatch, RateChangeServiceTest
- **RecordIds** is used by: ClinicalManagerControllerTest, ClinicianCoverageUpdateBatch
- **SendHPFReportBatch** is used by: SendHPFReportBatchTest, SendHPFReportScheduler
- **SendHPFReportScheduler** is used by: SendHPFReportBatchTest, SendHPFReportScheduler
- **Entry** is used by: TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **TruSalesAppSettingsSaveFuture** is used by: TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **TypeInfo** is used by: TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **Describe** is used by: TruSalesAppSettingsController, TruSalesAppSettingsControllerTest
- **ContractTerminationScheduler** is used by: ContractTerminationBatchTest, ContractTerminationScheduler
- **ContractTerminationBatch** is used by: ContractTerminationBatchTest, ContractTerminationScheduler
- **PracticeOperationChangeQueueable** is used by: PracticeOperationChangeQueueableInvoker, PracticeOperationChangeQueueableTest
- **ToLinkGenerator** is used by: RateChangeFinalProcessing, fileToLinkGeneratorTest
- **IdToGroup** is used by: DeactivateHPFsForClinician, SisterSiteGroupingUtility
- **IdToName** is used by: DeactivateHPFsForClinician, SisterSiteGroupingUtility
- **GetPOContractByClinicianStartDate** is used by: OmniUtility, OmniUtilityTest
- **Str** is used by: IdParsingUtil, OmniUtilityTest
- **CaseList** is used by: DeactivateCliniciansBatch, DeactivateHPFsForClinician
- **Jobs** is used by: GenerateJobDescriptionController, SendHPFReportBatchTest
- **DeactivateCliniciansBatch** is used by: DeactivateCliniciansBatch, DeactivateCliniciansBatchTest
- **Assert** is used by: ContactSSNActionTest, OmniUtilityTest
- **TruSalesAppController** is used by: TruSalesAppControllerTest
- **OpportunityLineItem** is used by: TruSalesAppControllerTest
- **PricebookEntry** is used by: TruSalesAppControllerTest
- **Class** is used by: CPARelationshipRecordsGeneratorTest
- **Cases** is used by: CPARelationshipRecordsGeneratorTest
- **Reviews** is used by: CPARelationshipRecordsGeneratorTest
- **CpaIds** is used by: CPARelationshipRecordsGeneratorTest
- **IdsFromReviews** is used by: CPARelationshipRecordsGeneratorTest
- **CPARelationshipRecordsGenerator** is used by: CPARelationshipRecordsGeneratorTest
- **TriggerHandler** is used by: OpportunityTriggerHandlerTest
- **OpportunityTriggerHandler** is used by: OpportunityTriggerHandlerTest
- **AssessmentEnvelopeItem** is used by: ClinicianIntakeFormAssessmentController
- **NameWithConfigMap** is used by: ClinicianIntakeFormAssessmentController
- **AssessmentEnvelope** is used by: ClinicianIntakeFormAssessmentController
- **DocumentWrapper** is used by: ClinicianIntakeFormAssessmentController
- **NameList** is used by: ClinicianIntakeFormAssessmentController
- **EnvItemName** is used by: ClinicianIntakeFormAssessmentController
- **PMT_AvailabilityResourceCreation** is used by: PMT_AvailabilityResourceCreationTest
- **DuplicateRuleHeader** is used by: GuidedClinicianCreationController
- **RateChangeSummaryAction** is used by: RateChangeActionsTest
- **CloneContractAction** is used by: RateChangeActionsTest
- **ContractSyncAction** is used by: RateChangeActionsTest
- **GenerateAndAttachLetterAction** is used by: RateChangeActionsTest
- **GetContractsToSend** is used by: RateChangeActionsTest
- **EmailMessage** is used by: RateChangeActionsTest
- **SaveContractSelectionAction** is used by: RateChangeActionsTest
- **RatesForCategory** is used by: ClinicianContractSyncService
- **WithAnyExecutedContract** is used by: ClinicianContractSyncService
- **ToAccountMap** is used by: ClinicianContractSyncService
- **ShiftRates** is used by: ClinicianContractSyncService
- **ToOwnerMap** is used by: ClinicianContractSyncService
- **ToClinicianNameMap** is used by: ClinicianContractSyncService
- **ClinicianRatesByHpf** is used by: ClinicianContractSyncService
- **TypeMap** is used by: ClinicianContractSyncService
- **IdWithAccountId** is used by: ClinicianContractSyncService
- **IdsFromCCM** is used by: ClinicianContractSyncService
- **PoContractIdWithShiftTypes** is used by: ClinicianContractSyncService
- **IdToHPFIdMap** is used by: ClinicianContractSyncService
- **RatesMap** is used by: ClinicianContractSyncService
- **CategoriesWithNewShifts** is used by: ClinicianContractSyncService
- **RatesByCategory** is used by: ClinicianContractSyncService
- **ShiftTypes** is used by: ClinicianContractSyncService
- **ToContractNumbersMap** is used by: ClinicianContractSyncService
- **IdWithCCMMap** is used by: ClinicianContractSyncService
- **IdToContractIdMap** is used by: ClinicianContractSyncService
- **CcmRecords** is used by: ClinicianContractSyncService
- **OfHPFToContractShiftRates** is used by: ClinicianContractSyncService
- **Numbers** is used by: ClinicianContractSyncService
- **ToNameMap** is used by: ClinicianContractSyncService
- **ToTeamMemberMap** is used by: ClinicianContractSyncService
- **ContractsForHpf** is used by: ClinicianContractSyncService
- **ShiftTypesForHPF** is used by: ClinicianContractSyncService
- **ForHPF** is used by: ClinicianContractSyncService
- **WithContract** is used by: ClinicianContractSyncService
- **UpdatedRateShiftData** is used by: ClinicianContractSyncService
- **ClinicianAccountIds** is used by: ClinicianContractSyncService
- **RateMap** is used by: ClinicianContractSyncService
- **Acct** is used by: CongaAgreementServiceHelperTest
- **Corporation_and_Tax_Information__c** is used by: CongaAgreementServiceHelperTest
- **Agree** is used by: CongaAgreementServiceHelperTest
- **LineRec** is used by: CongaAgreementServiceHelperTest
- **AttachmentResult** is used by: OpportunityAttachmentController
- **TypeList** is used by: OpportunityAttachmentController
- **Document_Type__c** is used by: OpportunityAttachmentController
- **ServiceAccIds** is used by: CongaAgreementServiceHelper
- **CEToFacilityNamesMap** is used by: CongaAgreementServiceHelper
- **TierSLSet** is used by: CongaAgreementServiceHelper
- **Rec** is used by: CongaAgreementServiceHelper
- **SR** is used by: CongaAgreementServiceHelper
- **IdToAgreeIdMap** is used by: CongaAgreementServiceHelper
- **NameSet** is used by: CongaAgreementServiceHelper
- **NameSLPMap** is used by: CongaAgreementServiceHelper
- **CTIContSet** is used by: CongaAgreementServiceHelper
- **IdToContIdMap** is used by: CongaAgreementServiceHelper
- **AgreeIdSet** is used by: CongaAgreementServiceHelper
- **SLPIds** is used by: CongaAgreementServiceHelper
- **IdToPNCMap** is used by: CongaAgreementServiceHelper
- **ChristusIdSet** is used by: CongaAgreementServiceHelper
- **HPFMap** is used by: CongaAgreementServiceHelper
- **AccIdToAgreeIdMap** is used by: CongaAgreementServiceHelper
- **IdToPCAIdMap** is used by: CongaAgreementServiceHelper
- **AARMap** is used by: CongaAgreementServiceHelper
- **IdToAccountIdsMap** is used by: CongaAgreementServiceHelper
- **NameSLPSet** is used by: CongaAgreementServiceHelper
- **TierNPPASet** is used by: CongaAgreementServiceHelper
- **Recs** is used by: CongaAgreementServiceHelper
- **ToUseCorpNameMap** is used by: CongaAgreementServiceHelper
- **CEToAccountIdsMap** is used by: CongaAgreementServiceHelper
- **CongaAgreementServiceHelperTest** is used by: CongaAgreementServiceHelper
- **QueryMap** is used by: CongaAgreementServiceHelper
- **AccToSLToHPFMap** is used by: CongaAgreementServiceHelper
- **IdToCCEIdtoHrsMap** is used by: CongaAgreementServiceHelper
- **CTIStatusSet** is used by: CongaAgreementServiceHelper
- **ShiftMap** is used by: CongaAgreementServiceHelper
- **IdNoCTISet** is used by: CongaAgreementServiceHelper
- **AgreeMap** is used by: CongaAgreementServiceHelper
- **ClinicianSet** is used by: CongaAgreementServiceHelper
- **CEToSLPFacilityNamesMap** is used by: CongaAgreementServiceHelper
- **IdToContIdNoCTIMap** is used by: CongaAgreementServiceHelper
- **ByAccount** is used by: GetPOContractByClinicianStartDate
- **POContractResult** is used by: GetPOContractByClinicianStartDate
- **ContactToContractIds** is used by: processHPFupdatesBactchClass
- **AllRelatedHealthcarePractitionerRecords** is used by: processHPFupdatesBactchClass
- **ServiceAccountIds** is used by: processHPFupdatesBactchClass
- **HpftoUpdate** is used by: processHPFupdatesBactchClass
- **IdToContractStartDate** is used by: processHPFupdatesBactchClass
- **ToContractIds** is used by: processHPFupdatesBactchClass
- **IdToStartDate** is used by: processHPFupdatesBactchClass
- **PractitionerIds** is used by: processHPFupdatesBactchClass
- **AccountToContractStartDate** is used by: processHPFupdatesBactchClass
- **HPFToClinicianMapping** is used by: processHPFupdatesBactchClass
- **CalculateNPPARates** is used by: CalculateNPPARatesTest
- **PCAList** is used by: CalculateNPPARatesTest
- **RulesMap** is used by: OpportunityHelper
- **RequiredDocumentAttributes** is used by: OpportunityHelper
- **PostProcessRateChange** is used by: PostProcessRateChangeTest
- **TestTemplate** is used by: PostProcessRateChangeTest
- **ValidationResult** is used by: RateChangeInvocableInput
- **InId** is used by: SelectContactsController
- **Apttus__DocumentVersion__c** is used by: DocumentVersionTriggerHandlerTest
- **Apttus__APTS_Template__c** is used by: DocumentVersionTriggerHandlerTest
- **Templates** is used by: DocumentVersionTriggerHandlerTest
- **DocVersions** is used by: DocumentVersionTriggerHandlerTest
- **OpportunityLineItemsForProduct** is used by: TruSalesAppController
- **SalesProductMapItemsWithOpportunity** is used by: TruSalesAppController
- **OwnerId** is used by: TruSalesAppController
- **OpportunitySyncRequestItem** is used by: TruSalesAppController
- **SetWithProduct** is used by: TruSalesAppController
- **SalesProductMapItemsWithProduct** is used by: TruSalesAppController
- **ToRetrieve** is used by: TruSalesAppController
- **OpportunitySyncRequest** is used by: TruSalesAppController
- **Enable_Sales_Stages_Values__c** is used by: TruSalesAppController
- **Stages** is used by: TruSalesAppController
- **FieldsToRetrieve** is used by: TruSalesAppController
- **OpportunitySyncRequestItemProduct** is used by: TruSalesAppController
- **LineItems** is used by: TruSalesAppController
- **Info** is used by: TruSalesAppController
- **OpportunityLineItemsForOpportunity** is used by: TruSalesAppController
- **OpportunityHistoryStage** is used by: TruSalesAppController
- **RecordTypeId** is used by: TruSalesAppController
- **Pnc** is used by: GetProviderNetworkControllerTest
- **GetProviderNetworkController** is used by: GetProviderNetworkControllerTest
- **RecordsToProcess** is used by: CPAReviewCaseGenerator
- **CPA_Review__c** is used by: CPAReviewCaseGenerator
- **CPACase** is used by: CPAReviewCaseGenerator
- **FacilityAccountIds** is used by: CPAReviewCaseGenerator
- **IdToCaseOwnerMap** is used by: CPAReviewCaseGenerator
- **IdToServiceAccountIdMap** is used by: CPAReviewCaseGenerator
- **IdToCaseMap** is used by: CPAReviewCaseGenerator
- **AccountToClinicianHPFMap** is used by: CPAReviewCaseGenerator
- **IdSet** is used by: CPAReviewCaseGenerator
- **ReviewsToInsert** is used by: CPAReviewCaseGenerator
- **ListForEachHpf** is used by: CalculateNPPARates
- **MapOfCountAndSumOfRates** is used by: CalculateNPPARates
- **ToAdd** is used by: CalculateNPPARates
- **MapOfHPFIdToPCA** is used by: CalculateNPPARates
- **JustCreated** is used by: CreateCongaAgreementService
- **Addendums** is used by: CreateCongaAgreementService
- **AgreementByCE** is used by: CreateCongaAgreementService
- **CorporateEntityIds** is used by: CreateCongaAgreementService
- **ChangeCases** is used by: CreateCongaAgreementService
- **AddendumsToInsert** is used by: CreateCongaAgreementService
- **IllegalArgumentException** is used by: CreateCongaAgreementService
- **ContractAgreements** is used by: CreateCongaAgreementService
- **TypeIds** is used by: CreateCongaAgreementService
- **EntityIds** is used by: CreateCongaAgreementService
- **IdOnOpp** is used by: SystemTreeExtension
- **IdOnLead** is used by: SystemTreeExtension
- **Discovery** is used by: SystemTreeExtension
- **Ctrl** is used by: SystemTreeExtension
- **SystemId** is used by: SystemTreeExtension
- **TitleIds** is used by: CheckRatesForServiceAccFacility
- **Source_Component__c** is used by: ErrorLogUtilTest
- **LogRequests** is used by: ErrorLogUtilTest
- **Error_Type__c** is used by: ErrorLogUtilTest
- **ErrorLogUtilTest** is used by: ErrorLogUtilTest
- **UpdatePreviousHPFBatchInvoke** is used by: UpdatePreviousHPFBatchInvokeTest
- **OmniProcess** is used by: CIFormAssessmentControllerTest
- **Processes** is used by: CIFormAssessmentControllerTest
- **ClinicianIntakeFormAssessmentController** is used by: CIFormAssessmentControllerTest
- **HTTPResponse** is used by: RequestFeedbackForControllerTest
- **HttpMock** is used by: RequestFeedbackForControllerTest
- **OpportunityAndAccountNames** is used by: RequestFeedbackForControllerTest
- **OpportunityAttachmentTriggerHandler** is used by: OpportunityAttachmentTriggerHandlerTest
- **CommunityLoginController** is used by: CommunityLoginControllerTest
- **ToName** is used by: RateChangeSummaryAction
- **WithEmailSent** is used by: RateChangeSummaryAction
- **SummaryItem** is used by: RateChangeSummaryAction
- **OWA** is used by: OpportunityTriggerHandler
- **OP** is used by: OpportunityTriggerHandler
- **StagingRule** is used by: OpportunityTriggerHandler
- **RequiredFinal** is used by: OpportunityTriggerHandler
- **RequiredDocuments** is used by: OpportunityTriggerHandler
- **CurrentDocuments** is used by: OpportunityTriggerHandler
- **OPP** is used by: OpportunityTriggerHandler
- **TempList** is used by: OpportunityTriggerHandler
- **Requireddocuments** is used by: OpportunityTriggerHandler
- **MissingDocuments** is used by: OpportunityTriggerHandler
- **GuidedClinicianCreationController** is used by: GuidedClinicianCreationControllerTest
- **CpaIdByType** is used by: ContractSyncRemoteActionTest
- **Cpas** is used by: ContractSyncRemoteActionTest
- **Action** is used by: ContractSyncRemoteActionTest
- **ActivateUserQueueable** is used by: UserActivationFlowAction
- **ToActivate** is used by: UserActivationFlowAction
- **SSNInput** is used by: ContactSSNAction
- **SSNOutputs** is used by: ContactSSNAction
- **Request** is used by: UserActivationFlowActionTest
- **UserRole** is used by: UserActivationFlowActionTest
- **IdRequest** is used by: UserActivationFlowActionTest
- **UserActivationFlowAction** is used by: UserActivationFlowActionTest
- **ClinicianIds** is used by: RateChangeService
- **ClonedContractIds** is used by: RateChangeService
- **CloneAndDocumentQueueable** is used by: RateChangeService
- **PaClinicianIds** is used by: RateChangeService
- **ToDeactivate** is used by: RateChangeService
- **CloneHelper** is used by: RateChangeService
- **RateChangeRec** is used by: RateChangeService
- **AccIds** is used by: fileToLinkGenerator
- **Urls** is used by: fileToLinkGenerator
- **ProcessedUserContacts** is used by: fileToLinkGenerator
- **ContractFileResponse** is used by: fileToLinkGenerator
- **ToPocs** is used by: CreateClientChangeManagementQueueable
- **ExistForHPF** is used by: CreateClientChangeManagementQueueable
- **TitleKeys** is used by: CreateClientChangeManagementQueueable
- **OperationChangeIds** is used by: CreateClientChangeManagementQueueable
- **NP_PA_SHIFT_TYPE** is used by: PracticeOperationChangeQueueable
- **WithMixedBagFacilityTitles** is used by: PracticeOperationChangeQueueable
- **IdWithFacilityToProcessType** is used by: PracticeOperationChangeQueueable
- **IdWithFacilityToRules** is used by: PracticeOperationChangeQueueable
- **ToFinalProcessType** is used by: PracticeOperationChangeQueueable
- **EMPLOYEE_SUB_TYPE** is used by: PracticeOperationChangeQueueable
- **ToRules** is used by: PracticeOperationChangeQueueable
- **SHIFT_BONUS_CODE** is used by: PracticeOperationChangeQueueable
- **PocIds** is used by: PracticeOperationChangeQueueable
- **SCPHealth** is used by: SendHPFReportBatch
- **RPCs** is used by: ClinicianCoverageUpdateBatchTest
- **Than270** is used by: DeactivateHPFsForClinicianTest
- **ContractIdsAndCrc** is used by: ContractSyncAction
- **CapturePCA__e** is used by: PCATriggerHandler
- **ToNew** is used by: ClinicianContractCloneServiceTest
- **Delete** is used by: ClinicianContractCloneServiceTest
- **Users** is used by: HPFReportEmailUtilTest
- **WithProcessType** is used by: PracticeOperationChangeUtil
- **AccountIdHPFId** is used by: CPARelationshipRecordsGeneratorQueuable
- **PncList** is used by: CPARelationshipRecordsGeneratorQueuable
- **RecordsToInsert** is used by: CPARelationshipRecordsGeneratorQueuable
- **AccToOtherClinicianHPFidsMap** is used by: CPARelationshipRecordsGeneratorQueuable
- **RecordsToUpsert** is used by: CPARelationshipRecordsGeneratorQueuable
- **IdToOtherAccountIdMap** is used by: CPARelationshipRecordsGeneratorQueuable
- **CliniciansCPAsHPFsIdSet** is used by: CPARelationshipRecordsGeneratorQueuable
- **ClinicianHPFidsList** is used by: CPARelationshipRecordsGeneratorQueuable
- **SystemTreeExtension** is used by: AllVisualForceTest
- **CreateCompetitorExtension** is used by: AllVisualForceTest
- **LeadScoreCardbyAccount__c** is used by: AllVisualForceTest
- **CompetitorsExtension** is used by: AllVisualForceTest
- **ScoreCardMatrix__c** is used by: AllVisualForceTest
- **ClinicalManagerRequest** is used by: ClinicalManagerController
- **ClinicianIdStrings** is used by: ClinicalManagerController
- **Wrapper** is used by: ClinicalManagerController
- **ClinicalManagerResponse** is used by: ClinicalManagerController
- **PersonAccIdVsOverRate** is used by: ClinicalManagerController
- **ClinicianData** is used by: ClinicalManagerController
- **ClinicalRecord** is used by: ClinicalManagerController
- **Error** is used by: ClinicalManagerController
- **PractIdsFromHPF** is used by: ClinicalManagerController
- **ClinicalManagerList** is used by: ClinicalManagerController
- **Body** is used by: ClinicalManagerController
- **Object** is used by: ClinicalManagerController
- **ClinicalDataWrapper** is used by: ClinicalManagerController
- **SelectedClinicianIds** is used by: ClinicalManagerController
- **LightningResponse** is used by: ClinicalManagerController
- **Output** is used by: ContractDetails
- **Reference** is used by: OpportunityAttachmentControllerTest
- **SelectOptions** is used by: OpportunityAttachmentControllerTest
- **OpportunityAttachmentController** is used by: OpportunityAttachmentControllerTest
- **SendTermsheetForSignature** is used by: SendTermsheetForSignatureTest
- **SendCalloutMock** is used by: SendTermsheetForSignatureTest
- **CheckRatesForServiceAccFacility** is used by: CheckRatesForServiceAccFacility_Test
- **TestException** is used by: PasswordResetController
- **ResetResult** is used by: PasswordResetController
- **JobStatusController** is used by: JobStatusControllerTest
- **LoginAction** is used by: CommunityLoginController
- **DefaultSiteLoginAction** is used by: CommunityLoginController
- **Page** is used by: CommunityLoginController
- **Logins** is used by: CommunityLoginController
- **MockSiteLoginAction** is used by: CommunityLoginController
- **ClinicianPCAIds** is used by: ClinicianCoverageUpdateBatch
- **Keys** is used by: ClinicianCoverageUpdateBatch
- **ClientPCAIds** is used by: ClinicianCoverageUpdateBatch
- **ByCPAByServAccFacilityTitle** is used by: ClinicianCoverageUpdateBatch
- **RateCode** is used by: ClinicianCoverageUpdateBatch
- **OperationShifts** is used by: ClinicianCoverageUpdateBatch
- **ContractFacilities** is used by: ClinicianCoverageUpdateBatch
- **RPCMap** is used by: ClinicianCoverageUpdateBatch
- **PCAsWithShiftAdded** is used by: ClinicianCoverageUpdateBatch
- **ClientRPCs** is used by: ClinicianCoverageUpdateBatch
- **ByShiftType** is used by: ClinicianCoverageUpdateBatch
- **TypeRates** is used by: ClinicianCoverageUpdateBatch
- **RatesByCPA** is used by: ClinicianCoverageUpdateBatch
- **ClinicianCPAIdsForRatePayCodes** is used by: ClinicianCoverageUpdateBatch
- **PCAWithSerAccTitleShift** is used by: ClinicianCoverageUpdateBatch
- **ByCPAByShiftType** is used by: ClinicianCoverageUpdateBatch
- **OperationContracts** is used by: ClinicianCoverageUpdateBatch
- **ClinicianCPAIds** is used by: ClinicianCoverageUpdateBatch
- **PCA** is used by: ClinicianCoverageUpdateBatch
- **ClinicianCloneResult** is used by: ClinicianCoverageUpdateBatch
- **ProcessedCPAIds** is used by: ClinicianCoverageUpdateBatch
- **IdsForSync** is used by: ClinicianCoverageUpdateBatch
- **ClinicianCloneContext** is used by: ClinicianCoverageUpdateBatch
- **HPFUpdates__e** is used by: ClinicianCoverageUpdateBatch
- **ByKey** is used by: ClinicianCoverageUpdateBatch
- **ShiftNames** is used by: ClinicianCoverageUpdateBatch
- **RatePayCodeMap** is used by: ClinicianCoverageUpdateBatch
- **RatePayCodesToDelete** is used by: ClinicianCoverageUpdateBatch
- **Service** is used by: ClinicianCoverageUpdateBatch
- **PCAResult** is used by: ClinicianCoverageUpdateBatch
- **RatePayCodeChanges** is used by: ClinicianCoverageUpdateBatch
- **NamesByCPA** is used by: ClinicianCoverageUpdateBatch
- **CPAWithUpdateMap** is used by: ClinicianCoverageUpdateBatch
- **RatesByShiftType** is used by: ClinicianCoverageUpdateBatch
- **Titles** is used by: ClinicianCoverageUpdateBatch
- **RecordsByContractFacility** is used by: ClinicianCoverageUpdateBatch
- **IdWithPayRateChange** is used by: ClinicianCoverageUpdateBatch
- **IdWithCPAId** is used by: ClinicianCoverageUpdateBatch
- **PayCodeResult** is used by: ClinicianCoverageUpdateBatch
- **CPAMap** is used by: ClinicianCoverageUpdateBatch
- **Outputs** is used by: GetContractsToSend
- **GenerateJobDescriptionController** is used by: GenerateJobDescriptionControllerTest
- **Facility_Profile__c** is used by: GenerateJobDescriptionControllerTest
- **IdMap** is used by: HPFReportEmailUtil
- **ProductFieldsValueView** is used by: TruSalesAppSettingsController
- **WithNull** is used by: TruSalesAppSettingsController
- **FieldValuesFromOpp** is used by: TruSalesAppSettingsController
- **ForViewFromOpportunity** is used by: TruSalesAppSettingsController
- **UserProfilesSelected** is used by: TruSalesAppSettingsController
- **Apexpages** is used by: TruSalesAppSettingsController
- **OpportunityList** is used by: TruSalesAppSettingsController
- **SalesProductMapItemsOpp** is used by: TruSalesAppSettingsController
- **WrapperProfiles** is used by: TruSalesAppSettingsController
- **BotsSettingsDeleted** is used by: TruSalesAppSettingsController
- **NameValueMap** is used by: TruSalesAppSettingsController
- **FieldValues** is used by: TruSalesAppSettingsController
- **SalesStages** is used by: TruSalesAppSettingsController
- **FieldsForProductMap** is used by: TruSalesAppSettingsController
- **UsersFieldsListStatic** is used by: TruSalesAppSettingsController
- **UsersFields** is used by: TruSalesAppSettingsController
- **Picklist_Value__c** is used by: TruSalesAppSettingsController
- **TruSales_Users_Item__c** is used by: TruSalesAppSettingsController
- **Object_nameOpp** is used by: TruSalesAppSettingsController
- **ListOpportunity** is used by: TruSalesAppSettingsController
- **PicklistValueToStrings** is used by: TruSalesAppSettingsController
- **WrapperRoles** is used by: TruSalesAppSettingsController
- **NameWithOutProduct** is used by: TruSalesAppSettingsController
- **UsersFieldsList** is used by: TruSalesAppSettingsController
- **ListSalesUsersItems** is used by: TruSalesAppSettingsController
- **Wrappers** is used by: TruSalesAppSettingsController
- **NamesOpp** is used by: TruSalesAppSettingsController
- **ProductUpdated** is used by: TruSalesAppSettingsController
- **TruSalesAppSettingsSave** is used by: TruSalesAppSettingsController
- **ForViewFromProduct** is used by: TruSalesAppSettingsController
- **FieldsNameFromProductOpp** is used by: TruSalesAppSettingsController
- **ButtonWrapper** is used by: TruSalesAppSettingsController
- **FieldValuesProductOpp** is used by: TruSalesAppSettingsController
- **OpportunityStage** is used by: TruSalesAppSettingsController
- **ValuesSet** is used by: TruSalesAppSettingsController
- **FieldValuesProduct** is used by: TruSalesAppSettingsController
- **TypeOpp** is used by: TruSalesAppSettingsController
- **Items** is used by: TruSalesAppSettingsController
- **Profiles** is used by: TruSalesAppSettingsController
- **Picklist** is used by: TruSalesAppSettingsController
- **ProductList** is used by: TruSalesAppSettingsController
- **PicklistNameValues** is used by: TruSalesAppSettingsController
- **OpportunityFieldsValueView** is used by: TruSalesAppSettingsController
- **MapItemsForSave** is used by: TruSalesAppSettingsController
- **ValueToStrings** is used by: TruSalesAppSettingsController
- **MapItemsForSaveWithOpp** is used by: TruSalesAppSettingsController
- **FieldsNameFromProduct** is used by: TruSalesAppSettingsController
- **SalesAppSettings** is used by: TruSalesAppSettingsController
- **Roles** is used by: TruSalesAppSettingsController
- **OpportunityUpdated** is used by: TruSalesAppSettingsController
- **FieldsOpp** is used by: TruSalesAppSettingsController
- **ListStrings** is used by: TruSalesAppSettingsController
- **ListUsers** is used by: TruSalesAppSettingsController
- **UserRolesSelected** is used by: TruSalesAppSettingsController
- **ValuePickListFromProductTrigger** is used by: TruSalesAppSettingsController
- **TruVoice_Product_Id__c** is used by: TruSalesAppSettingsController
- **ValuesFromOppProduct** is used by: TruSalesAppSettingsController
- **NamePicklistValue** is used by: TruSalesAppSettingsController
- **Object_name** is used by: TruSalesAppSettingsController
- **OpportunityValuePickListFromProductTrigger** is used by: TruSalesAppSettingsController
- **Field** is used by: TruSalesAppSettingsController
- **GetAllIds** is used by: ClinicalManagerControllerTest
- **GetData** is used by: ClinicalManagerControllerTest
- **HPF** is used by: ClinicalManagerControllerTest
- **GetSummary** is used by: ClinicalManagerControllerTest
- **ListValuesList** is used by: RequestFeedbackForController
- **ListVal** is used by: RequestFeedbackForController
- **Role** is used by: RequestFeedbackForController
- **JsonList** is used by: RequestFeedbackForController
- **SObjectException** is used by: GenerateLetterService
- **GenerateAndAttachLetterResult** is used by: GenerateLetterService
- **ToUpdateList** is used by: DocumentVersionTriggerHandler
- **IdToDocumentTitle** is used by: DocumentVersionTriggerHandler
- **NameLower** is used by: DocumentVersionTriggerHandler
- **VersionToAgreementMap** is used by: DocumentVersionTriggerHandler
- **ContractDetails** is used by: ContractDetailsTest
- **FinalOutput** is used by: RateChangeFinalProcessing
- **SelectedIdsListString** is used by: RateChangeFinalProcessing
- **FinalOut** is used by: RateChangeFinalProcessing
- **Out** is used by: RateChangeFinalProcessing
- **ToAccountIds** is used by: SisterSiteGroupingUtility
- **Group** is used by: SisterSiteGroupingUtility
- **GroupingResult** is used by: SisterSiteGroupingUtility
- **DocToContract** is used by: RateChangeContractUtil
- **Table** is used by: GenerateLetterServiceTest
- **HPFupdatesBactchClass** is used by: processHPFupdatesBatchClassTest
- **HPFs** is used by: processHPFupdatesBatchClassTest
- **CpasByContractId** is used by: ContractSyncRemoteAction
- **ActiveRatesByFacility** is used by: ContractSyncRemoteAction
- **CpaMapByType** is used by: ContractSyncRemoteAction
- **ClinicianCpaIds** is used by: ContractSyncRemoteAction
- **ToDeleteIdSet** is used by: ContractSyncRemoteAction
- **TypeActiveRatesByFacility** is used by: ContractSyncRemoteAction
- **PoCpaIds** is used by: ContractSyncRemoteAction
- **PcasByCpaId** is used by: ContractSyncRemoteAction
- **PoOtherTypePcaIdMap** is used by: ContractSyncRemoteAction
- **PoShiftPcaIdMap** is used by: ContractSyncRemoteAction
- **NotDeleted** is used by: ContractSyncRemoteAction
- **ActiveRates** is used by: ContractSyncRemoteAction
- **NetworkContracts** is used by: ContractSyncRemoteAction
- **RPCToDelete** is used by: ContractSyncRemoteAction
- **RecordsToDeleteIdSet** is used by: ContractSyncRemoteAction
- **CpasByPncId** is used by: ContractSyncRemoteAction
- **ShiftActiveRates** is used by: ContractSyncRemoteAction
- **CpasToUpdate** is used by: ContractSyncRemoteAction
- **IdToBestPoContractId** is used by: ContractSyncRemoteAction
- **ContractsByAccountId** is used by: ContractSyncRemoteAction
- **PoContractIds** is used by: ContractSyncRemoteAction
- **IdToAccountIdMap** is used by: ContractSyncRemoteAction
- **TypeActiveRates** is used by: ContractSyncRemoteAction
- **OfCPA** is used by: ContractSyncRemoteAction
- **OtherTypePcaMap** is used by: ContractSyncRemoteAction
- **RecordsToDelete** is used by: ContractSyncRemoteAction
- **UpdatesMap** is used by: ContractSyncRemoteAction
- **IdToFacilityTitleMap** is used by: ContractSyncRemoteAction
- **OtherTypeActiveRates** is used by: ContractSyncRemoteAction
- **SisterSiteGroupingUtility** is used by: DeactivateHPFsForClinician
- **ListToUpdatePermanent** is used by: DeactivateHPFsForClinician
- **ClinicianToSisterSiteGrpToHPD** is used by: DeactivateHPFsForClinician
- **HpfIds** is used by: DeactivateHPFsForClinician
- **DateWorked** is used by: DeactivateHPFsForClinician
- **SisteResults** is used by: DeactivateHPFsForClinician
- **ListToUpdate** is used by: DeactivateHPFsForClinician
- **IdToAccountId** is used by: DeactivateHPFsForClinician
- **PrvldDate** is used by: DeactivateHPFsForClinician
- **ClinicianToCntrctInitialEffDate** is used by: DeactivateHPFsForClinician
- **ForScope** is used by: DeactivateHPFsForClinician
- **ClinicianToSisterSiteGrpToLWD** is used by: DeactivateHPFsForClinician
- **InitialEffDate** is used by: DeactivateHPFsForClinician
- **HPFId** is used by: DeactivateHPFsForClinician
- **IdToTerminate** is used by: DeactivateHPFsForClinician
- **ClinicianToSisterSiteGrpToPNSD** is used by: DeactivateHPFsForClinician
- **NightPCAs** is used by: ClinicianContractSyncQueueableTest
- **TestDataCache** is used by: ClinicianContractSyncQueueableTest
- **NightPcas** is used by: ClinicianContractSyncQueueableTest
- **Description** is used by: ClinicianContractSyncQueueableTest
- **Shifts** is used by: ClinicianContractSyncQueueableTest
- **DayPCAs** is used by: ClinicianContractSyncQueueableTest
- **Contract2** is used by: ClinicianContractSyncQueueableTest
- **After** is used by: ClinicianContractSyncQueueableTest
- **DeactivateCliniciansBatchInvoke** is used by: DeactivateCliniciansBatchInvokeTest
- **CloneQueueableInput** is used by: CloneContractAction
- **IdStrings** is used by: CloneContractAction
- **AccountDetails** is used by: AccountDetailsTest
- **SelectContactsController** is used by: SelectContactsControllerTest
- **ShiftAddedPOCs** is used by: PracticeOperationChangeQueueableTest
- **PracticeOperationChangeQueueableInvoker** is used by: PracticeOperationChangeQueueableTest
- **POCs** is used by: PracticeOperationChangeQueueableTest
- **Acc** is used by: PracticeOperationChangeQueueableTest
- **IncreasedPOCs** is used by: PracticeOperationChangeQueueableTest
- **PracticeOperationChangeQueueableTest** is used by: PracticeOperationChangeQueueableTest
- **EmailsSentContractIds** is used by: PostProcessRateChangeAction
- **EmailBatchResult** is used by: PostProcessRateChangeAction
- **PostProcessInput** is used by: PostProcessRateChangeAction
- **ContactIds** is used by: PostProcessRateChangeAction
- **EmailMessagesResult** is used by: PostProcessRateChangeAction
- **HPFIdsToUpdate** is used by: ContractTerminationBatch
- **TasksToUpdate** is used by: ContractTerminationBatch
- **ToPNCMap** is used by: ContractTerminationBatch
- **IdsForExtendingContracts** is used by: ContractTerminationBatch
- **ToActiveHPFIdsMap** is used by: ContractTerminationBatch
- **ToCancelReasonMap** is used by: ContractTerminationBatch
- **ToExtendingHPFIdsMap** is used by: ContractTerminationBatch
- **IdsToUpdate** is used by: ContractTerminationBatch
- **ToHPFIdsMap** is used by: ContractTerminationBatch
- **CasesToInsert** is used by: ContractTerminationBatch
- **HPFsMap** is used by: ContractTerminationBatch
- **CaseIds** is used by: ContractTerminationBatch
- **ActiveHPFs** is used by: ContractTerminationBatch
- **Scope** is used by: SendHPFReportBatchTest
- **Lines** is used by: GenerateJobDescriptionController
- **Facility_Name__r** is used by: GenerateJobDescriptionController
- **PaJobs** is used by: GenerateJobDescriptionController
- **SetAssignmentList** is used by: TruSalesAppSettingsSaveFuture
- **JobStatusResult** is used by: JobStatusController
- **WithServiceAccIdMap** is used by: DeactivateCliniciansBatch
- **AccIdToSisContractMap** is used by: DeactivateCliniciansBatch
- **IdAndRelatedAccId** is used by: DeactivateCliniciansBatch
- **IdToUpdate** is used by: DeactivateCliniciansBatch
- **SistesContract** is used by: DeactivateCliniciansBatch
- **OfServiceAccount** is used by: DeactivateCliniciansBatch
- **AccIdtoHPFMap** is used by: DeactivateCliniciansBatch
- **AccIdToRltdContractMap** is used by: DeactivateCliniciansBatch
- **HPFListTpUpdate** is used by: DeactivateCliniciansBatch
- **SistesHPF** is used by: DeactivateCliniciansBatch
- **AccIdToUpdate** is used by: DeactivateCliniciansBatch
- **Lst** is used by: DeactivateCliniciansBatch
- **AccId** is used by: DeactivateCliniciansBatch
- **Version__c** is used by: OpportunityAttachmentTriggerHandler
- **Version** is used by: OpportunityAttachmentTriggerHandler
- **DOCUMENT_TYPES** is used by: OpportunityAttachmentTriggerHandler
- **IDslocal** is used by: PostProcessRateChange
- **ListResult** is used by: fileToLinkGeneratorTest
- **KeyResult** is used by: fileToLinkGeneratorTest
- **Responses** is used by: fileToLinkGeneratorTest
- **List2** is used by: fileToLinkGeneratorTest
- **ValuesResult** is used by: fileToLinkGeneratorTest
- **StatusContractsUpdated** is used by: fileToLinkGeneratorTest
- **WithData** is used by: fileToLinkGeneratorTest
- **WithNulls** is used by: fileToLinkGeneratorTest
- **ValueResult** is used by: fileToLinkGeneratorTest
- **SelectIdResult** is used by: fileToLinkGeneratorTest
- **MapResult** is used by: fileToLinkGeneratorTest
- **ObjectsResult** is used by: fileToLinkGeneratorTest
- **HttpMockCollectors** is used by: TruSalesAppSettingsControllerTest
- **FieldsTest** is used by: TruSalesAppSettingsControllerTest
- **RoleWrappers** is used by: TruSalesAppSettingsControllerTest
- **ProfileWrappers** is used by: TruSalesAppSettingsControllerTest
- **HttpMockCollectorsFailed** is used by: TruSalesAppSettingsControllerTest
- **Option** is used by: TruSalesAppSettingsControllerTest
- **RateChangeFinalProcessing** is used by: RateChangeFinalProcessingTest
- **OmniUtility** is used by: OmniUtilityTest
- **Provs** is used by: ContractTerminationBatchTest
- **Nets** is used by: ContractTerminationBatchTest
- **Limits** is used by: RateChangeServiceTest
- **DataMD** is used by: RateChangeServiceTest
- **PayCodes** is used by: RateChangeServiceTest
- **TestDoc** is used by: RateChangeServiceTest
- **DataNP** is used by: RateChangeServiceTest
- **Row** is used by: RateChangeServiceTest
- **SendEmailResult** is used by: RateChangeServiceTest

---

## Usage Notes

- Use this graph for impact analysis before modifying components
- Dependencies are detected via code analysis (not exhaustive)
- Reverse dependencies show which components will be affected by changes
- For component details, see `COMPONENT-CATALOG.md`
- For story-component mapping, see `COMPONENT-TO-STORY-MAP.md`
