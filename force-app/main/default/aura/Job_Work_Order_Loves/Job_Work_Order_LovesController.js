({
    WorkOrderPageRedirect : function(component, event, helper) {
        var jobid=component.get("v.recordId");
        $A.get("e.force:closeQuickAction").fire(); 
        window.open('/one/one.app#/alohaRedirect/apex/WorkOrderLovesForBarCode?id='+jobid,'_self'); 
    },
})