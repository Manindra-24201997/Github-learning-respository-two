public with sharing class MaterialInventoryItemImportController 
{
      public Blob csvFileBody{get;set;}
      public string csvAsString{get;set;}
      public string csvAsString1{get;set;}
      transient public String[] csvFileLines{get;set;}
      public boolean recordsdisplay{get;set;}
      public boolean recordinsert{get;set;}
      public List<Material_Inventory_Item__c> Miilist{get;set;}
      public List<Material_Item__c> Materialitemlist{get;set;}
      Set<string> materialitem=new Set<string>();
      map<string,Material_Item__c> Mapinsertmaterialitem=new Map<string,Material_Item__c>();
    
  
      public MaterialInventoryItemImportController ()
      {
            csvFileLines = new String[]{};
            Miilist= New List<Material_Inventory_Item__c>(); 
            Materialitemlist = New List<Material_Item__c>(); 
            recordsdisplay=false;
            recordinsert=false;
      }
  
      public void importCSVFile()
      {
           recordsdisplay=true;
           try
           {
                   csvAsString = csvFileBody.toString();
                   csvFileLines = csvAsString.split('\\r\\n'); 
                   System.debug('-------csvFileLines.size()---------------'+csvFileLines.size());
                    
                 
                   for(Integer i=1;i<csvFileLines.size();i++)
                   {
                        string[] csvRecordData = csvFileLines[i].split(',');
                        if(String.isBlank(csvRecordData[0]) && String.isBlank(csvRecordData[1]) && String.isBlank(csvRecordData[2]))
                        { 
                             continue;
                        }
                        else 
                        {   
                            materialitem.add(csvRecordData [0]);
                        }
                     
                    }
                         
                   System.debug('-------csvFileLines.size()---------------'+csvFileLines.size());
                   
                         
                   for(Material_Item__c matitem: [select Id,name,Manufacturer_Item_No__c from Material_Item__c where Manufacturer_Item_No__c IN :materialitem])
                   {  
                   
                        Mapinsertmaterialitem.put(matitem.Manufacturer_Item_No__c,matitem);
                   }
                   
                   for(Integer i=1;i<csvFileLines.size();i++)
                   {
                        string[] csvRecordData = csvFileLines[i].split(',');
                        
                        if(String.isBlank(csvRecordData[0]) && String.isBlank(csvRecordData[1]) && String.isBlank(csvRecordData[2]))
                             { 
                                  continue;
                             }
                             else 
                             { 
                                 if(Mapinsertmaterialitem.containsKey(csvRecordData [0]))
                                 {
                                      Material_Inventory_Item__c miiobj = new Material_Inventory_Item__c();
                                  
                                                
                                           miiobj.name = csvRecordData[0];
                                           miiobj.Mfg_Item_Number__c = csvRecordData[0];
                                           miiobj.Material_Item__c= Mapinsertmaterialitem.get(csvRecordData[0]).ID;
                                           miiobj.Qty_On_Shelf__c = Decimal.ValueOf(csvRecordData[1]);
                                           miiobj.Inventory_Date__c = date.parse(csvRecordData[2]);
                                           Miilist.add(miiobj); 
                                     }   
                          
                                   else 
                                      { 
                                      
                                            Material_Inventory_Item__c miiobj = new Material_Inventory_Item__c() ;
                                           
                                           if(String.isBlank(csvRecordData[0]) && String.isBlank(csvRecordData[1]) && String.isBlank(csvRecordData[2]))
                                           { 
                                                   continue;
                                           }
                                           else 
                                           {            
                                                     miiobj.name = csvRecordData[0];
                                                     miiobj.Mfg_Item_Number__c = csvRecordData[0];
                                                     miiobj.Qty_On_Shelf__c = Decimal.ValueOf(csvRecordData[1]);
                                                     miiobj.Inventory_Date__c = date.parse(csvRecordData[2]);
                                                     
                                                     Miilist.add(miiobj); 
                                           }
                                      } 
                         }
           }
           }
             
           catch (Exception e)
           {
               ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data Please make sure input csv file is correct---------'+e);
               ApexPages.addMessage(errorMessage);
           }   
      }
  
     public void saveme()
     {
          recordinsert=true;
          recordsdisplay=false;
          system.debug('============Miilist=================>'+Miilist);
          if(Miilist.size()>0)
          {
              upsert Miilist;
          }
          else
          {
              ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Upload a File');
               ApexPages.addMessage(errorMessage);
          }
    }
    
    
     public PageReference cancelme()
     {
         PageReference pg = new PageReference('/apex/customReports');
         return pg;
     } 
     
     public PageReference refresh()
     {
         PageReference pg = new PageReference('/apex/MaterialInventoryItemImport');
         pg.setRedirect(true);
         return pg;
     } 
     
       
}