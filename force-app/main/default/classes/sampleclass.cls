public class sampleclass {
    
    @AuraEnabled
    public static Job__c returjobrcd(){
        Job__c jrcd=[select Id,name,Job_Auto_Number__c, CreatedDate from Job__c order by createddate desc limit 1];
        return jrcd;
    }
    
    @auraEnabled
    public static List<Account> findRecords(){
        List<Account> returnList=new List<Account>();
        returnList=[select id,name,type,industry from Account order by LastModifiedDate DESC Limit 10];
        return returnList;
    }
    
    @future(callout=true)
    public static void makeacallout(string name){
        system.debug('called future');
        httprequest req = new httprequest();
        req.setendpoint('https://salesforcetest.requestcatcher.com/test');
        req.setBody(JSON.serialize(name));
        req.setMethod('GET');
        Http http = new Http();
        
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
    }
    
    
    @AuraEnabled
    public static List<Contact> getContacts(String searchKeyword) {
        String searchQuery = '%' + String.escapeSingleQuotes(searchKeyword) + '%';
        system.debug('search query  branch changed in remote github changed 3');
        system.debug('local changes');
        return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName LIKE :searchQuery LIMIT 10];
    }
}