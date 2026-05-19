@isTest
global class HttpMockCollectors implements HttpCalloutMock{
    private String body;

    public HttpMockCollectors(String body){
        this.body = body;
    }
    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('GET',request.getMethod());
        System.assertEquals('https://api-releases.primary-intel.com/rest/clients/93458u934058u93458u90/collectors',request.getEndpoint());
        HttpResponse response=new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(body);
        return response;
    }
}