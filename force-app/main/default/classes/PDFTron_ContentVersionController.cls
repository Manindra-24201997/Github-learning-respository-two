public with sharing class PDFTron_ContentVersionController {


  /*  @AuraEnabled(cacheable=true)
    public static User getUserDetails(String recId) {
        return  [Select Id , Name ,Email from User where Id =:recId];
    }*/

    @AuraEnabled( cacheable=true )  
    public static List < JobSuite_Metadata__mdt > fetchJSMetadata() {
        return [SELECT Id, Token__c FROM JobSuite_Metadata__mdt];
    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Team__c> getJobTeamList(String recordId){
        List<Job_Team__c> jobteamList=[SELECT Id, Name, Email__c, Staff__c, Job__c FROM Job_Team__c  WHERE Job__c = :recordId  WITH SECURITY_ENFORCED];
        return jobteamList;
    }

    @AuraEnabled(cacheable=true)
    public static List<User> fetchUsersList(){
        List<User> usersList=[Select Id, Name, Email from User WHERE IsActive=:true];
        return usersList;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentVersionWrapper> getAttachments(String recordId){
        try {
            List<String> cdIdList = new List<String> ();
            List<ContentVersionWrapper> cvwList = new List<ContentVersionWrapper> ();

            //Define supported file extensions
            Set<String> fileFormats = new Set<String> {
                'pdf', 
                'docx', 
                'xlsx',
                'pptx',
                'jpg',
                'jpeg',
                'png',
                'tif',
                'xlsx'

            };
            //Find links between record & document
            for(ContentDocumentLink cdl : [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ]) {
                cdIdList.add(cdl.ContentDocumentId);
                System.debug('ContentDocumentLink List: ' + cdIdList);
            }
            //Use links to get attachments
            for(ContentVersion cv :  [SELECT Id, LastModifiedDate,Title,FileExtension, ContentDocumentId, VersionData  FROM ContentVersion WHERE ContentDocumentId IN :cdIdList AND IsLatest = true Order by LastModifiedDate DESC]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwList.add(new ContentVersionWrapper(cv));
                    //System.debug('Completed CV Conversion:' + cv);
                }
            }
            system.debug(cvwList);
            return cvwList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }



   /* @AuraEnabled
    public static List<ContentVersionWrapper> getAttachments1(String recordId){
        try {
            List<String> cdIdList = new List<String> ();
            List<ContentVersionWrapper> cvwList = new List<ContentVersionWrapper> ();

            //Define supported file extensions
            Set<String> fileFormats = new Set<String> {
                'pdf', 
                'docx', 
                'xlsx',
                'pptx',
                'jpg',
                'jpeg',
                'png',
                'tif',
                'xlsx'
            };
            //Find links between record & document
            for(ContentDocumentLink cdl : [SELECT id, ContentDocumentId, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ]) {
                cdIdList.add(cdl.ContentDocumentId);
                System.debug('ContentDocumentLink List: ' + cdIdList);
            }
            //Use links to get attachments
            for(ContentVersion cv :  [SELECT Id, LastModifiedDate,Title,FileExtension, VersionData  FROM ContentVersion WHERE ContentDocumentId IN :cdIdList AND IsLatest = true Order by LastModifiedDate DESC]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwList.add(new ContentVersionWrapper(cv));
                    //System.debug('Completed CV Conversion:' + cv);
                }
            }
            //system.debug(cvwList);
            return cvwList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/


    @AuraEnabled
    public static List<ContentVersionBodyWrapper> getAttachmentBody(String recordId){
        try {
            List<ContentVersionBodyWrapper> cvwbList = new List<ContentVersionBodyWrapper> ();

            //Define supported file extensions
            Set<String> fileFormats = new Set<String> {
                'pdf', 
                'docx', 
                'xlsx',
                'pptx',
                'jpg',
                'jpeg',
                'png',
                'tif',
                'xlsx'
            };
            
            for(ContentVersion cv : [SELECT Id,LastModifiedDate,ContentDocumentId, Title,FileExtension, VersionData FROM ContentVersion WHERE /*Id =:recordId*/ ContentDocumentId =:recordId AND IsLatest = true]) {
                if(fileFormats.contains(cv.FileExtension.toLowerCase())) {
                    //System.debug('Converting CV: ' + cv.Id);
                    cvwbList.add(new ContentVersionBodyWrapper(cv));
                   // System.debug('Completed CV Conversion:' + cv);
                }
            }
            system.debug(cvwbList);
            return cvwbList;
           //return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void postAComment(String ChatterContent, String ContThread, String recordId, String Author, String fileName, Boolean AddMent, Boolean ModMent, Boolean DelAnn, Boolean stedetail) {
        
            system.debug('>>>>>>>>>ChatterContent>>>>>>>>>>'+ChatterContent);
            system.debug('>>>>>>>>>ContThread>>>>>>>>>>'+ContThread);
            system.debug('>>>>>>>>>JobId>>>>>>>>>>'+recordId);
            list<string> emailAddress = new list<string>();
            set<string> userIds = new set<string>();
            String CusNotifySubject;
            string jobAutoNum;
            string pageUrl;
            Approval_Job_Task__c ApproveJT;
            Job_Task__c jobTask;
            Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
            if(stedetail){
                system.debug('>>>>>>>>>stedetail if Enter>>>>>>>>>>'+stedetail);
                if(setting.Job_Task_Level__c == true && setting.Job_Approval_Process__c == false && setting.File_Attach_at_Task_Level__c == false){
                    system.debug('>>>>>>>>>setting.Job_Task_Level__c if Enter>>>>>>>>>>'+setting.Job_Task_Level__c);
                    ApproveJT= [select id,Name,Task__c,Task__r.Job__c,Task__r.Job__r.Job_Auto_Number__c from Approval_Job_Task__c where id=:recordId WITH SECURITY_ENFORCED];
                    jobAutoNum = ApproveJT.Task__r.Job__r.Job_Auto_Number__c;
                    pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ApproveJT.id;
                }
                else if(setting.Job_Approval_Process__c == true && setting.Job_Task_Level__c == false && setting.File_Attach_at_Task_Level__c == false){
                    system.debug('>>>>>>>>>setting.Job_Approval_Process__c if Enter>>>>>>>>>>'+setting.Job_Approval_Process__c);
                    ApproveJT= [select id,Name,Project__c,Project__r.Job_Auto_Number__c from Approval_Job_Task__c where id=:recordId WITH SECURITY_ENFORCED];
                    jobAutoNum = ApproveJT.Project__r.Job_Auto_Number__c;
                    pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ApproveJT.id;
                }
                else if(setting.File_Attach_at_Task_Level__c == true && setting.Job_Approval_Process__c == false && setting.Job_Task_Level__c == false){
                    system.debug('>>>>>>>>>setting.File_Attach_at_Task_Level__c if Enter>>>>>>>>>>'+setting.File_Attach_at_Task_Level__c);
                    jobTask= [select id,Name,Job__c,Job__r.Job_Auto_Number__c from Job_Task__c where id=:recordId WITH SECURITY_ENFORCED];
                    jobAutoNum = jobTask.Job__r.Job_Auto_Number__c;
                    pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+jobTask.id;
                }
                //pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ApproveJT.id;
            }          
            else{
                system.debug('>>>>>>>>>stedetail else Enter>>>>>>>>>>'+stedetail);
                Job__c job=[Select id,name,Job_Auto_Number__c from Job__c where id=:recordId WITH SECURITY_ENFORCED];
                jobAutoNum=job.Job_Auto_Number__c;
                pageUrl=''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+job.id;
            }
            

            CustomNotificationType commentNotify= [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Task_Inprogress_Notification' LIMIT 1];

            String content = ChatterContent;
            String content2 = content.SubstringAfter('@');
            system.debug(content2);
            String[] sub = content2.split('@');
            system.debug(sub);
            List<string> names=new List<string>();
            for (String str: sub) 
            {
                List<String> fnln = str.split(' ');
                if(fnln.size()<=2){
                    names.add(str);
                }
                else{
                    List<String> fnln2 = str.split(' ');
                    names.add(fnln2[0] + ' ' + fnln2[1]);
                }
            }
            system.debug('names----->'+names);

            if(names.size() > 0)
            {
                system.debug('names size if enter----->');
                String addressee='';

                for(User uName:[SELECT Id,Email FROM User where Name IN :names LIMIT 150])
                {
                    emailAddress.add(uName.Email);
                    userIds.add(uName.Id);
                }
                system.debug('emailAddress size----->'+emailAddress.size());

                if(emailAddress.size() > 0)
                {
                        system.debug('emailAddress size if enter----->');
                        addressee = emailAddress[0];

                        for (Integer i = 1; i < emailAddress.size(); i++) {
                            if (emailAddress!= null)
                            { 
                                addressee += ':' + emailAddress[i];
                                system.debug('**********'+addressee);
                            }
                        }
                    
                    system.debug('addressee----->>>>>>>>'+addressee);
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                    String[] toAddresses = addressee.split(':', 0);
                    system.debug('toAddresses----->>>>>>>>'+toAddresses);
                    message.setToAddresses(toAddresses);
                
                    if(AddMent || ModMent){
                        message.subject = Author+ ' mentioned you in a comment on '+fileName +' (#'+jobAutoNum+')';
                        CusNotifySubject = Author+ ' mentioned you in a comment on '+fileName +' (#'+jobAutoNum+')';
                    }
                    if(DelAnn){
                        message.subject = Author+ ' has deleted a comment on '+fileName +' (#'+jobAutoNum+')';
                        CusNotifySubject = Author+ ' has deleted a comment on '+fileName +' (#'+jobAutoNum+')';
                    }

                   // message.subject = Author+ ' mentioned you in a comment on '+fileName +' (#'+jobAutoNum+')';
                   // CusNotifySubject = Author+ ' mentioned you in a comment on '+fileName +' (#'+jobAutoNum+')';

                    string ChatterThread = ContThread;
                    string ChatterContThread = ChatterThread.replaceAll('\n','<br/>');
                    //string ChatterContThread = ChatterThread1.replaceAll(' ','&nbsp');
                    
                    //string body=' <html><body> <h2 style="font-size:18px;font-weight:500;margin:8px;text-align:center"> '+Author+'<br/> <br/>'+ChatterContent +'<br/> <br/>'+ ChatterContThread+' </body></html>';

                    string body='<html><body><table border="0" style="padding:20px 300px 20px 300px" cellspacing="0"  height="100%" width="100%" bgcolor="#f5f8fa"><tr><td><div style="width:100%;min-width:100%;border:1px solid black;border-top:1px solid black;background-color:white "><br/><h2 style="font-size:18px;font-weight:500;margin:8px;font-family:Helvetica;"><b>'+Author+'</b>	</h2><br/><h2 style="font-size:14px;font-weight:500;margin:12px;font-family:Helvetica;line-height:1.40">'+ChatterContent +'</h2><br/><center><a href="'+pageUrl+'" style="border-radius:5px;background-color:#137CBD;color:white;display:inline-block;font-size:14px;font-weight:500;line-height:1.25;padding:10px 20px;text-decoration:none;width:auto;min-width:110px;white-space:nowrap" target="_blank">View/Comment</a></center><br/><hr style="height:1px;color:red;background-color:#eaf0f6;margin:0px 5px 0px 5px ;padding:0px"><br/><br/><h2 style="font-size:14px;font-weight:500;margin:12px;font-family:Helvetica;line-height:1.40"> '+ChatterContThread+'</h2></div></td></tr></table></body></html>';
                    message.setHtmlBody(body);
                    // message.plainTextBody = Author+'\n\n'+ChatterContent +'\n\n'+ ContThread;
                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }

                    Messaging.CustomNotification customNotify = new Messaging.CustomNotification(commentNotify.Id, null, CusNotifySubject, +'\n'+ ChatterContent +'\n\n'+ ContThread, recordId, null);

                    customNotify.send(userIds);
                }
            } 
     

    }

    @AuraEnabled
    public static void saveDocument(String json, String recordId) {
        //system.debug('json>>>>>>>>>>'+json);
        //system.debug('Recid>>>>>'+recordId);
        try {
            PDFTron_ContentVersionPayload pl = PDFTron_ContentVersionPayload.parse(json);
           // system.debug('Payload document Id>>>>>>>>>>: ' + pl.contentDocumentId);
          /*  ContentVersion cv = new ContentVersion();
            // 'S' = a Salesforce File
            
            if(pl.contentDocumentId != null) {
                cv.ContentDocumentId = pl.contentDocumentId;
                cv.ReasonForChange = 'Saved from WebViewer';//only for file updates
            } else {
                for(ContentDocumentLink cdl :  [SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :recordId AND ContentDocument.Title = :pl.title ]) {
                            if(cdl.ContentDocumentId != null) {
                                cv.ContentDocumentId = cdl.ContentDocumentId;
                                system.debug('cv.ContentDocumentId>>>>>>>>>>: ' + cv.ContentDocumentId);
                            }
                        }
            }*/
            List<ContentVersion> cvidList=[select id,IsLatest,ReasonForChange,ContentDocumentId,FileType FROM ContentVersion where ContentDocumentId=:pl.contentDocumentId];
            List<ContentVersion> updateCVList=new List<ContentVersion>();
            List<ContentVersion> insertCVList=new List<ContentVersion>();
            //system.debug('>>>>>>>>>>>>>cvidList size>>>>>>>>>>>>>'+cvidList.size());
                
            /*if(cvidList.size()==1)
            {
                ContentVersion cv1 = new ContentVersion();
                cv1.VersionData = EncodingUtil.base64Decode(pl.base64Data);
                cv1.Title = pl.title;
                cv1.PathOnClient = pl.filename;
                cv1.ContentDocumentId=cvidList[0].ContentDocumentId;
                // system.debug('### Upserting cv: ' + cv1);
                insert cv1; 
            }
            else{
                for(ContentVersion cvd:cvidList)
                {
                    if(cvd.IsLatest == true)
                    {
                        cvd.VersionData = EncodingUtil.base64Decode(pl.base64Data);  cvd.Title = pl.title;    updateCVList.add(cvd);
                    }
                }
                update updateCVList; 
            }*/
            
            
            for(ContentVersion cvd:cvidList)
            {
                if(cvd.IsLatest == true && cvd.ReasonForChange!='Saved from WebViewer')
                {
                    system.debug('>>>>>>>>>>>>>IsLatest PDF if>>>>>>>>>>>>>');
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = EncodingUtil.base64Decode(pl.base64Data);
                    cv.Title = pl.title;
                    cv.PathOnClient = pl.filename;
                    cv.ContentDocumentId=cvidList[0].ContentDocumentId;
                    cv.ReasonForChange='Saved from WebViewer';
                    insertCVList.add(cv);
                }
                else if(cvd.IsLatest == true && cvd.ReasonForChange=='Saved from WebViewer'){
                    system.debug('>>>>>>>>>>>>>IsLatest PDF else>>>>>>>>>>>>>');
                    cvd.VersionData = EncodingUtil.base64Decode(pl.base64Data);  
                    cvd.Title = pl.title;   
                    updateCVList.add(cvd);
                }
            }
            insert insertCVList;
            update updateCVList; 
          
            
        } catch (Exception e) {
            system.debug('### ERROR: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ContentVersionBodyWrapper {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String body {get; set;}
        @AuraEnabled
        public ContentVersion cv;
        
        public ContentVersionBodyWrapper(ContentVersion contentVer) {
            this.cv = contentVer;
            this.name = contentVer.Title + '.' + contentVer.FileExtension;
            this.body = EncodingUtil.base64Encode(contentVer.VersionData);
        }
    }

    public class ContentVersionWrapper {
        @AuraEnabled
        public String name {get; set;}
       // @AuraEnabled
       // public String body {get; set;}
        @AuraEnabled
        public ContentVersion cv;
        
        public ContentVersionWrapper(ContentVersion contentVer) {
            this.cv = contentVer;
            this.name = contentVer.Title + '.' + contentVer.FileExtension;
           // this.body = EncodingUtil.base64Encode(contentVer.VersionData);
        }
    }
}