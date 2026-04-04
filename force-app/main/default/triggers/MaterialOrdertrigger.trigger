trigger MaterialOrdertrigger on Material_Order__c (before delete) {


 set<id>moidsset=new set<id>();
    for(Material_Order__c  moid : Trigger.old)
    {
        moidsset.add(moid.id);
    } 
    
    
   Material_Purchase_Line_Item__c lstMPLI =  [select id,name,Material_Item__c, Material_Item__r.name,Material_Order__c, Material_Order__r.name, Calc_Unit__c,Qty__c from Material_Purchase_Line_Item__c  where Material_Order__c =: moidsset WITH SECURITY_ENFORCED Order By CreatedDate desc limit 1];

  if(lstMPLI != null)
  {
  lstMPLI.addError('Cannot delete this record because there is line items under this material order');
  }
  else
  {
Material_Order__c morcd  = [select id,name,Vendor_Name__r.name, Issue_Date__c, MO_Due_Date__c, Status__c,Vendor_Name__c  from Material_Order__c where id =: moidsset WITH SECURITY_ENFORCED limit 1];
delete morcd;
  }

}