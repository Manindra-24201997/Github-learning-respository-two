public class Production_Est_Template_Duplicate_Ctrl {
    
    @AuraEnabled
    public static id duplicatePETemplate(id recordId){
        list<Production_Estimate_Temp_Line_Items__c> lineItemList=[select Name,Calc_Unit__c,Sided__c,
                                                                             Equipment_Type__c,Color__c,
                                                                             Commission__c,Sort_Order__c,
                                                                             Width_in_Inches__c,Length_in_Inches__c,
                                                                             EachQtyUpforUsed__c,SheetQtyUpforUsed__c,
                                                                             Qty_Up__c,Quantity__c,
                                                                             of_Pages__c,Production_Estimate_Template__c,
                                                                             Production_Estimate_Template__r.Name,
                                                                             Material_Item__c,Vendor__c,
                                                                             GL_Department__c,GL_Code__c,
                                                                             Qty_Used__c,Divide_Sheets_By_Two__c
                                                                             from Production_Estimate_Temp_Line_Items__c
                                                                             where Production_Estimate_Template__c=:recordId];
        system.debug('---lineItemList----'+lineItemList.size());
        
        Production_Estimate_Template__c peTemplate=[select name from Production_Estimate_Template__c where id=:recordId];
        Production_Estimate_Template__c dupTemp=new Production_Estimate_Template__c();
        dupTemp.name='Dup : '+DateTime.Now()+' '+ peTemplate.name;
        insert dupTemp;
        
        list<Production_Estimate_Temp_Line_Items__c> petlitemlist=new list<Production_Estimate_Temp_Line_Items__c>();
        for(Production_Estimate_Temp_Line_Items__c petli: lineItemList){
            Production_Estimate_Temp_Line_Items__c item=new Production_Estimate_Temp_Line_Items__c();
            item.Name=petli.Name;
            item.Calc_Unit__c=petli.Calc_Unit__c;
            item.Sided__c=petli.Sided__c;
            item.Equipment_Type__c=petli.Equipment_Type__c;
            item.Color__c=petli.Color__c;
            item.Commission__c=petli.Commission__c;
            item.Sort_Order__c=petli.Sort_Order__c;
            item.Width_in_Inches__c=petli.Width_in_Inches__c;
            item.Length_in_Inches__c=petli.Length_in_Inches__c;
            item.EachQtyUpforUsed__c=petli.EachQtyUpforUsed__c;
            item.SheetQtyUpforUsed__c=petli.SheetQtyUpforUsed__c;
            item.Qty_Up__c=petli.Qty_Up__c;
            item.Quantity__c=petli.Quantity__c;
            item.of_Pages__c=petli.of_Pages__c;
            item.Production_Estimate_Template__c=dupTemp.id;
            item.Material_Item__c=petli.Material_Item__c;
            item.Vendor__c=petli.Vendor__c;
            item.GL_Department__c=petli.GL_Department__c;
            item.GL_Code__c=petli.GL_Code__c;
            //item.Qty_Used__c=pli.Qty_Used__c;
            item.Divide_Sheets_By_Two__c=petli.Divide_Sheets_By_Two__c;
            petlitemlist.add(item);
            system.debug('---petlitemlist---'+petlitemlist.size());
            
        }
        if(!petlitemlist.isEmpty()){
            insert petlitemlist;
        }
        return dupTemp.id;
    }
}