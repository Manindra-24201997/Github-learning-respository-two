public class ConnectionProcessingClass {
    
    @AuraEnabled
    public static string getcmpnamespace(){
            return 'c';
    } 
    
    @AuraEnabled
    public Static String ConnecttoAssana(String authcode,boolean isRefresh){
        // system.debug('authcode === '+authcode + 'IS REFRESH=== '+isRefresh);
        try{
            boolean istestorg = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
            if(String.isNotBlank(authcode)){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                String params ='?'+'grant_type='+(isRefresh? 'refresh_token' :'authorization_code');
                params+='&client_id=1202714330484313';
                params+='&client_secret=17f37926e6374e454c2d6f856eef3957';
                if(istestorg){
                    params+='&redirect_uri=https://test.salesforce.com/c/connectionProcessingApp.app';
                }
                else{
                    params+='&redirect_uri=https://login.salesforce.com/c/connectionProcessingApp.app';    
                }
                if(!isRefresh) params+='&code='+authcode;
                else params+='&refresh_token='+authcode;
                req.setEndpoint('https://app.asana.com/-/oauth_token'+params);
                HttpResponse res = h.send(req);
                AuthWrapper ath = (AuthWrapper)JSON.deserialize(res.getBody(),AuthWrapper.class);    
                Asana_Creds__c ac = new Asana_Creds__c();
                if(!isRefresh){
                    ac.Name='Assana Account';
                    ac.Access_Token__c=ath.access_token;
                    ac.Refresh_Token__c=ath.refresh_token;
                    ac.Last_Refreshed_Date__c=datetime.now();
                    insert ac;
                    //system.debug('insert ac === '+ac);
                }
                else {
                    ac = Asana_Creds__c.getInstance('Assana Account');
                    ac.Access_Token__c=ath.access_token;
                    //ac.Refresh_Token__c=ath.refresh_token;
                    ac.Last_Refreshed_Date__c=datetime.now();
                    update ac;
                    //system.debug('update ac === '+ac);
                }
                
                DateTime datetimenow = DateTime.now();
                datetimenow = datetimenow.addMinutes(59);
                Integer hour= datetimenow.hour();
                Integer min = datetimenow.minute();
                Integer sec = datetimenow.second();
                String cronExp =sec+' '+min+' '+hour+' * * ? *';
                // List<AsyncApexJob> schrefJobs = [SELECT Id FROM AsyncApexJob where status = 'queued' and JobType='ScheduledApex' and ApexClass.Name='scheduleTokenRefresh'];
                list<CronTrigger> schrefJobs  = [SELECT Id, State, CronjobDetail.Name, CronJobDetail.Id, NextFireTime FROM CronTrigger WHERE  CronJobDetail.Name LIKE '%Hourly Access Token Refresh%'];            
                if(schrefJobs.size()>0){
                    //system.debug('schrefJobs === '+schrefJobs);
                    system.abortJob(schrefJobs[0].Id);
                }
                system.schedule('Hourly Access Token Refresh', cronExp, new scheduleTokenRefresh());
                //system.debug('res'+res);
                return 'Success'; 
            }
            return 'Error';  
        }
        Catch(Exception ex){
            system.debug('msg === '+ex.getMessage());
            return 'Error-'+ex.getMessage();
            
        }
    }
    
    @AuraEnabled
    public Static String orgdetails(){
        string orgid = userinfo.getOrganizationId();
        return orgid;
    }
    
    
    @future(callout=true)
    public Static void ConnecttoAssanaFuture(String authcode,boolean isRefresh){
        // system.debug('authcode === '+authcode + 'IS REFRESH=== '+isRefresh);
        try{
            boolean istestorg = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
            if(String.isNotBlank(authcode)){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                String params ='?'+'grant_type='+(isRefresh? 'refresh_token' :'authorization_code');
                params+='&client_id=1202714330484313';
                params+='&client_secret=17f37926e6374e454c2d6f856eef3957';
                if(istestorg){
                    params+='&redirect_uri=https://test.salesforce.com/c/connectionProcessingApp.app';
                }
                else{
                    params+='&redirect_uri=https://login.salesforce.com/c/connectionProcessingApp.app';    
                }
                if(!isRefresh) params+='&code='+authcode;
                else params+='&refresh_token='+authcode;
                req.setEndpoint('https://app.asana.com/-/oauth_token'+params);
                req.setTimeout(120000);
                HttpResponse res = h.send(req);
                AuthWrapper ath = (AuthWrapper)JSON.deserialize(res.getBody(),AuthWrapper.class);    
                Asana_Creds__c ac = new Asana_Creds__c();
                if(!isRefresh){
                    ac.Name='Assana Account';
                    ac.Access_Token__c=ath.access_token;
                    ac.Refresh_Token__c=ath.refresh_token;
                    ac.Last_Refreshed_Date__c=datetime.now();
                    insert ac;
                    // system.debug('insert ac === '+ac);
                }
                else {
                    ac = Asana_Creds__c.getInstance('Assana Account');
                    ac.Access_Token__c=ath.access_token;
                    /*if(ac.Refresh_Token__c != null && string.isNotBlank(ac.Refresh_Token__c)){
ac.Refresh_Token__c=ath.refresh_token;
}*/
                    ac.Last_Refreshed_Date__c=datetime.now();
                    update ac;
                    // system.debug('update ac === '+ac);
                }
                
                
                //return 'Success'; 
            }
            // return 'Error';  
        }
        Catch(Exception ex){
            system.debug('msg === '+ex.getMessage());
            // return 'Error-'+ex.getMessage();
        }
        DateTime datetimenow = DateTime.now();
        datetimenow = datetimenow.addMinutes(59);
        Integer hour= datetimenow.hour();
        Integer min = datetimenow.minute();
        Integer sec = datetimenow.second();
        String cronExp =sec+' '+min+' '+hour+' * * ? *';
        // List<AsyncApexJob> schrefJobs = [SELECT Id FROM AsyncApexJob where status = 'queued' and JobType='ScheduledApex' and ApexClass.Name='scheduleTokenRefresh'];
        list<CronTrigger> schrefJobs  = [SELECT Id, State, CronjobDetail.Name, CronJobDetail.Id, NextFireTime FROM CronTrigger WHERE  CronJobDetail.Name LIKE '%Hourly Access Token Refresh%'];            
        if(schrefJobs.size()>0){
            //system.debug('schrefJobs === '+schrefJobs);
            system.abortJob(schrefJobs[0].Id);
        }
        system.schedule('Hourly Access Token Refresh', cronExp, new scheduleTokenRefresh());
        //system.debug('res'+res);
    }
    
    public class AuthWrapper{
        public String access_token;
        public String refresh_token;
    }
}