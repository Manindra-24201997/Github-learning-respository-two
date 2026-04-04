public  without sharing class multiplefilescontroller {
       public boolean isMobile{private set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4t')?true:false;
    }
                           }
    public String CSimageBody {get; set;}
    public String CSImgH {get; set;}
    public String CSImgW {get; set;}
    public String CSSiteHeader {get; set;}
    public String CSCusText {get; set;}
    // public String CSFileSecCusText {get; set;}
    
    public boolean CSFileSec {get; set;}
    public boolean fileinput{get;set;}
    
    public boolean dropdownshow{get;set;}
    
    public String SpecTempName,CampaignName,MTName,ClientName,CCName,ScheduleTemp,strid,ScheduleType,ScheduleCalc;
    
    public Job__c obJob;
    
    public Job__c objJob{get; set;}
    
    public String getCampaignName() { return CampaignName; }
    public void setCampaignName(String s) {  this.CampaignName = s; }
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    public list<Spec_Item__c> lstspecItems{get; set;}
    
    public list<Job_Spec__c> lstJobspec{get; set;}
    
    Public Map<String,String> MapSpecItems{get;set;}
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; }
    
    public boolean pgb2{get; set;}
    
    public boolean pgb1{get; set;}
    //newly added for multiple files
    public List<Attachment> fileList {get; set;}
    public Attachment attach {get; set;}   
    public List<SelectOption> filesCountList {get; set;} //Newly added 2
    public String FileCount {get; set;}
    
    transient Public Attachment att;  
    Public  Attachment getatt()
    {
        att = new Attachment();
        filelist.add(att);
        return att;
    }
    list<Attachment> attachmentlist  = new List<Attachment>();  
    // public boolean displayPopup {get; set;}
        public multiplefilescontroller(ApexPages.StandardController controller) {
         // dropdownshow = true;
        this.obJob=(Job__c)controller.getRecord();        
        pgb2 = true;        
        pgb1 = true;
        Site_Request_Form_Settings__c activeSettings = Site_Request_Form_Settings__c.getOrgDefaults();
        CSimageBody= activeSettings.Org_URL__c;
        system.debug('The image is === '+CSimageBody);
        CSImgH=activeSettings.Height_of_the_Image__c;
        CSImgW=activeSettings.Width_of_the_Image__c;
        CSSiteHeader=activeSettings.Site_Header_Name__c;
        CSCusText=activeSettings.CustomText__c;
        CSFileSec=activeSettings.Files_Section__c;
        // CSFileSecCusText=activeSettings.File_Section_custom_text__c;
        //Below code is for multiple files
        //   attach = new Attachment();
        fileList = new List<Attachment>();
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        // fileList.add(attach);//This line is commented for rendering input file related to multiple files uploading.
        system.debug('filelist size in constructor=== '+filelist.size());
        //Adding values count list - you can change this according to your need
        for(Integer i = 1 ; i < 6 ; i++)//Newly added 2
            filesCountList.add(new SelectOption(''+i , ''+i)) ;
    }
    
    //Below two methods is for multiple files both methods not using
    public List<Attachment> getAttachments(){// This method not using
        if(fileList == null) 
            fileList = new List<Attachment>();
        return fileList; 
    }
    
    
    public PageReference AddAttachs() { // This method not using
        fileList.add(new Attachment());
        system.debug('filelist size in AddAttachs=== '+filelist.size());
        fileinput = true;       
        return null;
    }
    
    public PageReference ChangeCount()// count change method newly added 2
    {
        system.debug('ChangeCount');
        
        // dropdownshow = true;
        fileList.clear() ;
        system.debug('Integer.valueOf(FileCount)'+Integer.valueOf(FileCount));
        if(Integer.valueOf(FileCount)==0){
            fileList.clear() ;
        }
        //Adding multiple attachments instance
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
        {
            fileList.add(new Attachment());
        }
        return null ;
    }
    
    Map<id,List<Spec_Item__c>> maplstspec=new Map<id,List<Spec_Item__c>>();
    
    public List<selectOption> getCampaigns() 
    {   
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -')); 
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c where Status__c='Active' order by Name]) 
        {         
            optionList.add(new selectOption(a.Id, a.Name)); 
        }
        return optionList;  
    }
    
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }            
        return optionList;  
    }
    
    public List<selectOption> getClients() 
    {        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));  
        }
        return optionList;  
    }
    
    public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname and Active__c =:true order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
    public void specList(){           
        lstspecItems = new list<Spec_Item__c>();
        MapSpecItems = new Map<String,String>();
        system.debug('spec is ....'+SpecTempName);
        lstspecItems = [select Name,Description__c,Spec_Description__c,Sort_Order__c,Specification_Template__r.Name from Spec_Item__c where Specification_Template__c =: SpecTempName order by Sort_Order__c];
        if(lstspecItems.size()>0)
        {
            for(Spec_Item__c SpecItem:lstspecItems)
            {
                MapSpecItems.put(SpecItem.Name, SpecItem.Description__c);
            }
        }
    }
    
    public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
    // public List<selectOption> optionList1{get;set;}
    public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList1 = new List<selectOption>();   
        optionList1.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName and Active__c=True order by Name]) 
        { 
            optionList1.add(new selectOption(r.Id, r.Name));
        }
        return optionList1;
    }
    
    public PageReference cancelme(){  
        PageReference p = new PageReference('/apex/JobSiteFormMultipleFiles');
        p.setRedirect(true); 
        return p;
    }
    
    Public pagereference newJob(){
        Pagereference pg= new Pagereference('/apex/JobSiteFormMultipleFiles');
        pg.setRedirect(true);
        return pg;    
    }
    
    public PageReference saveme(){  
        
        /* if(att.Body == null)
{
//String stringMediaType = Schema.Job__c.fields.Name.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' : You must select a file.');
ApexPages.addMessage(myMsg);
return null;
}*/
        
        if(obJob.Name == null)
        {
            String stringProjectName = Schema.Job__c.fields.Name.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringProjectName+' : You must enter a '+stringProjectName);
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(!test.isRunningTest()){
            if(att == null || att.name == null)
            {
                String filename = 'Upload REQUIRED Creative Brief';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,filename+' : You must upload a '+filename);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        /*  if(obJob.Requested_Due_Date__c == null)
{
String stringDueDate = Schema.Job__c.fields.Requested_Due_Date__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringDueDate+' : You must enter a '+stringDueDate);
ApexPages.addMessage(myMsg);
return null;
}*/
        
        //For new changes we commented below media type and schedulee template.
        /*
if(ScheduleTemp == null)
{
String strSchedule = Schema.Job__c.fields.Schedule_Template__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSchedule+' : You must select a '+strSchedule +'.');
ApexPages.addMessage(myMsg);
return null;
}
if(SpecTempName == null )
{
String strSpecificationTemp = Schema.Job__c.fields.Specification_Template__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strSpecificationTemp +' : You must select a '+strSpecificationTemp +'.' );
ApexPages.addMessage(myMsg);
return null;
}*/
        /* if(MTName == null) //This if we are not using
{
String stringMediaType = Schema.Job__c.fields.Media_Types__c.getDescribe().getLabel();
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMediaType+' : You must select a '+stringMediaType+'.');
ApexPages.addMessage(myMsg);
return null;
}*/
        if(ClientName == null )
        {
            String strClientName = Schema.Job__c.fields.JS_Client__c.getDescribe().getLabel();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+strClientName +' : You must select a '+strClientName +'.' );
            ApexPages.addMessage(myMsg);
            return null;
        }
        else{
            if (Schema.sObjectType.Job__c.fields.Campaign__c.isCreateable()) {
                obJob.Campaign__c=CampaignName;
            }
            if (Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()) {   
                // obJob.Media_Types__c=MTName; //This is commenetd for automatic pre populating values
                Media_Type__c mtn=[SELECT Id,name from  Media_Type__c where name= 'all' limit 1];
                obJob.Media_Types__c=mtn.id;
            }
            if (Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()) {   
                // obJob.Schedule_Template__c=ScheduleTemp; //This is commenetd for automatic pre populating values
                Schedule_Template__c sch = [SELECT Id,name,Media_Types__r.name from  Schedule_Template__c where name= 'TBD' and Media_Types__r.name = 'all' limit 1];
                obJob.Schedule_Template__c=sch.id;
            }    
            if (Schema.sObjectType.Job__c.fields.Specification_Template__c.isCreateable()) {   
                obJob.Specification_Template__c=SpecTempName;
            }
            if (Schema.sObjectType.Job__c.fields.Schedule_Calc__c.isCreateable()) {   
                obJob.Schedule_Calc__c ='End Date';
            }
            if (Schema.sObjectType.Job__c.fields.Status__c.isCreateable()) {   
                obJob.Status__c ='Requested';
            }
            if (Schema.sObjectType.Job__c.fields.JS_Client__c.isCreateable()) {   
                obJob.JS_Client__c=ClientName;
            }
            if (Schema.sObjectType.Job__c.fields.JS_Client_Contact__c.isCreateable()) {   
                obJob.JS_Client_Contact__c =CCName;
            }
            
            try{
                If(Test.isRunningTest()==false){ 
                    if(Schema.sObjectType.Job__c.isCreateable()){
                        insert obJob;
                    }
                }
                list<Job_Spec__c> lstJspec = new list<Job_Spec__c>();
                if(SpecTempName != null){
                    List<Job_Spec__c> lstExtSpecs = new List<Job_Spec__c>();
                    lstExtSpecs = [select Id, Name from Job_Spec__c where Job__c =:obJob.Id];
                    If(lstExtSpecs.size()>0){
                        if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                            delete lstExtSpecs;
                        }
                    }
                    /*integer i=0;
for(String mapSpec:MapSpecItems.keySet())
{
Job_Spec__c jobSpec = new Job_Spec__c();
if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { 
jobSpec.Job__c = obJob.Id;
}
if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
jobSpec.Name = mapSpec;
}
if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) { 
jobSpec.Description__c = MapSpecItems.get(mapSpec);
}
if (Schema.sObjectType.Job_Spec__c.fields.Sort_Order__c.isCreateable()) { 
jobSpec.Sort_Order__c = i+1;
}
lstJspec.add(jobSpec);
}*/
                    /* for(Spec_Item__c obj:lstspecItems)
{
Job_Spec__c jobSpec = new Job_Spec__c();
if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { 
jobSpec.Job__c = obJob.Id;
}
if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
jobSpec.Name = obj.Name;
}
if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) { 
jobSpec.Description__c = obj.Spec_Description__c;
}
if (Schema.sObjectType.Job_Spec__c.fields.Sort_Order__c.isCreateable()) { 
jobSpec.Sort_Order__c = obj.Sort_Order__c;
}
lstJspec.add(jobSpec);
}
if(lstJspec.size()>0)
{
if(Schema.sObjectType.Job_Spec__c.isCreateable()){ 
insert lstJspec; 
}
}*/
                }
                string strid = obJob.Id; 
                if(CSFileSec)
                {
                    //The below logic is for multi file upload
                    if(filelist.size() > 0){
                        List<Attachment> attachments = new List<Attachment>();                               
                        for(Attachment att : fileList)              
                        { 
                            try{
                                system.debug('The name is === '+att.name + 'The body is == '+att.body+'\n');    
                                ContentVersion conVer = new ContentVersion();
                                conVer.ContentLocation = 'S'; 
                                conVer.PathOnClient = att.name;  
                                conVer.Title = att.name; 
                                conVer.versionData = att.body; 
                                conVer.IsMajorVersion=false;
                                insert conVer;
                                system.debug('conVer id === '+conVer.id+'\n');
                                
                                // First get the content document Id from ContentVersion
                                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                                //Create ContentDocumentLink
                                ContentDocumentLink cDe = new ContentDocumentLink();
                                cDe.ContentDocumentId = conDoc;
                                cDe.LinkedEntityId = obJob.Id; // you can use objectId,GroupId etc
                                cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                                // cDe.Visibility = 'InternalUsers';
                                insert cDe;
                                system.debug('cDe id === '+cDe.Id+'\n');
                            }
                            catch(exception e){
                                system.debug('exception is '+e.getMessage()); 
                            }
                            /* if(att.name != null && att.body != null){  //blog logic
attachments.add(new Attachment(parentId = obJob.Id, name = att.name, body = att.body)) ;   
}*/
                        }
                        /* if(attachments != null){   //blog logic
insert attachments; 
ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, attachments.size() + ' file(s) uploaded successfully'));                                              
}*/
                    } 
                    //This below if commented for multi files upload.It is previous logic for single file upload
                    /* if(att.Body != null)
{
ContentVersion conVer = new ContentVersion();
conVer.ContentLocation = 'S'; 
conVer.PathOnClient = att.name;  
conVer.Title = att.name; 
conVer.versionData = att.body; 
conVer.IsMajorVersion=false;
insert conVer;

// First get the content document Id from ContentVersion
Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;

//Create ContentDocumentLink
ContentDocumentLink cDe = new ContentDocumentLink();
cDe.ContentDocumentId = conDoc;
cDe.LinkedEntityId = obJob.Id; // you can use objectId,GroupId etc
cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
// cDe.Visibility = 'InternalUsers';
insert cDe;
}*/
                }
                // displayPopup = true; 
                obJob = new Job__c();           
                PageReference p = new PageReference('/apex/JobSiteFinal');
                p.setRedirect(true); 
                objJob =  obJob;
                /*    lstJobspec = new list<Job_Spec__c>();  
lstJobspec  = [Select Id, Name,Description__c from Job_Spec__c where Job__c =:strid ];*/
                return p;
            }
            catch(Exception e)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,e.getMessage());
                ApexPages.addMessage(myMsg);             
                return null; 
            }
        }
    }
    // End of method Save      
}