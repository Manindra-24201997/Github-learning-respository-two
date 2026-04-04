({
    getClientContacts : function(component, event, helper) {
        var clientContacts=component.get("c.getClientContacts");
        clientContacts.setCallback(this, function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.clientContacts",Response.getReturnValue());
            }
        });
        
        var materialItems=component.get("c.getMaterialItemList");
        materialItems.setCallback(this, function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.MaterialItemsList",Response.getReturnValue());
            }
        });
        $A.enqueueAction(clientContacts);
        $A.enqueueAction(materialItems);
    },
    getShowItems : function(component, event, helper,mTypeInput){
        var materialItems=component.get("c.showItems");
        materialItems.setParams({
            "MaterialItemNameString": mTypeInput
        });
        materialItems.setCallback(this, function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.MaterialItemsList",Response.getReturnValue());
            }
        });
        $A.enqueueAction(materialItems);
    },
    getCombineList : function(component, event, helper,selectedClientList,selectedMaterialItems){
        var getCombine=component.get("c.getCombinedList");
        getCombine.setParams({
            "clientContactSelectList":selectedClientList,
            "MIWrapperList":selectedMaterialItems
        });
        getCombine.setCallback(this,function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.combineStoreWrapper",Response.getReturnValue());
            }
        });
        $A.enqueueAction(getCombine);
    },
    saveOrder : function(component, event, helper,combineStoreWrapper,selectedMaterialItems){
        var order=component.get("c.OrderMethod");
        order.setParams({
            CombinedWrapperList:combineStoreWrapper,
            MIWrapperList:selectedMaterialItems
        });
        order.setCallback(this,function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            var toastEvent = $A.get("e.force:showToast");
            if(Response.getState()=='SUCCESS'){
                
             if(Response.getReturnValue()=='Success'){
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "duration":'2000',
                    "message": "Order submitted successfully."
                });
                toastEvent.fire();
                  window.setTimeout(
                               $A.getCallback(function() {
                                   var navigateEvent = $A.get("e.force:navigateToComponent");
                                   navigateEvent.setParams({
                                       componentDef: "c:JobsForClientContactLtCmp"
                                   });
                                   navigateEvent.fire();
                               }), 4000
                           );
            }
            else if(Response.getReturnValue()=='QuantittError'){
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "The Quantity must be less than Max Quantity of related Material Item."
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
            }else if(Response.getReturnValue()=='Email and BillingInstructions'){
                    toastEvent.setParams({
                        "title": "Review all errors!",
                        "type":"error",
                        "message": "Email and BillingInstructions are required fields."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                else if(Response.getReturnValue()=='BillingInstructions'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "Billing instructions is a required field."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                else if(Response.getReturnValue()=='Email'){
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "Email is a required field."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                }
                    else{
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": ''+Response.getReturnValue()
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner", false);
                    }
            }
            
        });
        $A.enqueueAction(order);
    }
    
})