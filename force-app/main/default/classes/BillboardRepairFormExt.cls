public class BillboardRepairFormExt {
    
    Public Client_Contact__c  clientContact{get;set;}
    Public String clientname;
    Public User lstUser{get;set;} 
    Public Media_Type__c NameBillboardMediatype{get;set;}
    Public Schedule_Template__c NameBillboardScheduletype{get;set;}
    
    public Attachment myfile;
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
    }
    
    Public String BillboardStore{get;set;}
    Public String BillboardRequestor{get;set;}
    Public String BillboardReads{get;set;}
    Public String Billboardshouldread{get;set;}
    Public String Billboardlightout{get;set;}
    Public String BillboardNotes{get;set;}
    
    public List<string> BillboardSigntypeList {get; set;} 
    public List<SelectOption> BillboardSigntype; 
    public List<SelectOption> getBillboardSigntype(){
        if (BillboardSigntype!= NULL) {            return BillboardSigntype;
                                      }
        BillboardSigntype= new List<SelectOption>();
        BillboardSigntype.add(new SelectOption('Billboard  ','Billboard'));
        BillboardSigntype.add(new SelectOption('DOT','DOT'));
        
        return BillboardSigntype;
    }  
    
    public string BBList{get; set;} 
    public list<SelectOption> Billboardlist;
    
    public List<SelectOption> getBillboardList(){
        List<SelectOption> BillboardList= new List<selectOption>();
        BillboardList.add(new selectOption('', '- None -'));  
        
        
        if(clientname.contains('Store')){
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
            }
        }
        
        if(clientname.contains('District')){
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
            }
        }
        
        if(clientname.contains('Division')){
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
            }
        }
        return BillboardList;
    } 
    
    Public String BBLName;
    public String getBBLName() { return BBLName; }
    public void setBBLName(String s) {  this.BBLName= s; }
    
    // This method is used to retrieve all Locatiopn into dropdown list
    public List<selectOption> getBBLocation() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Billboard__c gld : [Select id ,name ,Location__c,Client_Name__c FROM Billboard__c where Client_Name__c=:clientcontact.Client__c Order By Name]) 
        {  
            if(gld.Location__c!=null){
                optionList.add(new selectOption(gld.Location__c, gld.Location__c));
            }  
        }
        return optionList;  
    }   
    // End of method getBBLocation
    
    public List<string> BillboardLightList {get; set;} 
    public List<SelectOption> BillboardLight; 
    public List<SelectOption> getBillboardLight(){
        if (BillboardLight!= NULL) {            return BillboardLight;
                                   }
        BillboardLight= new List<SelectOption>();
        BillboardLight.add(new SelectOption('Light 1','Light 1'));
        BillboardLight.add(new SelectOption('Light 2','Light 2'));
        BillboardLight.add(new SelectOption('Light 3',' Light 3'));
        BillboardLight.add(new SelectOption('Light 4',' Light 4'));
        return BillboardLight;
    } 
    
    public List<string> BillboardServiceIssuesList {get; set;} 
    public List<SelectOption> BillboardServiceIssues; 
    public List<SelectOption> getBillboardServiceIssues(){
        if (BillboardServiceIssues!= NULL) {            return BillboardServiceIssues;
                                           }
        BillboardServiceIssues= new List<SelectOption>();
        BillboardServiceIssues.add(new SelectOption('Faded/Weathered Facing  ','Faded/Weathered Facing  '));
        BillboardServiceIssues.add(new SelectOption('Heart Issue','Heart Issue'));
        BillboardServiceIssues.add(new SelectOption('Incorrect Logos','Incorrect Logos'));
        BillboardServiceIssues.add(new SelectOption('Trim Trees/Brush','Trim Trees/Brush'));
        BillboardServiceIssues.add(new SelectOption('Needs White-Out/Taken Down(canceled)','Needs White-Out/Taken Down(canceled)'));
        BillboardServiceIssues.add(new SelectOption('Directional Information Incorrect','Directional Information Incorrect'));
        return BillboardServiceIssues;
    }  
    
    public BillboardRepairFormExt(){
        NameBillboardMediatype=[Select id ,name from Media_Type__c where name='Outdoor' limit 1];
        NameBillboardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Billboard Repair' AND Media_Types__r.name='Outdoor' limit 1];
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        clientname=clientcontact.Client__r.Name; 
    }
    
    Public pagereference save(){
        try
        {
            
            Job__c BillboardJob=new Job__c();
            
            BillboardJob.Media_Types__c=NameBillboardMediatype.id;
            BillboardJob.Schedule_Template__c=NameBillboardScheduletype.id;
            BillboardJob.JobFormTypeValues__c='Billboard Repair Request';
            BillboardJob.JS_Client__c=clientcontact.Client__c;
            BillboardJob.JS_Client_Contact__c=clientcontact.id;
            
            insert BillboardJob;
            
            Job_Spec__c BillboardSpec1=new Job_Spec__c();
            BillboardSpec1.Name='District';
            BillboardSpec1.Description__c=clientcontact.Client__r.Dummy_Picklist_1__c;
            BillboardSpec1.Job__c=BillboardJob.id;
            BillboardSpec1.Sort_Order__c=1;
            insert BillboardSpec1;
            
            
            Job_Spec__c BillboardSpec123=new Job_Spec__c();
            BillboardSpec123.Name='Billboard';
            BillboardSpec123.Description__c=BBList;
            BillboardSpec123.Job__c=BillboardJob.id;
            BillboardSpec123.Sort_Order__c=2;
            insert BillboardSpec123;
            
            Job_Spec__c BillboardSpec2=new Job_Spec__c();
            BillboardSpec2.Name='Store Name';
            BillboardSpec2.Description__c=clientcontact.Client__r.Name;
            BillboardSpec2.Job__c=BillboardJob.id;
            BillboardSpec2.Sort_Order__c=3;
            insert BillboardSpec2;
            
            Job_Spec__c BillboardSpec3=new Job_Spec__c();
            BillboardSpec3.Name='Requestor';
            BillboardSpec3.Description__c=clientcontact.name;
            BillboardSpec3.Job__c=BillboardJob.id;
            BillboardSpec3.Sort_Order__c=4;
            insert BillboardSpec3;
            
            List<Job_Spec__c> BillboardSigntypeSpecList =new list<Job_Spec__c>();
            if( BillboardSigntypeList.size() != null && BillboardSigntypeList.size() >0 ){
                for(string Billsign:BillboardSigntypeList ){
                    Job_Spec__c BillboardSpec4=new Job_Spec__c();
                    BillboardSpec4.Name='Sign type';
                    BillboardSpec4.Job__c=BillboardJob.id;
                    BillboardSpec4.Description__c=Billsign;
                    BillboardSpec4.Sort_Order__c=5;
                    BillboardSigntypeSpecList.add(BillboardSpec4);
                    
                }
            }
            insert BillboardSigntypeSpecList;
            
            Job_Spec__c BillboardSpec5=new Job_Spec__c();
            BillboardSpec5.Name='Location';
            BillboardSpec5.Description__c=BBLName;
            BillboardSpec5.Job__c=BillboardJob.id;
            BillboardSpec5.Sort_Order__c=6;
            insert BillboardSpec5;
            
            List<Job_Spec__c> BillboardServiceIssuesSpecList =new list<Job_Spec__c>();
            if(BillboardServiceIssuesList.size() >0 ){
                for(string BillService:BillboardServiceIssuesList  ){
                    Job_Spec__c BillboardSpec6=new Job_Spec__c();
                    BillboardSpec6.Name='Service Issues';
                    BillboardSpec6.Job__c=BillboardJob.id;
                    BillboardSpec6.Description__c=BillService;
                    BillboardSpec6.Sort_Order__c=7;
                    BillboardServiceIssuesSpecList.add(BillboardSpec6);
                    
                }
            }
            insert BillboardServiceIssuesSpecList ;
            
            
            Job_Spec__c BillboardSpec7=new Job_Spec__c();
            BillboardSpec7.Name='Currently Reads';
            BillboardSpec7.Description__c=BillboardReads;
            BillboardSpec7.Job__c=BillboardJob.id;
            BillboardSpec7.Sort_Order__c=8;
            insert BillboardSpec7;
            
            
            Job_Spec__c BillboardSpec8=new Job_Spec__c();
            BillboardSpec8.Name='Should Read';
            BillboardSpec8.Description__c=Billboardshouldread;
            BillboardSpec8.Job__c=BillboardJob.id;
            BillboardSpec8.Sort_Order__c=9;
            insert BillboardSpec8;
            
            
            List<Job_Spec__c> BillboardLightSpecList=new list<Job_Spec__c>();
            if(BillboardLightList.size() >0 ){
                for(string BillLight: BillboardLightList){
                    Job_Spec__c BillboardSpec9=new Job_Spec__c();
                    BillboardSpec9.Name='Lighting';
                    BillboardSpec9.Job__c=BillboardJob.id;
                    BillboardSpec9.Description__c=BillLight;
                    BillboardSpec9.Sort_Order__c=10;
                    BillboardLightSpecList.add(BillboardSpec9);
                    
                }
            }
            insert BillboardLightSpecList;
            
            Job_Spec__c BillboardSpec10=new Job_Spec__c();
            BillboardSpec10.Name='What time(s) are the lights being reported out';
            BillboardSpec10.Description__c=Billboardlightout;
            BillboardSpec10.Job__c=BillboardJob.id;
            BillboardSpec10.Sort_Order__c=11;
            insert BillboardSpec10;
            
            
            
            Job_Spec__c BillboardSpec12=new Job_Spec__c();
            BillboardSpec12.Name='Notes';
            BillboardSpec12.Description__c=BillboardNotes;
            BillboardSpec12.Job__c=BillboardJob.id;
            BillboardSpec12.Sort_Order__c=12;
            insert BillboardSpec12;
            
            
            if(!Test.isRunningTest()){  if(myfile.body != null ){
                Job_Spec__c BillboardSpec11=new Job_Spec__c();
                BillboardSpec11.Name='File';
                BillboardSpec11.Description__c='Files & documents attached';
                BillboardSpec11.Job__c=BillboardJob.id;
                BillboardSpec11.Sort_Order__c=13;
                insert BillboardSpec11;
                
                Attachment SpecAttachment=new Attachment(parentId=BillboardSpec11.id,name=myfile.Name,body=myfile.body); //Create instance of Attachment and add fields to it
                
                insert SpecAttachment;
                
                //Insert ContentVersion
                ContentVersion cVersion = new ContentVersion();
                cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                cVersion.PathOnClient = SpecAttachment.Name;//File name with extention
                cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                //cVersion.OwnerId = attach.OwnerId;//Owner of the file
                cVersion.Title = SpecAttachment.Name;//Name of the file
                cVersion.VersionData = SpecAttachment.Body;//File content
                Insert cVersion;
                
                //After saved the Content Verison, get the ContentDocumentId
                Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
                
                //Insert ContentDocumentLink
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                cDocLink.LinkedEntityId = SpecAttachment.ParentId;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                //  cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
                Insert cDocLink;
                
                Attachment delAttach= [select id,name from Attachment where id=:SpecAttachment.Id];
                
                delete delAttach;
                
                
                
                SpecAttachment.body = null; // clears the viewstate
                
            }
                                      
                                     }  
            
            PageReference pageRef = new PageReference('/lightning/n/Orders');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
            return null;
        }
    }
    
    Public pagereference back(){
        PageReference pageRef = new PageReference('/lightning/n/Store_Fronts');//('/apex/MaterialLineDetailpage?id='+Strid);
        pageRef.setRedirect(true);                                      
        return pageRef;
    }
    
    
    
}