({
    fetchCompletedJobs : function(component, event, helper) {
        helper.getFiltersVal(component, event, helper);
     	helper.fetchCompeJobs(component, event, helper);
    },
    
    handleSelect : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows'); 
        component.set('v.selectedRowsCount', selectedRows.length);
        component.set('v.selectedJobs', selectedRows);
    },
    
    doFilter : function(component, event, helper) {
        component.set("v.JobList",[]);
        component.set("v.selectedRowsCount",0);
        component.set("v.selectedJobs",[]);
        helper.filerJobRefecth(component, event, helper);
    },
    
    resetFilters : function (component, event, helper) {
        helper.resetFiltersHelper(component, event, helper);
    },
    
    createClientInvoice: function(component, event, helper) {
        var selectrowcount=component.get('v.selectedRowsCount');
        var selectJobs=component.get('v.selectedJobs');
        console.log('>>>>>>>>selectJobs>>>>>>>>>',selectJobs);
        var action=component.get("c.createClientInv");
        action.setParams({
            selectedrecs:selectJobs
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if (state === "SUCCESS") {
                 if(response.getReturnValue()=="OK"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "message":selectrowcount+" Jobs has created Client Invoice successfully."
                    });
                    toastEvent.fire(); 
                    component.set("v.selectedRowsCount",0);
                    component.set("v.JobList",[]);
                    helper.filerJobRefecth(component, event, helper);
                }
               else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!!",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();   
                }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!!",
                    "message": response.getReturnValue()
                });
                toastEvent.fire();   
            }
        });
        $A.enqueueAction(action);
    },
    
     cancelnaviagtion  : function (component, event, helper) {
         var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Job__c',
                actionName: 'home'
            }
        };
        navService.navigate(pageReference);
    },
    
})