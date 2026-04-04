({
    doInit : function(component, event, helper){
        var action = component.get("c.findRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.recList",res);
            }else if(state === "ERROR"){
                alert('Problem with connection. Please try again.');
            }
        });
        $A.enqueueAction(action);
    },
    fireEvent : function (component, event, helper){
        console.log('event get fired from SK_AccListView Component');
        var selectedAccountId = event.getSource().get('v.value');
        console.log('**********selectedAccountId:'+selectedAccountId);
        var myEvent = $A.get("e.skforce:SK_AccListViewEvent");
        myEvent.setParams({
            accountIdPassedFromEvent:selectedAccountId
        });
        console.log('firing event from component controller');
        myEvent.fire();
    },
    showSpinner: function(component, event, helper) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event, helper) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})