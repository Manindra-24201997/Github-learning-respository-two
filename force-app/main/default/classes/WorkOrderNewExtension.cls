public with sharing class WorkOrderNewExtension {

   // Global variables  
    public DateTime today{get;set;}
    String jobid;
    public List<Job_Team__c> JobTeam{get;set;} 
    public List<Job_Task__c> JobTask{get;set;} 
    public List<Job_Spec__c> CreativeBrief{get;set;}
    Public List<Production_Estimate__c> ProdEstMaterialitems{get;set;}
    public List<Shipment__c> Shipment{get;set;}
    
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public List<Document> lstDoc;
    public boolean imageNotFound{get;set;}
    public map<string,list<Job_Spec__c>> MapCB{get;set;}
    public map<string,list<Production_Estimate__c>> MapPE{get;set;}
  
    // End Global variables

      // Start Constructor
    public WorkOrderNewExtension (ApexPages.StandardController controller) 
    {
         // To display Subscriber Organization Logo
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
            
       jobid = ApexPages.currentpage().getParameters().get('id');
       JobTeam = [select id,Name,Role__c,Staff__c from Job_Team__c where Job__c =: jobid];
       CreativeBrief = [select id,Name,Description__c,Creative_Brief_Template__c from Job_Spec__c where Job__c =: jobid order By Sort_Order__c];
       JobTask = [select id,Name,Due_Date__c,Start_Date__c,Revised_Due_Date__c,Task_Order__c,Marked_Done__c,Assigned_Users__c from Job_Task__c where Job__c =: jobid Order By Task_Order__c];
       ProdEstMaterialitems=[select id,name,PE_Template__c,Material_Item__c ,Material_Item__r.Calc_Unit__c, Quantity__c,Length_in_Inches__c,Width_in_Inches__c,Material_Item__r.name  from Production_Estimate__c where Job__c =: jobid order By Sort_Order__c];
       Shipment=[select id,name,Shipment_Phone__c,TO_ATTN__c,Shipment_Street_Address__c,Shipment_Address_2__c,Shipment_City__c,Shipment_State__c,Shipment_Zip_code__c from Shipment__c where Job__c =: jobid];
       
       
         MapCB = new map<string,list<Job_Spec__c>>();
         
         for(Job_Spec__c JS:CreativeBrief)
         {
               if(MapCB.containsKey(js.Creative_Brief_Template__c))
               {
                  List <Job_Spec__c > jSpeclist =  MapCB.get(js.Creative_Brief_Template__c);
                  jSpeclist.add(js);
                  MapCB.put(js.Creative_Brief_Template__c,jSpeclist );  
                }
                else
                {
                  MapCB.put(js.Creative_Brief_Template__c, new List<Job_Spec__c >{js}) ;
                }   
         
         }
         
         
          MapPE = new map<string,list<Production_Estimate__c>>();
         
         for(Production_Estimate__c JS:ProdEstMaterialitems)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                  PElist.add(js);
                  MapPE.put(js.PE_Template__c,PElist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                }   
         
         }
       
       
       
       
       today=System.NOW();
    }
    // End Constructor 
    /*
         <tr><td style="width:50%">
          <apex:image value="{!$Resource.WorkorderQClogo}"/>
        </td>
        </tr>*/

}