public with sharing class CMNFormTemplateController 
{
    public Job__c Job{get;set;}
    public Map<string, string> SpecsMap{get;set;}
    public String jobId{get;set;}
    public String D,N;
    public CMNFormTemplateController(ApexPages.StandardController controller) 
    {
       jobId = ApexPages.currentPage().getParameters().get('jobid');
       Job = [select id, JS_Client__r.Client_Code__c,JS_Client__r.Name ,JS_Client__r.Billing_City__c , JS_Client__r.Billing_Postal_Code__c,JS_Client__r.Billing_Street__c , JS_Client__r.Billing_State__c, JS_Client__r.Phone__c, (select id, Name, Description__c,Creative_Brief_Template__c   from Job_Specs__r) from Job__c where id=:jobId];
       SpecsMap =new Map<string, string>();
       for(Job_Spec__c spec : Job.Job_Specs__r)       {
           
           if(spec.Description__c == 'Enter Spec Description here'){     D = '';   N = spec.Creative_Brief_Template__c + ' ' + spec.name;
               system.debug('>>>>>>>>>>>>>>>>>>>>'+ N);
           }
           else {       D = spec.Description__c;   N = spec.Creative_Brief_Template__c + ' ' + spec.name;
                system.debug('>>>>>>>>>>>>>>>>>>>>'+ N);
           }  SpecsMap.put(N, D);
       }
       
      
      
    }
   
}