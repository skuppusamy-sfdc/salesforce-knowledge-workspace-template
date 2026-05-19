public class CalculateNPPARates {
    
    /**
     * @description The wrapper class for the input parameter of the invocable method.
     * It holds the List Of PCAs.
     */
    public class InvocableInput {
        @InvocableVariable(label='List Of PCA to process' required=true)
        public List<PreventiveCareAgreement> PCAListToProcess;
        @InvocableVariable(label='NPPATier')
        public String NPPATier;
        @InvocableVariable(label='TimeType')
        public String TimeType;
        
    }
    
    /**
     * @description The wrapper class for the output response of the invocable method.
     * It holds values to update back in the flow
     */
    public class InvocableOutput {
        @InvocableVariable(label='FullTimeWeeklyBlended')
        public Decimal FullTimeWeeklyBlended;
        @InvocableVariable(label='FullTimeMonthlyBlendedRate')
        public Decimal FullTimeMonthlyBlendedRate;
        @InvocableVariable(label='FullTimeOverageRate')
        public Decimal FullTimeOverageRate;
        @InvocableVariable(label='AvgHourlyrate')
        public Decimal AvgHourlyrate;
    }
    
    /**
     * @description:  Main invocable method that retrieves list of PCAs and Calculates Rates.
    */
    @InvocableMethod(label='Get List Of PCAs' description = 'Fetch the List of PCAs')
    public static  List<InvocableOutput> getCalculatedRates(List<InvocableInput> inputs) {
        List<InvocableOutput> outputList = new List<InvocableOutput>();
            
            
        try {
            Map<Id, List<PreventiveCareAgreement>>MapOfHPFIdToPCA = new Map<Id, List<PreventiveCareAgreement>> ();
            Map<String, Decimal> MapOfCountAndSumOfRates = new Map <String, Decimal>();
            
            
            List <PreventiveCareAgreement> pcaList = [Select id, ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c, Rate__c 
                                                      FROM PreventiveCareAgreement Where ID IN: inputs[0].PCAListToProcess
                                                     AND ContractPaymentAgreement.Provider_Network_Contract__r.Deleted__c = false ];
            
            // NPPATier can be null (only for Part Time Time Type), so a default value of 1 is assigned.
            // This prevents exceptions due to division by null or zero during calculations.
            // In this case, only the EE NP/PA Hourly Blended calculation is performed (PR1050558-4667). 
            Decimal NPPATier = (inputs != null && !inputs.isEmpty() && inputs[0].NPPATier != null) ? Decimal.valueOf(inputs[0].NPPATier) : 1; 
            String TimeType = (inputs != null && !inputs.isEmpty() && inputs[0].TimeType != null) ? inputs[0].TimeType : '';
            Decimal totalSalarySum = 0;
            
            
            for (PreventiveCareAgreement pca: pcaList) {
                if (String.isNotBlank(pca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c)) {
                    if (MapOfHPFIdToPCA.containskey(pca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c)) {
                        List <PreventiveCareAgreement> pcaToAdd = MapOfHPFIdToPCA.get(pca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c);
                        pcaToAdd.add(pca);
                        MapOfHPFIdToPCA.put(pca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c, pcaToAdd);
                    } else {
                        MapOfHPFIdToPCA.put(pca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c, new List<PreventiveCareAgreement>{pca});
                    }
                }
                
            }
            
            for (String HPFId: MapOfHPFIdToPCA.keySet()) {
                List<PreventiveCareAgreement> pcaListForEachHpf = MapOfHPFIdToPCA.get(HPFId);
                Decimal Rate = 0;
                for (PreventiveCareAgreement pca : pcaListForEachHpf) {
                    Rate = Rate + pca.Rate__c;
                }
                MapOfCountAndSumOfRates.put(HPFId+'-'+pcaListForEachHpf.size(), Rate );
            }
            
            // Modifying the Map to store the avg of Rate now
            
            for (String key : MapOfCountAndSumOfRates.KeySet()) {
                Integer count = Integer.valueOf(key.split('-')[1]);
                Decimal avg = MapOfCountAndSumOfRates.get(key) / count;
                MapOfCountAndSumOfRates.put(key, avg);
            }
            
            Decimal sumAllFacility = 0;
            // Modifying the Map to multiply the avg* NPPATier
            for (String key : MapOfCountAndSumOfRates.KeySet()) {
                sumAllFacility = MapOfCountAndSumOfRates.get(key) + sumAllFacility ;
                    
                Decimal avgWithNPPATier = MapOfCountAndSumOfRates.get(key) * NPPATier;
                totalSalarySum = avgWithNPPATier + totalSalarySum;
                MapOfCountAndSumOfRates.put(key, avgWithNPPATier);
            }
            
            Decimal avgAllFacility = (sumAllFacility / MapOfCountAndSumOfRates.size()).setScale(2);
            Decimal avgSalary = (totalSalarySum / MapOfCountAndSumOfRates.size()).setScale(2);
            Decimal avgHourlyRate = (avgSalary / NPPATier).setScale(2);
            Decimal baseRate = avgHourlyRate + 2;
            Decimal NPPATierFactor = ((NPPATier * 12) / 52).setScale(2);
			Decimal fullTimeWeekly = (avgHourlyRate * NPPATierFactor).setScale(2);
            //Decimal fullTimeWeekly = avgHourlyRate * 40;
            Decimal fullTimeMonthly = avgHourlyRate * NPPATier;
            
            InvocableOutput invOutPut = new InvocableOutput();            
            invOutPut.FullTimeWeeklyBlended = fullTimeWeekly;
            invOutPut.FullTimeMonthlyBlendedRate = fullTimeMonthly;
            invOutPut.FullTimeOverageRate = baseRate;
            
            If(TimeType == 'Part Time'){
                invOutPut.AvgHourlyrate = avgAllFacility;
            }else{
                invOutPut.AvgHourlyrate = avgHourlyRate;
            }
            
            
            /*The output list should have the same size as the input list because Salesforce Flow processes items one-to-one. 
             * Each input record must have a corresponding output record for the flow to work correctly.*/
            for (integer inputInd = 0 ;inputInd < inputs.size() ;inputInd ++) {
                outputList.add(invOutPut);
            }
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception======>'+e.getLinenumber()+e.getMessage());
        }
        return outputList;
    }

}