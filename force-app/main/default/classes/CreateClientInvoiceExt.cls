public class CreateClientInvoiceExt {
    
    @AuraEnabled
    public static List <Job__c> fetchCompJobs() {
        List <Job__c> displayJobs=new List <Job__c>();
        List<Job__c> JobList = [SELECT Id, Name, Job_Auto_Number__c,Completion_Date__c,(select id,Approved__c from Production_Estimates__r),(select id,name,Job__c,Job__r.Job_Auto_Number__c from Client_Invoices__r) from Job__c where Status__c='completed' order by Job_Auto_Number__c desc limit 60];
        system.debug('>>>>>>>Job List Size>>>>>>>'+JobList.size());
        for(Job__c job:JobList){
            if(job.Production_Estimates__r.size()>0 && job.Client_Invoices__r.size() == 0){
                Boolean ShowJob=true;
                for(Production_Estimate__c PEST:job.Production_Estimates__r){
                    if(PEST.Approved__c==false){
                        ShowJob=false;
                        break;
                    }
                }
                if(ShowJob){
                    displayJobs.add(job);
                }
            }
        }
        system.debug('>>>>>>>displayJobs List Size>>>>>>>'+displayJobs.size());
        return displayJobs;
    }
    
   @AuraEnabled
    public static wrapper getFiltersData(){ 
        wrapper wrp = new wrapper();
        list<Object> Filerlist=new  list<Object>();
        //set<string> usernames = new set<string>();
        //set<string> queuenames = new set<string>();
        set<string> ownernames = new set<string>();
        list<string> ownrstfnames = new list<string>();
        List<Campaign__c> Camplist = [SELECT Id, Name FROM Campaign__c where status__c='Active' WITH SECURITY_ENFORCED order by Name ];
        List<Media_Type__c>  MediaList =[SELECT Id, Name FROM Media_Type__c  WITH SECURITY_ENFORCED order by Name];
        List<Schedule_Template__c> STemplist=[SELECT Id, name,Media_Types__c,Active__c FROM Schedule_Template__c where Active__c =:True WITH SECURITY_ENFORCED order by Name];
        List<Client__c> Clientlist=[SELECT Id, name,Client_Code__c FROM Client__c where Active__c=:true WITH SECURITY_ENFORCED order by Name]; 
        /*List<Job__c>jobs = [select id,name,Ownerid,owner.name,Status__c,owner.type from Job__c where OwnerId != null and Status__c = 'completed'  WITH SECURITY_ENFORCED order by owner.name];
        system.debug('jobs size '+jobs.size());
        for(Job__c jobowners : jobs)
        {
            if(jobowners.owner.type == 'queue')
            {
                usernames.add(jobowners.owner.name);
            }
            else if(jobowners.owner.type == 'user'){
                usernames.add(jobowners.owner.name);   
            }
        }*/
        List<user> userrecords = [select id,name,isactive from user where isactive = true  WITH SECURITY_ENFORCED order by name asc];
        system.debug('userrecords==== '+userrecords.size());
        list<Group> queuercd =   [select id,name  from Group  WITH SECURITY_ENFORCED  order by name asc];
        system.debug('querercds ==== '+queuercd.size());
        for(user us : userrecords){
            ownernames.add(us.name);  
        }
        for(Group Gp : queuercd){
            ownernames.add(Gp.name);  
        }
        Filerlist.add(Camplist);
        Filerlist.add(MediaList);
        Filerlist.add(STemplist);
        Filerlist.add(Clientlist);
        System.debug(Filerlist);
        for(string val : ownernames){
            ownrstfnames.add(val);   
        }
        ownrstfnames.sort();
        wrp.objectvalues = Filerlist;
        wrp.ownernames = ownrstfnames;
        return wrp;
    } 
    
    
    public class wrapper{
        @AuraEnabled public List <object> objectvalues;
        @AuraEnabled public list <string> ownernames; 
    } 
    
    
    
    
    
    @AuraEnabled
    public static list<Job__c> FilterChangesJobs(List<string> strCampaignName,List<string> strmediatype,List<string> strscheduletemp,List<string> strClientName,List<string>strOwnerName){
        List <Job__c> displayJobs=new List <Job__c>();
        string sQuery = 'select id,name,Job_Auto_Number__c,Completion_Date__c,(select id,Approved__c from Production_Estimates__r),(select id,name,Job__c from Client_Invoices__r),Campaign__r.name,JS_Client__r.name,Media_Types__r.name,Schedule_Template__r.name,OwnerId,owner.name from job__c where Status__c=\'completed\'';
        
        system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>'+strCampaignName);
        
        system.debug('>>>>>>>>>>>>>strmediatype>>>>>>>>>>>>>'+strmediatype);
        
        if(strCampaignName!=Null && strCampaignName.size()>0)
            // system.debug('>>>>>>>>>>>>>strCampaignName>>>>>>>>>>>>>2'+strCampaignName);
            sQuery+=' And Campaign__r.name=: strCampaignName';
        
        if(strmediatype!=null && strmediatype.size()>0)
            sQuery +=' And Media_Types__r.name=:strmediatype';    
        
        if(strscheduletemp!=null && strscheduletemp.size()>0)
            sQuery +=' And Schedule_Template__r.name=:strscheduletemp';          
        
        if(strClientName !=Null && strClientName.size()>0)
            sQuery +=' And JS_Client__r.name =:strClientName';
        
        if(strOwnerName !=Null && strOwnerName.size()>0)
            sQuery +=' And owner.name =:strOwnerName';
        
        sQuery +=' WITH SECURITY_ENFORCED Order by Job_Auto_Number__c desc limit 1000';
        
        List<Job__c> returnJoblist=Database.query(sQuery);
        
        system.debug('>>>>>>>Job List Size>>>>>>>'+returnJoblist.size());

        for(Job__c job:returnJoblist){
          system.debug('>>>>>>>job.Client_Invoices__r.size() >>>>>>>'+job.Client_Invoices__r.size());
            if(job.Production_Estimates__r.size() > 0 && job.Client_Invoices__r.size()  == 0){
                Boolean ShowJob=true;
                for(Production_Estimate__c PEST:job.Production_Estimates__r){
                    if(PEST.Approved__c==false){
                        ShowJob=false;
                        break;
                    }
                }
                if(ShowJob){
                   displayJobs.add(job);
                }
            }
        }
        system.debug('>>>>>>>displayJobs List Size>>>>>>>'+displayJobs.size());
         
        return displayJobs;
        //return returnJoblist;
    }
    
    @AuraEnabled
    public static string createClientInv(List<SObject> selectedrecs) {
        try{
            System.debug('=====selectedrecs======'+selectedrecs);  
            List<Job__c> selectedrows=(List<Job__c>)selectedrecs;
            System.debug('=====Jobs selected rows======='+selectedrows);  
            set<id> setJobId= new set<id>();
            for(Job__c SelJob : selectedrows)
            {
                setJobId.add(SelJob.Id);
            }
            
            Map<Id,Client_Invoice__c> JobIdwithClientInv=new Map<Id,Client_Invoice__c>();
            Map<Id, List<Client_Invoice_Line_Item__c>> JobIdwithClientInvLI= new Map<Id, List<Client_Invoice_Line_Item__c>>();
            
            List<Job__c> jobupdateList=new List<Job__c>();
            List<Job__c> JobList=[select id,name,(select id,name,Job__c, Amount__c, Approved__c, Calc_Unit__c,Total_Cost__c,GL_Code__c,Quantity__c,Sort_Order__c,PE_Template__c,Equipment_Type__c from Production_Estimates__r),JS_Client__c,Traffic_Notes__c from Job__c where Id IN:setJobId];
            for(Job__c job:JobList){
                
                job.Status__c='Invoiced';
                jobupdateList.add(job);
                //Initializing the client Invoice record
                Client_Invoice__c cliInv=new Client_Invoice__c();
                cliInv.Client_Name__c=job.JS_Client__c;
                cliInv.Job__c=job.Id;
                cliInv.Notes__c=job.Traffic_Notes__c;
                cliInv.Payment_Term__c='Due upon Reciept';
                JobIdwithClientInv.put(job.Id,cliInv);
                
                //Initializing the client Invoice Line Items record
                List<Client_Invoice_Line_Item__c> ListcliInvLI=new List<Client_Invoice_Line_Item__c>();
                for(Production_Estimate__c peLI:job.Production_Estimates__r){
                    Client_Invoice_Line_Item__c cliInvLII=new Client_Invoice_Line_Item__c();
                    cliInvLII.Production_Estimate__c=peLI.Id;
                    cliInvLII.Billable_Amount__c=peLI.Total_Cost__c;
                    cliInvLII.GL_Code__c=peLI.GL_Code__c;
                    cliInvLII.Quantity__c=peLI.Quantity__c;
                    cliInvLII.Sort_Order__c=peLI.Sort_Order__c;
                    cliInvLII.PE_Template__c=peLI.PE_Template__c;
                    cliInvLII.Equipment_Type__c=peLI.Equipment_Type__c;
                    ListcliInvLI.add(cliInvLII);
                }
                JobIdwithClientInvLI.put(job.Id, ListcliInvLI);
            }
            
            
            // Inserting the Invoices
            List<Id> CliInvIds = new List<Id>();
            Database.SaveResult[] dsrList = database.insert(JobIdwithClientInv.values());
           
            for(Database.SaveResult dsr : dsrList){
                if(dsr.isSuccess()){
                    CliInvIds.add(dsr.getId());
                }
            }
                
            
            for(Client_Invoice__c cli : [select id,Job__c FROM Client_Invoice__c WHERE Id IN: CliInvIds]){
                JobIdwithClientInv.put(cli.Job__c, cli);
            }
            
            List<Client_Invoice_Line_Item__c> linetemsToBeInserted = new List<Client_Invoice_Line_Item__c>();
            for(Id Jobid : JobIdwithClientInvLI.keySet()){
                if(JobIdwithClientInv.containskey(Jobid) && JobIdwithClientInv.get(Jobid).Id != NULL){
                    for(Client_Invoice_Line_Item__c cliInvLi : JobIdwithClientInvLI.get(Jobid)){
                        cliInvLi.Client_Invoice__c = JobIdwithClientInv.get(Jobid).Id;
                        linetemsToBeInserted.add(cliInvLi);
                    }
                }
            }
            // Inserting the Invoice Line Items
            if(!linetemsToBeInserted.isEmpty()){
                insert linetemsToBeInserted;
            }
            Update jobupdateList;
            return 'OK';
        }
        Catch(System.DmlException e){
            return ''+e.getMessage();
        }
    }
}