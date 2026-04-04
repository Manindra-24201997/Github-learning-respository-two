/* Purpose of code: Code to update the Access token
Created by: Subhranshu (Dhruvsoft)
Created Date:16th Oct 2015 */


public class UpdateJobsuiteEchoMediaSetting {
     @future(Callout=True)
    public static void updaterefreshtoken()
    {
        try{
            parsercls prsr=new parsercls();
            JobsuiteEchoMediaSettings__c authsetng= [select Access_Token__c,Api_Endpoint__c,User_Name__c,Password__c from JobsuiteEchoMediaSettings__c];
            
            
            String body = '{"username":"'+authsetng.User_Name__c+'","password":"'+authsetng.Password__c+'"}';
            Http httpprotocal= new Http();
            HttpRequest  req=new HttpRequest();
            req.setEndpoint(authsetng.Api_Endpoint__c+'login');
            req.setMethod('POST');
            req.settimeout(60000);
            req.setHeader('Content-Type', 'application/json');
            req.setbody(body);
            system.debug('Request is'+req);
            HTTPResponse response = httpprotocal.send(req);
            
            system.debug('Response deforder it is sent to site'+response );
            System.debug('Returned result is'+response .getBody());    
            If(response .getStatusCode()==200)
            {
                string  res=response .getBody();
                jsonParser prser=json.createParser(res);
                while(prser.NextToken()!=NULL){
                    prsr=(parsercls)Prser.ReadValueAs(parsercls.Class);
                } 
                authsetng.Access_Token__c=prsr.id;
                //authsetng.Updated_Date_and_Time__c=system.today();
                update authsetng;
                system.debug('the updated custom setting is'+authsetng);
            }
            
      }
        Catch(Exception E)
        {
          system.debug('The Exception is'+E);
         }  
  }
    
    public class parsercls
    {
        public String id;  
    }    
    
    
}