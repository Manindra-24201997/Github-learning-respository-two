trigger Contacttrigger2024 on Contact (before insert,After insert,after delete) {
    
    if(trigger.isbefore && trigger.isinsert){
        // Create a set to store the Account Ids associated with the new contacts
        Set<Id> accountIds = new Set<Id>();
        map<string,account>accmap = new map<string,account>();
        // Iterate through the new contacts and collect the associated Account Ids
        for (Contact newContact : Trigger.new) {
            if (newContact.AccountId != null) {
                accountIds.add(newContact.AccountId);
            }
        }
        
        // Query for the number of existing contacts for each Account
        Map<string, Integer> accountContactCountMap = new Map<string, Integer>();
        for (AggregateResult aggregateResult : [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]) {
            system.debug('aggregateResult === '+aggregateResult);
            system.debug('accountid === '+aggregateResult.get('AccountId'));
            accountContactCountMap.put((string)aggregateResult.get('AccountId'), (Integer)aggregateResult.get('contactCount'));
        }
        
        // Check if the new contact exceeds the limit for any Account and add error
        /*for (Contact newContact : Trigger.new) {
system.debug('newContact === '+newContact);
system.debug('accountContactCountMap.get(newContact.AccountId === '+  accountContactCountMap.get(newContact.AccountId));
if (newContact.AccountId != null && accountContactCountMap.containsKey(newContact.AccountId) &&
accountContactCountMap.get(newContact.AccountId) >= 3) {
newContact.addError('Cannot add more than 4 contacts to this account.');
}
}*/
        
        list<account>accrcds = [select id,name,(select id,lastname,accountid from contacts) from account where id =:accountIds];
        map<string,integer>accmapnew = new map<string,integer>();
        for(account acc : accrcds){
            if(acc.contacts.size() > 3){
                accmapnew.put(acc.id,acc.contacts.size());
            }
        }
        
        for(contact con : trigger.new){
            if(accmapnew.containskey(con.accountid)){
                //con.adderror('More than four records'); //working code
            }
        }
    }
    
    if(trigger.isafter && trigger.isinsert){
        set<string>accids = new set<string>();
        for(contact con : trigger.new){
            accids.add(con.AccountId);   
        } 
        
        map<string,account>accmapnew = new map<string,account>();
        list<account>acclist = [select id,name,Number_of_contatcs__c from account where id =: accids];
        for(account accrcdsnew : acclist){
            accmapnew.put(accrcdsnew.id,accrcdsnew);  
        }
        
        
        map<string,integer>accmap = new map<string,integer>();
        aggregateresult[] aggrcd = [select count(id)contactcount,accountid from contact where accountid =: accids group by accountid];
        for(aggregateresult agr : aggrcd){
            accmap.put((string)agr.get('accountid'),(integer)agr.get('contactcount'));
        }
        system.debug('accmap === '+accmap);
        
        /*map<string,list<contact>>mapval = new  map<string,list<contact>>();
list<contact>conrecord = [select id,lastname,accountid from contact where accountid =: accids];
for(contact cc : conrecord){
if(!mapval.containskey(cc.AccountId)){
mapval.put(cc.AccountId,new list<contact>{cc});
}
else{
list<contact>conrecd = new list<contact>();
conrecd.add(cc);
mapval.put(cc.AccountId,conrecd);
}
}*/
        
        list<account>listsobj = new list<account>();
        for(contact ccnw : trigger.new){
            if(accmapnew.containskey(ccnw.accountid)){
                account accsobj = new account();
                accsobj.Id = ccnw.AccountId;
                accsobj.Number_of_contatcs__c = accmap.get(ccnw.accountid);
                listsobj.add(accsobj);
                system.debug('listsobj === '+listsobj+'\n');
            }
        }
        
        if(listsobj.size() > 0){
            system.debug('update listsobj === '+listsobj+'\n');
            update listsobj;
            //database.update(listsobj,false);
        }
        
    }
    
    if (Trigger.isAfter && Trigger.isDelete) {
        integer i = 0;
        // 1. Collect Account IDs from deleted contacts
        Set<Id> accIds = new Set<Id>();
        for (Contact con : Trigger.old) {
            system.debug('con last name === '+con.lastname);
            if (con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }
        
        if (accIds.isEmpty()) {
            return; // No related accounts
        }
        
        // 2. Map of Account records
        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, Name, Number_of_contatcs__c FROM Account WHERE Id IN :accIds]
        );
        
        // 3. Aggregate count of remaining contacts per Account
        Map<Id, Integer> contactCountMap = new Map<Id, Integer>();
        AggregateResult[] results = [
            SELECT COUNT(Id) contactCount, AccountId
            FROM Contact
            WHERE AccountId IN :accIds
            GROUP BY AccountId
        ];
        for (AggregateResult ar : results) {
            contactCountMap.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
        }
        
        // 4. Prepare Account updates
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accIds) {
            if (accMap.containsKey(accId)) {
                Account accToUpdate = new Account();
                accToUpdate.Id = accId;
                accToUpdate.Number_of_contatcs__c =
                    contactCountMap.containsKey(accId) ? contactCountMap.get(accId) : 0;
                accountsToUpdate.add(accToUpdate);
            }
        }
        
        // 5. Update Accounts with new contact counts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
}