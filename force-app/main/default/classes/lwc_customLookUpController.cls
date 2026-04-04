public with sharing class lwc_customLookUpController {
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm,string objname,string mediaid) {
        system.debug('search term === '+searchTerm);
        system.debug('objectapiname === '+objname);
        system.debug('mediaid === '+mediaid);
        List <sObject> returnList = new List <SObject> ();
        if(string.isNotEmpty(searchTerm)){
            DescribeSObjectResult describeResult =Schema.getGlobalDescribe().get(objname).getDescribe();
            string searchword = searchTerm + '%';
            String sQuery =' SELECT Id,Name FROM ' + describeResult.getName() +' where Name LIKE: searchword ';
            returnList = Database.query(sQuery);
            System.debug('======SOquey of Media Type========'+sQuery);
        }
        return returnList;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Schedule_Template__c> getschtemprcd(string searchTerm,string mediaid) {
        string searchword = searchTerm + '%';
        list<Schedule_Template__c>schrcd = [select id,name,Media_Types__c from Schedule_Template__c where name like:searchword and Media_Types__c =: mediaid];
        return schrcd;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Client_Contact__c> getclientcntrcd(string searchTerm,string clientid) {
        string searchword = searchTerm + '%';
        list<Client_Contact__c>clientcntrcd = [select id,name,Client__c from Client_Contact__c  where name like:searchword and Client__c =: clientid];
        return clientcntrcd;
    }
    
    /* old blog method 
@AuraEnabled(cacheable=true)
public static List<sObject> search(String searchTerm, string myObject, String filter) {
system.debug('search term === '+searchTerm);
system.debug('myObject === '+myObject);
system.debug('filter === '+filter);

String myQuery = null;
if(filter != null && filter != ''){
myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
}
else {
if(searchTerm == null || searchTerm == ''){
}
else {
myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
}
}
List<sObject> lookUpList = database.query(myQuery);
return lookUpList;
}*/
}