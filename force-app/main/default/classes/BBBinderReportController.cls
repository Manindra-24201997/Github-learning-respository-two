public with sharing class BBBinderReportController {


              Public String strBBname{get;set;}
              Public string strBBClientName{get;set;}
              Public List<string> BBStatusString {get;set;}
              Public String strBBVendorName{get;set;}
              public String strBBtype{get;set;}
              public String strDistrict{get;set;}
              Public String strSize{get;set;}
              Public String strIllumination{get;set;}
              public Decimal strPMT{get;set;}
              Public String strLong{get;set;}
              Public String strLat{get;set;}
              Public String strBBlocation{get;set;}
              public String strTitle{get;set;}
              public Billboard__c dat {get;set;}
              public Billboard__c dat2 {get;set;}
           /* public String getstrBBClientName() { return strBBClientName; }
              public void setstrBBClientName(String s) {  this.strBBClientName= s; }
              public String getstrBBVendorName() { return strBBVendorName; }
              public void setstrBBVendorName(String s) {  this.strBBVendorName= s; }*/
  
  
              Public  Transient List<Billboard__c> tempbillboards;
              Public String soql{get;set;} 
               
                public Transient List<BBWrapper>  BW;
                public List<ClienDistrictWrapper>  CDWrapper{get;set;}
                public Transient List<ClientNameWrapper> CNW;
                public Transient  ClienDistrictWrapper tmpCDWrapper;
                public Transient  ClientNameWrapper tmpCNW;
                public List<Document> lstDoc;
                public String imageBody{get;set;}
                public String imageURL{get;set;}
                public boolean imageNotFound{get;set;} 
            

  Public BBBinderReportController(){
          
          // Code to display Subsriber Organization Logo
          
          // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
           
         dat= New Billboard__c ();
         dat2= New Billboard__c ();  
           
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
         BW= new List<BBWrapper>();
         CNW= new List<ClientNameWrapper>();
    
    
    
    
   }
   
     
     
     
     public List<SelectOption> getBBStatus(){
      List<SelectOption> BBstatusoptionList = new List<selectOption>();
         

        for(schema.picklistEntry p : Billboard__c.Billboard_Status__c.getDescribe().getPicklistValues()){
               BBstatusoptionList .add(new SelectOption(p.getLabel(),p.getLabel()));
               
           }
        
        return BBstatusoptionList ;
    } 
   
    public List<SelectOption> getBBType(){
      List<SelectOption> optionList = new List<selectOption>();
         

        for(schema.picklistEntry p : Billboard__c.Billboard_Type__c.getDescribe().getPicklistValues()){
              optionList .add(new SelectOption(p.getLabel(),p.getLabel()));
               
           }
        
        return optionList ;
    } 
    
     public List<SelectOption> getIllumination(){
      List<SelectOption> optionList = new List<selectOption>();
         
        optionList.add(new selectOption('', '- None -'));
        for(schema.picklistEntry p : Billboard__c.Illumination__c.getDescribe().getPicklistValues()){
              optionList .add(new SelectOption(p.getLabel(),p.getLabel()));
               
           }
        
        return optionList ;
    } 
    
    
    
   public List<SelectOption> getDistrict(){
      List<SelectOption> optionList = new List<selectOption>();
         
        optionList.add(new selectOption('', '- None -'));  
        for(schema.picklistEntry p : Client__c.Dummy_Picklist_1__c.getDescribe().getPicklistValues()){
              optionList .add(new SelectOption(p.getLabel(),p.getLabel()));
               
           }
        
        return optionList ;
    } 
    
   
    
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
    {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));    
          }
          return optionList;  
     }   
     // End of method getClients
   
   
    // This method is used to retrieve all vendors into dropdown list
    public List<selectOption> getvendors() 
    {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (vendor__c  a : [SELECT Id, name FROM vendor__c order by Name]) 
          {  
            optionList.add(new selectOption(a.name, a.Name));     
          }
          return optionList;  
    }   
    // End of method getvendors
   
   
   
   
   Public pagereference  searchbillboards() {
                     Decimal strpmtdecimal;
                     Date D1=dat.Expiration_Date__c;
                     Date D2=dat2.Expiration_Date__c;
                    tempbillboards= new List<Billboard__c>();
                    CDWrapper = new List<ClienDistrictWrapper>();
                    
                   
                    system.debug('client name'+strBBClientName); 
                 
                 
               /*     strBBname= ApexPages.CurrentPage().getParameters().get('strBBname');
                    strBBstatus= ApexPages.CurrentPage().getParameters().get('strBBstatus');
                    strBBClientName= ApexPages.CurrentPage().getParameters().get('strBBClientName');
                    strBBVendorName= ApexPages.CurrentPage().getParameters().get('strBBVendorName');
                    strBBtype= ApexPages.CurrentPage().getParameters().get('strBBtype');
                    
                    strBBlocation= ApexPages.CurrentPage().getParameters().get('strBBlocation');
                    strTitle= ApexPages.CurrentPage().getParameters().get('strTitle');
                    
                    system.debug('BB#'+strBBname);
                    system.debug('Ststus values:::'+strBBstatus);*/
                    
                    soql='Select id ,name ,Title__c,Size__c,Client_Name__r.Client_Code__c,Attachment_ID__c ,Client_Name__c,Client_Name__r.name,Photo_2_New__c,Client_Name__r.Dummy_Picklist_1__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__r.Dummy_Picklist_1__c !=null ';
              
               
                  if(strBBname!=Null)
                   soql +=' And Name like \'%'+String.escapeSingleQuotes(strBBname)+'%\' ';
                   
                  if(strTitle!=Null)
                   soql +=' And Title__c like \'%'+String.escapeSingleQuotes(strTitle)+'%\' ';
                    
                  if(strBBlocation!=Null)
                   soql +=' And Location__c like \'%'+String.escapeSingleQuotes(strBBlocation)+'%\' ';
                  
                   system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>BBStatusString1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+BBStatusString);
                    
                 if(BBStatusString!=Null && BBStatusString.size()>0)
                   soql +=' And Billboard_Status__c =:BBStatusString';
                   system.debug('>>>>>>>>>>>>>>>>>>>>>>>>BBStatusString2>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+BBStatusString ); 
                   
                  if(strIllumination!=Null)
                   soql +=' And Illumination__c=:strIllumination';
                   
                  system.debug('client name'+strBBClientName); 
                   
                  if(strBBClientName!=Null)
                   soql +=' And Client_Name__r.name =:strBBClientName';
                    
                  system.debug('client name'+strBBClientName);  
                  
                  
                  
                  if(strDistrict!=Null)
                   soql +=' And Client_Name__r.Dummy_Picklist_1__c=:strDistrict'; 
                   
                    
                  if(strBBVendorName!=Null)
                   soql +=' And BB_Vendor__r.name=:strBBVendorName';
                    
                   
                 if(strBBtype!=Null)
                   soql +=' And Billboard_Type__c =:strBBtype';
                     
                  
                    
                 if(!String.IsBlank(strSize) )
                   soql +=' And Size__c=:strSize';
                   
                 if(D1!=Null && D2!=null)
                   soql +=' And (Expiration_Date__c>=:D1 AND Expiration_Date__c<=:D2)';  
                   
               
              
                if(strPMT!=0)
                   soql +=' And PMT__c  =:strPMT';
                    
                   
                   
                      
                 if(!String.ISBLANK(strLat))
                   soql +=' And Latitude__c=:strLat';
                   
                   
                 if(!String.IsBlank(strlong))
                   soql +=' And Longitude__c=:strlong';
                       
                
               
                soql +=' order by Client_Name__r.Dummy_Picklist_1__c ,Client_Name__r.Client_Code__c,Name limit 150'; 
               
                 System.debug('Query is : ' + soql);  
                
                tempbillboards=Database.query(soql);
                
                
                system.debug('Size of BBs list ::::: ' + tempbillboards.size());
                
                
    
    
           string strClientDistNew;
           string strClientNameNew;
           string strClientCodeNew;
           
          for(Billboard__c aa:tempbillboards)
         {
           if (strClientDistNew!= aa.Client_Name__r.Dummy_Picklist_1__c )
            {
            
            
               
                if (strClientDistNew != null)
               {                                
                    tmpCNW.BWrapper= BW;
                    CNW.add(tmpCNW);
                    tmpCDWrapper.CNWrapper= CNW;
                    CDWrapper.add(tmpCDWrapper);
                    system.debug('cWrapper :::::::::'+CDWrapper);                                                                      
                }
                
               tmpCNW= new ClientNameWrapper();     
               tmpCDWrapper= new ClienDistrictWrapper();     
                    
                
                tmpCDWrapper.strClientDist = strClientDistNew = aa.Client_Name__r.Dummy_Picklist_1__c ;
                tmpCNW.strClientName = strClientNameNew = aa.Client_Name__r.Name;
                tmpCNW.strClientCode = strClientCodeNew= aa.Client_Name__r.Client_Code__c;
                
                CNW= new List<ClientNameWrapper>();
                BW = new List<BBWrapper>();
                
            }   
           else{
                  if (strClientNameNew != aa.Client_Name__r.Name) 
                      { 
                          
                        if(BW.size() > 0 && BW.size() !=null)
                        {     
                              
                               tmpCNW.BWrapper= BW;
                               CNW.add(tmpCNW);
                               tmpCNW= new ClientNameWrapper();
                               
                               tmpCNW.strClientName = strClientNameNew = aa.Client_Name__r.Name;
                               tmpCNW.strClientCode = strClientCodeNew= aa.Client_Name__r.Client_Code__c;
                               strClientDistNew = aa.Client_Name__r.Dummy_Picklist_1__c; 
                                 
                             }                  
                             BW = new List<BBWrapper>();                       
                        } 
                    }
            BBWrapper objWrapper = new BBWrapper();
            objWrapper.BB= aa;              
            
           // objWrapper.jobSpecs= mapJSpec.get(aa.id);
            
            
            BW.add(objWrapper); 
        }
       if (strClientDistNew != null){
           
                    tmpCNW.BWrapper= BW;
                    CNW.add(tmpCNW);
                    tmpCDWrapper.CNWrapper= CNW;
                    CDWrapper.add(tmpCDWrapper);
                    
           
       }
    
    
    
    
    
   
      return null;
  }
  
    Public pagereference  PrintReport() {
     
       PageReference pageRef= new PageReference('/apex/BBBinderReportPrint');
       pageRef.setRedirect(false);        
       return pageRef;   
       
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
            public List<BBWrapper> BWrapper{get;set;}
            public ClientNameWrapper()
            {
                if(BWrapper== NULL) {BWrapper= new List<BBWrapper>();}
            }  
        }

     public class BBWrapper
        {              
           public Billboard__c BB {get;set;}
           
           public BBWrapper()
            {
                 
            }
        }

  


}