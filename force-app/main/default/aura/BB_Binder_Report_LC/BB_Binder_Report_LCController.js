({
    doInit : function(component, event, helper) {
        console.log('>>>>> 1. Do Init>>>>>');
        helper.FetchpicklistVal(component, event, helper);
    },
    handleSearch : function(component, event, helper) {
        
        helper.getResultsList(component, event, helper);
    },
    downloadPdf :function(component, event, helper) {
        component.set("v.showSpinner",true);
        console.log('downloadPdf');
        var myEvent = $A.get("e.c:LcToVfEvent");
        myEvent.setParams({                
            reslutwrapper:component.get('v.ResultsList')
        });
        myEvent.fire();       
    }    
})