({
	delete_MO : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName ="JobSuite__Material_Order__c";
        var delActon=component.get("c.deleteMOrcd");
            delActon.setParams({rcdids: recId});
        delActon.setCallback(this, function(deleteRes) {
             console.log('===vendor delete result======' + deleteRes.getReturnValue());
            if (deleteRes.getState() === "SUCCESS") {
                if(deleteRes.getReturnValue()=="deleted"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "JobSuite__Material_Order__c"
                    });
                    homeEvent.fire();
                } 
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Please delete Material Line items records before deleting this record.'
                    });     
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Record has '+ errors[0].message
                }); 
            }
        });
         $A.enqueueAction(delActon);
	},
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})