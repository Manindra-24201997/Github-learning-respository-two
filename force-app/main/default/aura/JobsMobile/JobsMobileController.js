({
    setPagref : function(component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "JobSuite__Job__c"
        });
        homeEvent.fire();
    }
})