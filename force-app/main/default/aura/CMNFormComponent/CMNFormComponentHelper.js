({
     ClientAddress: function(component, event, helper){
        var action = component.get("c.getClientAddress");
        action.setCallback(this, function(response) {
            console.log("=====Client Contact====", JSON.stringify(response.getReturnValue()));
            if (response.getState() === "SUCCESS") {
                component.set("v.clientCon",response.getReturnValue()); 
                console.log("=====After IF Client Contact====", JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
})