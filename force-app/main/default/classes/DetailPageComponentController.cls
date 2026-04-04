public with Sharing class DetailPageComponentController {
    
    @AuraEnabled
    public static String getObjectFieldLabel(list < String > ObjNames) {
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);
    }
    
    @AuraEnabled
    public static Map < String, list < SObject >> findjobsandnotes(Id recordId) {
        Map < String, list < SObject >> JobDataUnderCmp = new Map < String, list < SObject >> ();
        set < Id > SetJobIds = new set < Id > ();
        if(!Schema.sObjectType.Job__c.isAccessible()){
            return null;
        }
        List < Job__c > lstJob =[Select Id, Name, Job_Auto_Number__c, JS_Client__r.name, Status__c, Budgeted_Cost__c, Invoice_Actual_Amounts__c, Estimate_Total__c from Job__c where Campaign__c = : recordId and Status__c = 'Active'
                               WITH SECURITY_ENFORCED ORDER BY Job_Auto_Number__c DESC LIMIT 1000];
        for (Job__c JobID: lstJob) {
            SetJobIds.add(JobID.Id);
        }
        
        //List<Note> lstJobNotes=[Select Id,Title, Body,ParentId,Parent.Name from Note where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        List < ContentDocumentLink > lstJobNotes = new List < ContentDocumentLink > ();
        List < ContentDocumentLink > lstJobChatter = new List < ContentDocumentLink > (); //and ContentDocument.FileExtension!='snote'
        if (SetJobIds.size() > 0) {
            if(!Schema.sObjectType.ContentDocumentLink.isAccessible()){
                return null;
            }
            lstJobNotes = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink where LinkedEntityId IN: SetJobIds and ContentDocument.FileExtension = 'snote' WITH SECURITY_ENFORCED];
            lstJobChatter = [SELECT Id, LinkedEntityId,  ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink where LinkedEntityId IN: SetJobIds and ContentDocument.FileExtension != 'snote'  WITH SECURITY_ENFORCED];
        }
        List < Attachment > lstJobAttach = [Select Id, Name, ParentId from Attachment where ParentId IN: lstJob  WITH SECURITY_ENFORCED ORDER BY CreatedDate LIMIT 1000];
        // List<Job__c> lstJobChatter= [Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title,ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks where ContentDocument.FileExtension!='snote') from Job__c where Id IN:lstJob and  Status__c='Active' ORDER BY Job_Auto_Number__c DESC LIMIT 1000];        
        
        JobDataUnderCmp.put('Jobs', lstJob);
        JobDataUnderCmp.put('Job__Notes', lstJobNotes);
        JobDataUnderCmp.put('Job__Attachments', lstJobAttach);
        JobDataUnderCmp.put('Job__ChatterFiles', lstJobChatter);
        return JobDataUnderCmp;
    }
    
    @AuraEnabled
    public static list < String > fetchPicklistvalues() {
        list < String > Options = new list < String > ();
        List < Schema.PicklistEntry > Picklist = Job__c.Status__c.getDescribe().getPicklistValues();
        Options.add('All Jobs');
        for (Schema.PicklistEntry Op: Picklist) {
            Options.add(Op.getValue());
        }
        return Options;
    }
    
    @AuraEnabled
    public static List < Campaign_Template__c > getCampaignTemplates() {
       
        if(!Schema.sObjectType.Campaign_Template__c.isAccessible()){
            return null;
        }
        return [select Id, Name from Campaign_Template__c WITH SECURITY_ENFORCED];
    }
    
    @AuraEnabled
    public static String ImpCampTempJobs(string CmpId, String selectedCTemp) {
        
        if (selectedCTemp != null && selectedCTemp != '') {
            List < Job__c > CTJInsert = new List < Job__c > ();
            set < Id > schTempSet = new set < Id > ();
            List < Schedule_Template__c > scheduleTempList = new List < Schedule_Template__c > ();
            Map < Id, List < Schedule_Task__c >> tempTasksMap = new Map < Id, List < Schedule_Task__c >> ();
            List < Campaign_Jobs__c > campJobsList = new List < Campaign_Jobs__c > ();
            List < Campaign_Team__c > campTeamList = new List < Campaign_Team__c > ();
            List < Job_Team__c > jobTeamListInsert = new List < Job_Team__c > ();
            // List<Schedule_Task__c> scheduleTaskInsert =new List<Schedule_Task__c>();
            List<ScheduleTaskRole__c> lstScheduleTaskRole=new List<ScheduleTaskRole__c>();
            List < Job_Task__c > lstJobTaskInsert = new List < Job_Task__c > ();
            List<Job_Task_Role__c> lstJobTaskRoleInsert=new List<Job_Task_Role__c>();
            
            Set < Date > holidays = new Set < Date > ();
            if(!Schema.sObjectType.Holiday__c.isAccessible()){
                return 'No Access';
            }
            for (Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL WITH SECURITY_ENFORCED]) {
                holidays.add(hc.Date__c);
            }
            if(!Schema.sObjectType.Campaign_Template__c.isAccessible()){
                return 'No Access';
            }
            if(!Schema.sObjectType.Campaign_Jobs__c.isAccessible()){
                return 'No Access';
            }
            if(!Schema.sObjectType.Campaign_Team__c.isAccessible()){
                return 'No Access';
            }
            Campaign_Template__c CTempRecord = [select Id, Name, Schedule_Calc__c, (select Id, Name, Media_Type__c, Schedule_Template__c, Creative_Brief_Template__c, Campaign_Template__c from Campaign_Jobs__r), (select Id, Role__c, Email__c, Staff__c from Campaign_Team__r) from Campaign_Template__c where Id = : selectedCTemp WITH SECURITY_ENFORCED];
            for (Campaign_Jobs__c cmp: CTempRecord.Campaign_Jobs__r) {
                schTempSet.add(cmp.Schedule_Template__c);
            }
            campJobsList.addAll(CTempRecord.Campaign_Jobs__r);
            campTeamList.addAll(CTempRecord.Campaign_Team__r);
           
            if(!Schema.sObjectType.Campaign__c.isAccessible()){
                return 'No Access';
            }
            
            Campaign__c CampaignRecord = [select Id, Name, Start_Date__c, End_Date__c,Campaign_Description__c,Description__c,Dummy_Date_1__c,Dummy_Date_2__c	 from Campaign__c where Id = : CmpId WITH SECURITY_ENFORCED];
            string CmpName=CampaignRecord.Name;
            
            if(!Schema.sObjectType.Job__c.isAccessible()){
                return 'No Access';
            }
            
            List < Job__c > CTjobs = [Select Id, Job_Id__c, Budgeted_Cost__c, Name, Campaign_Template__c, Job_Auto_Number__c, JS_Client__r.name, Invoice_Actual_Amounts__c, Status__c, Estimate_Total__c from Job__c where Campaign__c = : CmpId and Campaign_Template__c = : selectedCTemp WITH SECURITY_ENFORCED];
            if (CTjobs.size() > 0) {
                return 'This Template already Imported for this Campaign';
            } else {
                //campJobsList=[select id,name,Media_Type__c,Schedule_Template__c,Creative_Brief_Template__c,Campaign_Template__c from Campaign_Jobs__c where Campaign_Template__c=:selectedCTemp];
                if (CTempRecord.Schedule_Calc__c==null){
                    return 'Selected Campaign Template doesn\'t have Schedule Cal.Please update it';
                }
                else if (campJobsList.size() == 0) {
                    return 'This Template doesn\'t have jobs to import';
                } else if (CTempRecord.Schedule_Calc__c == 'Start Date' && CampaignRecord.Start_Date__c == null) {
                    return 'Please Update this Campaign with Start Date to Process the Campaign Template Import Functionality.';
                } else if (CTempRecord.Schedule_Calc__c == 'End Date' && CampaignRecord.End_Date__c == null) {
                    return 'Please Update this Campaign with End Date to Process the Campaign Template Import Functionality';
                } else {
                    try {
                        
                        Boolean startDateApproach = true;
                        if (CTempRecord.Schedule_Calc__c == 'Start Date') {
                            startDateApproach = true;
                            if(!Schema.sObjectType.Schedule_Template__c.isAccessible()){
                                return 'No Access';
                            }
                             if(!Schema.sObjectType.Schedule_Task__c.isAccessible()){
                                return 'No Access';
                            }
                            scheduleTempList = [SELECT Id, Name, (select Id, Name, Days__c, GL_Code__c, Locked__c, Report__c, Task_Order__c, Hours__c, Roles__c from Schedule_Tasks__r Order BY Task_Order__c ASC) FROM Schedule_Template__c where Id IN: schTempSet WITH SECURITY_ENFORCED];
                        } else {
                            startDateApproach = false;
                              if(!Schema.sObjectType.Schedule_Template__c.isAccessible()){
                                return 'No Access';
                            }
                             if(!Schema.sObjectType.Schedule_Task__c.isAccessible()){
                                return 'No Access';
                            }
                            scheduleTempList = [SELECT Id, Name, (select Id, Name, Days__c, GL_Code__c, Locked__c, Report__c, Task_Order__c, Hours__c, Roles__c from Schedule_Tasks__r Order BY Task_Order__c DESC) FROM Schedule_Template__c where Id IN: schTempSet WITH SECURITY_ENFORCED];
                        }
                        
                        for (Schedule_Template__c sTemp: scheduleTempList) {
                            tempTasksMap.put(sTemp.Id, new list <Schedule_Task__c> (sTemp.Schedule_Tasks__r));
                        }
                        
                        set<Id> STempLIst=tempTasksMap.Keyset();
                        Map<Id,List<ScheduleTaskRole__c>> STaskMapwithRoles=new Map<Id,List<ScheduleTaskRole__c>>();
                        if(!Schema.sObjectType.ScheduleTaskRole__C.isAccessible()){
                            return 'No Access';
                        }
                        List<Schedule_Task__c> sTasksWithRoles=[select Id,(Select Id,Name,Schedule_Task__c,Schedule_Task__r.Schedule_Template__c from ScheduleTaskRole__r) Name, Days__c, GL_Code__c, Locked__c, Report__c, Task_Order__c, Hours__c, Roles__c from Schedule_Task__c Where Schedule_Template__c IN:STempLIst WITH SECURITY_ENFORCED];
                        for(Schedule_Task__c sTsk:sTasksWithRoles){
                            STaskMapwithRoles.put(sTsk.Id,new list <ScheduleTaskRole__c>(sTsk.ScheduleTaskRole__r) );
                        }
                        
                        for (Campaign_Jobs__c cj: campJobsList) {
                            Job__c J = new Job__c();
                            if(Schema.sObjectType.Job__c.fields.Name.isCreateable()){
                                J.Name = cj.name;
                            }
                            if(Schema.sObjectType.Job__c.fields.Campaign__c.isCreateable()){
                                J.Campaign__c = CmpId;
                            }
                            if(Schema.sObjectType.Job__c.fields.Media_Types__c.isCreateable()){
                                J.Media_Types__c = cj.Media_Type__c;
                            }
                            if(Schema.sObjectType.Job__c.fields.Schedule_Template__c.isCreateable()){
                                J.Schedule_Template__c = cj.Schedule_Template__c;
                            }
                            if(Schema.sObjectType.Job__c.fields.Specification_Template__c.isCreateable()){
                                J.Specification_Template__c = cj.Creative_Brief_Template__c;
                            }
                            if(Schema.sObjectType.Job__c.fields.Schedule_Calc__c.isCreateable()){
                                J.Schedule_Calc__c = CTempRecord.Schedule_Calc__c;
                            }
                            if (CTempRecord.Schedule_Calc__c == 'Start Date') {
                                if(Schema.sObjectType.Job__c.fields.Start_Date__c.isCreateable()){
                                    J.Start_Date__c = CampaignRecord.Start_Date__c;
                                }
                            }  
                            if (CTempRecord.Schedule_Calc__c == 'End Date') {
                                if(Schema.sObjectType.Job__c.fields.Due_Date__c.isCreateable()){
                                    J.Due_Date__c = CampaignRecord.End_Date__c;
                                }
                            }
                            if(Schema.sObjectType.Job__c.fields.Campaign_Template__c.isCreateable()){
                                J.Campaign_Template__c = cj.Campaign_Template__c;
                            }
                            Campaign_Controls__c jscc=Campaign_Controls__c.getOrgDefaults();
                            boolean CNECustomDataCopySetting=jscc.Copy_Description_and_Message__c;
                            system.debug('----CNECustomDataCopySetting----'+CNECustomDataCopySetting);
                            if(CNECustomDataCopySetting){ 
                                if(Schema.sObjectType.Job__c.fields.Name.isCreateable()){
                                    J.Name = CmpName+' - '+cj.name;
                                }
                                if(Schema.sObjectType.Job__c.fields.Start_Date__c.isCreateable()){
                                    J.Start_Date__c = CampaignRecord.Start_Date__c;
                                }
                                if(Schema.sObjectType.Job__c.fields.Due_Date__c.isCreateable()){
                                    J.Due_Date__c = CampaignRecord.End_Date__c;
                                }
                                if(Schema.sObjectType.Job__c.fields.Dummy_Date_1__c.isCreateable()){
                                    J.Dummy_Date_1__c = CampaignRecord.Dummy_Date_1__c;
                                }
                                if(Schema.sObjectType.Job__c.fields.Dummy_Date_2__c.isCreateable()){
                                    J.Dummy_Date_2__c = CampaignRecord.Dummy_Date_2__c;
                                }
                                if(Schema.sObjectType.Job__c.fields.Creative_Overview__c.isCreateable()){
                                    J.Creative_Overview__c=CampaignRecord.Campaign_Description__c;
                                }
                                if(Schema.sObjectType.Job__c.fields.Job_Description__c.isCreateable()){
                                    J.Job_Description__c=CampaignRecord.Description__c;
                                }
                            }
                            CTJInsert.add(J);
                        }
                        if(Schema.sObjectType.Job__c.isCreateable()){
                            Insert CTJInsert;
                        }
                        
                        for (Job__c Jb: CTJInsert) {
                            for (Campaign_Team__c cmpTeam: campTeamList) {
                                Job_Team__c jobTeam = new Job_Team__c();
                                if(Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()){
                                    jobTeam.Staff__c = cmpTeam.Staff__c;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()){
                                    jobTeam.Role__c = cmpTeam.Role__c;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()){
                                    jobTeam.Email__c = cmpTeam.Email__c;
                                }
                                if(Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()){
                                    jobTeam.Job__c = Jb.Id;
                                }
                                jobTeamListInsert.add(jobTeam);
                            }
                        }
                        if(Schema.sObjectType.Job_Team__c.isCreateable()){
                            Insert jobTeamListInsert;
                        }
                        
                        List<Job_Team__c> JobTeamList=[select Id,Staff__c,Email__c,Role__c,Job__c,Job__r.Schedule_Template__c From Job_Team__c where Id IN:jobTeamListInsert WITH SECURITY_ENFORCED Order by CreatedDate Limit:campTeamList.size()];
                        
                        List <Id> stScheduleTaskId = new List <Id> ();
                        //Map<Id,Map<String,Id>> JobwithSTasksMap = new Map<Id,Map<String,Id>>();
                        //Map<Id,Map<Id,Id>> JobTasksMap = new Map<Id,Map<Id,Id>>();
                        
                        for (Job__c Jb: CTJInsert) {
                            
                            Date std;
                            Datetime NTSD;
                            if (startDateApproach) {
                                std = Date.newInstance(Jb.Start_Date__c.Year(), Jb.Start_Date__c.month(), Jb.Start_Date__c.Day());
                            } else {
                                std = Date.newInstance(Jb.Due_Date__c.Year(), Jb.Due_Date__c.month(), Jb.Due_Date__c.Day());
                            }
                            List <Schedule_Task__c> scheduleTaskList = new List < Schedule_Task__c > ();
                            scheduleTaskList = tempTasksMap.get(Jb.Schedule_Template__c);
                            
                            //Map<String,Id> StaskMap=new Map<String,Id>();
                            for (Integer i = 0; i < scheduleTaskList.size(); i++) {
                                //StaskMap.put(scheduleTaskList[i].Name,scheduleTaskList[i].Id);
                                stScheduleTaskId.add(scheduleTaskList[i].Id);
                                Job_Task__c jt = new Job_Task__c();
                                if (i == 0) {
                                    if (startDateApproach && Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {
                                        jt.Start_Date__c = std;
                                    } else {
                                        if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable())
                                        {
                                            jt.Due_Date__c = std;
                                        }
                                    }
                                    
                                } else {
                                    Date d2 = Date.newInstance(NTSD.Year(), NTSD.Month(), NTSD.Day());
                                    if (startDateApproach && Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {
                                        jt.Start_Date__c = d2;
                                    } else {
                                        if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable())
                                        {
                                            jt.Due_Date__c = d2;
                                        }
                                    }
                                }
                                
                                Datetime dtStartDate;
                                if (startDateApproach) {
                                    dtStartDate = DateTime.newInstance(jt.Start_Date__c.Year(), jt.Start_Date__c.Month(), jt.Start_Date__c.Day());
                                } else {
                                    dtStartDate = DateTime.newInstance(jt.Due_Date__c.Year(), jt.Due_Date__c.Month(), jt.Due_Date__c.Day());
                                }
                                system.debug('Start Date is : ' + dtStartDate);
                                if(Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable())
                                {
                                    jt.Days__c = scheduleTaskList[i].Days__c;
                                }
                                Integer jCount = 0;
                                
                                while (true) {
                                    Date d3 = Date.newInstance(dtStartDate.Year(), dtStartDate.Month(), dtStartDate.Day());
                                    
                                    // Skip Holiday and Sat-Sun while calulation Due Date & Revised Due Date
                                    if ((dtStartDate.format('E') != 'Sat' && dtStartDate.format('E') != 'Sun') && !(holidays.contains(d3))) {
                                        jCount = jCount + 1;
                                        if (jCount > jt.Days__c) {
                                            break;
                                        }
                                        system.debug('jCount======' + jCount);
                                        system.debug('==========' + dtStartDate);
                                        
                                        system.debug('===========' + dtStartDate.format('E'));
                                        
                                        if (startDateApproach) {
                                            dtStartDate = dtStartDate.addDays(1);
                                        } else {
                                            dtStartDate = dtStartDate.addDays(-1);
                                        }
                                        system.debug('After adding 1 day : ' + dtStartDate);
                                        
                                    } else {
                                        system.debug('==========' + dtStartDate);
                                        
                                        if (startDateApproach) {
                                            dtStartDate = dtStartDate.addDays(1);
                                        } else {
                                            dtStartDate = dtStartDate.addDays(-1);
                                        }
                                        continue;
                                    }
                                }
                                system.debug('Calculation============' + dtStartDate);
                                
                                Date d1 = Date.newInstance(dtStartDate.Year(), dtStartDate.Month(), dtStartDate.Day());
                                system.debug('D1============' + dtStartDate);
                                
                                if (startDateApproach && Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) {
                                    jt.Due_Date__c = d1;
                                } else {
                                    if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()){
                                        jt.Start_Date__c = d1;
                                    }
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()){
                                    jt.Revised_Due_Date__c = jt.Due_Date__c;
                                }
                                System.debug('Due Date : ' + jt.Due_Date__c);
                                
                                NTSD = DateTime.valueOf(dtStartDate);
                                if(Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()){
                                    jt.Name = scheduleTaskList[i].Name;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()){
                                    jt.GL_Code__c = scheduleTaskList[i].GL_Code__c;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()){
                                    jt.Report__c = scheduleTaskList[i].Report__c;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()){
                                    jt.Locked__c = scheduleTaskList[i].Locked__c;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Hours__c.isCreateable()){
                                    jt.Hours__c = scheduleTaskList[i].Hours__c;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Schedule_Roles__c.isCreateable()){
                                    jt.Schedule_Roles__c = scheduleTaskList[i].Roles__c;
                                }
                                if(Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()){
                                    jt.Task_Order__c = scheduleTaskList[i].Task_Order__c;
                                }
                                
                                System.Debug('Task Order @@@@@@@@@@@@@@@@@@@@@@@@@' + jt.Task_Order__c);
                                if(Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()){
                                    jt.Job__c = Jb.Id;
                                }
                                //mp1.put(lstScheduleTask[i].Name,lstScheduleTask[i].Id);
                                lstJobTaskInsert.add(jt);
                                
                            }
                            
                            //JobwithSTasksMap.put(Jb.Schedule_Template__c,StaskMap);
                        }
                        if(Schema.sObjectType.Job_Task__c.isCreateable()){
                            Insert lstJobTaskInsert;
                        }
                        
                        Map<Id,List<ScheduleTaskRole__c>> mapwithTasks=new Map<Id,List<ScheduleTaskRole__c>>();
                        //List<Job_Task__c> JobTaskList=[select Id,Name,Job__c,Job__r.Schedule_Template__c from Job_Task__c where Id IN:lstJobTaskInsert];
                        for(Integer i=0; i<lstJobTaskInsert.size(); i++){
                            mapwithTasks.put(lstJobTaskInsert[i].Id,STaskMapwithRoles.get(stScheduleTaskId[i]));
                        }    
                        
                        //lstScheduleTaskRole=[Select Id,Name,Schedule_Task__c,Schedule_Task__r.Schedule_Template__c,Schedule_Task__r.Name from ScheduleTaskRole__c where Schedule_Task__c IN :stScheduleTaskId];
                        for(Job_Task__c jbt:lstJobTaskInsert){
                            for(ScheduleTaskRole__c st1:mapwithTasks.get(jbt.Id)){
                                //Job_Team__c[]=[Select Staff__c,Email__c from Job_Team__c where Role__c=: st1.Name and Job__c=:jobId ];
                                for(Job_Team__c jteam: JobTeamList){
                                    if(jteam.Role__c==st1.Name){
                                        Job_Task_Role__c objJobTaskRole=new Job_Task_Role__c();
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()){
                                            objJobTaskRole.Name=st1.Name;
                                        }
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()){
                                            objJobTaskRole.Job_Task__c=jbt.Id;//mapwithTasks.get(st1.Schedule_Task__c);
                                        }
                                        String strStaff=jteam.Staff__c;  
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()){
                                            objJobTaskRole.User__c=strStaff;
                                        }
                                        if(Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()){
                                            objJobTaskRole.Email__c=jteam.Email__c;
                                        }
                                        lstJobTaskRoleInsert.add(objJobTaskRole);
                                    }
                                }
                            }  
                        }
                        if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){
                            Insert lstJobTaskRoleInsert;
                        }
                    } catch (Exception e) {
                        return '' + e.getMessage();
                    }
                }
            }
            
            return 'Sucessfully Imported Campaign Template Jobs';   
        } else { 
            return 'Please select the  Campaign Template';
        }
        
        
    }
    
    @AuraEnabled
    public static Map < String, list < SObject >> RefreshJobNotes(Id recordId, String JobStatus) {
        System.debug('===recordId======' + recordId);
        System.debug('===JobStatus======' + JobStatus);
        set < Id > SetJobIds = new set < Id > ();
        Map < String, list < SObject >> JobDataUnderCmp = new Map < String, list < SObject >> ();
        List < Job__c > lstJob = new List < Job__c > ();
        if (JobStatus == 'All Jobs')
            lstJob = [Select Id, Name, Job_Auto_Number__c, JS_Client__r.name, Status__c, Budgeted_Cost__c, Invoice_Actual_Amounts__c, Estimate_Total__c from Job__c where Campaign__c = : recordId WITH SECURITY_ENFORCED ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        else
            lstJob = [Select Id, Job_Auto_Number__c, Name, JS_Client__r.name, Status__c, Budgeted_Cost__c, Invoice_Actual_Amounts__c, Estimate_Total__c from Job__c where Campaign__c = : recordId and Status__c = : JobStatus WITH SECURITY_ENFORCED ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        
        for (Job__c JobID: lstJob) {
            SetJobIds.add(JobID.Id);
        }
        
        List < ContentDocumentLink > lstJobNotes = new List < ContentDocumentLink > (); //and ContentDocument.FileExtension='snote'
        List < ContentDocumentLink > lstJobChatter = new List < ContentDocumentLink > (); //and ContentDocument.FileExtension!='snote'
        if (SetJobIds.size() > 0) {
            lstJobNotes = [SELECT Id, LinkedEntityId,  ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink where LinkedEntityId IN: SetJobIds and ContentDocument.FileExtension = 'snote' WITH SECURITY_ENFORCED ];
            lstJobChatter = [SELECT Id, LinkedEntityId,  ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLink where LinkedEntityId IN: SetJobIds and ContentDocument.FileExtension != 'snote' WITH SECURITY_ENFORCED ];
        }
        List < Attachment > lstJobAttach = [Select Id, Name, ParentId from Attachment where ParentId IN: lstJob  WITH SECURITY_ENFORCED ORDER BY CreatedDate LIMIT 1000];
        //  List<Job__c> lstJobChatter= [Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title,ContentDocument.FileExtension, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks where ContentDocument.FileExtension!='snote') from Job__c where Id IN:lstJob and  Status__c='Active' ORDER BY Job_Auto_Number__c DESC LIMIT 1000];        
        
        // List<Note> lstJobNotes=[Select Id,Title, Body,ParentId,Parent.Name from Note where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        //List<Attachment> lstJobAttach=[Select Id,Name,ParentId,Parent.Name from Attachment where ParentId IN:lstJob ORDER BY CreatedDate LIMIT 1000];
        //List<Job__c> lstJobChatter= [Select Id,Name,Job_Auto_Number__c,JS_Client__r.name,Status__c,Budgeted_Cost__c,Invoice_Actual_Amounts__c,Estimate_Total__c,(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedBy.Name, ContentDocument.LastModifiedDate FROM ContentDocumentLinks) from Job__c where Id IN:lstJob  ORDER BY Job_Auto_Number__c DESC LIMIT 1000];        
        
        JobDataUnderCmp.put('Jobs', lstJob);
        JobDataUnderCmp.put('Job__Notes', lstJobNotes);
        JobDataUnderCmp.put('Job__Attachments', lstJobAttach);
        JobDataUnderCmp.put('Job__ChatterFiles', lstJobChatter);
        
        return JobDataUnderCmp;
        
    }
    
    
    // LWC Methods from here
    
}