Global with sharing  class MapOfBBForClient {
    @AuraEnabled
    public static string getClientId(){
        User  lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c  clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        string clientId=clientcontact.Client__c;
        system.debug('component class called === '+clientId);
        return clientId;
    }
}