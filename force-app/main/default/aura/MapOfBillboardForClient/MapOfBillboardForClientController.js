({
    doinit: function (cmp, event, helper) {
     var action=cmp.get("c.getClientId");
        action.setCallback(this,function(Response){
           // alert('-----rESPONSE'+Response.getReturnValue());
            cmp.set('v.clientId',Response.getReturnValue());
        });
         $A.enqueueAction(action);
   
    }
})