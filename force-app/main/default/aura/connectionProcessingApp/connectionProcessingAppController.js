({
    myAction : function(component, event, helper) {
        var actionorg = component.get("c.getcmpnamespace");
        actionorg.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('name space === '+response.getReturnValue());
                var namespace  = response.getReturnValue();
                $A.createComponent(
                    namespace+":connectionProcessing",
                    {
                        
                    },
                    function(newButton, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            var body = cmp.get("v.body");
                            body.push(newButton);
                            cmp.set("v.body", body);
                        }
                    }
                );
            } 
            else{
                console.log('Error === '+response.getError());
            }
        });
        $A.enqueueAction(actionorg);
    }
})