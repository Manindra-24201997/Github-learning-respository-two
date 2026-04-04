public with sharing class BillboradstorefrontTabPagecCnt {

 
  Public Client_Contact__c  clientContact{get;set;}
  Public User lstUser{get;set;}
  public string clientid;
  public  BillboradstorefrontTabPagecCnt(){
      lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
      clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
      clientid=clientcontact.Client__c;
      
      
}

Public pagereference  GotoBBlistpage() {


     pagereference pg=new Pagereference('/apex/DisplayBillboardForClientContact?id='+clientid);
     pg.setRedirect(true);
     return pg;


}


}