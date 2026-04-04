({
    doInit : function(component, event, helper) {
        //alert('do init');
        var checkPEpermisson=component.get("c.getMPLIPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]") && component.get("v.isAccess[1]")){
                    helper.CreateMPLIRecord(component, event, helper); 
                    component.set("v.isMPLIOpen",true);
                }
            }
        });
        $A.enqueueAction(checkPEpermisson); 
        helper.getFieldLabels(component, event, helper);
        helper.getMPO(component, event, helper);
        helper.getMaterialItems(component, event, helper);
    },
    
    materialitemchange : function(component, event, helper) {
        //alert('materialitemchange');
    },
    
    
    MPLIload : function(component, event, helper) {
        //alert('MPLIload');
    },
    
    MPLIOnsubmit : function(component, event, helper) {
        //alert('MPLIOnsubmit');
        event.preventDefault();
        var MIPLIfields=event.getParam("fields");
        var QtyField = component.find('MPLIQty').get('v.value');
        var  MaterialItemvalue = component.find('MISelectId').get('v.value');
        var ReceiptQty = component.find('receiptval').get('v.value');
        MIPLIfields["Material_Order__c"]=component.get("v.MPONameVendorName[2]");
        MIPLIfields["Material_Item__c"]=MaterialItemvalue;
        if(QtyField == null || QtyField == 'undefined' || QtyField == '' || QtyField <= 0){
            var ToastCalMsg = $A.get("e.force:showToast");
            ToastCalMsg.setParams({
                "title": "error",
                "message":"Qty Ordered Field is required Or Qty Field is Greater then Zero to save a record."
            });
            ToastCalMsg.fire();  
        }
        else if(ReceiptQty == null || ReceiptQty == 'undefined' || ReceiptQty == '' || ReceiptQty <= 0){
            var ToastCalMsg = $A.get("e.force:showToast");
            ToastCalMsg.setParams({
                "title": "error",
                "message":"Receipt Qty Field is required Or Receipt Qty is Greater then Zero to save a record."
            });
            ToastCalMsg.fire();  
        }
            else if(MaterialItemvalue == null || MaterialItemvalue == 'undefined' || MaterialItemvalue == ''){
                var ToastCalMsg = $A.get("e.force:showToast");
                ToastCalMsg.setParams({
                    "title": "error",
                    "message":"Material Item Field is required to save a record."
                });
                ToastCalMsg.fire();
            }
                else{
                    component.find("recordEditForm").submit(MIPLIfields);
                    console.log('===Material Receipt OnSubmit fields===='+JSON.stringify(MIPLIfields));
                }
        
    },
    
    onMPLIRecordSuccess : function(component, event, helper) {
        // alert('onMPLIRecordSuccess === '+myRecordId);
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var ReceiptQty = component.find('receiptval').get('v.value');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.MPONameVendorName[2]")
        });
        navEvt.fire();
        
        helper.showToast({
            "type":"success",
            "message":  "Material Order Line Item Record Inserted Successfully."
        });
        component.set("v.isMPLIOpen",false);
        if(myRecordId){
            helper.createMolireceipt(component,event,helper,myRecordId,ReceiptQty);
        }
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isMPLIOpen", false);
        component.set('v.MPLIRecordid', null);
        $A.get('e.force:refreshView').fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.recordId'),
            "slideDevName": "related"
        });
        navEvt.fire();
    }
    
})