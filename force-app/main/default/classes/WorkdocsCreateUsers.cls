public class WorkdocsCreateUsers implements Database.Batchable<sobject>, Database.AllowsCallouts {
	public Database.QueryLocator start(Database.BatchableContext BC){
        boolean t = true;
        String s = null;
        String uId = userInfo.getUserId();
     return Database.getQueryLocator('Select id, Title, email, firstname, lastname, IsActive, Workdocs_Id__c from User where Id !=:uId and IsActive=:t and Workdocs_Id__c !=:s ');//WITH SECURITY_ENFORCED
  		//return null;
    }
 
    public void execute(Database.BatchableContext BC, List<user> scope){
        for(user s:scope){
            Workdocs_Connection__c a = [select id, Access_Token__c, Application_Id__c, Redirect_Url__c, State__c, User__c from Workdocs_Connection__c where User__c = :userinfo.getuserid() WITH SECURITY_ENFORCED limit 1];
            String token = 'Bearer '+a.Access_Token__c;
            HttpRequest httpRequest1 = new HttpRequest();
            httpRequest1.setEndpoint('https://workdocs.'+a.State__c+'.amazonaws.com/api/v1/users');
            httpRequest1.setHeader('Authentication', token);
            httpRequest1.setHeader('Content-Type', 'application/json');
            httpRequest1.setBody('{\"EmailAddress\": \"'+s.email+'\",\"GivenName\": \"'+s.firstname+'\",\"Password\": \"'+s.id+'Zz*\",\"Surname\": \"'+s.lastname+'\",\"Username\": \"'+s.email+'\"}');
            httpRequest1.setMethod('POST');
               
            Http http1 = new Http();
            HttpResponse response1 = http1.send(httpRequest1);
            System.debug('FileStatus 1:'+response1.getStatusCode());
            System.debug('FileBody 1:'+response1.getBody());
            
            if(response1.getStatusCode()==200){
                
                Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(response1.getBody());
                Map <String, Object> objectMap = (Map <String, Object>) root.get('User');
                String wdUserId = string.valueOf(objectMap.get('Id'));
                if(schema.SobjectType.user.Fields.Workdocs_Id__c.isUpdateable()){ 
                    s.Workdocs_Id__c = wdUserId;
                }
                if(Schema.sObjectType.user.isUpdateable()){
                    update s;
                }
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { s.email };
                message.subject = 'Jobsuite: Workdocs User Created';
                message.plainTextBody = 'UserName: '+s.email+ '  Password: '+s.id+'Zz*';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                
                if(results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                }
                else 
                {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            }
        } 
    }

    public void finish(Database.BatchableContext BC){
    }
}