({
    getBBList : function(component, event, helper) {
        
        var BBItems=component.get("c.DisplayBillboardList");
        BBItems.setCallback(this, function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.BBItemsList",Response.getReturnValue());
            }
        });
        
        $A.enqueueAction(BBItems);
    },
})