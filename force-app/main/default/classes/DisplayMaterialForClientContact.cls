public with sharing class DisplayMaterialForClientContact{

  Public List<Material_Item__c> MaterialList {get;set;}
  
   
  public  DisplayMaterialForClientContact(){
      
      MaterialList =[Select id ,name,Calc_Unit__c,Category__c,Package_Type__c,Store_Front__c,Type__c from Material_Item__c  where Store_Front__c=true];
      
      
}



}