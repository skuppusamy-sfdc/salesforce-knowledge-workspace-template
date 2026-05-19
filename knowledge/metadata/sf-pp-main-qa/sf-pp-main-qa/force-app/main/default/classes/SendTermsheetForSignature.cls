global class SendTermsheetForSignature implements Callable {
    
    public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');
        
        if (action == 'sendTermSheet') {
            String contractId = String.valueOf(input.get('contractId'));
            String endpoint = String.valueOf(input.get('endpoint'));
            String body = String.valueOf(input.get('requestBody'));
            output.put('result', sendDocument(contractId,endpoint,body));
        }

        return true;
    }
    
    private Map<String,Object> sendDocument(String contractId,String endpoint,String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String orgDomain = Url.getOrgDomainUrl().toString();
        request.setEndpoint(orgDomain + endpoint); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        
        // Include the Session ID for authentication
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        
        Map<String,Object> result = new Map<String,Object>();
        try {
            HttpResponse response = http.send(request);
            result.put('statusCode',response.getStatusCode());
            result.put('responseBody',JSON.deserializeUnTyped(response.getBody()));
        } catch (System.CalloutException e) {
            result.put('errorMessage',e.getMessage());
        }
        return result;
    }
    
}