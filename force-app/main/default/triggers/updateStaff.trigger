//This Trigger is on Job Team Object,used for Update Staff on Job Task of same job.

trigger updateStaff on Job_Team__c (after insert)
{
    List<Job_Task_Role__c> lstJTRDelete=new List<Job_Task_Role__c>();
    List<Job_Task_Role__c> lstJTRInsert=new List<Job_Task_Role__c>();
    List<Job_Task_Role__c> JobTaskRoleNew  = new List<Job_Task_Role__c>();
    set<Id> JobIDS= new set<id>();
    
    //Start of Job Team update event.
    If(Trigger.isInsert)
    {
        Boolean blnFlag = false;
        
        for(Job_Team__c jt:Trigger.New)
        {
            
            JobIDS.add(jt.Job__c );
            
        }
        
        Map<Id,List<Job_Task__c >> jobIdToJobTaskMap = new Map<Id,List<Job_Task__c >>();
        Map<String,Job_Task__c > JobRoleToJobTaskMap = new Map<String,Job_Task__c>();
        for(Job_Task__c jobtask :[Select id,name ,Job__c ,Schedule_Roles__c from Job_Task__c  where Job__c IN : JobIDS and Marked_Done__c=false AND Schedule_Roles__c != NULL WITH SECURITY_ENFORCED])
        {
            if(jobIdToJobTaskMap.containsKey(jobTask.Job__c)){
                List<Job_Task__c> tempList = jobIdToJobTaskMap.get(jobTask.Job__c);
                tempList.add(jobtask);
                jobIdToJobTaskMap.put(jobTask.Job__c, tempList);
            }
            else{
                jobIdToJobTaskMap.put(jobTask.Job__c, new List<Job_Task__c>{jobtask});
            }
            /*for( string s : Schedule_Roles__c.split(';')){
JobRoleToJobTaskMap.put(
}*/
        }
        
        for(Job_Team__c jt:Trigger.New)
        {
            
            //for(Job_Task__c jobtask :[Select id,name  from Job_Task__c j where Job__c=:jt.Job__c and Marked_Done__c=false and Schedule_Roles__c INCLUDES(:jt.role__c)  ])
            if(jobIdToJobTaskMap.containsKey(jt.Job__c))
                for(Job_Task__c jobtask :jobIdToJobTaskMap.get(jt.Job__c) )
            {
                if(jobtask.Schedule_Roles__c!=NULL && jt.role__c != NULL)
                { 
                    if(jobtask.Schedule_Roles__c.contains(jt.role__c))
                    {
                        system.debug('jobtasklist'+jobtask.name);
                        
                        Job_Task_Role__c J2 = new Job_Task_Role__c ();
                        if(Schema.sObjectType.Job_Task_Role__c.fields.User__c.isCreateable()){
                            J2.User__c=jt.Staff__c;
                        }
                        if(Schema.sObjectType.Job_Task_Role__c.fields.Name.isCreateable()){
                            J2.Name=jt.Role__c;
                        }
                        if(Schema.sObjectType.Job_Task_Role__c.fields.Job_Task__c.isCreateable()){
                            J2.Job_Task__c = jobtask.id;
                        }
                        JobTaskRoleNew.add(J2);
                    } 
                }
            }   
            
        }              
        if(Schema.sObjectType.Job_Task_Role__c.isCreateable()){
            insert JobTaskRoleNew ;
        }
        
    }     
    
    Approval_Task_CS__c setting = Approval_Task_CS__c.getOrgDefaults();
    List<Approval_Job_Task_Roles__c> JobApprovalTaskRoleNew  = new List<Approval_Job_Task_Roles__c>();
    Map<Id,List<Approval_Job_Task__c >> jobIdToJobApprovalStepMap = new Map<Id,List<Approval_Job_Task__c >>();
    Map<String,Approval_Job_Task__c > JobRoleToJobTaskMap = new Map<String,Approval_Job_Task__c>();
    if(setting.Job_Task_Level__c)
    {
        for(Approval_Job_Task__c jobApproval :[Select id,name,Task__r.Job__c ,Schedule_Roles__c from Approval_Job_Task__c where Task__r.Job__c IN : JobIDS AND Status__c!='Approved' AND Schedule_Roles__c != NULL WITH SECURITY_ENFORCED])
        {
            if(jobIdToJobApprovalStepMap.containsKey(jobApproval.Task__r.Job__c)){
                List<Approval_Job_Task__c> tempList = jobIdToJobApprovalStepMap.get(jobApproval.Task__r.Job__c);
                tempList.add(jobApproval);
                jobIdToJobApprovalStepMap.put(jobApproval.Task__r.Job__c, tempList);
            }
            else{
                jobIdToJobApprovalStepMap.put(jobApproval.Task__r.Job__c, new List<Approval_Job_Task__c>{jobApproval});
            }
        }
        
    }else{
        for(Approval_Job_Task__c jobApproval :[Select id,name ,Project__c ,Schedule_Roles__c from Approval_Job_Task__c where Project__c IN : JobIDS AND Schedule_Roles__c != NULL WITH SECURITY_ENFORCED])
        {
            if(jobIdToJobApprovalStepMap.containsKey(jobApproval.Project__c)){
                List<Approval_Job_Task__c> tempList = jobIdToJobApprovalStepMap.get(jobApproval.Project__c);
                tempList.add(jobApproval);
                jobIdToJobApprovalStepMap.put(jobApproval.Project__c, tempList);
            }
            else{
                jobIdToJobApprovalStepMap.put(jobApproval.Project__c, new List<Approval_Job_Task__c>{jobApproval});
            }
            
        }
    }
    
    
    for(Job_Team__c jt:Trigger.New)
    {
        
        //for(Job_Task__c jobtask :[Select id,name  from Job_Task__c j where Job__c=:jt.Job__c and Marked_Done__c=false and Schedule_Roles__c INCLUDES(:jt.role__c)  ])
        if(jobIdToJobApprovalStepMap.containsKey(jt.Job__c))
            for(Approval_Job_Task__c jobAppStep :jobIdToJobApprovalStepMap.get(jt.Job__c) )
        {
            if(jobAppStep.Schedule_Roles__c!=NULL && jt.role__c != NULL)
            { 
                if(jobAppStep.Schedule_Roles__c.contains(jt.role__c))
                {
                    system.debug('jobApprovalSteplist'+jobAppStep.name);
                    
                    Approval_Job_Task_Roles__c J2 = new Approval_Job_Task_Roles__c ();
                    if(Schema.sObjectType.Approval_Job_Task_Roles__c.fields.User__c.isCreateable()){
                        J2.User__c=jt.Staff__c;
                    }
                    if(Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Name.isCreateable()){
                        J2.Name=jt.Role__c;
                    }
                    if(Schema.sObjectType.Approval_Job_Task_Roles__c.fields.Approval_Job_Task__c.isCreateable()){
                        J2.Approval_Job_Task__c = jobAppStep.id;
                    }
                    JobApprovalTaskRoleNew.add(J2);
                } 
            }
        }   
        
    }              
    if(Schema.sObjectType.Approval_Job_Task_Roles__c.isCreateable()){
        insert JobApprovalTaskRoleNew ;
    }
    
}    

//End of Trigger.