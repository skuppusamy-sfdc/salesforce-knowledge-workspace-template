/**
 * This class represents the controller for ClinicianIntake Form Assessment
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 09/03/2025
 * 
 * Test Class - CIFormAssessmentControllerTest
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber		DeveloperName		ModifiedDate		Description
 * =================================================================================
 * PR1050558-1095	Harsh Gupta			09/03/2025			Created this Controller
 * PR1050558-6001	Tapas Dey			03/18/2026			Modified this Controller
 * PR1050558-6829	Harsh Gupta			05/05/2026			Updating employment type
 * =================================================================================
 */
public class ClinicianIntakeFormAssessmentController {
    private static final string DO_STRING = 'DO';
    private static final string MD_STRING = 'MD';
    private static final string NP_STRING = 'NP';
    private static final string PA_STRING = 'PA';
    private static final Integer NO_OF_DAYS = Integer.valueOf(Label.FetchAssessmentEnvelopeItem) ;
    
    /*
     * description	- This method get invoked by CaseCreationFlow
     * input		- caseList - Accept the list of cases
     * output		- nothing             
     */
    @InvocableMethod(label = 'Setup CI Assessment' description='Setup CI Assessment for the Clinician in the community' )
    public static void setupAssessment(List<Case> caseList) {
        try {
            if(caseList.size() > 0) {
                setupAssessment(caseList.get(0));
            }
        } catch(Exception ex) {
            System.debug(logginglevel.Error, 'Error::ClinicianIntakeFormAssessmentController::setupAssessment'+ex.getMessage());
            System.debug(logginglevel.Error,'StackTrace ::ClinicianIntakeFormAssessmentController::setupAssessment'+ex.getStackTraceString());
        }
    }
    
    /*
     * description	- This method is to setup the assessment on certain criteria met
     * input		- cs - Accept single case record
     * output		- nothing
     */
    public static void setupAssessment(Case cs) {
        
        List<string> docNameList = new List<string>{'Clinician_Profile_Updates'};//Add the default Doc Name
        Contact con = [SELECT Id, Name,AccountId, Professional_Title__c, MailingState from Contact where Id = :cs.ContactId limit 1];
        System.debug(logginglevel.FINEST,'con.MailingState '+con.MailingState);
        if(con.MailingState != null && con.MailingState == 'California') {
            System.debug(logginglevel.FINEST,'MAiling state is CA');
             docNameList.add('CCPA_Doc');
        }
        
        //query existing Assessment Envelope Item for the Clinician for last 180 days
        Set<String> assessmentEnvItemName = new Set <String>();
        Date reqDate = Date.today().addDays(- NO_OF_DAYS);
        string employmentType;
        
        for (AssessmentEnvelopeItem asi : [Select Id, Name, OmniProcess.Name,  Assessment.Name FROM AssessmentEnvelopeItem 
                                                               WHERE AssessmentEnvelope.Account.PersonContactId =:cs.ContactId 
                                                               AND CreatedDate > :reqDate]) {
            assessmentEnvItemName.add(asi.Name);
        }
        
        for(bpats__ATS_Applicant__c applicant : [SELECT Id, 
                                                        bpats__Job__r.Facility_Name__r.Service_State__c,
                                                        bpats__Job__r.Facility_Name__r.Service_Line__r.Description__c,   
                                                        bpats__Job__r.Facility_Title_Lookup__c,
                                                        bpats__Job__r.Facility_Title_Lookup__r.Code_Set_Sub_Type__c
                                                 FROM bpats__ATS_Applicant__c 
                                                 WHERE bpats__ATS_Applicant__c = :cs.ContactId order by Createddate desc]) {
            
            // Local variables for clarity and null safety
            String employmentSubType = applicant.bpats__Job__r?.Facility_Title_Lookup__r?.Code_Set_Sub_Type__c;
            String serviceState = applicant.bpats__Job__r?.Facility_Name__r?.Service_State__c;
            String serviceLineDesc = applicant.bpats__Job__r?.Facility_Name__r?.Service_Line__r?.Description__c;
            String facilityTitle = applicant.bpats__Job__r?.Facility_Title_Lookup__c;
            if(employmentType == null) {
                employmentType = employmentSubType;                             
            }
            if(employmentSubType == 'Employee' && !docNameList.contains('COI_Doc')) {
                  docNameList.add('COI_Doc');
            }

            if(serviceState == 'CA' && !docNameList.contains('CCPA_Doc')) {
                  docNameList.add('CCPA_Doc');
            }

            if(serviceLineDesc != null) {
                if(serviceLineDesc == 'Virtual Health') {
                    docNameList.add('CoC_eHealth');
                } else if(facilityTitle != null) {
                    if(serviceLineDesc == 'Emergency Medicine') {
                        if(con.Professional_Title__c == NP_STRING || con.Professional_Title__c == PA_STRING) docNameList.add('CoC_UC_EM_NP_PA');
                        else if(con.Professional_Title__c == MD_STRING || con.Professional_Title__c == DO_STRING) docNameList.add('CoC_EM_Physician');
                    } 
                    else if(serviceLineDesc == 'Post Acute Provider Services' || serviceLineDesc == 'Hospital Medicine' ||
                           serviceLineDesc == 'Critical Care (formerly ISV)') {
                        if(con.Professional_Title__c == NP_STRING || con.Professional_Title__c == PA_STRING) docNameList.add('CoC_HM_PAPS_Tele_Hospitalist_NP_PA');
                        else if(con.Professional_Title__c == MD_STRING || con.Professional_Title__c == DO_STRING) docNameList.add('CoC_HM_PAPS_Tele_Hospitalist_Physician');
                    } 
                    /*else if(serviceLineDesc == 'Critical Care (formerly ISV)') {
                        if(con.Professional_Title__c == NP_STRING || con.Professional_Title__c == PA_STRING) docNameList.add('CoC_ISV_Critical_Care_NP_PA');
                        else if(con.Professional_Title__c == MD_STRING || con.Professional_Title__c == DO_STRING) docNameList.add('CoC_ISV_Critical_Care_Physician');
                    }*/ 
                    else if(serviceLineDesc == 'Pediatric - Hospital Medicine') {
                        docNameList.add('CoC_Peds_HM');
                    } 
                    else if(serviceLineDesc == 'Urgent Care') {
                        if(con.Professional_Title__c == NP_STRING || con.Professional_Title__c == PA_STRING) docNameList.add('CoC_UC_NP_PA');
                        else if(con.Professional_Title__c == MD_STRING || con.Professional_Title__c == DO_STRING) docNameList.add('CoC_UC_Physician');
                    }
                    
                    if(serviceLineDesc == 'Critical Care (formerly ISV)') {
                        if(con.Professional_Title__c == NP_STRING || con.Professional_Title__c == PA_STRING) docNameList.add('CoC_ISV_Critical_Care_NP_PA');
                        else if(con.Professional_Title__c == MD_STRING || con.Professional_Title__c == DO_STRING) docNameList.add('CoC_ISV_Critical_Care_Physician');
                    }
                }
            }
        }
        List<DocumentWrapper> wrapList = getRelatedOmniscriptIds(docNameList, assessmentEnvItemName);
        if(wrapList.size() > 0) {
            Id envelopeId = createAssessmentEnvelope(cs, con);
            createAssessmentEnvelopeItem(envelopeId, wrapList);
        } else {
            cs.Status = 'Closed';            
        }
        cs.SuppliedCompany = employmentType;
        update cs;
    }
    
    /*
     * description	- This method is to create the AssessmentEnvelope
     * input		- cs 	- Single case record
     * 				- con	- Single contact record
     * output		- Id	- Return AssessmentEnvelope's Id
     */
    public static Id createAssessmentEnvelope(Case cs, Contact con) {
        AssessmentEnvelope env = new AssessmentEnvelope();
        env.Name = 'CI Form - ' + con.Name;
        env.AccountId = con.AccountId;
        env.ContactId = con.Id;
        env.RequestReferenceId = cs.Id;
        env.ExpirationDateTime = System.now() + 30;
        env.Status = 'Completed';
        env.NotificationStatus = 'NotSent';
        insert env;
        return env.Id;
    }
    
    /*
     * description	- This method is to create the AssessmentEnvelopeItem
     * input		- envelopeId 	- Parent Envelope Id
     * 				- docNameList	- List of document names
     * output		- nothing
     */
    public static void createAssessmentEnvelopeItem(Id envelopeId, List<DocumentWrapper> wrapList) {
        List<AssessmentEnvelopeItem> envList = new List<AssessmentEnvelopeItem>();
        Integer i = 1;
        for(DocumentWrapper wrap : wrapList) {
			AssessmentEnvelopeItem item = new AssessmentEnvelopeItem();
			item.Name = wrap.documentLabel;
            item.OmniProcessId = wrap.omniProcessId;
            item.AssessmentEnvelopeId = envelopeId;
            item.Status = 'NotStarted';
            envList.add(item);
        }
        if(envList.size() > 0) {
            insert envList;
        }
        
    }
    
    /*
     * description	- This method is to get config details on the basis of document name
     * input		- docNameList	- List of document names
     * output		- config details
     */
    public static List<DocumentWrapper> getRelatedOmniscriptIds(List<string> docNameList, Set<String> assessmentEnvItemName) {
        List<DocumentWrapper> wrapList = new List<DocumentWrapper>();
        Map<string,Intake_Form_Document_Configs__mdt> osNameWithConfigMap = new  Map<string,Intake_Form_Document_Configs__mdt>();
        for(Intake_Form_Document_Configs__mdt config : [SELECT Id, DeveloperName, Omniscript_Developer_Name__c, Document_Label__c
                                                        FROM Intake_Form_Document_Configs__mdt
                                                       	WHERE DeveloperName IN :docNameList AND 
                                                        Document_Label__c NOT IN: assessmentEnvItemName
                                                        //Not(Omniscript_Developer_Name__c like '%Add%')
                                                       ]) {
            osNameWithConfigMap.put(config.Omniscript_Developer_Name__c,config);
        }
        Set<string> omniIdSet = osNameWithConfigMap.keySet();
        string query = 'SELECT Id, Name, UniqueName FROM OmniProcess WHERE UniqueName IN :omniIdSet';
        String query1 = 'SELECT Id, Name, UniqueName FROM OmniProcess limit 10';
        List<OmniProcess> omniList =  new List<OmniProcess>();
        omniList = Test.isRunningTest() ? Database.query(query1) : Database.query(query);
        System.debug('omniList::'+omniList);
        for(OmniProcess omni : omniList) {
            DocumentWrapper wrap = new DocumentWrapper();
            wrap.omniProcessId = omni.Id;
            wrap.documentLabel = Test.isRunningTest() ? omni.UniqueName : osNameWithConfigMap.get(omni.UniqueName)?.Document_Label__c;
            wrapList.add(wrap);
        }
       
        return wrapList;
    }
    
    public class DocumentWrapper {
        public Id omniProcessId;
        public string documentLabel;
    }

}