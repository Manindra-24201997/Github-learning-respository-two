public class samplevfcontroller {
    public Job__c job{get;set;}
    public Job_Task__c jtk{get;set;}
    public string urlvalue{get;set;}
    public Attachment myfile;
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
    }
    public samplevfcontroller(){
        jtk = new Job_Task__c();
        urlvalue=ApexPages.currentPage().getParameters().get('id');
        system.debug('urlvalue == '+urlvalue);
    }
    public PageReference saveDetails() {
        try
        {
            system.debug('saveDetails === '+urlvalue);
            job =  [select id,name,Job_Auto_Number__c, CreatedDate from Job__c where id =:urlvalue  limit 1];
            jtk.Job__c = urlvalue;
            jtk.Schedule_Roles__c = 'Admin';
            insert jtk;
            system.debug('jtk === '+jtk);
            if(!Test.isRunningTest()){  if(myfile.body != null ){
                Attachment SpecAttachment = new Attachment(parentId = job.Id, name=myfile.name, body = myfile.body);
                /* insert the attachment */
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
            
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
            PageReference pg = new PageReference('/'+urlvalue);
            pg.setRedirect(true);
            return pg; 
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
            return null;
        }
    }
}