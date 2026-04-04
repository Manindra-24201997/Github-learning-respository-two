trigger Accounttrigger2024 on Account (before update,after update) {
    
    if(trigger.isbefore && trigger.isupdate){
        // map<string,string>mapval = new map<string,string>('a' => 'd','b' => 'e','c' => 'f');
        map<string,string>mapval = new map<string,string>();
        mapval.put('A','D');
        mapval.put('B','E');
        mapval.put('C','F');
        
        for(account acc : trigger.new){
            string value = '';
            if(string.isnotempty(acc.multi_picklist_1__c)){
                system.debug('acc val 1 === '+acc.multi_picklist_1__c);
                for(string mupickval : acc.multi_picklist_1__c.split(';')){
                    system.debug('mupickval === '+mupickval);
                    if(mapval.containskey(mupickval)){
                        system.debug('if mupickval === '+mupickval);
                        system.debug('if mupickval === '+string.isblank(mupickval));
                        value += string.isblank(mupickval) ?  mapval.get(mupickval) : ';' +mapval.get(mupickval);
                        system.debug('value === '+value);
                    }
                }         
            }
            acc.multi_picklist_2__c = value;
        }
    }
    
    
    /* if(trigger.isbefore && trigger.isupdate){ 
boolean isval = true;
//if(isval == true){
for(account acc : trigger.new){
//if(!Triggerclass2025.processedRecords.containskey(acc.id)){ // with map not worked in before update
if(trigger.oldmap.get(acc.id).Industry != acc.Industry ){
//Triggerclass2025.processedRecords.put(acc.id,true);
system.debug('acc id === '+acc.id);
acc.Industry = 'Technology';
//update acc;
//isval = false;
} 
}
}
//}*/
    
    if(trigger.isafter && trigger.isupdate){ 
        for(account acc : trigger.new){
            if(!Triggerclass2025.processedRecords.containskey(acc.id)){ // with map in after update worked 
                if(trigger.oldmap.get(acc.id).Industry != acc.Industry ){
                    Triggerclass2025.processedRecords.put(acc.id,true);
                    system.debug('acc id === '+acc.id);
                    acc.Industry = 'Technology';
                    update acc;
                } 
            }
        }
    }
    
    
    
}