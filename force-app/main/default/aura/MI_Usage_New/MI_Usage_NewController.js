({
    doInit : function(component, event, helper) {
        helper.fetchFieldSet(component, event, helper);
         helper.fetchMaterialUsageItems(component, event, helper);
    },
    
    MIUIOnSubmit :function(component, event, helper) {
        event.preventDefault();
        var MIUIfields=event.getParam("fields");
        MIUIfields["Material_Item__c"]=component.get("v.recordId");
        var MIrec=component.get("v.simpleRecord");
       /* console.log('===CalUnit====='+MIrec.Calc_Unit__c);
        console.log('===Fields in simpler Record===='+JSON.stringify(MIrec));*/
        var allMIUIRecords=component.get("v.MaterialUsageItems");
        var LatestMIUIRecord;
        for(var i=0; i<allMIUIRecords.length; i++){
            if(allMIUIRecords[i].rowIndexNo==0){
                LatestMIUIRecord=allMIUIRecords[i];
            }
        }
        //console.log('====Latest MIUI Record After=='+JSON.stringify(LatestMIUIRecord));
        var qtyonhand;
        if(LatestMIUIRecord!=null){
            //qtyonhand=parseInt(LatestMIUIRecord.Qty_On_Hand__c);
            qtyonhand=parseFloat(LatestMIUIRecord.Qty_On_Hand__c);
        }
        else{
            qtyonhand=0;
        }
        
        //console.log('>>>>Qty on Hand before parsing negative values>>>'+parseInt(-0.5));
        //console.log('>>>>Sheet Calc Qty on Hand before parsing>>>'+LatestMIUIRecord.Qty_On_Hand__c);
        //console.log('>>>>Sheet Calc Qty on Hand>>>'+qtyonhand);
        //console.log((MIUIfields.Credit__c != null));
       
       /* console.log('====MIUIf Roll LF======'+MIrec.Roll_LF__c);
        console.log('====MIUIf Casepack======'+MIrec.Case_Pack__c);
        console.log('====MIUIf Roll LF type======'+ (typeof(MIrec.Roll_LF__c)));
        console.log('====MIUIf Casepack type======'+(typeof(MIrec.Case_Pack__c)));*/
        
        //console.log('====differnce for Each======'+ ((qtyonhand) +((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0))));
        //console.log('====differnce for size======'+ ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c : 0))));
        //console.log('====differnce for Sheet======'+((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0))));
        
        if(MIrec.Calc_Unit__c=='Size'){
            MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c : 0)));
            //objMaterial.Qty_On_Hand__c=(qtyonhand +(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c: 0))- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c: 0);
            MIUIfields["Credit__c"]=(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Roll_LF__c : 0);
            MIUIfields["Debit__c"]=(MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Roll_LF__c: 0);
        }
        
        else if(MIrec.Calc_Unit__c=='Sheet'){
            
           /* console.log('>>>>Sheet Calc Qty on Hand>>>'+qtyonhand);
            console.log('>>>>Sheet Calc Credit>>>'+parseFloat(MIUIfields.Credit__c));
            console.log('====Sheet Calc Credit type======'+(typeof(parseFloat(MIUIfields.Credit__c))));
            console.log('>>>>Sheet Calc Case_Pack>>>'+MIrec.Case_Pack__c);*/
            
            MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0)));
            //objMaterial.Qty_On_Hand__c=((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c: 0)- (MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0)));
            MIUIfields["Credit__c"]=(MIUIfields.Credit__c != null ? MIUIfields.Credit__c * MIrec.Case_Pack__c : 0);
            MIUIfields["Debit__c"]=(MIUIfields.Debit__c != null ? MIUIfields.Debit__c * MIrec.Case_Pack__c: 0);
          
            /* console.log('====Sheet Calc Qty_On_Hand type======'+(typeof(MIUIfields.Qty_On_Hand__c)));
            console.log('>>>>Sheet Calc Qty_On_Hand updated>>>'+MIUIfields.Qty_On_Hand__c);   */     
        }
        
            else{
                MIUIfields["Qty_On_Hand__c"]= ((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0)));
                //objMaterial.Qty_On_Hand__c=((qtyonhand) + ((MIUIfields.Credit__c != null ? MIUIfields.Credit__c : 0) - (MIUIfields.Debit__c != null ? MIUIfields.Debit__c : 0)));
            } 
        component.find("MIUIEditform").submit(MIUIfields);
       // console.log('===Material Usage Items OnSubmit fields===='+JSON.stringify(MIUIfields));
    },
    
    MIUIOnSuccess :function(component, event, helper) {
        helper.fetchMaterialUsageItems(component, event, helper);   
        helper.updateMaterailItemQtyOnHandField(component, event, helper);           
    },
    
     doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    },
    
})