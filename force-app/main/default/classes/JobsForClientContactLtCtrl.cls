public class JobsForClientContactLtCtrl {
    
    @AuraEnabled
    public static List<string> getStatusList() 
    {
        list<String> statusOptions=new list<String>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
        statusOptions.add('All Jobs'); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            statusOptions.add(a.getLabel());  
        }
        
        return statusOptions;  
    }
    
    @AuraEnabled 
    public static List<Shipment__c> getShprecords(Id recordId) {
        system.debug(recordId);
        List<Shipment__c> lstShp = [select id,name,Job__c,Job__r.Job_Auto_Number__c,Shipment_Status__c,Shipping_Method__c,Shipment_Name__c,Tracking_Number__c,Shipment_Date__c from Shipment__c where Job__c =: recordId  Order BY Name];
        return lstShp;
    }
    
    @AuraEnabled 
    public static list<string> getLabels(){
        list<String> labels=new list<String>();
        String jobName = Job__c.Name.getDescribe().getLabel();
        labels.add(jobName);
        String client = Job__c.JS_Client__c.getDescribe().getLabel();
        labels.add(client);  
        string autoNumber=Job__c.JOB_Auto_NUmber__c.getDescribe().getLabel();
        labels.add(autoNumber);
        return labels;
    } 
    
    @AuraEnabled
    public static  List<Job__c> DisplayJobsforClientContact()
    {
        List<Job__c> JobList = new List<Job__c>();   
        List<Job__c> ReturnJobList = new List<Job__c>();       
        User  lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid()];
        Client_Contact__c clientcontact=[Select id,createddate,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        string clientname=clientcontact.Client__r.Name;
        system.debug('***usename***'+lstUser.Username);
        system.debug('***clientname***'+clientname);
        
        if(clientname.contains('District')){
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where (JS_Client__c =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c =:clientcontact.Client__c) and Status__c =: 'active' and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        if(clientname.contains('Store')){
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where   JS_Client__c =:clientcontact.Client__c and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        if(clientname.contains('Division')){
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        else{
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        
        system.debug('---joblist---'+JobList);
        system.debug('---joblist-size--'+JobList.size());
        return JobList;
    }
    
    @AuraEnabled
    public static List<Job__c> populateJobList(string strStatus)
    {
        List<Job__c> JobList =new List<Job__c>();
        List<Job__c> ReturnJobList = new List<Job__c>();       
        User  lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid()];
        Client_Contact__c clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        string clientname=clientcontact.Client__r.Name;
        Integer count = [select count() from Job__c where JS_Client__c =:clientcontact.Client__c];
        Integer countstr;
        if(strStatus != 'All Jobs')
        {
            countstr = [select count() from Job__c  where JS_Client__c =:clientcontact.Client__c ];
        }
        else
        {
            countstr = [select count() from Job__c where JS_Client__c =:clientcontact.Client__c and Status__c = :strStatus ];
        }
        
        if(strStatus == 'All Jobs')
        {
            if(count>1000)
            {
                if(clientname.contains('Store')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('District')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('Division')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                else{
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
            }
            else
            {
                if(clientname.contains('Store')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('District')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('Division')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                else{
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
            }
        }
        else
        {
            if(countstr >1000 )
            {
                if(clientname.contains('Store')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('District')){
                    
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('Division')){
                    
                    JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                else{
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }   
            }
            else
            {
                if(clientname.contains('Store')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('District')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                if(clientname.contains('Division')){
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c)  and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
                else{
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus  And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
                }
            }
        }
        return ReturnJobList;  
    }   
    
}