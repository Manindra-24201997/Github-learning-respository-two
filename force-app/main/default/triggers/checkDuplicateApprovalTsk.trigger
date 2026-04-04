// This trigger is used to check duplicate Approval_Job_Tasks
trigger checkDuplicateApprovalTsk on Approval_Job_Task__c(before insert, before update, after insert, after update, after delete) 
{
    
    // Check for duplicate Job Approval Task under one file
    If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
    {
        Set<Id> stTemp=new Set<Id>();    
        Set<Id> JobTaskId=new Set<Id>();
        for(Approval_Job_Task__c st:Trigger.New)  
        {  
            stTemp.add(st.Project__c);           
        }
        
        for(Approval_Job_Task__c st1:Trigger.New){
            
            if(st1.Task_Order__c==1){
                if(Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isCreateable() || Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isUpdateable()) {
                    st1.Next_Task_Due__c=True;
                }
                
            }
            
        }
        
        MAP<String,Approval_Job_Task__c>  inDb = new MAP<String,Approval_Job_Task__c>(); 
        MAP<String,Approval_Job_Task__c> inBatch = new MAP<String,Approval_Job_Task__c>();
        MAP<String,Approval_Job_Task__c>  JobTaskNameWithApprovalTask = new MAP<String,Approval_Job_Task__c>();
        
        for(Approval_Job_Task__c st:Trigger.New)
        {   
            stTemp.add(st.Project__c);
            JobTaskId.add(st.Task__c);
        }
        for(Approval_Job_Task__c t : [Select Id,Name,Project__c,File_Name__c,File_ID__c from Approval_Job_Task__c where Project__c IN : stTemp WITH SECURITY_ENFORCED])
        {
            inDb.put(t.Name+t.Project__c+t.File_Name__c,t);
        }
        for(Approval_Job_Task__c t : [Select Id,Name,Project__c,File_Name__c,File_ID__c,Task__c,Created_From_Job_Task__c from Approval_Job_Task__c where Task__c IN : JobTaskId WITH SECURITY_ENFORCED])
        {
            JobTaskNameWithApprovalTask.put(t.Name+t.Task__c+t.File_Name__c,t);
        }  
        
        for(Approval_Job_Task__c t : Trigger.New)
        {
            string name=t.Name+t.Project__c+t.File_Name__c;
            system.debug('>>>>>>>>Trigger name>>>>>>>>>>>'+name);
            if(t.Created_From_Job_Task__c==true){
                system.debug('>>>>>>>>Task Name trigger>>>>>>>>>>'+t.Name+t.Task__c+t.File_Name__c);
                If (JobTaskNameWithApprovalTask.containsKey(t.Name+t.Task__c+t.File_Name__c)) 
                {
                    If(Trigger.isInsert || t.id!=JobTaskNameWithApprovalTask.get(t.Name+t.Task__c+t.File_Name__c).Id) //if update then ignore itself as a dup
                        t.AddError('Step Name already Exists for this Job Task Aproval process');
                }
                Else If (inBatch.containsKey(t.Name+t.Task__c+t.File_Name__c))
                {
                    t.AddError('Duplicate in batch....');
                }
                Else
                {
                    inBatch.put(t.Name+t.Task__c+t.File_Name__c,t);
                }
            }
            else{
                If (inDb.containsKey(t.Name+t.Project__c+t.File_Name__c)) 
                {
                    If(Trigger.isInsert || t.id!=inDb.get(t.Name+t.Project__c+t.File_Name__c).Id) //if update then ignore itself as a dup
                        t.AddError('Step Name already Exists for this Aproval process');
                }
                Else If (inBatch.containsKey(t.Name+t.Project__c+t.File_Name__c))
                {
                    t.AddError('Duplicate in batch....');
                }
                Else
                {
                    inBatch.put(t.Name+t.Project__c+t.File_Name__c,t);
                }
            }
            
            
        }
    }// End of Checking for Duplicates
    
    
    //After creating approval process at task level we need to update Has_Approval_steps__c has true in the Task object for displaying the flag in the job task table
    if(Trigger.IsAfter && (Trigger.IsUpdate || Trigger.isInsert))
    {
        Set <String> JobTaskID = New Set <String> ();
        for(Approval_Job_Task__c objJT1:Trigger.New)
        {
            if (objJT1.Task__c != Null ) { 
                JobTaskID.add (objJT1.Task__c); 
            } 
        }
        If (JobTaskID.size ()> 0) { 
            List <Job_Task__c> upJobTaskList = new List <Job_Task__c> (); 
            For (Job_Task__c jobTsk: [SELECT Id, Has_Approval_steps__c FROM Job_Task__c WHERE id in: JobTaskID AND Has_Approval_steps__c != True WITH SECURITY_ENFORCED]) { 
                if(Schema.sObjectType.Job_Task__c.fields.Has_Approval_steps__c.isUpdateable()) {
                    jobTsk.Has_Approval_steps__c = true; 
                    upJobTaskList.add (jobTsk); 
                }
            } 
            If (upJobTaskList.size ()> 0) 
            {
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update upJobTaskList;
                }
            }
            
        } 
    }
    
    
    
    
    if(Trigger.IsAfter && Trigger.IsUpdate)
    {
        system.debug('>>>>>>>>>> After Trigger Fires >>>>>>>>>>>>>>>>');
        //Id  userId = userinfo.getUserId();
        Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
        list<string> Tskids=new list<string>();
        
        for(Approval_Job_Task__c objJT:Trigger.New)
        {
            
            if (setting.Custom_Notification__c == true)
            {
                if((Trigger.oldMap.get(objJT.Id).Status__c=='Pending' || Trigger.oldMap.get(objJT.Id).Status__c=='Changes Needed')  && Trigger.NewMap.get(objJT.Id).Status__c=='In Progress'){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.InprogressEmailNotification(Tskids);
                }
                if((Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='pending') || (Trigger.oldMap.get(objJT.Id).Undo__c==false && Trigger.NewMap.get(objJT.Id).Undo__c==true)){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.UndoEmailNotification(Tskids);
                }
                if(Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='Changes Needed' && Trigger.NewMap.get(objJT.Id).Undo__c==false){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.ChangesNeededNotification(Tskids);
                }
                if(Trigger.oldMap.get(objJT.Id).Status__c=='In Progress' && Trigger.NewMap.get(objJT.Id).Status__c=='Approved'){
                    Tskids.add(objJT.Id);
                    ApprovalTaskEmailNotification.ApprovedNotification(Tskids);
                }
            }
        }
        
        Map<ID, Job_Task__c> JobTaskUpdate = new Map<ID, Job_Task__c>();
        Boolean isExists = false;
        Set<String> JobTaskID = New Set<String>();
        for(Approval_Job_Task__c objJT1:Trigger.New)
        {
            if (objJT1.Task__c != Null ) { 
                JobTaskID.add (objJT1.Task__c); 
            } 
        }
        
        JobTaskUpdate = new Map<Id, Job_Task__c>([SELECT id, Has_Inprogress_Approval_Steps__c,(SELECT ID, Status__c FROM Job_Approval_Tasks__r) FROM Job_Task__c WHERE ID IN :JobTaskID]);
		
        for (Job_Task__c tsk: JobTaskUpdate.values()){
            isExists = false;
            for(Approval_Job_Task__c  Apptsk :tsk.Job_Approval_Tasks__r){
                if(Apptsk.Status__c == 'In Progress'){
                    tsk.Has_Inprogress_Approval_Steps__c = true;
                    isExists = true;
                }
                if(isExists == false){
                    tsk.Has_Inprogress_Approval_Steps__c = false;
                }  
            }
        }
        
        update JobTaskUpdate.values();
        
       /* If (JobTaskID.size ()> 0) { 
            List <Job_Task__c> upJobTaskList = new List <Job_Task__c> (); 
            For (Job_Task__c jobTsk: [SELECT Id, Has_Approval_steps__c FROM Job_Task__c WHERE id in: JobTaskID AND Has_Inprogress_Approval_Steps__c != True AND Status__c = 'In Progress' WITH SECURITY_ENFORCED]) { 
                if(Schema.sObjectType.Job_Task__c.fields.Has_Inprogress_Approval_Steps__c.isUpdateable()) {
                    jobTsk.Has_Inprogress_Approval_Steps__c = true; 
                    upJobTaskList.add (jobTsk); 
                }
            } 
            If (upJobTaskList.size ()> 0) 
            {
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update upJobTaskList;
                }
            }
            
        } */
        
    }
    
    
    if(Trigger.IsAfter && Trigger.IsDelete)
    {
        Set <String> JobTaskID = New Set <String> ();
        map<id,List<Approval_Job_Task__c>> mapTskIdwithApprjobtsk=new map<id,List<Approval_Job_Task__c>>();
        for(Approval_Job_Task__c objJT:Trigger.old)
        {
            if (objJT.Task__c != Null ) { 
                JobTaskID.add (objJT.Task__c); 
            } 
        }
        If (JobTaskID.size ()> 0) { 
            
            for(Approval_Job_Task__c apptsk:[select id,name,task__c from Approval_Job_Task__c where task__c in:JobTaskID WITH SECURITY_ENFORCED]){
                if(mapTskIdwithApprjobtsk.containsKey(apptsk.task__c)){
                    List<Approval_Job_Task__c> appjobtsk = mapTskIdwithApprjobtsk.get(apptsk.task__c);
                    appjobtsk.add(apptsk);
                    mapTskIdwithApprjobtsk.put(apptsk.task__c,appjobtsk);
                }
                else{
                    mapTskIdwithApprjobtsk.put(apptsk.task__c, new List<Approval_Job_Task__c> {apptsk});
                }
            }
            system.debug('>>>>>>>>>>After Delete>>>>>>>>>>>>>>>>>'+mapTskIdwithApprjobtsk);
            
            if(mapTskIdwithApprjobtsk.size()==0){
                List <Job_Task__c> upJobTaskList1 = new List <Job_Task__c> (); 
                For (Job_Task__c jobTsk: [SELECT Id, Has_Approval_steps__c FROM Job_Task__c WHERE id in: JobTaskID AND Has_Approval_steps__c = True WITH SECURITY_ENFORCED]) { 
                    if(Schema.sObjectType.Job_Task__c.fields.Has_Approval_steps__c.isUpdateable()) {
                        jobTsk.Has_Approval_steps__c = false; 
                        upJobTaskList1.add (jobTsk);
                    }
                } 
                If (upJobTaskList1.size ()> 0) {
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                        update upJobTaskList1;
                    }
                }
                
            }
        }         
        
    }
    
}// ENd of Trigger