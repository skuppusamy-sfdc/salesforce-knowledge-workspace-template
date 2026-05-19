@isTest
public class SendTermsheetForSignatureTest {
    
    @isTest
    public static void testSendTermSheet(){
        Test.setMock(HttpCalloutMock.class, new SendCalloutMock(201, 'null'));
        
        Map<String,Object> args = new Map<String,Object>();
        Map<String, Object> input = new Map<String, Object>{
           'contractId' => '1',
           'endpoint'  => 'endpoint',
           'requestBody' => 'requestBody'    
        }; 
        
        args.put('input',input);
        Map<String, Object> output = new Map<String, Object>(); args.put('output',output);
        Map<String, Object> options = new Map<String, Object>(); args.put('options',options);
        
        Test.startTest();
        SendTermsheetForSignature sts = new SendTermsheetForSignature();
        sts.call('sendTermSheet', args);
        Test.stopTest();
        
        System.assert(output.containsKey('result'));
    }
    
    public class SendCalloutMock implements HttpCalloutMock {
        private Integer statusCode = 201;
        private String body = '{"success": true}';
        
        public SendCalloutMock(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            
            response.setStatusCode(this.statusCode);
            response.setBody(this.body);
            
            return response;
        }
    }
    
}