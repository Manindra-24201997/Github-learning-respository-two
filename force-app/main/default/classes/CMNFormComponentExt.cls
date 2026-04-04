public class CMNFormComponentExt {
    
    /***************************************** Login user Client address  ******************************************/
    
    @AuraEnabled
    public static List<Client_Contact__c> getClientAddress() 
    {
        user u= new user();
        List<Client_Contact__c>  CCon=new List<Client_Contact__c>();
        u= [select firstname ,Username, Id, Profile.Name  from user where id=:userinfo.getuserid() limit 1];
        CCon=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Client_Code__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:u.Username];
        return CCon;
    }
    
    @AuraEnabled
    public static string SaveRequestForm(string requestType,List<string> Formvalues)
    {
        system.debug('>>>>>>>>>>>>>>> Save Method Enter >>>>>>>>>>>>>>>>>>>>>>>>>>');
         List<user> lstUser= [select firstname,Username,Id,Profile.Name from user where id=:userinfo.getuserid()];
        
        Client_Contact__c clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser[0].Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        
        Media_Type__c NameMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
        Schedule_Template__c CMNScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='CMN' AND Media_Types__r.name='Print' limit 1];//  added new form CMN Form in Store Order type
        
        try{
            Job__c CMNJob=new Job__c();
            CMNJob.Media_Types__c=NameMediatype.id;
            CMNJob.Schedule_Template__c=CMNScheduletype.id;
            CMNJob.JS_Client__c=clientcontact.Client__c;
            CMNJob.JS_Client_Contact__c=clientcontact.id;
            CMNJob.JobFormTypeValues__c='CMN Form';
            insert CMNJob; 
            
            Job_Spec__c CMNSpecFlyerName=new Job_Spec__c();
            CMNSpecFlyerName.Name='Name of Event';
            CMNSpecFlyerName.Description__c=Formvalues[0];
            CMNSpecFlyerName.Job__c=CMNJob.id;
            CMNSpecFlyerName.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerName;
            
            Job_Spec__c CMNSpecFlyerDate=new Job_Spec__c();
            CMNSpecFlyerDate.Name='Date';
            CMNSpecFlyerDate.Description__c=Formvalues[1];
            CMNSpecFlyerDate.Job__c=CMNJob.id;
            CMNSpecFlyerDate.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerDate;
            
            Job_Spec__c CMNSpecFlyerTime=new Job_Spec__c();
            CMNSpecFlyerTime.Name='Time';
            CMNSpecFlyerTime.Description__c=Formvalues[2];
            CMNSpecFlyerTime.Job__c=CMNJob.id;
            CMNSpecFlyerTime.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerTime;
            
            Job_Spec__c CMNSpecFlyerEvent=new Job_Spec__c();
            CMNSpecFlyerEvent.Name='Event Details';
            CMNSpecFlyerEvent.Description__c=Formvalues[3];
            CMNSpecFlyerEvent.Job__c=CMNJob.id;
            CMNSpecFlyerEvent.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerEvent;
            
            Job_Spec__c CMNSpecFlyerSpecial=new Job_Spec__c();
            CMNSpecFlyerSpecial.Name='Special Details';
            CMNSpecFlyerSpecial.Description__c=Formvalues[4];
            CMNSpecFlyerSpecial.Job__c=CMNJob.id;
            CMNSpecFlyerSpecial.Creative_Brief_Template__c='Flyers';
            insert CMNSpecFlyerSpecial;
            
            Job_Spec__c CMNSpecBannerName=new Job_Spec__c();
            CMNSpecBannerName.Name='Name of Event';
            CMNSpecBannerName.Description__c=Formvalues[5];
            CMNSpecBannerName.Job__c=CMNJob.id;
            CMNSpecBannerName.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerName;
            
            Job_Spec__c CMNSpecBannerDate=new Job_Spec__c();
            CMNSpecBannerDate.Name='Date';
            CMNSpecBannerDate.Description__c=Formvalues[6];
            CMNSpecBannerDate.Job__c=CMNJob.id;
            CMNSpecBannerDate.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerDate;
            
            Job_Spec__c CMNSpecBannerTime=new Job_Spec__c();
            CMNSpecBannerTime.Name='Time';
            CMNSpecBannerTime.Description__c=Formvalues[7];
            CMNSpecBannerTime.Job__c=CMNJob.id;
            CMNSpecBannerTime.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerTime;
            
            Job_Spec__c CMNSpecBannerEvent=new Job_Spec__c();
            CMNSpecBannerEvent.Name='Event Details';
            CMNSpecBannerEvent.Description__c=Formvalues[8];
            CMNSpecBannerEvent.Job__c=CMNJob.id;
            CMNSpecBannerEvent.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerEvent;
            
            Job_Spec__c CMNSpecBannerSpecial=new Job_Spec__c();
            CMNSpecBannerSpecial.Name='Special Details';
            CMNSpecBannerSpecial.Description__c=Formvalues[9];
            CMNSpecBannerSpecial.Job__c=CMNJob.id;
            CMNSpecBannerSpecial.Creative_Brief_Template__c='Banner';
            insert CMNSpecBannerSpecial;
            
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
        return 'true';   
    }
}