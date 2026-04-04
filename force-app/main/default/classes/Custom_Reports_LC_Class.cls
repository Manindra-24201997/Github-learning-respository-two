public class Custom_Reports_LC_Class {
    
    @AuraEnabled
    public static String ProfileInformation(){
        String usrProfileName = [select Id,User.Profile.Name from User where Id = :Userinfo.getUserId() WITH SECURITY_ENFORCED].Profile.Name;
        return usrProfileName ;
    }
    @AuraEnabled
    public static List<String> getJobStatus()
    {
        List<String> JobstatusoptionList = new List<String>();
        for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
        {
            JobstatusoptionList.add(p.getLabel());
        }                
        return JobstatusoptionList;
    } 
    
    @AuraEnabled
    public static List<object> getResultsList(string JobStatusString,string SringScheduleTypes)
    {
        System.debug('JobStatusString  is : ' + JobStatusString  );  
        System.debug('SringScheduleTypes : ' + SringScheduleTypes);  
        list<Job__c> joblist=new List<Job__c>();
        List<JobWrapper> jWResults=new List<JobWrapper>();
        List<JobCorporateOfficeNameplateWrapper> JCONWResult=new List<JobCorporateOfficeNameplateWrapper>();
        List<JobCorporateBusinessCardWrapper> JCBCWResult=new List<JobCorporateBusinessCardWrapper>();
        List<JobStoreBusinessWrapper> JSBCWResult=new List<JobStoreBusinessWrapper>();
        List<CMNFormWrapper> CMNWrapperlist=new List<CMNFormWrapper>();
        
        if(SringScheduleTypes =='Name Tag')
        {
            Map<Id,Job_Spec__c> Namemap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> Storemap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> YearofHiremap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> Logomap =new Map<Id,Job_Spec__c>(); 
            Map<Id,Job_Spec__c> Logomap2 =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> Titlemap =new Map<Id,Job_Spec__c>();
            
            joblist=[select id,name,JS_Client__r.name,JS_Client__r.Client_Code__c  from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes limit 600];
            
            set<string> jobIds = new set<String>();
            for(Job__c aa:joblist)
            {
                jobIds.add(aa.id);
            }
            
            for(Job_Spec__c specs:[Select id, name,Description__c,Job__c from Job_Spec__c where Job__c In :jobIds and Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
            {
                if(specs.name=='First Name'){Namemap.put(specs.Job__c,specs );}
                if(specs.name=='Last Name'){Storemap.put(specs.Job__c,specs );}
                if(specs.name=='Title'){Titlemap.put(specs.Job__c,specs );}
                if(specs.name=='Year Of Hire'){YearofHiremap.put(specs.Job__c,specs );}
                if(specs.name=='Logo'){
                    if(!Logomap.containskey(specs.Job__c))
                    {
                        Logomap.put(specs.Job__c,specs);
                    } 
                    else{ 
                        Logomap2.put(specs.Job__c,specs );
                    }
                }
            }
            
            for(Job__c aa:joblist)
            {
                JobWrapper objWrapper = new JobWrapper();
                objWrapper.job=aa;
                objWrapper.jobspecs=aa.Job_Specs__r;
                objWrapper.jobspecsName=Namemap.get(aa.id);
                objWrapper.jobspecsLogo=Logomap.get(aa.id);
                objWrapper.jobspecsLogo2=Logomap2.get(aa.id);
                objWrapper.jobspecsStore=Storemap.get(aa.id);
                objWrapper.jobspecsYearofhire=YearofHiremap.get(aa.id);
                objWrapper.jobspecsTitle=Titlemap.get(aa.id);
                jWResults.add(objWrapper);
            }
            //System.debug('jWResults: ' + jWResults);  
            return jWResults;
        }        
        else if(SringScheduleTypes =='Corporate Office Nameplate')
        {
            Map<Id,Job_Spec__c> CONamemap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> COYearofHiremap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> COBuildingMap=new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> COTitlemap =new Map<Id,Job_Spec__c>();
            Map<Id,String> CONamePlatemap =new Map<Id,String>();
            
            joblist=[select id,name,JS_Client__r.name,JS_Client__r.Client_Code__c  from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes limit 600];
            
            set<string> jIds = new set<String>();
            for(Job__c aa:joblist)
            {
                jIds.add(aa.id);
            }
            
            for(Job_Spec__c spex:[Select id, name,Description__c,Job__c from Job_Spec__c where Job__c In :jIds and Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
            {
                
                if(spex.name=='Title'){COTitlemap.put(spex.Job__c,spex );}
                if(spex.name=='Name'){CONamemap.put(spex.Job__c,spex );}
                if(spex.name=='Year Of Hire'){COYearofHiremap.put(spex.Job__c,spex );}
                if(spex.name=='Building'){COBuildingMap.put(spex.Job__c,spex );}
                if(spex.name=='Name Plate Type'){
                    if(CONamePlatemap.containskey(spex.Job__c)){
                        CONamePlatemap.put(spex.Job__c,CONamePlatemap.get(spex.Job__c)+', '+spex.Description__c);
                    }else{ 
                        CONamePlatemap.put(spex.Job__c,spex.Description__c );
                    }
                }
            }
            
            for(Job__c aa:joblist)
            {
                
                JobCorporateOfficeNameplateWrapper objCNWrapper = new JobCorporateOfficeNameplateWrapper();
                objCNWrapper.jobspecsTitle=COTitlemap.get(aa.id);
                objCNWrapper.jobspecsName=CONamemap.get(aa.id);
                objCNWrapper.jobspecsYearofhire=COYearofHiremap.get(aa.id);
                objCNWrapper.jobspecsBuilding=COBuildingMap.get(aa.id);
                objCNWrapper.jobspecsNameplateType=CONamePlatemap.get(aa.id);
                JCONWResult.add(objCNWrapper);
            }
            //System.debug('JCONWResult : ' + JCONWResult );  
            return JCONWResult;
        }
        else if(SringScheduleTypes =='Corporate Business Card')
        {
            Map<Id,Job_Spec__c> NameCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> DeptCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> TitleCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> LogoCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,String> LogoCBCmap1 =new Map<Id,String>();
            Map<Id,String> AddressCBCmap =new  Map<Id,String>();
            Map<Id,String> CompanyCBCmap =new Map<Id,String>();
            Map<Id,Job_Spec__c> EmailCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,string> WebsiteCBCmap =new Map<Id,string>();
            Map<Id,Job_Spec__c> PhoneCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> FaxCBCmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> MobileCBCmap =new Map<Id,Job_Spec__c>();
            
            joblist=[select id,name from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes  limit 600];
            
            set<string> jIds = new set<String>();
            for(Job__c aa:joblist)
            {
                jIds.add(aa.id);
            }
            
            for(Job_Spec__c spex:[Select id, name,Description__c,Job__c from Job_Spec__c where Job__c In :jIds and  Job__c In :jIds and  Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
            {
                
                if(spex.name=='Name'){NameCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Department'){DeptCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Title'){TitleCBCmap.put(spex.Job__c,spex );}                
                if(spex.name=='Address'){if(AddressCBCmap.containskey(spex.Job__c)){AddressCBCmap.put(spex.Job__c,AddressCBCmap.get(spex.Job__c)+', '+spex.Description__c);}else{ AddressCBCmap.put(spex.Job__c,spex.Description__c );}}
                if(spex.name=='Company'){if(CompanyCBCmap.containskey(spex.Job__c)){CompanyCBCmap.put(spex.Job__c,CompanyCBCmap.get(spex.Job__c)+', '+spex.Description__c);}else{ CompanyCBCmap.put(spex.Job__c,spex.Description__c );}}
                if(spex.name=='Email'){EmailCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Web site'){if(WebsiteCBCmap.containskey(spex.Job__c)){WebsiteCBCmap.put(spex.Job__c,WebsiteCBCmap.get(spex.Job__c)+', '+spex.Description__c);}else{ WebsiteCBCmap.put(spex.Job__c,spex.Description__c );}}
                if(spex.name=='Phone'){PhoneCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Mobile'){MobileCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Fax'){FaxCBCmap.put(spex.Job__c,spex );}
                if(spex.name=='Logo'){if(LogoCBCmap1.containskey(spex.Job__c)){LogoCBCmap1.put(spex.Job__c,LogoCBCmap1.get(spex.Job__c)+', '+spex.Description__c);}else{ LogoCBCmap1.put(spex.Job__c,spex.Description__c );}}
                if(spex.name=='ICE Chat') {
                    LogoCBCmap.put(spex.Job__c,spex );
                }
            }
            system.debug('LogoCBCmap1 ---> '+LogoCBCmap1);
            for(Job__c aa:joblist)
            {
                
                JobCorporateBusinessCardWrapper objWrapper1 = new JobCorporateBusinessCardWrapper();
                objWrapper1.job=aa;
                objWrapper1.jobspecsTitle=TitleCBCmap.get(aa.id);
                objWrapper1.jobspecsDept=DeptCBCmap.get(aa.id);
                objWrapper1.jobspecsName=NameCBCmap.get(aa.id);
                objWrapper1.jobspecsLogo=LogoCBCmap.get(aa.id);
                objWrapper1.jobspecsLogo1=LogoCBCmap1.get(aa.id);
                objWrapper1.jobspecsAddress=AddressCBCmap.get(aa.id);
                objWrapper1.jobspecsCompany=CompanyCBCmap.get(aa.id);
                objWrapper1.jobspecsPhone=PhoneCBCmap.get(aa.id);
                objWrapper1.jobspecsFax=FaxCBCmap.get(aa.id);
                objWrapper1.jobspecsEmail=EmailCBCmap.get(aa.id);
                objWrapper1.jobspecsMobile=MobileCBCmap.get(aa.id);
                objWrapper1.jobspecsWebsite=WebsiteCBCmap.get(aa.id);
                JCBCWResult.add(objWrapper1);
            }
            return JCBCWResult;
        }
        else if(SringScheduleTypes =='CMN')
        {
            Map<Id,Job_Spec__c> CMNFlyerNameofEventMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNFlyerDateMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNFlyerTimeMap=new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNFlyerEventDetailsMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNFlyerSpecialDetailsMap =new Map<Id,Job_Spec__c>();
            
            Map<Id,Job_Spec__c> CMNBannerNameofEventMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNBannerDateMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNBannerTimeMap=new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNBannerEventDetailsMap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CMNBannerSpecialDetailsMap =new Map<Id,Job_Spec__c>();
            
            joblist=[select id,name,JS_Client__r.name,JS_Client__r.Client_Code__c  from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes limit 600];
            
            set<string> jIds = new set<String>();
            for(Job__c aa:joblist)
            {
                jIds.add(aa.id);
            }
            
            for(Job_Spec__c spex:[Select id, name,Description__c,Job__c,Creative_Brief_Template__c from Job_Spec__c where Job__c In :jIds and  Job__c In :jIds and  Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
            {
                if(spex.name=='Name of Event' && spex.Creative_Brief_Template__c=='Flyers'){CMNFlyerNameofEventMap.put(spex.Job__c,spex );}
                if(spex.name=='Date' && spex.Creative_Brief_Template__c=='Flyers'){CMNFlyerDateMap.put(spex.Job__c,spex );}
                if(spex.name=='Time' && spex.Creative_Brief_Template__c=='Flyers'){CMNFlyerTimeMap.put(spex.Job__c,spex );}
                if(spex.name=='Event Details' && spex.Creative_Brief_Template__c=='Flyers'){CMNFlyerEventDetailsMap.put(spex.Job__c,spex );}
                if(spex.name=='Special Details' && spex.Creative_Brief_Template__c=='Flyers'){CMNFlyerSpecialDetailsMap.put(spex.Job__c,spex );}
                if(spex.name=='Name of Event' && spex.Creative_Brief_Template__c=='Banner'){CMNBannerNameofEventMap.put(spex.Job__c,spex );}
                if(spex.name=='Date' && spex.Creative_Brief_Template__c=='Banner'){CMNBannerDateMap.put(spex.Job__c,spex );}
                if(spex.name=='Time' && spex.Creative_Brief_Template__c=='Banner'){CMNBannerTimeMap.put(spex.Job__c,spex );}
                if(spex.name=='Event Details' && spex.Creative_Brief_Template__c=='Banner'){CMNBannerEventDetailsMap.put(spex.Job__c,spex );}
                if(spex.name=='Special Details' && spex.Creative_Brief_Template__c=='Banner'){CMNBannerSpecialDetailsMap.put(spex.Job__c,spex );}
            }
            
            for(Job__c aa:joblist)
            {
                
                CMNFormWrapper CMNWrapper = new CMNFormWrapper();
                CMNWrapper.job=aa;
                CMNWrapper.Clientname=aa.JS_Client__r.name;
                CMNWrapper.ClientCode=aa.JS_Client__r.Client_Code__c;
                CMNWrapper.CMNFlyerNameofEvent=CMNFlyerNameofEventMap.get(aa.id);
                CMNWrapper.CMNFlyerDate=CMNFlyerDateMap.get(aa.id);
                CMNWrapper.CMNFlyerTime=CMNFlyerTimeMap.get(aa.id);
                CMNWrapper.CMNFlyerEventDetails=CMNFlyerEventDetailsMap.get(aa.id);
                CMNWrapper.CMNFlyerSpecialDetails=CMNFlyerSpecialDetailsMap.get(aa.id);
                CMNWrapper.CMNBannerNameofEvent=CMNBannerNameofEventMap.get(aa.id);
                CMNWrapper.CMNBannerDate=CMNBannerDateMap.get(aa.id);
                CMNWrapper.CMNBannerTime=CMNBannerTimeMap.get(aa.id);
                CMNWrapper.CMNBannerEventDetails=CMNBannerEventDetailsMap.get(aa.id);
                CMNWrapper.CMNBannerSpecialDetails=CMNBannerSpecialDetailsMap.get(aa.id);
                system.debug(CMNWrapper);
                CMNWrapperlist.add(CMNWrapper);
            }
            return CMNWrapperlist;
        }
        else
        {
            Map<Id,Job_Spec__c> NameSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> TitleSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> LogoSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> AddressSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> CitySBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> StateSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> ZipSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> EmailSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> WebsiteSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> PhoneSBmap =new Map<Id,Job_Spec__c>();
            Map<Id,Job_Spec__c> FaxSBmap =new Map<Id,Job_Spec__c>();
            
            
            joblist=[select id,name from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes  limit 600];
            
            set<string> jIds = new set<String>();
            for(Job__c aa:joblist)
            {
                jIds.add(aa.id);
            }
            
            for(Job_Spec__c spex:[Select id, name,Description__c,Job__c from Job_Spec__c where  Job__c In :jIds and Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
            {
                if(spex.name=='Name'){NameSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Title'){TitleSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Address'){AddressSBmap.put(spex.Job__c,spex );}
                if(spex.name=='City'){CitySBmap.put(spex.Job__c,spex );}
                if(spex.name=='State'){StateSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Zip'){ZipSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Email'){EmailSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Web site'){WebsiteSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Phone'){PhoneSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Fax'){FaxSBmap.put(spex.Job__c,spex );}
                if(spex.name=='Logo'){LogoSBmap.put(spex.Job__c,spex );}
            }
            
            for(Job__c aa:joblist)
            {
                JobStoreBusinessWrapper objWrapper1 = new JobStoreBusinessWrapper();
                objWrapper1.job=aa;
                objWrapper1.jobspecsTitle=TitleSBmap.get(aa.id);
                objWrapper1.jobspecsName=NameSBmap.get(aa.id);
                objWrapper1.jobspecsLogo=LogoSBmap.get(aa.id);
                objWrapper1.jobspecsAddress=AddressSBmap.get(aa.id);
                objWrapper1.jobspecsCity=CitySBmap.get(aa.id);
                objWrapper1.jobspecsState=StateSBmap.get(aa.id);
                objWrapper1.jobspecsZip=ZipSBmap.get(aa.id);
                objWrapper1.jobspecsPhone=PhoneSBmap.get(aa.id);
                objWrapper1.jobspecsFax=FaxSBmap.get(aa.id);
                objWrapper1.jobspecsEmail=EmailSBmap.get(aa.id);
                objWrapper1.jobspecsWebsite=WebsiteSBmap.get(aa.id);
                JSBCWResult.add(objWrapper1);
            }
            //System.debug('JSBCWResult: ' + JSBCWResult);  
            return JSBCWResult;
        }
        
    }    
    
    public class JobWrapper
    {              
        @AuraEnabled public Job__c job{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsTitle{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsName{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsLogo{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsLogo2{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsStore{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsYearofhire{get;set;}
        @AuraEnabled public List<Job_Spec__c> jobspecs{get;set;}      
        public JobWrapper()
        {
            
        }
    }
    
    public class JobCorporateOfficeNameplateWrapper
    {              
        @AuraEnabled public Job_Spec__c jobspecsTitle{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsName{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsYearofhire{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsBuilding{get;set;}
        @AuraEnabled  public String jobspecsNameplateType{get;set;}
        public JobCorporateOfficeNameplateWrapper()
        {
            
        }
    }  
    public class JobCorporateBusinessCardWrapper
    {              
        @AuraEnabled public Job__c job{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsDept{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsTitle{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsName{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsLogo{get;set;}
        @AuraEnabled public string jobspecsLogo1{get;set;}
        @AuraEnabled public string jobspecsCompany{get;set;}
        @AuraEnabled public string jobspecsAddress{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsPhone{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsFax{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsEmail{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsMobile{get;set;}
        @AuraEnabled public string  jobspecsWebsite{get;set;}
        public JobCorporateBusinessCardWrapper()
        {
            
        }
    }  
    public class JobStoreBusinessWrapper
    {              
        @AuraEnabled public Job__c job{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsTitle{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsName{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsLogo{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsAddress{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsCity{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsState{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsZip{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsPhone{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsFax{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsEmail{get;set;}
        @AuraEnabled public Job_Spec__c jobspecsWebsite{get;set;}
        public JobStoreBusinessWrapper()
        {
            
        }
    }  
    public class CMNFormWrapper
    {              
        @AuraEnabled public Job__c job{get;set;}
        @AuraEnabled public string Clientname{get;set;}
        @AuraEnabled public string ClientCode{get;set;}
        @AuraEnabled public Job_Spec__c CMNFlyerNameofEvent{get;set;}
        @AuraEnabled public Job_Spec__c CMNFlyerDate{get;set;}
        @AuraEnabled public Job_Spec__c CMNFlyerTime{get;set;}
        @AuraEnabled public Job_Spec__c CMNFlyerEventDetails{get;set;}
        @AuraEnabled public Job_Spec__c CMNFlyerSpecialDetails{get;set;}
        @AuraEnabled public Job_Spec__c CMNBannerNameofEvent{get;set;}
        @AuraEnabled public Job_Spec__c CMNBannerDate{get;set;}
        @AuraEnabled public Job_Spec__c CMNBannerTime{get;set;}
        @AuraEnabled public Job_Spec__c CMNBannerEventDetails{get;set;}
        @AuraEnabled public Job_Spec__c CMNBannerSpecialDetails{get;set;}
        public CMNFormWrapper()
        {
            
        }
    }
    
    /*------------BB_Binder_Report------------------------Logic-------------*/
    @AuraEnabled
    public static List<string> getBBStatus(){
        List<string> BBstatusoptionList = new List<string>();
        for(schema.picklistEntry p : Billboard__c.Billboard_Status__c.getDescribe().getPicklistValues()){
            BBstatusoptionList .add(p.getLabel());
        }
        return BBstatusoptionList ;
    } 
    
    @AuraEnabled
    public static List<String> getBBType(){
        List<String> optionList = new List<String>();
        for(schema.picklistEntry p : Billboard__c.Billboard_Type__c.getDescribe().getPicklistValues()){
            optionList .add(p.getLabel());
        }        
        return optionList ;
    } 
    
    @AuraEnabled
    public static List<String> getIllumination(){
        List<String> optionList = new List<String>();         
        for(schema.picklistEntry p : Billboard__c.Illumination__c.getDescribe().getPicklistValues()){
            optionList .add(p.getLabel());
        }        
        return optionList ;
    } 
    
    
    @AuraEnabled
    public static List<string> getDistrict(){
        List<string> optionList = new List<string>();         
        for(schema.picklistEntry p : Client__c.Dummy_Picklist_1__c.getDescribe().getPicklistValues()){
            optionList .add(p.getLabel());
        }        
        return optionList ;
    } 
    
   
    @AuraEnabled 
    public static Map<String, String> getClients(){
        Map<String, String> optionList = new Map<String, String>();       
        for (Client__c a : [SELECT Id, name,client_code__c FROM Client__c order by Name]) 
        {  
            optionList.put(a.Name,a.Name + (a.client_code__c != null?' - ':'') + (a.client_code__c != null?a.client_code__c:''));    
        }       
        return optionList;
    }
    
    @AuraEnabled
    public static List<string> getvendors() 
    {    
        List<string> optionList = new List<string>();         
        for (vendor__c  a : [SELECT Id, name FROM vendor__c order by Name]) 
        {  
            optionList.add(a.Name);     
        }
        return optionList;  
    } 
    
    @AuraEnabled
    Public static list<object> searchbillboards(string strBBname,string strTitle,string strBBlocation,string BBStatusString,Boolean strIllumination,string strBBClientName,string strDistrict,string strBBVendorName,string strBBtype,string strSize,string strPMT,string strLat,string strlong,string expD1,string expD2) {
        
        // Date D1=dat.Expiration_Date__c;
        // Date D2=dat2.Expiration_Date__c;
        system.debug('expD1---'+expD1);
        system.debug('expD2---'+expD2);
        
        ClientNameWrapper tmpCNW=new ClientNameWrapper();
        ClienDistrictWrapper tmpCDWrapper=new ClienDistrictWrapper();
        List<ClientNameWrapper> CNW=new  List<ClientNameWrapper>();
        List<ClienDistrictWrapper>  CDWrapper=new  List<ClienDistrictWrapper>();
        List<BBWrapper>  BW=new List<BBWrapper> ();
        list<Billboard__c> tempbillboards= new List<Billboard__c>();        
        
        system.debug('client name'+strBBClientName); 
        string soql='Select id ,name ,Title__c,Size__c,Client_Name__r.Client_Code__c,Attachment_ID__c ,Client_Name__c,Client_Name__r.name,Photo_2_New__c,Client_Name__r.Dummy_Picklist_1__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__r.Dummy_Picklist_1__c !=null ';
        string  soqlImages= 'Select id ,name ,Title__c,Size__c,Client_Name__r.Client_Code__c,Attachment_ID__c ,Client_Name__c,Client_Name__r.name,Photo_2_New__c,Client_Name__r.Dummy_Picklist_1__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c ,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp asc limit 1) from Billboard__c where Client_Name__r.Dummy_Picklist_1__c !=null ';
        
        if(strBBname!=null)
        { soql +=' And Name like \'%'+String.escapeSingleQuotes(strBBname)+'%\' ';
           soqlImages +=' And Name like \'%'+String.escapeSingleQuotes(strBBname)+'%\' ';
        }
        if(strTitle!=null)
        {   soql +=' And Title__c like \'%'+String.escapeSingleQuotes(strTitle)+'%\' ';
           soqlImages +=' And Title__c like \'%'+String.escapeSingleQuotes(strTitle)+'%\' ';
        }
        if(strBBlocation!=null)
        {  soql +=' And Location__c like \'%'+String.escapeSingleQuotes(strBBlocation)+'%\' ';
        soqlImages +=' And Location__c like \'%'+String.escapeSingleQuotes(strBBlocation)+'%\' ';
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>BBStatusString1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+BBStatusString);
        }
        if(!String.ISBLANK(BBStatusString))
        {  soql +=' And Billboard_Status__c =:BBStatusString';
        soqlImages +=' And Billboard_Status__c =:BBStatusString';
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>BBStatusString2>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+BBStatusString ); 
        }
        //if(!String.ISBLANK(strIllumination))
        if(strIllumination!=null)
        {soql +=' And Illumination__c=:strIllumination';
         soqlImages +=' And Illumination__c=:strIllumination';
        system.debug('Illumination'+strIllumination); 
        }
        if(!String.ISBLANK(strBBClientName))
        { soql +=' And Client_Name__r.name =:strBBClientName';
        soqlImages +=' And Client_Name__r.name =:strBBClientName';
        system.debug('client name'+strBBClientName);  
        }
        
        if(!String.ISBLANK(strDistrict))
        { soql +=' And Client_Name__r.Dummy_Picklist_1__c=:strDistrict'; 
        soqlImages +=' And Client_Name__r.Dummy_Picklist_1__c=:strDistrict';
        }
        if(!String.ISBLANK(strBBVendorName))
        { soql +=' And BB_Vendor__r.name=:strBBVendorName';
        soqlImages +=' And BB_Vendor__r.name=:strBBVendorName';}
        if(!String.ISBLANK(strBBtype))
        {soql +=' And Billboard_Type__c =:strBBtype';
         soqlImages +=' And Billboard_Type__c =:strBBtype';}
        if(!String.IsBlank(strSize) )
        {soql +=' And Size__c=:strSize';
         soqlImages+=' And Size__c=:strSize';}
        if(!String.ISBLANK(expD1) && !String.ISBLANK(expD2))
        {
            date d1=date.valueOf(expD1);
            system.debug('d1---'+d1);
            date d2=date.valueOf(expD2) ;
            system.debug('d2---'+d2);
            soql +=' And (Expiration_Date__c>=:d1 AND Expiration_Date__c<=:d2)'; 
            soqlImages+=' And (Expiration_Date__c>=:d1 AND Expiration_Date__c<=:d2)'; 
        }
        
        if(!String.ISBLANK(strPMT))
        {  Decimal pmatDecimal=Decimal.valueOf(strPMT);
            soql +=' And PMT__c  =:pmatDecimal';
         soqlImages +=' And PMT__c  =:pmatDecimal';}
        if(!String.ISBLANK(strLat))
        {  soql +=' And Latitude__c=:strLat';
        soqlImages +=' And Latitude__c=:strLat';}
        if(!String.IsBlank(strlong))
        {  soql +=' And Longitude__c=:strlong';
        soqlImages+=' And Longitude__c=:strlong';
    }
        soql +=' order by Client_Name__r.Dummy_Picklist_1__c ,Client_Name__r.Client_Code__c,Name limit 150'; 
        soqlImages+=' order by Client_Name__r.Dummy_Picklist_1__c ,Client_Name__r.Client_Code__c,Name limit 150'; 
        System.debug('Query is : ' + soql);  
        System.debug('Query images is  : ' + soqlImages);  
        
        tempbillboards=Database.query(soql);
        system.debug('Size of BBs list ::::: ' + tempbillboards.size());
        
        string strClientDistNew;
        string strClientNameNew;
        string strClientCodeNew;
        list<Billboard__c> billWithImage=Database.query(soqlImages);
         //system.debug('Size of billWithImage list ::::: ' + billWithImage);
        list<Id> contentDocumentIdvalues=new list<Id>();
        map<id,id> cDocToBillMap=new map<id,id>();
        if(!billWithImage.isEmpty()){
            for(Billboard__c bI:billWithImage){
                for(ContentDocumentLink cdl: bI.ContentDocumentLinks){
                    contentDocumentIdvalues.add(cdl.ContentDocumentId);
                    cDocToBillMap.put(cdl.ContentDocumentId,bI.id);
                }
            }
        }
        system.debug('cDocToBillMap--'+cDocToBillMap);
        Map<Id,String> contentDocMap=new Map<Id,String>();
        list<ContentVersion> conVersListValues=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId=:contentDocumentIdvalues and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC];
        system.debug('conVersListValues---'+conVersListValues);
        for(ContentVersion cv:conVersListValues){
            contentDocMap.put(cDocToBillMap.get(cv.ContentDocumentId),cv.Id);
            //system.debug('--contentDocMap--'+contentDocMap);
        }
       
        
        for(Billboard__c aa:tempbillboards)
        {
            if (strClientDistNew!= aa.Client_Name__r.Dummy_Picklist_1__c )
            {
                if (strClientDistNew != null)
                {                                
                    tmpCNW.BWrapper= BW;
                    CNW.add(tmpCNW);
                    tmpCDWrapper.CNWrapper= CNW;
                    CDWrapper.add(tmpCDWrapper);
                    //system.debug('cWrapper :::::::::'+CDWrapper);                                                                      
                }
                
                tmpCNW= new ClientNameWrapper();     
                tmpCDWrapper= new ClienDistrictWrapper();     
                
                tmpCDWrapper.strClientDist = strClientDistNew = aa.Client_Name__r.Dummy_Picklist_1__c ;
                tmpCNW.strClientName = strClientNameNew = aa.Client_Name__r.Name;
                tmpCNW.strClientCode = strClientCodeNew= aa.Client_Name__r.Client_Code__c;
                
                CNW= new List<ClientNameWrapper>();
                BW = new List<BBWrapper>();
            }   
            else{
                if (strClientNameNew != aa.Client_Name__r.Name) 
                { 
                    if(BW.size() > 0 && BW.size() !=null)
                    {     
                        tmpCNW.BWrapper= BW;
                        CNW.add(tmpCNW);
                        tmpCNW= new ClientNameWrapper();
                        tmpCNW.strClientName = strClientNameNew = aa.Client_Name__r.Name;
                        tmpCNW.strClientCode = strClientCodeNew= aa.Client_Name__r.Client_Code__c;
                        strClientDistNew = aa.Client_Name__r.Dummy_Picklist_1__c; 
                    }                  
                    BW = new List<BBWrapper>();                       
                } 
            }
            BBWrapper objWrapper = new BBWrapper();
            objWrapper.BB= aa;
            system.debug('contentDocMap1----'+contentDocMap);
            objWrapper.ContentVersionId=contentDocMap.get(aa.id);
            //system.debug('--objWrapper---'+objWrapper);            
            BW.add(objWrapper); 
        }
        
        if (strClientDistNew != null){
            
            tmpCNW.BWrapper= BW;
            CNW.add(tmpCNW);
            tmpCDWrapper.CNWrapper= CNW;
            CDWrapper.add(tmpCDWrapper);
            
        }    
       // system.debug('--CDWrapper-'+CDWrapper);
        return CDWrapper;
    }
    
    
    public class ClienDistrictWrapper
    {
        @AuraEnabled public List<ClientNameWrapper> CNWrapper{get;set;}
        @AuraEnabled public string strClientDist {get;set;} 
        public ClienDistrictWrapper()
        {
            if(CNWrapper== NULL) {CNWrapper= new List<ClientNameWrapper>();}
        }
    }
    
    public class ClientNameWrapper    
    { 
        @AuraEnabled public string strClientName {get;set;}
        @AuraEnabled public string strClientCode {get;set;}
        @AuraEnabled public List<BBWrapper> BWrapper{get;set;}
        public ClientNameWrapper()
        {
            if(BWrapper== NULL) {BWrapper= new List<BBWrapper>();}
        }  
    }
    
    public class BBWrapper
    {              
        @AuraEnabled public Billboard__c BB {get;set;}
        @AuraEnabled public String ContentVersionId {get;set;}
        public BBWrapper()
        {
            
        }
    }
    
    
}