public with sharing class GenerateJobDescriptionController {
        
        public static final String EDIT_LABEL = 'Edit Here';
        
        
        // ==== Header Section ====
        public static final String HEADER_TEMPLATE =
            'Service Line: {SERVICE_LINE}<br/>' +
            'Position Title: {POSITION_TITLE}<br/>' +
            'Location: {LOCATION}<br/>' +
            'Job Type: {JOB_TYPE}<br/>' +
            'Recruiter: {RECRUITER}<br/>';
        
        // ==== Position Overview ====
        public static final String POSITION_OVERVIEW_TEMPLATE =
            'Serve patients in moments that matter and be a part of the future of health care. '
            + 'SCP Health is seeking a dedicated {POSITION_TITLE} to join our dynamic team at {FACILITY_NAME}. '
            + 'Join us to grow your career, make a meaningful impact, and deliver high-quality care in the communities you serve.<br/><br/>'
            + '<ul>'
            + '<li>Patient Volume: {PATIENT_VOLUME}</li>'
            + '<li>Specialties: {SPECIALTIES}</li>'
            + '<li>Coverage Model: {COVERAGE_MODEL}</li>'
            + '<li>Number of Beds: {NUM_BEDS}</li>'
            + '<li>Acuity: {ACUITY}</li>'
            + '<li>EMR: {EMR}</li>'
            + '<li>Procedures: {PROCEDURES}</li>'
            + '<li>ICU: {ICU_STATUS}</li>'
            + '<li>Admissions/Transfers: {ADM_TRANSFER_RATES}</li>'
            + '<li>Fellowship/Residency: {FELLOWSHIP_INFO}</li>'
            + '<li>Moonlighting: {MOONLIGHTING}</li>'
            + '<li>ICP Site: {ICP_SITE}</li>'
            + '<li>Tele Coverage: {TELE_COVERAGE}</li>'
            + '</ul>';
        
        // ==== Qualifications ====
        public static final String QUALIFICATIONS_TEMPLATE =
            '<ul>'
            + '<li>Education: {EDUCATION}</li>'
            + '<li>Licensure: {LICENSURE}</li>'
            + '<li>Board Certification: {BOARD_CERTIFICATION}</li>'
            + '<li>Experience: {EXPERIENCE}</li>'
            + '<li>Skills & Procedures: {SKILLS}</li>'
            + '<li>Badges: {BADGES}</li>'
            + '</ul>';
        
        // ==== Facility Overview ====
        public static final String FACILITY_TEMPLATE =
            '<ul>'
            +'<li><b>About {FACILITY_NAME}:</b> {FACILITY_PARAGRAPH}</li><br/>'
            + '<li><b>Innovation/Growth:</b> {INNOVATION_STATEMENT}</li><br/>'
            + '<li><b>Teamwork/Culture:</b> {TEAM_CULTURE_STATEMENT}</li><br/>'
            + '<li><b>Services:</b> {SERVICES}</li><br/>'
            + '</ul>';
        
        // ==== Community Information ====
        public static final String COMMUNITY_TEMPLATE ='{COMMUNITY_INFORMATION}';
        
        // ==== Benefits & Compensation ====
        public static final String BENEFITS_TEMPLATE =
            '<ul>'
            //+ '<li>Compensation: {COMPENSATION}</li>'
            + '<li>Competitive compensation package with earning potential up to: {COMPENSATION}</li>'
            + '<li>Job Status: {JOB_STATUS}</li>'
            + '<li>Sign-On Bonus: {SIGN_ON_BONUS}</li>'
            + '<li>Benefits Eligibility: {BENEFITS_ELIGIBILITY}</li>'
            + '<li>No Non-Compete: {NON_COMPETE}</li>'
            + '<li>Professional liability insurance with tail coverage</li>'
            + '<li>Dedicated Chief Wellness Officer and wellness programming for clinicians</li>'
            + '<li>Established, respected, financially stable company</li>'
            + '<li>Equitable scheduling patterns</li>'
            + '<li>Dedicated on-site and regional leadership support</li>'
            + '<li>Robust professional growth and leadership development opportunities</li>'
            + '</ul>';
        
        // ==== Why Choose SCP ====
        public static final String WHY_SCP_TEMPLATE =
            'For over 50 years, SCP Health has been serving patients in moments that matter. '
            + 'As a physician-founded and physician-led organization specializing in emergency, hospital, and critical care medicine, '
            + 'we believe clinicians should focus on what matters most—delivering exceptional patient care.<br/><br/>'
            + 'We support our physicians, nurse practitioners, and physician assistants with national capabilities, regional leadership support, '
            + 'and evidence-based practices. Our approach combines clinician autonomy with comprehensive administrative support, '
            + 'enabling work-life balance while practicing at the top of your license.<br/><br/>'
            + 'By supporting our clinicians in delivering exceptional care, we improve the health of our communities.<br/><br/>'
            + '<strong>Together, we heal.</strong>';
        
        // ==== Main Job Description Generator ====
        @AuraEnabled
        public static String generateJobDescription(Id recordId) {
            if (recordId == null) {
                throw new AuraHandledException('Record Id is required.');
            }
            
            Set<String> npPaJobs = new Set<String>{'Nurse Practitioner', 'Physician Assistant', 'Lead NP', 'Lead PA'};
            Set<String> physicianJobs = new Set<String>{'Staff Physician - MD', 'Travel Physician'};
            Set<String> serviceLines = new Set<String>{'ICPEM', 'ICPHM'};
            
            String finalDescription ='';
            
            try {
                List<bpats__Job__c> job = [SELECT Id,Service_Line2__c, bpats__Job_Description__c, bpats__Job_Title__c,City__c, State__c ,
                                        bpats__Type__c, Type_of_Job__c,Recruiter__c, Recruiter__r.Name, Recruiter__r.Email, Recruiter__r.Phone ,
                                        Facility_Name__r.Service_Line__r.Name ,Facility_Name__r.Patient_Encounters__c , Facility_Name__r.ED_Billable_Volume__c,
                                        Facility_Name__r.Trauma_Center_Designation__c, Admissions_Transfers__c, Fellowship_Residency__c, Moonlighting__c,
                                        Facility_Name__r.TeleHospitalist_Services_Active__c, Facility_Name__r.Licensure__c , Facility_Name__r.Board_Certification__c,
                                        Facility_Name__r.Procedures__c,Facility_Name__r.Service_LineLK__r.Name, Facility_Name__r.Facility_Profile__r.EMR_Name__c ,
                                        Compensation__c,Sign_On_Bonus__c, Facility_Name__r.About_Facility__c, Facility_Name__r.Innovation_Growth__c,
                                        Facility_Name__r.Name ,Facility_Name__r.Community_Comments__c ,Facility_Name__r.NP_PA_Hours_Per_Day__c, 
                                        Facility_Name__r.Teamwork_Culture__c, Facility_Name__r.Community_Information__c, Job_Status__c, Benefits_Eligibility__c,
                                        Scheduling__c, Malpractice_Coverage__c,No_Non_Compete__c,
                                        Facility_Name__r.Physician_Coverage_Hours_Per_Day__c , Facility_Name__r.Total_Beds__c, Facility_Name__r.Specialties__c,
                                        Facility_Name__r.ICU__c , Facility_Name__r.Education__c , Facility_Name__r.bpats__Total_Years_Of_Work_Experience__pc,
                                        Facility_Name__r.Skills_and_Procedures__c ,Facility_Name__r.Badges__c , Facility_Name__r.Facility_Services__c ,Facility_Name__r.Wellness_Support__c , Facility_Name__r.Leadership_Support__c
                                        FROM bpats__Job__c WHERE Id = :recordId
                                        ];
            
            if (job.isEmpty()) {
                throw new AuraHandledException('Invalid Job record.');
            }
            
                String coverageModel = '';
                String typeOfJob = job[0].Type_of_Job__c;
                String patientVolume ='';
                String iCPSite ='';
                
                /// if service line is "EM" then ED_Billable_Volume__c, if "HM" then Patient_Encounters__c
                if (String.isNotBlank(job[0].Service_Line2__c)) {
                    if (job[0].Service_Line2__c == 'EM' && job[0].Facility_Name__r != null && job[0].Facility_Name__r.ED_Billable_Volume__c != null) {
                        patientVolume = String.valueOf(job[0].Facility_Name__r.ED_Billable_Volume__c);
                    } else if (job[0].Service_Line2__c == 'HM' && job[0].Facility_Name__r != null && job[0].Facility_Name__r.Patient_Encounters__c != null) {
                        patientVolume = String.valueOf(job[0].Facility_Name__r.Patient_Encounters__c);
                    }
                }
                
                // Coverage Model logic
                if (npPaJobs.contains(typeOfJob)) {
                    coverageModel = (job[0].Facility_Name__r != null && job[0].Facility_Name__r.NP_PA_Hours_Per_Day__c != null) ? String.valueOf(job[0].Facility_Name__r.NP_PA_Hours_Per_Day__c) : null;
                } else if (physicianJobs.contains(typeOfJob)) {
                    coverageModel = (job[0].Facility_Name__r != null && job[0].Facility_Name__r.Physician_Coverage_Hours_Per_Day__c != null) ? String.valueOf(job[0].Facility_Name__r.Physician_Coverage_Hours_Per_Day__c) : null;
                }
                
                // ICP Site logic
                if (job[0].Facility_Name__r != null && job[0].Facility_Name__r.Service_LineLK__r != null && String.isNotBlank(job[0].Facility_Name__r.Service_LineLK__r.Name) && serviceLines.contains(job[0].Facility_Name__r.Service_LineLK__r.Name)) {
                    iCPSite = job[0].Facility_Name__r.Service_LineLK__r.Name;
                }
                
                Map<String, String> values = new Map<String, String>{
                    'SERVICE_LINE' => String.isNotBlank(job[0].Service_Line2__c) ? job[0].Service_Line2__c : EDIT_LABEL,
                    'POSITION_TITLE' => String.isNotBlank(job[0].bpats__Job_Title__c) ? job[0].bpats__Job_Title__c : EDIT_LABEL,
                    'LOCATION' => (
                        (String.isNotBlank(job[0].Facility_Name__r.Name) ? job[0].Facility_Name__r.Name : EDIT_LABEL + ' (Name)')
                        + ' , ' +
                        (String.isNotBlank(job[0].City__c)
                        ? job[0].City__c
                        : EDIT_LABEL + ' (City)'
                        )
                        + ' , ' +
                        (String.isNotBlank(job[0].State__c)
                        ? job[0].State__c
                        : EDIT_LABEL + ' (State)'
                        )
                        ),
                    'JOB_TYPE' => String.isNotBlank(job[0].bpats__Type__c) ? job[0].bpats__Type__c : EDIT_LABEL,
                    'RECRUITER' => job[0].Recruiter__c != null ? (String.isNotBlank(job[0].Recruiter__r.Name) ? job[0].Recruiter__r.Name : EDIT_LABEL + ' (Name)') + ' | ' + (String.isNotBlank(job[0].Recruiter__r.Email) ? job[0].Recruiter__r.Email : EDIT_LABEL + ' (Email)') + ' | ' + (String.isNotBlank(job[0].Recruiter__r.Phone) ? job[0].Recruiter__r.Phone : EDIT_LABEL + ' (Phone)') : EDIT_LABEL + ' (Name) | ' + EDIT_LABEL + ' (Email) | ' + EDIT_LABEL + ' (Phone)',

                    'PATIENT_VOLUME' => String.isNotBlank(patientVolume) ? patientVolume : EDIT_LABEL,
                    'SPECIALTIES' => String.isNotBlank(job[0].Facility_Name__r.Specialties__c) ? job[0].Facility_Name__r.Specialties__c : EDIT_LABEL,
                    'COVERAGE_MODEL' => String.isNotBlank(coverageModel) ? coverageModel : EDIT_LABEL,
                    'NUM_BEDS' => job[0].Facility_Name__r.Total_Beds__c != NULL ? job[0].Facility_Name__r.Total_Beds__c +'' : EDIT_LABEL,
                    'ACUITY' => job[0].Facility_Name__r.Trauma_Center_Designation__c != NULL ? job[0].Facility_Name__r.Trauma_Center_Designation__c +'' : EDIT_LABEL,
                    'EMR' => job[0].Facility_Name__r.Facility_Profile__r.EMR_Name__c != NULL ? job[0].Facility_Name__r.Facility_Profile__r.EMR_Name__c +'' : EDIT_LABEL,
                    'PROCEDURES' => job[0].Facility_Name__r.Procedures__c != NULL ? job[0].Facility_Name__r.Procedures__c +'' : EDIT_LABEL,
                    'ICU_STATUS' => String.isNotBlank(job[0].Facility_Name__r.ICU__c) ? job[0].Facility_Name__r.ICU__c : EDIT_LABEL,
                    'ADM_TRANSFER_RATES' => String.isNotBlank(job[0].Admissions_Transfers__c) ? job[0].Admissions_Transfers__c : EDIT_LABEL,
                    'FELLOWSHIP_INFO' => String.isNotBlank(job[0].Fellowship_Residency__c) ? job[0].Fellowship_Residency__c : EDIT_LABEL,
                    'MOONLIGHTING' => String.isNotBlank(job[0].Moonlighting__c) ? job[0].Moonlighting__c : EDIT_LABEL,
                    'ICP_SITE' => String.isNotBlank(iCPSite) ? iCPSite : EDIT_LABEL,
                    'TELE_COVERAGE' => job[0].Facility_Name__r.TeleHospitalist_Services_Active__c + '',
                    'EDUCATION' => String.isNotBlank(job[0].Facility_Name__r.Education__c) ? job[0].Facility_Name__r.Education__c : EDIT_LABEL,
                    'LICENSURE' => String.isNotBlank(job[0].Facility_Name__r.Licensure__c) ? job[0].Facility_Name__r.Licensure__c : EDIT_LABEL,
                    'BOARD_CERTIFICATION' => String.isNotBlank(job[0].Facility_Name__r.Board_Certification__c) ? job[0].Facility_Name__r.Board_Certification__c : EDIT_LABEL,
                    'EXPERIENCE' =>  job[0].Facility_Name__r.bpats__Total_Years_Of_Work_Experience__pc != NULL ? job[0].Facility_Name__r.bpats__Total_Years_Of_Work_Experience__pc +'' : EDIT_LABEL,
                    'SKILLS' => String.isNotBlank(job[0].Facility_Name__r.Skills_and_Procedures__c) ? job[0].Facility_Name__r.Skills_and_Procedures__c : EDIT_LABEL,
                    'BADGES' => String.isNotBlank(job[0].Facility_Name__r.Badges__c) ? job[0].Facility_Name__r.Badges__c : EDIT_LABEL,
                    'FACILITY_NAME' => String.isNotBlank(job[0].Facility_Name__r.Name) ? job[0].Facility_Name__r.Name : EDIT_LABEL,
                    'FACILITY_PARAGRAPH' =>  String.isNotBlank(job[0].Facility_Name__r.About_Facility__c) ? job[0].Facility_Name__r.About_Facility__c : EDIT_LABEL,
                    'INNOVATION_STATEMENT' => String.isNotBlank(job[0].Facility_Name__r.Innovation_Growth__c) ? job[0].Facility_Name__r.Innovation_Growth__c : EDIT_LABEL,
                    'TEAM_CULTURE_STATEMENT' => String.isNotBlank(job[0].Facility_Name__r.Teamwork_Culture__c) ? job[0].Facility_Name__r.Teamwork_Culture__c : EDIT_LABEL,
                    'SERVICES' => String.isNotBlank(job[0].Facility_Name__r.Facility_Services__c) ? job[0].Facility_Name__r.Facility_Services__c : EDIT_LABEL,
                    'COMMUNITY_INFORMATION' =>String.isNotBlank(job[0].Facility_Name__r.Community_Information__c) ? job[0].Facility_Name__r.Community_Information__c : EDIT_LABEL,
                    'COMPENSATION' =>  job[0].Compensation__c != NULL ? job[0].Compensation__c + '' : EDIT_LABEL,
                    'JOB_STATUS' => String.isNotBlank(job[0].Job_Status__c) ? job[0].Job_Status__c : EDIT_LABEL,
                    'SIGN_ON_BONUS' => job[0].Sign_On_Bonus__c != NULL ? job[0].Sign_On_Bonus__c + '' : EDIT_LABEL,
                    'BENEFITS_ELIGIBILITY' => String.isNotBlank(job[0].Benefits_Eligibility__c) ? job[0].Benefits_Eligibility__c : EDIT_LABEL,
                    'MALPRACTICE_COVERAGE' =>String.isNotBlank(job[0].Malpractice_Coverage__c) ? job[0].Malpractice_Coverage__c : EDIT_LABEL,
                    'WELLNESS_SUPPORT' => String.isNotBlank(job[0].Facility_Name__r.Wellness_Support__c) ? job[0].Facility_Name__r.Wellness_Support__c : EDIT_LABEL,
                    'SCHEDULING' => String.isNotBlank(job[0].Scheduling__c) ? job[0].Scheduling__c : EDIT_LABEL,
                    'LEADERSHIP_SUPPORT' => String.isNotBlank(job[0].Facility_Name__r.Leadership_Support__c) ? job[0].Facility_Name__r.Leadership_Support__c : EDIT_LABEL,
                    'NON_COMPETE' => String.isNotBlank(job[0].No_Non_Compete__c) ? job[0].No_Non_Compete__c : EDIT_LABEL
                };
                
                
                finalDescription =
                    applyTemplate(HEADER_TEMPLATE, values) +
                    '<br/><strong>Position Overview</strong><br/>' +
                    applyTemplate(POSITION_OVERVIEW_TEMPLATE, values) +
                    '<br/><strong>Qualifications</strong><br/>' +
                    applyTemplate(QUALIFICATIONS_TEMPLATE, values) +
                    '<br/><strong>Facility & Clinical Details</strong><br/>' +
                    applyTemplate(FACILITY_TEMPLATE, values) +
                    '<br/><strong>Community Information</strong><br/>' +
                    applyTemplate(COMMUNITY_TEMPLATE, values) +
                    '<br/><br/><strong>Benefits & Compensation</strong><br/>' +
                    applyTemplate(BENEFITS_TEMPLATE, values) +
                    '<br/><strong>Why SCP Health</strong><br/>' +
                WHY_SCP_TEMPLATE;
            
            // Update the Job Description field
            bpats__Job__c jobToUpdate = new bpats__Job__c(
                Id = recordId,
            bpats__Job_Description__c = finalDescription
                );
            update jobToUpdate;
            } catch (Exception e) {
                System.debug('ERROR'+ e.getMessage());
                System.debug('getLineNumber'+ e.getLineNumber());
                throw new AuraHandledException('ERROR'+ e.getMessage());
            }
            return finalDescription;
        }
        
        private static String applyTemplate(String template, Map<String, String> values) {
            for (String key : values.keySet()) {
                String value = '<span>' + values.get(key) + '</span>';
                if(values.get(key).contains(EDIT_LABEL)){
                    value =  value = value.replaceAll(EDIT_LABEL, '<span style="color: rgb(253, 6, 6);">' + EDIT_LABEL + '</span>');
                }
                
            template = template.replace('{' + key + '}', value);
        }
        return template;
    }
}