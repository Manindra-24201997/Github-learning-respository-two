({
	helperMethod : function(component,event,helper) {
		var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": "00B8c00000HGGcCEAX",
                "listViewName": null,
                "scope": "Job__c"
            });
            navEvent.fire();
	}
})