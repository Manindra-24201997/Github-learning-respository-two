({
    getFieldLabels : function(component, event, helper){
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : ['Material_Purchase_Line_Item__c']
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                component.set("v.ObjectType", JSON.parse( response.getReturnValue()));
            }
          else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(Objaction); 
    },
    
     CreateMPLIRecord :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Material_Purchase_Line_Item__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    createMolireceipt :  function(component, event, helper,molirecordid,Receiptval){
     var action = component.get("c.createreceiptrcd");
        action.setParams({
            rcdid : molirecordid,
            Receiptrcdval : Receiptval
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
     getMaterialItems :function(component, event, helper){
        var miaction = component.get("c.getMatereialItems");
        miaction.setCallback(this, function(res) {
            console.log("=====Materail Items records===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.MItem_Records", res.getReturnValue()); 
            } 
        });
        $A.enqueueAction(miaction);  
    },
    
    getMPO:function(component, event, helper){
        var mpoaction = component.get("c.getMpoRcd");
        mpoaction.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS"){
                component.set("v.MPONameVendorName", res.getReturnValue()); 
            } 
        });
        $A.enqueueAction(mpoaction); 
    },
    
   showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    }
})