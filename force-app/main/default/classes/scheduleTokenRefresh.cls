global class scheduleTokenRefresh implements schedulable , Database.AllowsCallouts {
    global void execute(SchedulableContext mm)
    {
        Asana_Creds__c ac = Asana_Creds__c.getInstance('Assana Account');
        //system.debug('ac == '+ac.Refresh_Token__c);
        ConnectionProcessingClass.ConnecttoAssanaFuture(ac.Refresh_Token__c,True);
    }
    
}