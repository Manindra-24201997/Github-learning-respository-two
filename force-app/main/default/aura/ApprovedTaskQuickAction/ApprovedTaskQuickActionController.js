({
    doInitApprovedTask : function(component, event, helper) {
        
        var JobCostAccess = component.get("c.getisAccessable");
        JobCostAccess.setCallback(this, function(JobCostresponse) {
            if (JobCostresponse.getState() === "SUCCESS") {
                console.log('Job Cost Accessable'+JobCostresponse.getReturnValue());
                component.set("v.JobDetailAccessible",JobCostresponse.getReturnValue());
            }
            
        });
        $A.enqueueAction(JobCostAccess); 
        
        setTimeout($A.getCallback(function (){
            if(component.get("v.JobDetailAccessible[2]")){  
                var recId = component.get("v.recordId");
                
                var ApprovedTask=component.get("c.ApprovedTsk");
                ApprovedTask.setParams({
                    TskId : recId
                });
                
                ApprovedTask.setCallback(this, function(response){ 
                    
                    console.log('>>>Response State>>>>>'+response.getState());
                    console.log('>>>Response State1>>>>>'+response.getReturnValue());
                    
                    if (response.getState() === "SUCCESS") {
                        var res=response.getReturnValue();
                        if(response.getReturnValue()=="Not Ready"){
                            helper.showToast({
                                "title": "Error!!",
                                "type": "error",
                                "message": 'Please submit this approval process first.'
                            });
                            $A.get("e.force:closeQuickAction").fire(); 
                        }
                        else if(response.getReturnValue()=="already Approved"){
                            helper.showToast({
                                "title": "Error!!",
                                "type": "error",
                                "message": 'This step has already been Approved.'
                            });
                            $A.get("e.force:closeQuickAction").fire(); 
                        }
                            else{
                                helper.showToast({
                                    "type": "success",
                                    "message": "Status changed to Approved."
                                });
                                $A.get("e.force:closeQuickAction").fire();
                                $A.get('e.force:refreshView').fire();
                                /*var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": res,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();*/
                        }
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            });
            
            $A.enqueueAction(ApprovedTask);
        }
            else{
                var ToastMsgaboveAppSteps = $A.get("e.force:showToast");
                ToastMsgaboveAppSteps.setParams({
                    "title": "ERROR",
                    "type": "error",
                    "message": 'Error, Approval Steps has insufficient access to Update'                        
                });
                ToastMsgaboveAppSteps.fire();
                
            }
        }), 1000);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    
})