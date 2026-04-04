public class CustomJobDuplicateExt {
	@AuraEnabled
    public static List<String> duplicateJob(String JobId) {
        List<String> resResult=new List<String>();
        String NewJobId='';
        string isError='false';
        String MTName,ClientName,CCName,ScheduleTemp,CampaignName,SpecTempName,JobName,CreatedBy,strJob_Id,clientid,oldJobId,status,stsNotes;
        boolean recalsch,ShowProductionEstimate;
        Date dtStartDate,dtDueDate,shpdate;
        String UserName=UserInfo.getName();
        
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        list<Staff__c> staffs=new list<Staff__c>();
        list<Client_Contact__c> CCs=new list<Client_Contact__c>();
        list<Vendor_Contact__c> VCs=new list<Vendor_Contact__c>();
        
        Set<String> ClientNames=new set<String>();
        Set<String> VendorNames=new set<String>();
        Set<String> staffNames=new set<String>();
        
        Map<String,Schema.SObjectField> jobFieldsMap = Schema.getGlobalDescribe().get('Job__c').getDescribe().fields.getMap();//Get object fileds apis 
        string queryFields='';
        List<String> editableFields = new List<String>();//List to store only ediatable fields of object
        
        //Framing dynamic query with only ediatable fields
        for(Schema.SObjectField fieldRef : jobFieldsMap.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.isUpdateable()) {
                editableFields.add(fieldResult.getname());
                if(queryFields=='' || queryFields==null){
                    queryFields=fieldResult.getname();
                }
                else{
                   //  if(fieldResult.getname()=='Creative_Overview__c'){//fieldResult.getname()=='Dummy_Date_1__c' ||
                    // }else{
                    	queryFields +=','+fieldResult.getname();
                   //  }
                }
            }
        }
        system.debug('queryFields----'+queryFields);
        string queryJob ='select '+queryFields+' From '+'Job__c'+' where id=:JobId'+'  limit 1';//WITH SECURITY_ENFORCED //Dynamic query with editable fields
        system.debug('---queryJob----'+queryJob);
        Job__c j=Database.query(queryJob);
        system.debug('---valuesQeryResult----'+j);
        //Job__c j=[select id, Name, Media_Types__c, Schedule_Template__c, Start_Date__c, Due_Date__c, JS_Client__c,JS_Client_Contact__c,UpdateSchedDateFieldCheck__c, Creative_Overview__c,Campaign__c, Client_Contact__c, Specification_Template__c, CreatedById, Client__c, Budgeted_Cost__c,  Completion_Date__c, Number_of_Days__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Date_5__c, Dummy_Date_6__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Picklist_5__c, Dummy_Picklist_6__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c, Dummy_Text_5__c, Dummy_Text_6__c, Estimate_Total__c, Flag__c, Job_Description__c, marked_Done__c, Schedule_Calc__c, Status__c, Status_Notes__c, Traffic_Notes__c from Job__c  where id =: JobId Limit 1];
        //[select id,Name,Media_Types__c,Schedule_Template__c,Start_Date__c,Due_Date__c,JS_Client__c,Campaign__c,Client_Contact__c,Specification_Template__c,CreatedById from Job__c  where id =: objJob.id Limit 1];
        clientid=j.JS_Client__c;
        
        String query ='SELECT id,name,Active__c from Staff__c where Active__c=true and IsDeleted__c=False  WITH SECURITY_ENFORCED order by name';
        
        staffs = Database.query(query); 
        
        for(Staff__c s:staffs){
            staffNames.add(s.name);
        }
        
        
        String query1 ='SELECT id,name,Active__c from Client_Contact__c Where Client__c=:clientid AND Active__c=true WITH SECURITY_ENFORCED Order by name';
        
        CCs= Database.query(query1);   
        
        for(Client_Contact__c  s:CCs){
            ClientNames.add(s.name);
        }   
        
        String query2 ='SELECT id,name,Active__c from Vendor_Contact__c where Active__c=true  WITH SECURITY_ENFORCED order by name';
        
        VCs= Database.query(query2);
        
        for(Vendor_Contact__c  s:VCs){
            VendorNames.add(s.name);
        }  
        
        
        OldJobId=j.Id;
        
        JobName='Dup : '+DateTime.Now()+' '+j.Name;
        if(JobName.length() > 80)
        {
            JobName = JobName.substring(0,80);
        }
        system.debug('---JobName----'+JobName);
        //CreatedBy=j.CreatedById;
        
        dtStartDate=system.today();
        dtDueDate=system.today();
        status='Active';
        shpdate=null;
        stsNotes='';
        
        try
        {
            system.debug('Client ======'+ClientName);
            //Assign fields values to duplicate job
            Job__c dupJob = new Job__c();
            for(String fieldName:editableFields){
                system.debug('---fieldName----'+fieldName);
                
                if(fieldName=='name'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,JobName);
                }
                else if(fieldName=='Start_Date__c'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,dtStartDate);
                }
                else if(fieldName=='Due_Date__c'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,dtDueDate);
                }
                else if(fieldName=='Dummy_Date_1__c'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,shpdate);
                }
                else if(fieldName=='Creative_Overview__c'){
                    system.debug('---fieldName---inside-'+fieldName);
                    dupJob.put(fieldName,stsNotes);
                }
                 else if(fieldName=='Status__c'){
                    system.debug('---fieldName---inside-'+fieldName);
                     dupJob.put(fieldName,status);
                }
                else if(fieldName=='OwnerId'){
                    system.debug('---fieldName---inside-'+fieldName);
                }
                else if(fieldName=='Revision__c' || fieldName=='Reprint__c'){
                    dupJob.put(fieldName,false);
                }
                else if(fieldName=='Revision_Increment__c')
                {
                    dupJob.put(fieldName,0);
                }     
              else if(fieldName =='Rollout__c')
                {
                   dupJob.put(fieldName,'');  
                }
                else if(fieldName =='Overs_to_Storefront__c')
                {
                   dupJob.put(fieldName,false);  
                }
               else if(fieldName == 'Project_Batch__c'){
                dupJob.put(fieldName,'');     
                }
                else{  
                    dupJob.put(fieldName,j.get(fieldName));
                }
                system.debug('---dup job----'+dupJob);
            }
            system.debug('---dup job----'+dupJob);
            if(Job__c.sObjectType.getDescribe().isCreateable()){
                insert dupJob;
            }
            
            NewJobId=dupJob.Id;
            
            // Trigger invokes JobTeam record, but we are duplicating record here.So, We will delete this records and create from retrieving from Old Job
            List<Job_Team__c> lstJobTeam=new List<Job_Team__c>();
            lstJobTeam=[Select id from Job_Team__c where Job__c=: dupJob.id WITH SECURITY_ENFORCED];
            if(Job_Team__c.sObjectType.getDescribe().isDeletable()){
                delete lstJobTeam;
            }
            
            // Trigger invokes JobSpec record, but we are duplicating record here.So, We will delete this records and re-create from retrieving from Old Job
            List<Job_Spec__c> deleteJobSpec=[Select id from Job_Spec__c where Job__c=:dupJob.id WITH SECURITY_ENFORCED];
            if(Job_Spec__c.sObjectType.getDescribe().isDeletable()){
                delete deleteJobSpec; 
            }  
            
            // Retrieve Team records
            lstJobTeam=[Select id,Job__c, Role__c,Staff__c,Email__c from Job_Team__c where Job__c=:OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
            List<Job_Team__c> insertJobTeam=new List<Job_Team__c>();
            
            for(Job_Team__c jt1:lstJobTeam)
            {
                if(staffNames.contains(jt1.Staff__c) || ClientNames.contains(jt1.Staff__c) || VendorNames.contains(jt1.Staff__c)){
                    
                    Job_Team__c jt=new Job_Team__c();
                    if (Schema.sObjectType.Job_Team__c.fields.Job__c.isCreateable()) { 
                        jt.Job__c=dupJob.id;}
                    if (Schema.sObjectType.Job_Team__c.fields.Role__c.isCreateable()) {  jt.Role__c=jt1.Role__c;}
                    if (Schema.sObjectType.Job_Team__c.fields.Staff__c.isCreateable()) {  jt.Staff__c=jt1.Staff__c;}
                    if (Schema.sObjectType.Job_Team__c.fields.Email__c.isCreateable()) {  jt.Email__c=jt1.Email__c;}
                    insertJobTeam.add(jt);
                }
                
                
            }
            if(Schema.sObjectType.Job_Team__c.isCreateable()){ 
                insert insertJobTeam;
            }
            
            
            System.debug('Job Team records for duplicate Job are created');
            
            List<Job_Task__c> insertJobTask=new List<Job_Task__c>();
            List<Job_Task__c> lstJT=new List<Job_Task__c>();
            Set<Id> OldTaskId=new Set<Id>();
            Map<String,Id> mp1 = new Map<String,Id>();
            Map<Id,Id> mp2 = new Map<Id,Id>();
            
            lstJT=[Select id,Name,GL_Code__c,Report__c,Locked__c,Days__c,Due_Date__c,Revised_Due_Date__c, Task_Order__c,Start_Date__c from Job_Task__c where Job__c=:OldJobId WITH SECURITY_ENFORCED ORDER BY Start_Date__c];
            
            for(Job_Task__c task:lstJT)
            {
                OldTaskId.add(task.id);
                Job_Task__c objJT = new Job_Task__c();
                if (Schema.sObjectType.Job_Task__c.fields.Name.isCreateable()) { 
                    objJT.Name = task.Name;}
                if (Schema.sObjectType.Job_Task__c.fields.GL_Code__c.isCreateable()) { objJT.GL_Code__c = task.GL_Code__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Report__c.isCreateable()) { objJT.Report__c = task.Report__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Locked__c.isCreateable()) { objJT.Locked__c = task.Locked__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Days__c.isCreateable()) {  objJT.Days__c = task.Days__c;}
                //code added to duplicate the start date for all the tasks
                if (Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isCreateable()) {  objJT.Start_Date__c = task.Start_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isCreateable()) { objJT.Due_Date__c = task.Due_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isCreateable()) {  objJT.Revised_Due_Date__c = task.Revised_Due_Date__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Task_Order__c.isCreateable()) {  objJT.Task_Order__c = task.Task_Order__c;}
                if (Schema.sObjectType.Job_Task__c.fields.Job__c.isCreateable()) { objJT.Job__c = dupJob.id;}
                
                mp1.put(task.Name,task.id);
                insertJobTask.add(objJT);
            }
            if(Schema.sObjectType.Job_Task__c.isCreateable()){ 
                insert insertJobTask;}
            
            System.debug('Schedule record are inserted');
            
            for(Job_Task__c jt:insertJobTask)
            {
                mp2.put(mp1.get(jt.Name),jt.Id);
            }
            
            List<Job_Task_Role__c> lstJTR=[Select id,Name,User__c,Job_Task__c,Email__c from Job_Task_Role__c where Job_Task__c IN:OldTaskId WITH SECURITY_ENFORCED];
            
            List<Job_Task_Role__c> insertJTR=new List<Job_Task_Role__c>();
            
            for(Job_Task_Role__c taskRole:lstJTR)
            {
                if(staffNames.contains(taskRole.User__c) || ClientNames.contains(taskRole.User__c) || VendorNames.contains(taskRole.User__c)){
                    Job_Task_Role__c objJTR=new Job_Task_Role__c();
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()) { 
                        objJTR.Name=taskRole.Name;}
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Email__c.isCreateable()) {  objJTR.Email__c=taskRole.Email__c; } // added by sugunakar.
                    if (Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()) {  objJTR.User__c=taskRole.User__c;}
                    if (Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()) {  objJTR.Job_Task__c=mp2.get(taskRole.Job_Task__c);}
                    insertJTR.add(objJTR);
                }
            }
            if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){ 
                insert insertJTR;
            }
            
            System.debug('Job Task Role are inserted');
            
            List<Job_Spec__c> insertJobSpec=new List<Job_Spec__c>();
            List<Job_Spec__c> lstJS=[Select id,Name,Description__c,Job__c,Creative_Brief_Template__c from Job_Spec__c where Job__c=: OldJobId WITH SECURITY_ENFORCED];
            
            for(Job_Spec__c spec:lstJS)
            {
                Job_Spec__c objJS=new Job_Spec__c();
                if (Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()) { 
                    objJS.Name=spec.Name;}
                if (Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()) {   objJS.Description__c=spec.Description__c;}
                if (Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()) { objJS.Job__c=dupJob.id;}
                if (Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()) { objJS.Creative_Brief_Template__c=spec.Creative_Brief_Template__c;}
                insertJobSpec.add(objJS);
            }
            if(Schema.sObjectType.Job_Spec__c.isCreateable()){ 
                insert insertJobSpec;
            }
            
            System.debug('Job Spec Records are re-created');
            
            
            if(ShowProductionEstimate){
                
                List<Production_Estimate__c> insertProdEstimate=new List<Production_Estimate__c>();
                List<Production_Estimate__c> lstProdEstimate=[Select id,Name,Job__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
                                                              Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where Job__c=: OldJobId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
                
                for(Production_Estimate__c p:lstProdEstimate)
                {
                    Production_Estimate__c  objJPE=new Production_Estimate__c  ();
                    if (Schema.sObjectType.Production_Estimate__c.fields.name.isCreateable()) {
                        objJPE.name=p.Name;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Job__c.isCreateable()) {objJPE.Job__c=dupJob.id;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Calc_Unit__c.isCreateable()) { objJPE.Calc_Unit__c=p.Calc_Unit__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Color__c.isCreateable()) {objJPE.Color__c=p.Color__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Commission__c.isCreateable()) { objJPE.Commission__c=p.Commission__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()) { objJPE.GL_Department__c=p.GL_Department__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()) { objJPE.GL_Code__c=p.GL_Code__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.of_Pages__c.isCreateable()) { objJPE.of_Pages__c=p.of_Pages__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Length_in_Inches__c.isCreateable()) {objJPE.Length_in_Inches__c=p.Length_in_Inches__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Material_Item__c.isCreateable()) { objJPE.Material_Item__c=p.Material_Item__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()) {objJPE.Quantity__c=p.Quantity__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isCreateable()) {objJPE.Qty_Up__c=p.Qty_Up__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()) {objJPE.SheetQtyUpforUsed__c=p.SheetQtyUpforUsed__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.EachQtyUpforUsed__c.isCreateable()) {objJPE.EachQtyUpforUsed__c=p.EachQtyUpforUsed__c;} 
                    if (Schema.sObjectType.Production_Estimate__c.fields.Sided__c.isCreateable()) {objJPE.Sided__c=p.Sided__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()) {objJPE.Vendor__c=p.Vendor__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Width_in_Inches__c.isCreateable()) {objJPE.Width_in_Inches__c  =p.Width_in_Inches__c  ;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.Equipment_Type__c.isCreateable()) {objJPE.Equipment_Type__c=p.Equipment_Type__c;}
                    if (Schema.sObjectType.Production_Estimate__c.fields.PE_Template__c.isCreateable()) {objJPE.PE_Template__c=p.PE_Template__c;}
                    
                    
                    insertProdEstimate.add(objJPE);
                }
                if(Schema.sObjectType.Production_Estimate__c.isCreateable()){ 
                    insert insertProdEstimate;
                }
                
            }
            
            
        }
        catch(Exception e)
        {
            isError = 'true';
            resResult.add(isError);
            resResult.add(NewJobId);
            resResult.add(''+e.getMessage());
            return resResult;
        }           
        
        
        resResult.add(isError);
        resResult.add(NewJobId);
        resResult.add('No Error');
        return resResult;
    }
}