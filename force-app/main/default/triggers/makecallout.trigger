trigger makecallout on case(after insert){
    if(trigger.isafter && trigger.isinsert){
        
        for(case c:trigger.new)
            sampleclass.makeacallout(c.CaseNumber);
    }
}