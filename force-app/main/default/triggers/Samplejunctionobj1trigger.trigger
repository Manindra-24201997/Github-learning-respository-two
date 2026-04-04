trigger Samplejunctionobj1trigger on Sample_Junction_Object__c (after insert) {
    if(trigger.isafter && trigger.isinsert){
        set<string>sampleobj1rcdids = new set<string>();
        for(Sample_Junction_Object__c jnc:trigger.new){
            sampleobj1rcdids.add(jnc.Sample_Object_1__c );
        }
        
        map<string,Sample_Object_1__c>parentmapsobj1 = new map<string,Sample_Object_1__c>();
        list<Sample_Object_1__c>sobj1list=[select id,Total_Junction_Amount__c from Sample_Object_1__c where id IN: sampleobj1rcdids];
        for(Sample_Object_1__c sobj1:sobj1list){
            parentmapsobj1.put(sobj1.id,sobj1);
        }
        
        map<string,integer>parentmap = new map<string,integer>();
        aggregateresult[] agglist=[select Sample_Object_1__c pntid,sum(Amount__c) am  from Sample_Junction_Object__c where Sample_Object_1__c IN: sampleobj1rcdids group by Sample_Object_1__c]; 
        for(aggregateresult agg:agglist){
            string parentid = (string) agg.get('pntid');
            integer sumamount = (integer) agg.get('am');
            parentmap.put(parentid,sumamount);
        }
        
        list<Sample_Object_1__c>updlist = new list<Sample_Object_1__c>();
        for(Sample_Junction_Object__c rcd:trigger.new){
            if(parentmapsobj1.containskey(rcd.Sample_Object_1__c)){
                Sample_Object_1__c sobjval = parentmapsobj1.get(rcd.Sample_Object_1__c);
                sobjval.Total_Junction_Amount__c = parentmap.get(rcd.Sample_Object_1__c);
                updlist.add(sobjval);
            }
        }
        
        if(updlist.size() > 0){
            update updlist;
        }
    }
}