public with sharing class NewStoreOutdoorReportController {

   Public Transient list<Job__c> joblist{get;set;}
  
   
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    
    public Transient   Map <string, List<Job__c>> mapJClient {get;set;}
     public Transient  Map <string,string> mapJClientName {get;set;}
    public Transient  Map <id, List <Job_Spec__c >> mapJSpec {get;set;}
    
    Public NewStoreOutdoorReportController  (){
    
    
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }

     
          joblist=[select id,name,Job_Auto_Number__c,(select id,name,Description__c ,Job__c from Job_Specs__r),Creative_Overview__c,JS_Client__c,Due_Date__c,Status_Notes__c,Status__c,JS_Client__r.name,JS_Client__r.Client_Code__c,JS_Client__r.Dummy_Picklist_1__c,Schedule_Template__r.name,Schedule_Template__c from Job__c where Schedule_Template__r.name='New Store Billboards' and JS_Client__r.name!=null and Status__c='Active'  order by  JS_Client__r.Name ASC,Job_Auto_Number__c];
        
          Set<id> JobIds = new Set<Id>();
          mapJClient=new Map<string,List<Job__c>>();
          mapJClientName=new Map<String,String>();
          
          for(Job__c aa : joblist)
          {
          
          if(aa.Job_Specs__r.size()>0){
            string clientName;
              JobIds.add(aa.id);
              
              if(mapJClient.containsKey(aa.JS_Client__r.name.toUpperCase())){
               list<Job__c> jobids1=mapJClient.get(aa.JS_Client__r.name.toUpperCase());
                jobids1.add(aa);
                mapJClient.put(aa.JS_Client__r.name.toUpperCase(),jobids1);
                
              }
               else{
               mapJClient.put(aa.JS_Client__r.name.toUpperCase(),new List<Job__c>{aa});
               mapJClientName.put(aa.JS_Client__r.name.toUpperCase(),aa.JS_Client__r.name);
               }
          }  
          
        }
       
        
       
        
        
     
        List<Job_Spec__c > jSpec = [select id,Name,Description__c ,Job__c,Job__r.name from Job_Spec__c where Job__c =: JobIds ];   
        
       mapJSpec  = new Map<Id, List <Job_Spec__c >>();
         
       
           for(Job_Spec__c  js:jSpec)
            {
              if(mapJSpec.containsKey(js.Job__r.id))
               {
                  List <Job_Spec__c > jSpeclist =  mapJSpec.get(js.Job__r.id);
                  jSpeclist .add(js);
                  mapJSpec.put(js.Job__r.id,jSpeclist );  
                }
                else
                {
                  mapJSpec.put(js.Job__r.id , new List<Job_Spec__c >{js}) ;
                }        
           
           }
   }
}