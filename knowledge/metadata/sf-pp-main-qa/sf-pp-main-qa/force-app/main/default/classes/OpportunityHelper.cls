/******************************************************************************
 * Name: OpportunityHelper
 * Description: Helper class for objects and other things on the opportunity object
 *
 *
 * Change Log
 * Item #   Date        Author          Description
 *    1     12/28/2016  Ben Logan       Created
 ******************************************************************************/
Global with sharing class OpportunityHelper {
    
    //*********************************************************************************
    //Use the method below to define the rules of how the document types should be handled
    //*********************************************************************************
    public static Map<String, list<RequiredDocumentAttributes>> StagingRulesMap()
    {
        Map<String, list<RequiredDocumentAttributes>> RulesMap = new Map<String, List<RequiredDocumentAttributes>>();
        
        //blank rule
        RequiredDocumentAttributes Blank = 
        new RequiredDocumentAttributes
        ('',False);
        
        RequiredDocumentAttributes MoviePlanWorksheet = 
        new RequiredDocumentAttributes
        ('Movie Plan Worksheet',False);
        
        RequiredDocumentAttributes ClientNeedsAssessment = 
        new RequiredDocumentAttributes
        ('Client Needs Assessment',False);
        
        RequiredDocumentAttributes ProForma_Final = 
        new RequiredDocumentAttributes
        ('Pro Forma',True);
        
        RequiredDocumentAttributes Proposal_Final = 
        new RequiredDocumentAttributes
        ('Proposal',True);
        
        RequiredDocumentAttributes MOU_Final = 
        new RequiredDocumentAttributes
        ('MOU',True);
        
        RequiredDocumentAttributes Contract_Final =
        new RequiredDocumentAttributes
        ('Contract',True);

        RequiredDocumentAttributes ProForma_At_Contract_Signature =
        new RequiredDocumentAttributes
        ('Proforma at Contract Signature',True);
                                                                                  
        
        //Stage = Marketing Qualified Lead
        RulesMap.put('Marketing Qualified Lead',null);
        
        //Stage = Sales Qualified Opportunity
        RulesMap.put('Sales Qualified Opportunity',null);
        
        //Stage = Proposal Request
        RulesMap.put('Proposal Request', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet
                                            });
        
        //Stage = Proposal Development
        RulesMap.put('Proposal Development', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment
                                            });
        
        //Stage = Proposal Presented
        RulesMap.put('Proposal Presented', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment,
                                            ProForma_Final,
                                            Proposal_Final
                                            });

        
        //Stage = Down Select
        RulesMap.put('Down Select', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment,
                                            ProForma_Final,
                                            Proposal_Final
                                            });
        
        //Stage = Verbal Award
        RulesMap.put('Verbal Award', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment,
                                            ProForma_Final,
                                            Proposal_Final
                                            });
        
        //Stage = MOU Signed
        RulesMap.put('MOU Signed', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment,
                                            ProForma_Final,
                                            Proposal_Final,
                                            MOU_Final
                                            });
       
        
        //Stage = Contract Signed
        RulesMap.put('Contract Signed', 
        new list<RequiredDocumentAttributes>{
                                            MoviePlanWorksheet,
                                            ClientNeedsAssessment,
                                            ProForma_Final,
                                            Proposal_Final,
                                            MOU_Final,
                                            Contract_Final,
                                            ProForma_At_Contract_Signature
                                            });
        
        return RulesMap;
    
    }
    
    //****************************************************************************************
    //Object to handle how the rules are handled. Add properties to this with caution.
    //****************************************************************************************
    Global class RequiredDocumentAttributes
    {
     Public String  DocumentType {get; set;} 
     Public Boolean Finalized    {get; set;} 
     
     Public RequiredDocumentAttributes(String DocumentType, Boolean Finalized)
     {
        this.DocumentType = DocumentType;
        this.Finalized = Finalized;
     }
    }

}