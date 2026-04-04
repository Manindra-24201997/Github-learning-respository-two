({
    fetchFieldSet : function(component, event, helper) {
        var actionMIUI = component.get("c.getFieldsforObject");
        actionMIUI.setParams({
            sObjName : "Material_Usage_line_item__c"
        });
        actionMIUI.setCallback(this, function(res) {
            // console.log("=====Field set for Materail Usage Line Items====", res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                component.set("v.MIUIFieldSet",res.getReturnValue()); 
            }
        });
        $A.enqueueAction(actionMIUI);
    },
    
    updateMaterailItemQtyOnHandField :function(component, event, helper) {
        var action=component.get("c.updateMaterailItemQtyOnHandField");
        action.setParams({
            MItemId:component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            //  console.log('====MaterialUsageItems Records==='+JSON.stringify(response.getReturnValue()));
            if(response.getState()=="SUCCESS" ){
                // helper.reloadData(component,event);
                if(response.getReturnValue()=="OK"){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "type" : "success",
                        "message": "The record was Created."
                    });
                    resultsToast.fire();  
                } 
                if(component.get("v.recordId")!=null)
                {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.recordId")
                    });
                    navEvt.fire();
                     $A.get('e.force:refreshView').fire();
                }
                component.set("v.isMIUIOpen",false);
               
            }
        });
        $A.enqueueAction(action);
    },
    
    reloadData :function(component,event){
        var refreshEvent=$A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
        
    },
    
    fetchMaterialUsageItems : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var action=component.get("c.getMaterialUsageItems");
        action.setParams({
            MItemId:recordId
        });
        action.setCallback(this, function(res){
            // console.log('====MaterialUsageItems Records==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.rowIndexNo=i;
                }
                component.set("v.MaterialUsageItems",rows);
            }
        });
        $A.enqueueAction(action);
    }
    
    
    
})