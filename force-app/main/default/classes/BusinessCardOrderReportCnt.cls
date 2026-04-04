public with sharing class BusinessCardOrderReportCnt 
{

         Transient Public List<Job_Spec__c> Creativebriefs{get;set;}
         Transient Public List<Job__c> joblist{get;set;} 
         public List<JobWrapper>  JW{get;set;}
         public List<JobStoreBusinessWrapper>  JWS{get;set;}
         public list<JobCorporateBusinessCardWrapper> JCBCW{get;set;} // Added a new Corporate Business Card Report
         public list<JobCorporateOfficeNameplateWrapper> JCONW{get;set;} // Added a new Corporate Office Nameplate
         public list<CMNFormWrapper> CMNWrapperlist{get;set;}//added a new CMN form
        
        // Added a new Corporate Office Nameplate
         Map<Id,Job_Spec__c> CONamemap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> COYearofHiremap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> COBuildingMap=new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> COTitlemap =new Map<Id,Job_Spec__c>();
         Map<Id,String> CONamePlatemap =new Map<Id,String>();
        
         Map<Id,Job_Spec__c> Namemap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> Storemap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> YearofHiremap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> Logomap =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> Logomap2 =new Map<Id,Job_Spec__c>();
         Map<Id,Job_Spec__c> Titlemap =new Map<Id,Job_Spec__c>();
        
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
        
       
       // Added a new Corporate Business Card Report
        
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
         
         
         
      // Added a new CMN form   
      
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
         
     //END Added a new CMN form    

        Public string JobStatusString {get;set;}
        public List<SelectOption> getJobStatus()
        {
              List<SelectOption> JobstatusoptionList = new List<selectOption>();
                 
        
                for(schema.picklistEntry p : Job__c.Status__c.getDescribe().getPicklistValues())
                {
                       JobstatusoptionList.add(new SelectOption(p.getLabel(),p.getLabel()));
                }
                
                return JobstatusoptionList;
       } 

       public String SringScheduleTypes{get;set;}
       public List<SelectOption> ScheduleTypes; 
       public List<SelectOption> getScheduleTypes() 
       {
            if (ScheduleTypes!= NULL) 
            {        
                return ScheduleTypes;
            }
            ScheduleTypes= new List<SelectOption>();
            ScheduleTypes.add(new SelectOption('Store Business Card','Store Business Card'));
            ScheduleTypes.add(new SelectOption('Corporate Business Card','Corporate Business Card')); // Added a new Corporate Business Card Report
            ScheduleTypes.add(new SelectOption('Corporate Office Nameplate','Corporate Office Nameplate'));// Added a new Corporate Office Nameplate
            ScheduleTypes.add(new SelectOption('Name Tag','Name Tag'));
            ScheduleTypes.add(new SelectOption('CMN','CMN'));
            
            return ScheduleTypes;
      } 



      Public BusinessCardOrderReportCnt()
      {
            JW = new List<JobWrapper>(); 
            JWS = new List<JobStoreBusinessWrapper>();
            JCBCW = new list<JobCorporateBusinessCardWrapper>(); // Added a new Corporate Business Card Report
            JCONW = new list<JobCorporateOfficeNameplateWrapper>();// Added a new Corporate Office Nameplate
            CMNWrapperlist = new list<CMNFormWrapper>();// Added a new CMN form
      }


      Public pagereference SearchSpecs()
      {

            JW = new List<JobWrapper>(); 
            JWS=new List<JobStoreBusinessWrapper>(); 
            JCBCW=new list<JobCorporateBusinessCardWrapper>();// Added a new Corporate Business Card Report
            JCONW = new list<JobCorporateOfficeNameplateWrapper>();// Added a new Corporate Office Nameplate
            CMNWrapperlist = new list<CMNFormWrapper>();// Added a new CMN form
            
            Logomap.clear();
            
            
            System.debug('JobStatusString  is : ' + JobStatusString  );  
            System.debug('SringScheduleTypes : ' + SringScheduleTypes);  
       
           if(SringScheduleTypes =='Name Tag')
           {
        
                 joblist=[select id,name,JS_Client__r.name,JS_Client__r.Client_Code__c  from Job__c where status__c=:JobStatusString  and  Schedule_Template__r.name=:SringScheduleTypes limit 600];
                 
                 set<string> jIds = new set<String>();
                 for(Job__c aa:joblist)
                 {
                     jIds.add(aa.id);
                 }
                 
                 for(Job_Spec__c spex:[Select id, name,Description__c,Job__c from Job_Spec__c where Job__c In :jIds and Job__r.status__c=:JobStatusString  and Job__r.Schedule_Template__r.name=:SringScheduleTypes])
                 {
                 
                      if(spex.name=='First Name'){Namemap.put(spex.Job__c,spex );}
                    
                      if(spex.name=='Last Name'){Storemap.put(spex.Job__c,spex );}
                     
                      if(spex.name=='Title'){Titlemap.put(spex.Job__c,spex );}
                      
                      if(spex.name=='Year Of Hire'){YearofHiremap.put(spex.Job__c,spex );}
                       
                      if(spex.name=='Logo'){if(!Logomap.containskey(spex.Job__c)){Logomap.put(spex.Job__c,spex);}  else{ Logomap2.put(spex.Job__c,spex );}}
                    
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
                     
                     
                     JW.add(objWrapper);
                 }
         
                 System.debug('JW: ' + JW);  
 
           }
           
           // Added a new Corporate Office Nameplate
           
           else if(SringScheduleTypes =='Corporate Office Nameplate')
           {
        
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
                      
                      if(spex.name=='Name Plate Type'){if(CONamePlatemap.containskey(spex.Job__c)){CONamePlatemap.put(spex.Job__c,CONamePlatemap.get(spex.Job__c)+', '+spex.Description__c);}else{ CONamePlatemap.put(spex.Job__c,spex.Description__c );}}
                    
                 }
                 
                 for(Job__c aa:joblist)
                 {
                 
                     JobCorporateOfficeNameplateWrapper objCNWrapper = new JobCorporateOfficeNameplateWrapper();
                     objCNWrapper.jobspecsTitle=COTitlemap.get(aa.id);
                     objCNWrapper.jobspecsName=CONamemap.get(aa.id);
                     objCNWrapper.jobspecsYearofhire=COYearofHiremap.get(aa.id);
                     objCNWrapper.jobspecsBuilding=COBuildingMap.get(aa.id);
                     objCNWrapper.jobspecsNameplateType=CONamePlatemap.get(aa.id);
                     
                     JCONW.add(objCNWrapper);
                 }
         
                 System.debug('JCONW : ' + JCONW );  
 
           }
           
           
           
           
           
           
           else if(SringScheduleTypes =='Corporate Business Card')
           {
                 LogoCBCmap1 = new Map<Id, String>();
                 CompanyCBCmap = new Map<Id, String>();
                 AddressCBCmap = new Map<Id, String>();
                 WebsiteCBCmap = new Map<Id, String>();
                 
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
                     
                    //     if(spex.name=='Address'){AddressCBCmap.put(spex.Job__c,spex );}
                         
                   //      if(spex.name=='Company'){CompanyCBCmap.put(spex.Job__c,spex );}
                   
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
                     
                     JCBCW.add(objWrapper1);
                }
           
           
           }
           
           
           
           // Added a new CMN form
           
           else if(SringScheduleTypes =='CMN')
           {
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
                     
                     
                      CMNWrapperlist.add(CMNWrapper);
                 }
                 
                 
                 
                 
                 
                 
                 
           }
         
           else
           {
    
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
                     
                     
                     JWS.add(objWrapper1);
             }
 
             System.debug('JWS: ' + JWS);  
 
          }

          return null;
      }



        public class JobWrapper
        {              
               public Job__c job{get;set;}
               public Job_Spec__c jobspecsTitle{get;set;}
               public Job_Spec__c jobspecsName{get;set;}
               public Job_Spec__c jobspecsLogo{get;set;}
               public Job_Spec__c jobspecsLogo2{get;set;}
               public Job_Spec__c jobspecsStore{get;set;}
               public Job_Spec__c jobspecsYearofhire{get;set;}
               public List<Job_Spec__c> jobspecs{get;set;}
               public JobWrapper()
               {
                 
               }
        }
       
        public class JobStoreBusinessWrapper
        {              
               public Job__c job{get;set;}
               public Job_Spec__c jobspecsTitle{get;set;}
               public Job_Spec__c jobspecsName{get;set;}
               public Job_Spec__c jobspecsLogo{get;set;}
               public Job_Spec__c jobspecsAddress{get;set;}
               public Job_Spec__c jobspecsCity{get;set;}
               public Job_Spec__c jobspecsState{get;set;}
               public Job_Spec__c jobspecsZip{get;set;}
               public Job_Spec__c jobspecsPhone{get;set;}
               public Job_Spec__c jobspecsFax{get;set;}
               public Job_Spec__c jobspecsEmail{get;set;}
               public Job_Spec__c jobspecsWebsite{get;set;}
               
               public JobStoreBusinessWrapper()
               {
                 
               }
        }   
        
        
     // added a new CMN form logic   
        
        public class CMNFormWrapper
        {              
               public Job__c job{get;set;}
               public string Clientname{get;set;}
               public string ClientCode{get;set;}
               public Job_Spec__c CMNFlyerNameofEvent{get;set;}
               public Job_Spec__c CMNFlyerDate{get;set;}
               public Job_Spec__c CMNFlyerTime{get;set;}
               public Job_Spec__c CMNFlyerEventDetails{get;set;}
               public Job_Spec__c CMNFlyerSpecialDetails{get;set;}
               public Job_Spec__c CMNBannerNameofEvent{get;set;}
               public Job_Spec__c CMNBannerDate{get;set;}
               public Job_Spec__c CMNBannerTime{get;set;}
               public Job_Spec__c CMNBannerEventDetails{get;set;}
               public Job_Spec__c CMNBannerSpecialDetails{get;set;}
               
               public CMNFormWrapper()
               {
                 
               }
        }
        
        
        
        
        
        public class JobCorporateBusinessCardWrapper
        {              
               public Job__c job{get;set;}
               public Job_Spec__c jobspecsDept{get;set;}
               public Job_Spec__c jobspecsTitle{get;set;}
               public Job_Spec__c jobspecsName{get;set;}
               public Job_Spec__c jobspecsLogo{get;set;}
               public string jobspecsLogo1{get;set;}
               public string jobspecsCompany{get;set;}
               public string jobspecsAddress{get;set;}
               public Job_Spec__c jobspecsPhone{get;set;}
               public Job_Spec__c jobspecsFax{get;set;}
               public Job_Spec__c jobspecsEmail{get;set;}
               public Job_Spec__c jobspecsMobile{get;set;}
               public string  jobspecsWebsite{get;set;}
               
               public JobCorporateBusinessCardWrapper()
               {
                 
               }
        }  
        
        
        public class JobCorporateOfficeNameplateWrapper
        {              
               
               public Job_Spec__c jobspecsTitle{get;set;}
               public Job_Spec__c jobspecsName{get;set;}
               public Job_Spec__c jobspecsYearofhire{get;set;}
               public Job_Spec__c jobspecsBuilding{get;set;}
               public String jobspecsNameplateType{get;set;}
               
               public JobCorporateOfficeNameplateWrapper()
               {
                 
               }
        }  
        
       
       
       Public Pagereference Excel()
       {
             Pagereference  pr=new Pagereference ('/apex/BusinessCardOrderReportExcel');
             pr.setRedirect(false);
             return pr;
       }  
       
       
}