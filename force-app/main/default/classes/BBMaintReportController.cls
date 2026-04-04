public with sharing class BBMaintReportController {

    Public Transient list<Job__c> joblist{get;set;}
    public Transient List<JobWrapper>  JW;
    public Transient List<ClienDistrictWrapper>  CDWrapper{get;set;}
    public Transient List<ClientNameWrapper> CNW;
    public Transient  ClienDistrictWrapper tmpCDWrapper;
    public Transient  ClientNameWrapper tmpCNW;
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
     
    
    Public BBMaintReportController (){
         
         // Code to display Subsriber Organization Logo
          
          // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
         
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

        // End of code to display Subscriber Organization Logo
    
         CDWrapper = new List<ClienDistrictWrapper>();
         JW= new List<JobWrapper>();
         CNW= new List<ClientNameWrapper>();

          joblist=[select id,name,(select id,name,Description__c ,Job__c from Job_Specs__r),Creative_Overview__c,JS_Client__c,Due_Date__c,Status_Notes__c,Status__c,JS_Client__r.name,JS_Client__r.Client_Code__c,JS_Client__r.Dummy_Picklist_1__c,Schedule_Template__r.name,Schedule_Template__c from Job__c where Schedule_Template__r.name='Billboard Repair' and JS_Client__r.Dummy_Picklist_1__c !=null and Status__c=:'Active'  order by  JS_Client__r.Dummy_Picklist_1__c DESC,JS_Client__r.Client_Code__c,JS_Client__r.name,name ];
          Set<string> JobIds = new Set<string>();
          
          for(Job__c aa : joblist)
          {
          system.debug('JObName first'+aa.Name);
          
          if(aa.Job_Specs__r.size()>0){
              JobIds.add(aa.id);
          }  
          
        }
        //get the list of job Spec  for every job;
        List<Job_Spec__c > jSpec = [select id,Name,Description__c ,Job__c,Job__r.name from Job_Spec__c where Job__c =: JobIds ];   
         
         Map <Id, List <Job_Spec__c >> mapJSpec = new Map<Id, List <Job_Spec__c >>();
         
         
         
           //get the job Spec for the job
         
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
           string strClientDistNew;
           string strClientNameNew;
           string strClientCodeNew;
           
          for(Job__c aa:joblist)
         {
             
           if (strClientDistNew!= aa.JS_Client__r.Dummy_Picklist_1__c )
            {
           
               
                if (strClientDistNew != null)
               {       
                    tmpCNW.jWrapper= JW;
                    CNW.add(tmpCNW);
                    tmpCDWrapper.CNWrapper= CNW;
                    CDWrapper.add(tmpCDWrapper);
                    system.debug('cWrapper :::::::::'+CDWrapper);                                                                      
                }
                
               tmpCNW= new ClientNameWrapper();     
               tmpCDWrapper= new ClienDistrictWrapper();     
                    
                
                tmpCDWrapper.strClientDist = strClientDistNew = aa.JS_Client__r.Dummy_Picklist_1__c ;
                tmpCNW.strClientName = strClientNameNew = aa.JS_Client__r.Name;
                tmpCNW.strClientCode = strClientCodeNew= aa.JS_Client__r.Client_Code__c;
                
                CNW= new List<ClientNameWrapper>();
                JW = new List<JobWrapper>();
                
            }   
           else{
              
                  if (strClientNameNew != aa.JS_Client__r.Name) 
                      { 
                        if(JW.size() > 0 && JW.size() !=null)
                        {     
                              
                               tmpCNW.jWrapper= JW;
                               CNW.add(tmpCNW);
                               tmpCNW= new ClientNameWrapper();
                               
                               tmpCNW.strClientName = strClientNameNew = aa.JS_Client__r.Name;
                               tmpCNW.strClientCode = strClientCodeNew= aa.JS_Client__r.Client_Code__c;
                               strClientDistNew = aa.JS_Client__r.Dummy_Picklist_1__c; 
                                 
                             }                  
                             JW = new List<JobWrapper>();                       
                        } 
                    }
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;              
            
            objWrapper.jobSpecs= mapJSpec.get(aa.id);
            
            
            JW.add(objWrapper); 
        }
       if (strClientDistNew != null){
        
                    tmpCNW.jWrapper= JW;
                    CNW.add(tmpCNW);
                    tmpCDWrapper.CNWrapper= CNW;
                    CDWrapper.add(tmpCDWrapper);
                    
           
       }

     }

    public class ClienDistrictWrapper
    {
       public List<ClientNameWrapper> CNWrapper{get;set;}
       public string strClientDist {get;set;} 
        public ClienDistrictWrapper()
        {
          if(CNWrapper== NULL) {CNWrapper= new List<ClientNameWrapper>();}
        }
     }
    
     public class ClientNameWrapper    
       { 
            public string strClientName {get;set;}
            public string strClientCode {get;set;}
            public List<JobWrapper> jWrapper{get;set;}
            public ClientNameWrapper()
            {
                if(jWrapper== NULL) {jWrapper= new List<JobWrapper>();}
            }  
        }

     public class JobWrapper
        {              
           public Job__c job {get;set;}
           
           public List<Job_Spec__c > jobSpecs{get;set;}
           public JobWrapper()
            {
                 
            }
        }



}