trigger Opportunitytrugger2024 on Opportunity (before insert,before update,after insert,after delete,after update) {
    
    //The below code is restricting inserting records if 2 qualification and 1 prospecting records under same account
    /*if(trigger.isbefore && trigger.isinsert){
set<string>accids = new set<string>();
for(Opportunity opp : trigger.new){
accids.add(opp.accountid);
}

map<string,integer>oppmapqualification = new map<string,integer>();
map<string,integer>oppmapProspecting = new map<string,integer>();

list<opportunity>opplist = [select id,name,stagename,accountid from opportunity where accountid =: accids and (stagename='qualification' or stagename='prospecting')];
system.debug('opplist === '+opplist);
integer i = 0;
integer p = 0;
for(opportunity opprcds : opplist){
if(opprcds.stagename == 'qualification'){
if(!oppmapqualification.containskey(opprcds.AccountId)){
i = 0;
i += 1;
system.debug('if '+i+' oppmapqualification === '+oppmapqualification+' opp name === '+opprcds.name+' current i === '+i);
oppmapqualification.put(opprcds.AccountId,i);
}
else{
i += 1;
system.debug('else '+i+' oppmapqualification === '+oppmapqualification+' opp name === '+opprcds.name+' current i === '+i);
oppmapqualification.put(opprcds.AccountId,i);
}
}

if(opprcds.stagename == 'prospecting'){
if(!oppmapqualification.containskey(opprcds.AccountId)){
p = 0;
p += 1;
system.debug('if '+p+' oppmapProspecting === '+oppmapProspecting+' opp name === '+opprcds.name+' current p === '+p);
oppmapProspecting.put(opprcds.AccountId,p);
}
else{
p += 1;
system.debug('else '+p+' oppmapProspecting === '+oppmapProspecting+' opp name === '+opprcds.name+' current p === '+p);
oppmapProspecting.put(opprcds.AccountId,p);
}
}

}
system.debug('oppmapqualification === '+oppmapqualification);
for(opportunity opprcdsnew : trigger.new){
if(oppmapqualification.containskey(opprcdsnew.AccountId)){
system.debug('size === '+oppmapqualification.get(opprcdsnew.AccountId));
if(oppmapqualification.get(opprcdsnew.AccountId) >= 2 && oppmapProspecting.get(opprcdsnew.AccountId) >= 1){
//opprcdsnew.adderror('Two qualification and one prospecting records already exists');  
}
}
}
}*/
    
    
    //The below chatgpt code is restricting inserting records if 2 qualification and 1 prospecting records under same account
    
    if(trigger.isbefore && trigger.isinsert ){
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : Trigger.new) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) return;
        
        // Query existing opportunities for those accounts
        Map<Id, Integer> qualificationCountMap = new Map<Id, Integer>();
        Map<Id, Integer> prospectingCountMap = new Map<Id, Integer>();
        
        for (AggregateResult ar : [SELECT AccountId accId, StageName stage, COUNT(Id) cnt FROM Opportunity WHERE AccountId IN :accountIds 
                                   GROUP BY AccountId, StageName]) {
                                       system.debug('ar === '+ar);
                                       Id accId = (Id) ar.get('accId');
                                       String stage = (String) ar.get('stage');
                                       Integer count = (Integer) ar.get('cnt');
                                       
                                       if (stage == 'Qualification') {
                                           qualificationCountMap.put(accId, count);
                                       } else if (stage == 'Prospecting') {
                                           prospectingCountMap.put(accId, count);
                                       }
                                   }
        
        // Validate new records
        for (Opportunity opp : Trigger.new) {
            if (opp.AccountId == null) continue;
            
            Integer qualCount = qualificationCountMap.get(opp.AccountId);
            Integer prospCount = prospectingCountMap.get(opp.AccountId);
            
            if (qualCount == null) qualCount = 0;
            if (prospCount == null) prospCount = 0;
            
            // Include the current record in stage calculation
            if (opp.StageName == 'Qualification') qualCount++;
            if (opp.StageName == 'Prospecting') prospCount++;
            
            if (qualCount > 2 && prospCount > 1) {
                opp.addError('You cannot insert this Opportunity: The account already has 2 Qualification and 1 Prospecting opportunities.');
            }
        }
    }
    
    //The below code is restricting inserting records if account has more than 3 records
    if(trigger.isbefore && trigger.isinsert){
        set<string>accids = new set<string>();
        for(opportunity opp : trigger.new){
            accids.add(opp.AccountId);
        }
        
        map<string,integer>aggmap=new map<string,integer>();
        aggregateresult[] agglist = [select count(id)rcdcount,accountid from opportunity where accountid =: accids group by accountid];
        system.debug('agglist === '+agglist);
        for(aggregateresult aggrcd:agglist){
            aggmap.put((string)aggrcd.get('accountid'),(integer)aggrcd.get('rcdcount'));
        }
        system.debug('aggmap === '+aggmap);
        for(opportunity opprcd : trigger.new){
            system.debug('opprcd contains key === '+aggmap.containskey(opprcd.accountid));
            if(aggmap.containskey(opprcd.accountid)){
                system.debug('count === '+aggmap.get(opprcd.accountid));
                if(aggmap.get(opprcd.accountid) >= 3) {
                    //opprcd.adderror('Already 3 records exist');
                }
            }
        }
    }
    
    if(trigger.isafter && trigger.isinsert){
        set<string>accids = new set<string>();
        for(Opportunity opp : trigger.new){
            accids.add(opp.AccountId);
        }
        
        map<string,account>accmap = new map<string,account>();
        for(account accrcd : [select id,name from account where id=:accids]){
            accmap.put(accrcd.id,accrcd);
        }
        
        map<string,integer>aggmap = new map<string,integer>();
        aggregateresult[] aggrcds = [select count(id)rcdcount,accountid from opportunity where accountid=:accids group by accountid];
        for(aggregateresult agg:aggrcds){
            aggmap.put((string)agg.get('accountid'),(integer)agg.get('rcdcount'));
        }
        list<account>updateacc = new list<account>();        
        for(opportunity opp : trigger.new){
            if(accmap.containskey(opp.AccountId)){
                account accsobj = accmap.get(opp.AccountId);
                accsobj.Number_of_opportunities__c = aggmap.containskey(opp.AccountId) ? aggmap.get(opp.AccountId) : 0;
                updateacc.add(accsobj);
            }
        }
        if(updateacc.size() > 0){
            update updateacc;
        }
    }
    
    if(trigger.isafter && (trigger.isdelete || trigger.isupdate)){
        set<string>accids=new set<string>();
        for(Opportunity opprcd:trigger.old){
            accids.add(opprcd.AccountId);
        }
        for(Opportunity opprcd2:trigger.new){
            if(trigger.oldmap.get(opprcd2.id).accountid != opprcd2.accountid){
                accids.add(opprcd2.AccountId);
            }
        }
        system.debug('accids === '+accids);
        
        map<string,integer>aggmap = new map<string,integer>();
        aggregateresult[] aggrcds = [select count(id)rcdcount,accountid from opportunity where accountid=:accids group by accountid];
        if(aggrcds.size() > 0){
            for(aggregateresult agg:aggrcds){
                aggmap.put((string)agg.get('accountid'),(integer)agg.get('rcdcount'));
            }
        }
        
        list<account>updateacc = new list<account>();
        for(account accrcd : [select id,name from account where id=:accids]){
            if(aggmap.containskey(accrcd.Id)){
                accrcd.Number_of_opportunities__c = aggmap.containskey(accrcd.id) ? aggmap.get(accrcd.id) : 0;
                updateacc.add(accrcd);
            }
        }
        if(updateacc.size() > 0){
            update updateacc;
        }
        
    }
    
}