public with sharing class StatusReportSearchController {
    
    public list<string>jbids{get;set;}
    public set<String> ReturnValue {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public Transient List<JobWrapper>  JW;
    public Transient List<CampaignNameWrapper>  CNWrapper{get;set;}
    public Transient  CampaignNameWrapper tmpCNWrapper;
    Public string strClientName{get;set;}
    Public string strClientContactName{get;set;}
    Public string StatusString {get;set;}
    Public String strCampaignName{get;set;}
    Public String strUsers{get;set;}
    Public String strUsersName{get;set;}
    Public string Owner{get;set;}
    Public string DepartmentString {get;set;}
    Public string JobTypeString {get;set;}
    Public string Timing {get;set;}// newly added
    Public Transient list<Job__c> joblist{get;set;}
    Public Transient string  soql{get;set;}
    
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public  StatusReportSearchController (){
        jbids = new list<string>();
        // Code to display Subsriber Organization Logo
        ReturnValue = new set<string>();
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
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
        
        CNWrapper = new List<CampaignNameWrapper>();
        JW= new List<JobWrapper>();
    }
    
    public List<SelectOption> getjobStatus(){
        List<SelectOption> jobstatusoptionList = new List<selectOption>();
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues()){
            jobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        return jobstatusoptionList;
    } 
    
    public pageReference Result()
    {
        ReturnValue = new set<string>();
        if(strUsers!=Null){
            User u= [SELECT Id, name FROM user where  id=:strUsers];
            strUsersname=u.name;
        } 
        joblist= new List<Job__c>();
        soql='Select id ,name,Timing_Status__c,Job_Timing_Status__c,Status__c,CreatedById,Start_Date__c,Status_Notes__c,Creative_Overview__c ,due_Date__c,Job_Auto_Number__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Job_Description__c,JS_Client__c,JS_Client__r.name,Campaign__r.name,Campaign__r.Dummy_Date_1__c,Campaign__r.Dummy_Date_2__c,Campaign__r.Dummy_Date_3__c,(Select id,Email__c,Role__c,Staff__c from Job__c.Job_Team__r  ),(select id,Name,Due_Date__c,Revised_Due_Date__c from Job__c.Job_Task__r abc where Marked_Done__c=false order by Revised_Due_Date__c  Limit 1) from Job__c where Campaign__r.name!=null';
        
        if(StatusString!=Null)
            soql +=' And Status__c =:StatusString';
        
        
        if(strClientName!=Null)
            soql +=' And JS_Client__r.name =:strClientName';
        
        system.debug('client name'+strClientName);   
        
        if(strClientContactName!=Null)
            soql +=' And JS_Client_Contact__r.name =:strClientContactName';
        
        system.debug('client Contact name'+strClientContactName);           
        
        
        if(strCampaignName!=Null)
            soql +=' And Campaign__r.name =:strCampaignName';
        
        system.debug('Campaign name'+strCampaignName);            
        
        
        if(DepartmentString!=Null)
            soql +=' And Dummy_Picklist_2__c=:DepartmentString';
        
        
        if(JobTypeString!=Null)
            soql +=' And Dummy_Picklist_3__c=:JobTypeString';
        
        
        if(strUsers!=Null)
            soql +=' And CreatedById=:strUsers';    
        
        //newly added for timing status column
        
        if(Timing!=Null)
            soql +=' And Job_Timing_Status__c=:Timing';
        
        
        if(Owner!=null)            
            soql +=' And OwnerId=:Owner'; 
        
        soql +=' order by Campaign__r.name,Job_Auto_Number__c,Name LIMIT 500'; 
        
        System.debug('Query is : ' + soql);  
        
        joblist=Database.query(soql);
        
        for(Job__c jcrcd : joblist){
            ReturnValue.add(jcrcd.id);
        }
        
        return null;
        
    }
    
    //Newly aded logic for timing status
    public List<SelectOption> gettimingval(){
        List<SelectOption> jobtimingstatusoptionList = new List<selectOption>();
        jobtimingstatusoptionList.add(new selectOption('', '- None -')); 
        for(schema.picklistEntry p : Job__c.Job_Timing_Status__c.getDescribe().getPicklistValues()){
            jobtimingstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
        }
        return jobtimingstatusoptionList;
    } 
    
    public List<SelectOption> getDepartments(){
        List<SelectOption> jobDepartmentsoptionList = new List<selectOption>();
        jobDepartmentsoptionList.add(new selectOption('', '- None -')); 
        
        for(schema.picklistEntry p : Job__c.Dummy_Picklist_2__c.getDescribe().getPicklistValues()){
            jobDepartmentsoptionList .add(new SelectOption(p.getLabel(),p.getLabel()));
            
        }
        
        return jobDepartmentsoptionList;
    } 
    
    public List<SelectOption> getJobType(){
        List<SelectOption> jobJobTypeoptionList = new List<selectOption>();
        jobJobTypeoptionList.add(new selectOption('', '- None -')); 
        
        for(schema.picklistEntry p : Job__c.Dummy_Picklist_3__c.getDescribe().getPicklistValues()){
            jobJobTypeoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
            
        }
        
        return jobJobTypeoptionList;
    }
    
    // This method is used to retrieve all Clients into dropdown list
    public List<selectOption> getClients() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
        {  
            //optionList.add(new selectOption(a.name, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));    
            
            optionList.add(new selectOption(a.name, a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:'')));    
            
        }
        return optionList;  
    }   
    // End of method getClients
    
    // This method is used to retrieve all Client Contacts based on the client value selection : strClientName into dropdown list
    public List<selectOption> getClientContacts() 
    {    
        system.debug('>>>>>>>>>>>strClientName>>>>>>>>>>>>>'+strClientName);
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client_Contact__c a : [SELECT Id, name, Client__c FROM Client_Contact__c where Client__r.Name=:strClientName and Active__c=:true order by Name]) 
        {  
            optionList.add(new selectOption(a.name, a.Name));    
        }
        return optionList;  
    }   
    // End of method getClients
    
    // This method is used to retrieve all Campaigns into dropdown list
    public List<selectOption> getCampaigns() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Campaign__c a : [SELECT Id, name FROM Campaign__c order by Name]) 
        {  
            optionList.add(new selectOption(a.name, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getCampaigns
    
    // This method is used to retrieve all Users into dropdown list
    public List<selectOption> getusers() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (User a : [SELECT Id, name FROM user  order by name]) 
        {  
            optionList.add(new selectOption(a.id, a.Name ));    
        }
        return optionList;  
    }   
    // End of method getUsers
    
    Public pagereference  searchjobds() {
        
        if(strUsers!=Null){
            User u= [SELECT Id, name FROM user where  id=:strUsers];
            strUsersname=u.name;
        } 
        
        joblist= new List<Job__c>();
        CNWrapper = new List<CampaignNameWrapper>();          
        string stractive='Active';
        
        soql='Select id ,name,Timing_Status__c,Job_Timing_Status__c,Status__c,CreatedById,Start_Date__c,Status_Notes__c,Creative_Overview__c ,due_Date__c,Job_Auto_Number__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Job_Description__c,JS_Client__c,JS_Client__r.name,Campaign__r.name,Campaign__r.Dummy_Date_1__c,Campaign__r.Dummy_Date_2__c,Campaign__r.Dummy_Date_3__c,(Select id,Email__c,Role__c,Staff__c from Job__c.Job_Team__r  ),(select id,Name,Due_Date__c,Revised_Due_Date__c from Job__c.Job_Task__r abc where Marked_Done__c=false order by Revised_Due_Date__c  Limit 1) from Job__c where Campaign__r.name!=null';
        
        if(StatusString!=Null)
            soql +=' And Status__c =:StatusString';
        
        
        if(strClientName!=Null)
            soql +=' And JS_Client__r.name =:strClientName';
        
        system.debug('client name'+strClientName);   
        
        if(strClientContactName!=Null)
            soql +=' And JS_Client_Contact__r.name =:strClientContactName';
        
        system.debug('client Contact name'+strClientContactName);           
        
        
        if(strCampaignName!=Null)
            soql +=' And Campaign__r.name =:strCampaignName';
        
        system.debug('Campaign name'+strCampaignName);            
        
        
        if(DepartmentString!=Null)
            soql +=' And Dummy_Picklist_2__c=:DepartmentString';
        
        
        if(JobTypeString!=Null)
            soql +=' And Dummy_Picklist_3__c=:JobTypeString';
        
        
        if(strUsers!=Null)
            soql +=' And CreatedById=:strUsers';    
        
        //newly added for timing status column
        
        if(Timing!=Null)
            soql +=' And Job_Timing_Status__c=:Timing';
        
        
        if(Owner!=null)            
            soql +=' And OwnerId=:Owner'; 
        
        soql +=' order by Campaign__r.name,Job_Auto_Number__c,Name LIMIT 500'; 
        
        System.debug('Query is : ' + soql);  
        
        joblist=Database.query(soql);
        
        system.debug('Size of jobss list ::::: ' + joblist.size());
        
        Set<string> JobIds = new Set<string>();
        
        for(Job__c aa : joblist)
        {
            system.debug('JObName first'+aa.Name);
            
            // if(  aa.Job_Team__r.size()>0  || aa.Job_Task__r.size() >0){
            JobIds.add(aa.id);
            //  }  
            
        }
        
        
        //get the list of job Team  for every job;
        List<Job_Team__c > jTeam = [Select id,name,Role__c,staff__c,Job__r.name  from Job_Team__c where  Job__c =: JobIds ];   
        
        Map <Id, List <Job_Team__c >> mapJTeam = new Map<Id, List <Job_Team__c >>();
        
        //get the job Team for the job
        
        for(Job_Team__c  jT:jTeam )
        {
            if(mapJTeam.containsKey(jT.Job__r.id))
            {
                List <Job_Team__c > jTeamlist =  mapJTeam.get(jT.Job__r.id);
                jTeamlist .add(jT);
                mapJTeam.put(jT.Job__r.id,jTeamlist );  
            }
            else
            {
                mapJTeam.put(jT.Job__r.id , new List<Job_Team__c >{jT}) ;
            }        
            
        }
        
        //get the list of staff with Production Role for every job;
        Map<Id,list<String>> STmap = new Map<Id, List<string>>();
        for(Job__c obj : joblist)
        {              
            if(obj.Job_Team__r.size()>0)
            {
                List<string> stName = new List<string>();
                List<Job_Team__c> lst1 = mapJTeam.get(obj.Id);
                for(Job_Team__c objT:lst1)
                {
                    if(objT.Staff__c != null && objT.Role__c != NULL ) 
                    {
                        if(objT.Role__c =='Production')
                        {
                            string tName= objT.Staff__c;
                            stName.add(tName);
                        }
                    }
                }
                STmap.put(obj.Id,stName);
            }
            
        }
        
        //get the list of staff with Designer Role for every job;
        Map<Id,list<String>> STmap2 = new Map<Id, List<string>>();
        for(Job__c obj : joblist)
        {              
            if(obj.Job_Team__r.size()>0)
            {
                List<string> stName1 = new List<string>();
                List<Job_Team__c> lst1 = mapJTeam.get(obj.Id);
                for(Job_Team__c objT:lst1)
                {
                    if((objT.Staff__c != null && objT.Role__c != NULL)) 
                    {   
                        string tName;
                        system.debug('--obj.Dummy_Picklist_3__c---'+obj.Dummy_Picklist_3__c); 
                        system.debug('--objT.Role__c---'+objT.Role__c);
                        if(obj.Dummy_Picklist_3__c!=null && obj.Dummy_Picklist_3__c.contains('Copy Fix') && objT.Role__c.contains('Copy Editor'))
                        {
                            
                            tName= objT.Staff__c;
                            stName1.add(tName);
                            break;
                        }
                        
                        else if(objT.Role__c.contains('Designer'))
                        {
                            tName= objT.Staff__c;
                            stName1.add(tName);
                            break;
                            // stName1.add(tName);
                        }
                        //  stName1.add(tName);
                    }
                }
                STmap2.put(obj.Id,stName1);
            }
            
        }
        
        //get the list of job Task  for every job;
        List<Job_Task__c> jTask = [select id,Name,Due_Date__c,Revised_Due_Date__c,Job__r.name from Job_Task__c   where Job__c =: JobIds ];   
        
        Map <Id, List <Job_Task__c>> mapJTask = new Map<Id, List <Job_Task__c>>();
        
        //get the job Task for the job
        
        for(Job_Task__c  jT:jTask)
        {
            if(mapJTask.containsKey(jT.Job__r.id))
            {
                List <Job_Task__c> jTasklist =  mapJTask.get(jT.Job__r.id);
                jTasklist.add(jT);
                mapJTask.put(jT.Job__r.id,jTasklist);  
            }
            else
            {
                mapJTask.put(jT.Job__r.id , new List<Job_Task__c>{jT}) ;
            }        
            
        }
        
        //get the list of Task with FMA Review for every job;
        
        Map<Id,list<Date>> STaskmap = new Map<Id, List<Date>>();
        for(Job__c obj : joblist)
        {              
            //  if( obj.Job_Task__r.size()>0)
            //  {
            List<Date> stdate = new List<Date>();
            List<Job_Task__c> lst1 = mapJTask.get(obj.Id);
            if(lst1==null )continue;
            for(Job_Task__c objT:lst1)
            {
                if(objT.Name =='FMA Review' ) 
                {
                    date tdate= objT.Revised_Due_Date__c;
                    stdate.add(tdate);
                }
            }
            STaskmap.put(obj.Id,stdate);
            //   }
            
        }
        
        //get the list of Task with Delivery for every job;
        
        Map<Id,list<Date>> STaskmap2 = new Map<Id, List<Date>>();
        for(Job__c obj : joblist)
        {              
            //   if(obj.Job_Task__r.size()>0)
            //{
            List<Date> stdate = new List<Date>();
            List<Job_Task__c> lst1 = mapJTask.get(obj.Id);
            if(lst1==null )continue;
            for(Job_Task__c objT:lst1)
            {
                if(objT.Name =='Delivery' ) 
                {
                    date tdate= objT.Revised_Due_Date__c;
                    stdate.add(tdate);
                }
            }
            STaskmap2.put(obj.Id,stdate);
            //  }
        }
        
        string strCampaignNameNew;
        Integer counter = 0;
        for(Job__c aa:joblist)
        {
            if (strCampaignNameNew!= aa.Campaign__r.Name)
            {
                if (strCampaignNameNew!= null)
                {     
                    system.debug('JW::::'+JW);                           
                    tmpCNWrapper.jWrapper= JW;
                    CNWrapper.add(tmpCNWrapper);
                    system.debug('cWrapper :::::::::'+CNWrapper);                                                                      
                }  
                
                tmpCNWrapper= new CampaignNameWrapper();     
                
                tmpCNWrapper.strCampaignName = strCampaignNameNew= aa.Campaign__r.Name ;
                tmpCNWrapper.strPreLaunch =  aa.Campaign__r.Dummy_Date_1__c;
                tmpCNWrapper.strLaunch= aa.Campaign__r.Dummy_Date_2__c;
                tmpCNWrapper.strShip =  aa.Campaign__r.Dummy_Date_3__c;
                
                JW = new List<JobWrapper>();
            }   
            counter = counter + 1;
            JobWrapper objWrapper = new JobWrapper();
            objWrapper.job = aa;   
            if(aa.Creative_Overview__c!=null)
            {
                String StatusNotes = aa.Creative_Overview__c;
                StatusNotes = StatusNotes.replaceAll('<[^>]+>',' ');
                objWrapper.JobStatusNotes=StatusNotes;
            }
            //objWrapper.JobStatusNotes=aa.Creative_Overview__c;
            objWrapper.count= '';
            objWrapper.Count2 = counter;
            objWrapper.jobTeams= STmap.get(aa.id);
            objWrapper.jobTeams2= STmap2.get(aa.id);
            
            objWrapper.jobTasks= STaskmap.get(aa.id);
            objWrapper.jobTasks2= STaskmap2.get(aa.id);
            
            JW.add(objWrapper); 
        }
        
        if (strCampaignNameNew!= null){
            tmpCNWrapper.jWrapper= JW;
            CNWrapper.add(tmpCNWrapper);
            system.debug('cWrapper :::::::::'+CNWrapper);
        }
        return null;
    }
    
    public class CampaignNameWrapper
    {
        public List<JobWrapper> jWrapper{get;set;}
        public string strCampaignName {get;set;} 
        public Date strPreLaunch {get;set;} 
        public Date strLaunch {get;set;} 
        public Date strShip {get;set;} 
        public CampaignNameWrapper()
        {
            if(jWrapper== NULL) {jWrapper= new List<JobWrapper>();}
        }
    }
    
    public class JobWrapper
    {              
        public Job__c job {get;set;}
        public string JobStatusNotes {get;set;} 
        public List<string> jobTeams{get;set;}
        public List<string> jobTeams2{get;set;}
        public List<date>   jobTasks{get;set;}
        public List<date>   jobTasks2{get;set;}
        public string timingstatus{get;set;}
        Public string Count{get;set;}
        Public integer Count2{get;set;}
        public JobWrapper()
        {
        }
    }
    
    Public pagereference  PrintReport() {
        PageReference pageRef= new PageReference('/apex/CampStatusReportPrint');
        pageRef.setRedirect(false);        
        return pageRef;   
    }
    
    Public pagereference  PrintReportChannelMarketing() {
        PageReference pageRef2= new PageReference('/apex/CampStatusReportChannelMarketingPdf');
        pageRef2.setRedirect(false);        
        return pageRef2;   
    }
}