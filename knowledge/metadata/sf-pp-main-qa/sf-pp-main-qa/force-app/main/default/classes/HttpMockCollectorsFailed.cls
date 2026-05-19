@IsTest
global class HttpMockCollectorsFailed implements HttpCalloutMock{

    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('GET',request.getMethod());
        System.assertEquals('https://api-releases.primary-intel.com/rest/clients/93458u934058u93458u90/collectors',request.getEndpoint());
        HttpResponse response=new HttpResponse();
        response.setStatusCode(400);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('body');
        return response;
    }
}