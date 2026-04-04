({
	doInitduplicate : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        
        var DupAction=component.get("c.duplicatePETemplate");
        DupAction.setParams({
            recordId : recId
        });
        
        DupAction.setCallback(this, function(dupres) {
             console.log('===duplicate state======' + dupres.getState());
            var dupState = dupres.getState();
            var dupid = dupres.getReturnValue();
            if (dupState === "SUCCESS") {
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Duplicated Successfully.'
                    });  
                 var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId":dupid,                       
                    });
                    navEvt.fire();
            }
           else {
                console.log('>>>>>> Error >>>>>>>>>>',dupres.getError()[0].message);
                var errors = dupres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
         $A.enqueueAction(DupAction);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
		
})