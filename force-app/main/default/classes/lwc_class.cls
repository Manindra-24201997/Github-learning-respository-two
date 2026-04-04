public with sharing class lwc_class {
    
    @AuraEnabled(cacheable=true)
    public static list<Opportunity> retriveOpportunities() {
        return [SELECT Id, Name, Account.Name, Account.owner.name FROM Opportunity LIMIT 10];
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Job__c>getrecords(string Searchname){
        string value = '%'+Searchname+'%';
        system.debug('value === '+value);
        list<Job__c>jobrcd = [select id,Name,Status__c, JS_Client__c, JS_Client__r.Name from Job__c where Name like:value limit 11];
        return jobrcd;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Job__c>getrecordsbasedonparam(string Searchname){
        string searchword = '%'+Searchname+'%';
        system.debug('searchword === '+searchword);
        list<Job__c>jobrcd = [select id,Name,Status__c, JS_Client__c, JS_Client__r.Name from Job__c where Name like:searchword  limit 11];
        system.debug('jobrcd === '+jobrcd);
        return jobrcd;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Job__c>getrecordsbasedonparamsforevent(string Searchname,boolean recalc){
        string searchword = '%'+Searchname+'%';
        system.debug('searchword === '+searchword+'recalc === '+recalc);
        list<Job__c>jobrcd = [select id,Name,Status__c, JS_Client__c, JS_Client__r.Name,Job_Auto_Number__c,UpdateSchedDateFieldCheck__c from Job__c 
                              where Name like:searchword and UpdateSchedDateFieldCheck__c=:recalc  limit 11];
        system.debug('jobrcd === '+jobrcd);
        return jobrcd;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<account>getAccList(){
        list<account>acc = [select id,name,Phone from account limit 10];
        return acc;
    }
    
}