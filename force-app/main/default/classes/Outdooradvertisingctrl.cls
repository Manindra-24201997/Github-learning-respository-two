public class Outdooradvertisingctrl {
    
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
    public static list<string> getLabels(){
        list<String> labels=new list<String>();
        String jobName = Job__c.Name.getDescribe().getLabel();
        labels.add(jobName);
        String client = Job__c.JS_Client__c.getDescribe().getLabel();
        labels.add(client);  
        string autoNumber=Job__c.JOB_Auto_NUmber__c.getDescribe().getLabel();
        labels.add(autoNumber);
        system.debug('labels === '+labels);
        return labels;
    } 
    
    @AuraEnabled
    public static List<Job__c> getbillboardjobs(){
        
        List<Job__c> JobList = new List<Job__c>();   
        List<Job__c> ReturnJobList = new List<Job__c>();       
        User  lstUser = [select firstname ,Username,id, Profile.Name  from user where id=:userinfo.getuserid()];
        Client_Contact__c clientcontact=[Select id,createddate,Email__c , name,Client__c,UserName__c, 
                                                   Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,
                                                   Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c,
                                                   Client__r.Phone__c   from Client_Contact__c 
                                                   where UserName__c =:lstUser.Username ];
        string clientname=clientcontact.Client__r.Name;
        string value = '';
        system.debug('***usename***'+lstUser.Username);
        system.debug('***clientname***'+clientname);
        
        if(clientname.contains('District')){
            value='District';
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where (JS_Client__c =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c =:clientcontact.Client__c) and Status__c =: 'active' and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        else if(clientname.contains('Store')){
            value='Store';
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate,Schedule_Template__r.name from Job__c where   JS_Client__c =:clientcontact.Client__c  And CreatedBy.Profile.Name ='SP Client Contact' and name like '%BillBoard Repair%' and Schedule_Template__r.Name = 'Billboard Repair' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        else if(clientname.contains('Division')){
            value='Division';
            JobList=[Select id ,name ,Status__c,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c,CreatedDate from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
        }
        else{
            value='else';
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
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' and name like '%BillBoard Repair%' and Schedule_Template__r.Name = 'Billboard Repair'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
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
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' and name like '%BillBoard Repair%' and Schedule_Template__r.Name = 'Billboard Repair' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
                    
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
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' and name like '%BillBoard Repair%' and Schedule_Template__r.Name = 'Billboard Repair'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
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
                    JobList=[Select id ,name ,Status__c,createddate,JOB_Auto_NUmber__c,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' and name like '%BillBoard Repair%' and Schedule_Template__r.Name = 'Billboard Repair' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];
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
        return JobList;  
    }   
    
    @AuraEnabled
    public static List<BillboardWrapper> DisplayBillboardList(){
        
        List<Billboard__c> BillboardList =new List<Billboard__c>();
        List<BillboardWrapper>  BBWrapperList = new List<BillboardWrapper>();
        
        User lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username ];
        
        Client__c CC=[select id, name,Longitude__c,Hierarchy__c, Latitude__c from Client__c  where id=:clientcontact.Client__c];
        
        string clientname=cc.name;  
        
        if(clientname.contains('Store')){
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c limit 1000];
        }
        
        else if(clientname.contains('District')){
            
            system.debug('>>>>>>>>>>clientcontact.Client__c>>>>>>>>>'+clientcontact.Client__r.name); 
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c limit 1000];
            
            system.debug('>>>>>>>>>>>>>>>>>>>'+BillboardList);
            
        }
        
        else if(clientname.contains('Division')){
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c limit 1000];
        } 
        
        else{
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c limit 1000];
        }
        
        Set<Id> contentDocumentIdSet =new Set<Id>();
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
        }
        
        Map<Id,String> contentDocMap=new Map<Id,String>();
        Map<Id,List<String>> contentVerMap=new Map<Id,List<String>>();
        
        List<ContentVersion> conVersList=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC];
        for(ContentVersion cv:conVersList){
            contentDocMap.put(cv.ContentDocumentId,cv.Id);
        }
        
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    if(contentDocMap.containskey(cdl.ContentDocumentId))
                    {
                        if(contentVerMap.containskey(bb.Id))
                        {
                            List<String> ConVeList=contentVerMap.get(bb.Id);
                            ConVeList.add(contentDocMap.get(cdl.ContentDocumentId));
                            contentVerMap.put(bb.Id,ConVeList);
                        }
                        else
                        {
                            contentVerMap.put(bb.Id,new List<string> {contentDocMap.get(cdl.ContentDocumentId)});
                        }
                    }
                }
            }
        }
        
        for(Billboard__c bb: BillboardList){
            if(!contentVerMap.containsKey(bb.Id))
            {
                list<String> aa=new List<string>();
                contentVerMap.put(bb.Id,aa);
            }
        }
        
        for(Billboard__c BB:BillboardList)
        {
            BillboardWrapper BBW = new BillboardWrapper();
            BBW.BBWrap= BB;
            BBW.ContentVersionId=new List<String>();
            for(ContentDocumentLink cdl:BB.ContentDocumentLinks){
                if(contentVerMap.containsKey(bb.Id)){
                    BBW.ContentVersionId=contentVerMap.get(bb.Id);                    break;
                }
            } 
            BBWrapperList.add(BBW);           
        }
        
        return BBWrapperList;
    }
    
    @AuraEnabled
    public static List<BillboardWrapper> DisplayBillboardListForSorting(string sortdirection,string sortfield){
        
        List<Billboard__c> BillboardList =new List<Billboard__c>();
        List<BillboardWrapper>  BBWrapperList = new List<BillboardWrapper>();
        
        User lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        
        Client_Contact__c clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username ];
        
       // Client_Contact__c clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c ='generalmanager@sample.com'  ];
        system.debug('client contact name === '+clientcontact.Client__c);
        Client__c CC=[select id, name,Longitude__c,Hierarchy__c, Latitude__c from Client__c  where id=:clientcontact.Client__c];
        system.debug('cc === '+CC);
        
        string clientname=cc.name;  
        //string clientname='Store 052 Ada, OK';
        string clientid=clientcontact.Client__c;
        string fieldval = '';
        string sortdirectionval = '';
        if(sortdirection == 'arrowup'){
            sortdirectionval = ' asc ';
        }
        else{
            sortdirectionval = ' desc ';  
        }
        if(sortfield == 'Billboard_Type__c'){
            fieldval = 'Billboard_Type__c';
        }
        else{
            fieldval = 'Name';
        }
        string billboardrcd = 'Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c =';      
        if(clientname.contains('Store')){
            system.debug('Store');
            /*if(sortdirection == 'arrowup'){
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c order by  limit 1000];
}
else{
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c order by  limit 1000];
}*/
            billboardrcd+=' :clientid';  
        }
        
        else if(clientname.contains('District')){
            system.debug('District');
            /*   if(sortdirection == 'arrowup'){
system.debug('>>>>>>>>>>clientcontact.Client__c>>>>>>>>>'+clientcontact.Client__r.name); 
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c  order by Billboard_Type__c asc  limit 1000];
system.debug('>>>>>>>>>>>>>>>>>>>'+BillboardList);
}
else{
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c  order by Billboard_Type__c desc  limit 1000];
}*/
            billboardrcd+=' :clientid OR Client_Name__r.Hierarchy__c=:clientid';       
        }
        
        else if(clientname.contains('Division')){
            system.debug('Division');
            /* if(sortdirection == 'arrowup'){
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c order by Billboard_Type__c asc  limit 1000];
}
else{
BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c  order by Billboard_Type__c desc limit 1000];
}*/
            billboardrcd+=' :clientid OR Client_Name__r.Hierarchy__c=:clientid OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientid';       
        } 
        
        else{
            system.debug('else');  
            // BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c limit 1000];
            billboardrcd+=' :clientid';      
        }
        
        billboardrcd+= ' order by Billboard_Status__c,  '+''+fieldval+''+sortdirectionval+' limit 1000';
        system.debug('billboardrcd === '+billboardrcd+'\n');
        BillboardList = (Database.query(billboardrcd));
        system.debug('BillboardList === '+BillboardList.size());
        
        Set<Id> contentDocumentIdSet =new Set<Id>();
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
        }
        
        Map<Id,String> contentDocMap=new Map<Id,String>();
        Map<Id,List<String>> contentVerMap=new Map<Id,List<String>>();
        
        List<ContentVersion> conVersList=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC];
        for(ContentVersion cv:conVersList){
            contentDocMap.put(cv.ContentDocumentId,cv.Id);
        }
        
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    if(contentDocMap.containskey(cdl.ContentDocumentId))
                    {
                        if(contentVerMap.containskey(bb.Id))
                        {
                            List<String> ConVeList=contentVerMap.get(bb.Id);
                            ConVeList.add(contentDocMap.get(cdl.ContentDocumentId));
                            contentVerMap.put(bb.Id,ConVeList);
                        }
                        else
                        {
                            contentVerMap.put(bb.Id,new List<string> {contentDocMap.get(cdl.ContentDocumentId)});
                        }
                    }
                }
            }
        }
        
        for(Billboard__c bb: BillboardList){
            if(!contentVerMap.containsKey(bb.Id))
            {
                list<String> aa=new List<string>();
                contentVerMap.put(bb.Id,aa);
            }
        }
        
        for(Billboard__c BB:BillboardList)
        {
            BillboardWrapper BBW = new BillboardWrapper();
            BBW.BBWrap= BB;
            BBW.ContentVersionId=new List<String>();
            for(ContentDocumentLink cdl:BB.ContentDocumentLinks){
                if(contentVerMap.containsKey(bb.Id)){
                    BBW.ContentVersionId=contentVerMap.get(bb.Id);                    break;
                }
            } 
            BBWrapperList.add(BBW);           
        }
        
        return BBWrapperList;
    }
    
     @AuraEnabled
    public static string getClientId(){
        User  lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c  clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        string clientId=clientcontact.Client__c;
        system.debug('component class called === '+clientId);
        return clientId;
    }
    
    // Start Wrapper Class 
    public class BillboardWrapper
    {
        @AuraEnabled public Billboard__c BBWrap{get;set;}
        @AuraEnabled public List<String> ContentVersionId {get;set;}
        public BillboardWrapper()
        {
            BBWrap= new Billboard__c();
        }
        
    }   
    // End of Wrapper Class
}