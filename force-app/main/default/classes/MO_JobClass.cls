public with sharing class MO_JobClass {
    
    @AuraEnabled 
    public static String getObjectType(List<String> ObjNames) {
        return getDynamicLabelUtilityloves.getDescribedObjects(ObjNames);   
    }
    
    @AuraEnabled 
    public static list<Boolean> getMOPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Material_Order__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Order__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Order__c.isUpdateable());
        isAccessList.add(Schema.sObjectType.Material_Order__c.isdeletable());
        return isAccessList;
    }
    
    @AuraEnabled 
    public static list<Boolean> getMPLIPermiossions()
    {
        list<boolean> isAccessList=new list<boolean>();
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Purchase_Line_Item__c.isUpdateable());
        
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isAccessible());
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isCreateable()); 
        isAccessList.add(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isUpdateable());
        return isAccessList;
    }
    
    // ================================================= FieldSets fields =====================================================================//
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List < Schema.FieldSetMember > fields = fieldMap.get(fieldsetname).getFields();
        List < string > fieldsname = new List < string > ();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        return fieldsname;
    }
    
    @AuraEnabled
    public Static list<Material_Item__c> getMatereialItems() {   
        list<Material_Item__c> miList=new list<Material_Item__c>();
        miList=[SELECT Id, Name,Calc_Unit__c,Mt_Status__c	 FROM Material_Item__c where Calc_Unit__c ='Each' and Mt_Status__c = 'Active' WITH SECURITY_ENFORCED order by Name];
        return miList;
    }
    
    @AuraEnabled
    public Static list<String> getMpoRcd() {  
        list<string> fieldvalues = new list<string>();
        Material_Order__c mo = [select id,name,Vendor_Name__c,Vendor_Name__r.Name from Material_Order__c where name = 'MPO - 00017' WITH SECURITY_ENFORCED limit 1];
        fieldvalues.add(mo.name);
        fieldvalues.add(mo.Vendor_Name__r.Name);
        fieldvalues.add(mo.id);
        return fieldvalues;
    }
    
    @AuraEnabled
    public Static void createreceiptrcd(string rcdid,decimal Receiptrcdval) {
        decimal qty = 0;
        Material_Purchase_Line_Item__c mpli = [select id,name,Material_Item__c,Qty_Outstanding__c,Material_Item__r.name,Material_Order__c, Material_Order__r.name,MPLI_Status__c, Calc_Unit__c,Qty__c from Material_Purchase_Line_Item__c where id =: rcdid WITH SECURITY_ENFORCED limit 1];
        Material_Order_Line_Item_Receipt__c molirecipt  = new   Material_Order_Line_Item_Receipt__c();
        if(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.fields.Material_Purchase_Line_Item__c.isCreateable()){
            molirecipt.Material_Purchase_Line_Item__c = mpli.id;
        }
        if(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.fields.MOLI_Receipt_Date__c.isCreateable()){
            molirecipt.MOLI_Receipt_Date__c = system.today();
        }
        if(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.fields.MPLI_Receipt_Status__c.isCreateable()){
            molirecipt.MPLI_Receipt_Status__c = 'Received';
        }
        if(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.fields.MOLI_Receipt_Qty__c.isCreateable()){
            molirecipt.MOLI_Receipt_Qty__c = Receiptrcdval;
            qty = molirecipt.MOLI_Receipt_Qty__c;
        }
        if(Schema.sObjectType.Material_Order_Line_Item_Receipt__c.isCreateable()){
            insert molirecipt;
        }
        
        // Below logic is for  Qty outstading update 
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.fields.Qty_Outstanding__c.isupdateable()){
            if(mpli.Qty_Outstanding__c <= 0 || mpli.Qty_Outstanding__c == null){
                mpli.Qty_Outstanding__c = mpli.Qty__c-Receiptrcdval ;  
            }
            else{
                mpli.Qty_Outstanding__c = mpli.Qty_Outstanding__c-Receiptrcdval ;  
                
            }
        }
            if(Schema.sObjectType.Material_Purchase_Line_Item__c.fields.Calc_Unit__c.isupdateable()){
            mpli.Calc_Unit__c = 'Each';
        }
        if(Schema.sObjectType.Material_Purchase_Line_Item__c.isupdateable()){
            update mpli;
        }// Qty outstading update ends here.
        
        //Logic for creating material usage line items
        Material_Item__c MIrec=[Select Id,Name,Qty_On_Hand__c,Calc_Unit__c,Case_Pack__c,Roll_LF__c,(Select Id,Name,Qty_On_Hand__c,Date__c,Debit__c,Credit__c,Type__c,Material_Item__c  from Material_Usage_line_items__r Order by Createddate DESC) from Material_Item__c  where Id=:mpli.Material_Item__c WITH SECURITY_ENFORCED limit 1];
        if(MIrec.Material_Usage_line_items__r.size()>0){
            decimal latestmuln = MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c;
            Material_Usage_line_item__c MIUIfields = new Material_Usage_line_item__c(); 
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Material_Item__c.isCreateable()){
                MIUIfields.Material_Item__c = MIrec.id;
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Qty_On_Hand__c.isCreateable()){
                MIUIfields.Qty_On_Hand__c = ((MIrec.Material_Usage_line_items__r[0].Qty_On_Hand__c) + ((qty != null ? qty : 0) - (0)));
                //system.debug('MIUIfields.Qty_On_Hand__c === '+MIUIfields.Qty_On_Hand__c);
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Credit__c.isCreateable()){
                MIUIfields.Credit__c = (qty != null ? qty  : 0);
                //system.debug(' MIUIfields.Credit__c === '+ MIUIfields.Credit__c);
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Debit__c.isCreateable()){
                MIUIfields.Debit__c = 0;
                //system.debug(' MIUIfields.Debit__c === '+ MIUIfields.Debit__c);
            }
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Date__c.isCreateable()){
                MIUIfields.Date__c = system.today();
                //system.debug(' MIUIfields.Date__c === '+ MIUIfields.Date__c);
            } 
            if(Schema.sObjectType.Material_Usage_line_item__c.fields.Type__c.isCreateable()){
                MIUIfields.Type__c = 'Purchase';
            }  
            
            //Here we operating dml for muli and material item qty on hand
            if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                insert MIUIfields;
                system.debug('inserted rcd is === '+MIUIfields + '\n');
                
                if(Schema.sObjectType.Material_Item__c.fields.Qty_On_Hand__c.isUpdateable()){
                    MIrec.Qty_On_Hand__c =  MIUIfields.Qty_On_Hand__c;
                    update MIrec;
                    system.debug('Updated rcd is === '+MIrec + '\n');
                }
            }// dml operation ends here.
        }
    }      
}