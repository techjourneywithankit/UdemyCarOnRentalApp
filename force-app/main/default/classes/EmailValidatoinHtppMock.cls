@isTest
public with sharing class EmailValidatoinHtppMock implements HttpCalloutMock{
    
    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        String json=		'{'+
		'  "email_deliverability": {'+
		'    "status": "deliverable",'+
		'    "status_detail": "valid_email"'+
		'   }'+
		'}';
        res.setBody(json);
        return res;
    }
}