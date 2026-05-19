global class CheckRatesForServiceAccFacility implements Callable {
	 public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');
        return invokeMethod(action, input, output, options);
    }
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs,
        Map<String, Object> output, Map<String, Object> options) {
        if(methodName == 'ValidateRate') {
            output.put('rateValidated', validateRate(inputs));
        }
        return true;
    }
    
     public Boolean validateRate(Map<String,Object> input) {
        
        //Output Value
        Boolean Validated = false;
        //Input Value
        String contractId = String.valueOf(input.get('ContextId'));
        Decimal rate = Decimal.valueOf(String.valueOf(input.get('Rate')));
        String unitOfMeasure = String.valueOf(input.get('UnitOfMeasure'));
        
        List<String> facilityTitleIds = new List<String>();
		Object rawFacilityObj = input.get('ListOfFacilityTitleIds');

        if (rawFacilityObj instanceof List<Object>) {
            for (Object obj : (List<Object>) rawFacilityObj) {
                if (obj instanceof Map<String, Object>) {
                    facilityTitleIds.add(String.valueOf(((Map<String, Object>) obj).get('value')));
                }
            }
        }
        
        Set<String> shiftCodes = new Set<String>();
        Object rawShiftObj = input.get('shifts');
        if (rawShiftObj instanceof List<Object>) {
            for (Object obj : (List<Object>) rawShiftObj) {
                if (obj instanceof Map<String, Object>) {
                    shiftCodes.add(String.valueOf(((Map<String, Object>) obj).get('ShiftCode')));
                }
            }
        }
   		AggregateResult[] aggResult;
   		if (!facilityTitleIds.isEmpty() && !shiftCodes.isEmpty()) {
			try {
                aggResult = [
                    SELECT MAX(Rate__c) maxRate,
                           MIN(Rate__c) minRate,
                    	   FacilityTitle__c,
                    	   Shift__r.Shift_Name__r.Code
                    FROM PreventiveCareAgreement
                    WHERE FacilityTitle__c IN :facilityTitleIds
                    AND Shift__r.Shift_Name__r.Code IN :shiftcodes
                    AND ContractPaymentAgreement.Type__c = 'Shift'
                    AND ContractPaymentAgreement.ContractId = :contractId
                    GROUP BY FacilityTitle__c,Shift__r.Shift_Name__r.Code
                ];
            } catch (QueryException qe) {
                return false;
            }
        
    	}
        Integer expectedCombinations = facilityTitleIds.size() * shiftcodes.size();
         // Check if every combination has a record
    	if (aggResult.size() != expectedCombinations) {
            return false;
   		}
         
        for (AggregateResult ar : aggResult) {
            Decimal maxRate = (Decimal) ar.get('maxRate');
            Decimal minRate = (Decimal) ar.get('minRate');
            // If entered rate doesn’t match the existing range for any combination
            if (maxRate != minRate || maxRate != rate) {
                validated = false;
                break;
            } else {
                validated = true;
            }
        }
         return validated;
     }   
}