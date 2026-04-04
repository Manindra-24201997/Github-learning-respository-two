public with sharing class CMNFormOrdersController 
{
    
     public boolean isTab{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t' || theme=='Theme4d')?true:false;
                                          }
    }
    
    
    
    Public boolean ShowCMNForm{get;set;}  //  added new form CMN Form in Store Order type
    Public boolean ShowCMNBannerForm{get;set;} 
    Public boolean ShowCMNConForm{get;set;} 
    Public Schedule_Template__c CMNScheduletype{get;set;}
    Public Media_Type__c NameMediatype{get;set;}
    Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;} 
   
    Public String CMNFlyerNameofEvent{get;set;}
    Public String CMNFlyerDate{get;set;}
    Public String CMNFlyerTime{get;set;}
    Public String CMNFlyerEventDetails{get;set;}
    Public String CMNFlyerSpecialDetails{get;set;}
    
    Public String CMNBannerNameofEvent{get;set;}
    Public String CMNBannerDate{get;set;}
    Public String CMNBannerTime{get;set;}
    Public String CMNBannerEventDetails{get;set;}
    Public String CMNBannerSpecialDetails{get;set;}
    Public Boolean FlyerApproved{get;set;}
    Public Boolean BannerApproved{get;set;}
    
    
    
    public CMNFormOrdersController()
    {
        ShowCMNForm=true;
        ShowCMNBannerForm=false;
        ShowCMNConForm=false;
        
            NameMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
            CMNScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='CMN' AND Media_Types__r.name='Print' limit 1];//  added new form CMN Form in Store Order type
            lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
            clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Client_Code__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
            System.debug('ClientContact'+clientcontact.name);
    }
    
    public void CMNBMethod() 
    {
      
         if((string.isBlank(CMNFlyerNameofEvent)) || (string.isBlank(CMNFlyerDate)) || (string.isBlank(CMNFlyerTime)))
         {
             if(string.isBlank(CMNFlyerNameofEvent))
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Name of Event'));
             }
             if(string.isBlank(CMNFlyerDate))
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Date'));
             }
             if(string.isBlank(CMNFlyerTime))
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Time'));
             }
             
         }
         else
         {
            ShowCMNForm=false;
            ShowCMNBannerForm=true;
            ShowCMNConForm=false;
         }
          
       
          
    }


    public PageReference Back() 
    {
        PageReference pageRef = new PageReference('/apex/StorefrontJobRequestForm');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void CMNConMethod() 
    {    
    
         if((string.isBlank(CMNBannerNameofEvent)) || (string.isBlank(CMNBannerTime)) || (string.isBlank(CMNBannerDate)))
         {
             if(string.isBlank(CMNBannerNameofEvent))
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Name of Event'));
             }
             if(string.isBlank(CMNBannerTime))
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Time'));
             }
             if(string.isBlank(CMNBannerDate))
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Date'));
             }
             
         }
         else
         {
        
            ShowCMNConForm=true;
            ShowCMNForm=false;
            ShowCMNBannerForm=false;
         }
         
          
    }


    public void BackToFlyer() 
    {
        ShowCMNForm=true;
        ShowCMNBannerForm=false;
        ShowCMNConForm=false;
    }
    
    
    public PageReference order() 
    {
    
    
         if(FlyerApproved==false||BannerApproved==false)
         {
             if(FlyerApproved==false)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please approve the CMN Flyer Template'));
             }
             if(BannerApproved==false)
             {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please approve the CMN Banner Template'));
             }
        }
    
       try
       {
            Job__c CMNJob=new Job__c();
                CMNJob.Media_Types__c=NameMediatype.id;
                CMNJob.Schedule_Template__c=CMNScheduletype.id;
                CMNJob.JS_Client__c=clientcontact.Client__c;
                CMNJob.JS_Client_Contact__c=clientcontact.id;
                CMNJob.JobFormTypeValues__c='CMN Form';
            insert CMNJob; 
            
            Job_Spec__c CMNSpecFlyerName=new Job_Spec__c();
                CMNSpecFlyerName.Name='Name of Event';
                CMNSpecFlyerName.Description__c=CMNFlyerNameofEvent;
                CMNSpecFlyerName.Job__c=CMNJob.id;
                CMNSpecFlyerName.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerName;
                
                
            Job_Spec__c CMNSpecFlyerDate=new Job_Spec__c();
                CMNSpecFlyerDate.Name='Date';
                CMNSpecFlyerDate.Description__c=CMNFlyerDate;
                CMNSpecFlyerDate.Job__c=CMNJob.id;
                CMNSpecFlyerDate.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerDate;
                
            Job_Spec__c CMNSpecFlyerTime=new Job_Spec__c();
                CMNSpecFlyerTime.Name='Time';
                CMNSpecFlyerTime.Description__c=CMNFlyerTime;
                CMNSpecFlyerTime.Job__c=CMNJob.id;
                CMNSpecFlyerTime.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerTime;
                
            Job_Spec__c CMNSpecFlyerEvent=new Job_Spec__c();
                CMNSpecFlyerEvent.Name='Event Details';
                CMNSpecFlyerEvent.Description__c=CMNFlyerEventDetails;
                CMNSpecFlyerEvent.Job__c=CMNJob.id;
                CMNSpecFlyerEvent.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerEvent;
            
            
            Job_Spec__c CMNSpecFlyerSpecial=new Job_Spec__c();
                CMNSpecFlyerSpecial.Name='Special Details';
                CMNSpecFlyerSpecial.Description__c=CMNFlyerSpecialDetails;
                CMNSpecFlyerSpecial.Job__c=CMNJob.id;
                CMNSpecFlyerSpecial.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerSpecial;
            
           
           Job_Spec__c CMNSpecBannerName=new Job_Spec__c();
                CMNSpecBannerName.Name='Name of Event';
                CMNSpecBannerName.Description__c=CMNBannerNameofEvent;
                CMNSpecBannerName.Job__c=CMNJob.id;
                CMNSpecBannerName.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerName;
                
                
            Job_Spec__c CMNSpecBannerDate=new Job_Spec__c();
                CMNSpecBannerDate.Name='Date';
                CMNSpecBannerDate.Description__c=CMNBannerDate;
                CMNSpecBannerDate.Job__c=CMNJob.id;
                CMNSpecBannerDate.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerDate;
                
            Job_Spec__c CMNSpecBannerTime=new Job_Spec__c();
                CMNSpecBannerTime.Name='Time';
                CMNSpecBannerTime.Description__c=CMNBannerTime;
                CMNSpecBannerTime.Job__c=CMNJob.id;
                CMNSpecBannerTime.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerTime;
                
            Job_Spec__c CMNSpecBannerEvent=new Job_Spec__c();
                CMNSpecBannerEvent.Name='Event Details';
                CMNSpecBannerEvent.Description__c=CMNBannerEventDetails;
                CMNSpecBannerEvent.Job__c=CMNJob.id;
                CMNSpecBannerEvent.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerEvent;
            
            
            Job_Spec__c CMNSpecBannerSpecial=new Job_Spec__c();
                CMNSpecBannerSpecial.Name='Special Details';
                CMNSpecBannerSpecial.Description__c=CMNBannerSpecialDetails;
                CMNSpecBannerSpecial.Job__c=CMNJob.id;
                CMNSpecBannerSpecial.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerSpecial;
            
        if(isTab)
        {
            PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');
            pageRef.setRedirect(true);
            return pageRef;
        }
           
           PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');
           pageRef.setRedirect(true);
           return pageRef;
        
         /*   PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');
            pageRef.setRedirect(true);
            return pageRef;*/
            
        }
        
         catch(Exception e)
         {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getmessage()));
             return null;
         }
     
           return null;
        
    }
   

    



}