public with sharing class TrilliumJobRequestFormPageExt 
{
    
    public boolean isTab{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t' || theme=='Theme4d')?true:false;
                                          }
    }
     
    
    
    Public Media_Type__c NameStoreMediatype{get;set;}
    Public Schedule_Template__c NameStoreScheduletype{get;set;}
    public List<ClientContactsWrapper> CCWrapperList {get; set;}
    public List<MaterialItemWrapper> MIWrapperList {get; set;}
    public List<CombinedWrapper> CombinedWrapperList {get; set;}
    public map<string,Material_Item__c> MapMaterialItem {get;set;}
    public List<Client_Contact__c> CCSelected {get; set;}
    public List<Material_Item__c> MISelected {get; set;}
    public boolean ShowClientContacts {get;set;}
    Public boolean ShowMaterialItems {get;set;}
    Public boolean ShowCombinedData {get;set;}
    public map<id,decimal> MapMaxQuty{get;set;}
    public Set<Datetime> holidaysNew;
     Public String MaterialItemNameString {get;set;}
     public boolean editaddress{get;set;}
     
    Public TrilliumJobRequestFormPageExt()
    {
        
        ShowClientContacts = true;
        ShowMaterialItems = false;
        ShowCombinedData = false;
        editaddress=false;
        
        
        NameStoreMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
        NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Made To Order' AND Media_Types__r.name='Print' limit 1];
        
        list<Client_Contact__c> ClientContactList= new List<Client_Contact__c>();
        
        CCWrapperList = new List<ClientContactsWrapper>();
        
        ClientContactList=[select id,name,Client__c,Shipping_Address__c ,Shipping_Address_2__c,City__c,Zip__c,State__c,Client__r.Client_Code__c  from Client_Contact__c where Client__r.name=:'Trillium CNG' order by name];
        
        for(Client_Contact__c CC:ClientContactList)
        {
            ClientContactsWrapper c = new ClientContactsWrapper();
            c.ClientConWrap = CC;
            c.Contactselect= false;
            CCWrapperList.add(c);
        }
          
          // Material Item List
           
          List<Material_Item__c> MaterialItemList = new List<Material_Item__c>();
          
          MIWrapperList = new List<MaterialItemWrapper>();
          
           MaterialItemList=[select id,name,File_Photo__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Type__c,Description__c,Max_Qty__c,Calc_Unit__c,GL_Code__c,Category__c,GL_Department__c,Creative_Brief_Template__c,Creative_Brief_Template__r.name,Production_Estimate_Template__c,Production_Estimate_Template__r.name from Material_Item__c where Type__c=:'Trillium CNG' order by name];
          
          MapMaterialItem = new  map<string,Material_Item__c>();
          
             Set<Id> contentDocumentIdSet =new Set<Id>();
             Map<Id,String> contentDocMap=new Map<Id,String>();
             for(Material_Item__c MI: MaterialItemList){
                for(ContentDocumentLink cdl: MI.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
             }
            for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
             if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                   contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
           }
              
          
          for(Material_Item__c MI:MaterialItemList)
          {
              MaterialItemWrapper M = new MaterialItemWrapper();
              M.MIWrap= MI;
              M.MISelect = False;
               M.ContentVersionId='';
              for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                    if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                     M.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                     break;
                    }
                 } 
              MIWrapperList.add(M);
              MapMaterialItem.put(MI.id,MI);
          }
        
        
    }
    
    
    public void Editaddress()
    {
         editaddress = true;
        
    }
    
    public void MIMethod()
    {
          CCSelected=new List<Client_Contact__c>();
    
          for(ClientContactsWrapper ccwrap : CCWrapperList)
          {  
               if(ccwrap.Contactselect)
               {  
                  CCSelected.add(ccwrap.ClientConWrap);  
               }  
          }   
      
          if(CCSelected.size()>0)
          {
                ShowClientContacts = False;
                ShowMaterialItems = true;
                ShowCombinedData = False;
                editaddress = False;
          }
    
          else
          {
                ShowClientContacts = true;
                ShowMaterialItems = False;
                ShowCombinedData = False;   
                editaddress = False;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select atleast one Client Contact'));
          }
    
    
       
    }
    
    
    
    Public void ShowItems()            
    {       
        string MIname='%'+MaterialItemNameString+'%';       
         List<Material_Item__c> MaterialItemList = new List<Material_Item__c>();        
         MIWrapperList = new List<MaterialItemWrapper>();       
         if(MIname!=null)       
         {      
            MaterialItemList=[select id,name,File_Photo__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Type__c,Description__c,Max_Qty__c,Calc_Unit__c,GL_Code__c,Category__c,GL_Department__c,Creative_Brief_Template__c,Creative_Brief_Template__r.name,Production_Estimate_Template__c,Production_Estimate_Template__r.name from Material_Item__c where  (Name like: MIname OR Description__c like: MIname) AND Type__c=:'Trillium CNG' ORDER BY Name ASC];     
         }      
                
          MapMaterialItem = new  map<string,Material_Item__c>();   
          
          
         Set<Id> contentDocumentIdSet =new Set<Id>();
         Map<Id,String> contentDocMap=new Map<Id,String>();
          for(Material_Item__c MI: MaterialItemList){
                 for(ContentDocumentLink cdl: MI.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                  }
               }
          for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
             if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                   contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
          }
          
                
          for(Material_Item__c MI:MaterialItemList)       
          {     
              MaterialItemWrapper M = new MaterialItemWrapper();        
              M.MIWrap= MI;     
              M.MISelect = False;    
               M.ContentVersionId='';
                 for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                    if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                     M.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                     break;
                    }
                 }
              MIWrapperList.add(M);     
              MapMaterialItem.put(MI.id,MI);        
          }
          
     }
    
    public void CombinedMethod()
    {
        
         list<Material_Item__c> MIListVal = new list<Material_Item__c>();
         CombinedWrapperList = new List<CombinedWrapper>();
         Map<string,integer> m = new map<string,integer>();
         MapMaxQuty = new map<id,decimal>();
        
         for(MaterialItemWrapper MIW: MIWrapperList)
         {
             if(MIW.MISelect == true)
             {
                  MIListVal.add(MIW.MIWrap);   
                  m.put(MIW.MIWrap.Id,1);      
                  MapMaxQuty.put(MIW.MIWrap.id,MIW.MIWrap.Max_Qty__c);   
             }
         } 
         
         
         
          if(MIListVal.size()>0)
          {
               ShowClientContacts = False;
               ShowMaterialItems = False;
               ShowCombinedData = true;
          }
    
          else
          {
                ShowClientContacts = False;
                ShowMaterialItems = true;
                ShowCombinedData = False;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select atleast one Material Item'));
          }
         
         
            
         
         for(ClientContactsWrapper CCW: CCWrapperList)
         {
             if(CCW.Contactselect==true)
             {
                  CombinedWrapper CombineWrapper = new CombinedWrapper();
                 
                  CombineWrapper.CombinedClientContact = CCW.ClientConWrap;
                  
                   for(String str: m.keySet())
                   {
                          CombineWrapper.itemsList.add(new CombinedWrapperItem(MapMaterialItem.get(str)));
                   }
                  
                  CombineWrapper.MapQuan = m;
                  CombineWrapper.Address = CCW.ClientConWrap.Shipping_Address__c;
                  CombineWrapper.Address2 = CCW.ClientConWrap.Shipping_Address_2__c;
                  CombineWrapper.City = CCW.ClientConWrap.City__c;
                  CombineWrapper.state = CCW.ClientConWrap.State__c;
                  CombineWrapper.Zipcode = CCW.ClientConWrap.Zip__c;
                  CombinedWrapperList.add(CombineWrapper);
                 
             }
         }
         
    }
    
    
    
      // Save Method
        
        public Pagereference OrderMethod()
        {
        
             List<Job__c> JobsTobeInsert=new List<Job__c>();
             Map<String,Job__c > ClientJobMap= new  Map<String,Job__c > ();
             list<Production_Estimate__c> ProdEstimateList = new List<Production_Estimate__c>();
             list<Job_Spec__c> SpecsList = new List<Job_Spec__c>();
             list<Shipment__c> ShipmentList = new list<Shipment__c>();
             list<Client_Contact__c> Cconlist = new list<Client_Contact__c>();
             
             
            if(!CombinedWrapperList.isEmpty())
              {
                  for(CombinedWrapper cbw : CombinedWrapperList)
                  {
                        for(CombinedWrapperItem cm:cbw.itemsList)
                        {
                                  if(cm.mItem.Max_Qty__c < cm.enteredQty)
                                  {
                                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Quantity must be less than Max Quantity of related Material Item'));
                                       return null;
                                  }
                              
                        }
                        
                        
                        if(string.isBlank(cbw.BillingInstru))
                        {
                        
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Billing instructions is a required field'));
                                       return null;
                        }
                  }
              }
             
             
             
                try
                {  
                    
                     if(!CombinedWrapperList.isEmpty())
                     {
                               
                              CombinedWrapper comb =    CombinedWrapperList[0];
                              set<string> creativeBIds = new set<string>();
                              
                              for(string compMat :comb.MapQuan.keyset())
                              {
                                  creativeBIds.add(MapMaterialItem.get(compMat).Creative_Brief_Template__c);
                              }
                              
                              List<Spec_Item__c> specs = [select id,Name, Specification_Template__c,Description_Picklist__c,Lock__c,Sort_Order__c,Description__c,Spec_Item_picklist__c,Value__c  from Spec_Item__c where Specification_Template__c in :creativeBIds];
                              Map<string, List<Spec_Item__c>> MatSpecItemMap = new Map<string, List<Spec_Item__c>>();
                              
                              for(Spec_Item__c sp : specs)
                              {
                                  if(MatSpecItemMap.keyset().contains(sp.Specification_Template__c))
                                  {
                                      MatSpecItemMap.get(sp.Specification_Template__c).add(sp);
                                  }
                                  else
                                  {
                                      List<Spec_Item__c> jsi = new List<Spec_Item__c>();
                                      jsi.add(sp);
                                      MatSpecItemMap.put(sp.Specification_Template__c, jsi);
                                  }
                              }
                              
                              
                              
                              CombinedWrapper comb1 =    CombinedWrapperList[0];
                              set<string> creativeBIds1 = new set<string>();
                            
                              for(string compMat :comb1.MapQuan.keyset())
                              {
                                  creativeBIds1.add(MapMaterialItem.get(compMat).Production_Estimate_Template__c);
                              }
                              
                              List<Production_Estimate_Temp_Line_Items__c> specs1 = [select id,Name,Production_Estimate_Template__c,Vendor__c,GL_Department__c,GL_Code__c,Quantity__c,Calc_Unit__c,Material_Item__c,Qty_Up__c,Color__c,Sided__c,of_Pages__c,Width_in_Inches__c,Divide_Sheets_By_Two__c,Equipment_Type__c,Length_in_Inches__c,Commission__c,SheetQtyUpforUsed__c,EachQtyUpforUsed__c,Sort_Order__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c in :creativeBIds1];
                              Map<string, List<Production_Estimate_Temp_Line_Items__c>> MatSpecItemMap1 = new Map<string, List<Production_Estimate_Temp_Line_Items__c>>();
                             
                              for(Production_Estimate_Temp_Line_Items__c sp : specs1)
                              {
                                  if(MatSpecItemMap1.keyset().contains(sp.Production_Estimate_Template__c))
                                  {
                                      MatSpecItemMap1.get(sp.Production_Estimate_Template__c).add(sp);
                                  }
                                  else
                                  {
                                      List<Production_Estimate_Temp_Line_Items__c> jsi1 = new List<Production_Estimate_Temp_Line_Items__c>();
                                      jsi1.add(sp);
                                      MatSpecItemMap1.put(sp.Production_Estimate_Template__c, jsi1);
                                  }
                              }
                                
                               holidaysNew= new Set<Datetime>();
                                             
                                   for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c != NULL])
                                   {
                                       holidaysNew.add(hc.Date__c);
                                   }
                                   
                                   
                                    Datetime  TodaycreatedDate= system.today();
                                    system.debug('>>>>>>>>'+TodaycreatedDate);
                                    
                                    integer x=0;
                                    datetime duedate;
                                    while(x<=5)
                                    {
                                        duedate=TodaycreatedDate.adddays(1);
                                        system.debug('>>>>>>format>'+duedate.format('E'));
                                        if(duedate.format('E')!= 'Sun' && duedate.format('E')!='Sat' && (!holidaysNew.contains(duedate)))
                                        {
                                            x++;
                                        }
                                        TodaycreatedDate=TodaycreatedDate.adddays(1);
                                    }
                                    system.debug('>>>>duedate>>>>'+duedate.adddays(-1));
                                
                              for(CombinedWrapper cbw : CombinedWrapperList)
                              {
                                  
                                  
                                    Job__c TJob=new Job__c();
                                    TJob.Media_Types__c=NameStoreMediatype.id;
                                    TJob.Schedule_Template__c=NameStoreScheduletype.id;
                                    TJob.Start_Date__c=system.today();
                                    TJob.Due_Date__c=date.valueof(duedate.adddays(-1));
                                    TJob.JobFormTypeValues__c='Trillium CNG';
                                    TJob.JS_Client__c=cbw.CombinedClientContact.Client__c;
                                    TJob.JS_Client_Contact__c=cbw.CombinedClientContact.id;
                                    TJob.Traffic_Notes__c= 'Store - '+cbw.CombinedClientContact.Client__r.Client_Code__c+'\n'+cbw.BillingInstru+'\n'+'SAP - '+ cbw.Sap +'\n'+ 'WBS - '+ cbw.Wbs;
                                    
                                    JobsTobeInsert.add(TJob);
                                   
                                    
                              }
                              insert JobsTobeInsert;
                              
                             set<string> jids = new set<string>();
                             for(Job__c j: JobsTobeInsert)
                             {
                                 jids.add(j.id);
                             }
                              
                             for(Job__c j: [select id, name, Media_Types__c, Schedule_Template__c, JobFormTypeValues__c, JS_Client__c, JS_Client_Contact__c from Job__c  where id in :jids ])
                             {
                                 ClientJobMap.put(j.JS_Client_Contact__c,j);
                             }
                             
                             for(CombinedWrapper cbw : CombinedWrapperList)
                             {
                             
                                   if(ClientJobMap.containskey(cbw.CombinedClientContact.id))
                                   {
                                   
                                        Shipment__c TJobShip=new Shipment__c();
                                        Client_Contact__c Clientcon = new Client_Contact__c();
        
                                        TJobShip.TO_ATTN__c=cbw.Attn;
                                        TJobShip.Shipment_Status__c='Pending';
                                      /*  TJobShip.Shipment_Street_Address__c=cbw.CombinedClientContact.Shipping_Address__c;
                                        TJobShip.Shipment_Address_2__c=cbw.CombinedClientContact.Shipping_Address_2__c;
                                        TJobShip.Shipment_City__c=cbw.CombinedClientContact.City__c;
                                        TJobShip.Shipment_State__c=cbw.CombinedClientContact.State__c;
                                        TJobShip.Shipment_Zip_code__c=cbw.CombinedClientContact.Zip__c;*/
                                        TJobShip.Job__c=ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                        TJobShip.Shipment_Name__c=ClientJobMap.get(cbw.CombinedClientContact.id).name;
                                        TJobShip.Shipment_Phone__c=cbw.Phone;
                                        
                                        if(cbw.editmode==true && cbw.Acceptance==true)
                                        {
                                            TJobShip.Shipment_Street_Address__c=cbw.Address;
                                            TJobShip.Shipment_Address_2__c=cbw.Address2;
                                            TJobShip.Shipment_City__c=cbw.City;
                                            TJobShip.Shipment_State__c=cbw.State;
                                            TJobShip.Shipment_Zip_code__c=cbw.Zipcode;
                                            
                                            Clientcon.id=cbw.CombinedClientContact.id;
                                            Clientcon.Client__c=cbw.CombinedClientContact.Client__c;
                                            Clientcon.Shipping_Address__c=cbw.Address;
                                            Clientcon.Shipping_Address_2__c=cbw.Address2;
                                            Clientcon.City__c=cbw.City;
                                            Clientcon.State__c=cbw.State;
                                            Clientcon.Zip__c=cbw.Zipcode;
                                            Cconlist.add(Clientcon);
                                            
                                        }
                                        else if(cbw.editmode==true)
                                        {
                                            TJobShip.Shipment_Street_Address__c=cbw.Address;
                                            TJobShip.Shipment_Address_2__c=cbw.Address2;
                                            TJobShip.Shipment_City__c=cbw.City;
                                            TJobShip.Shipment_State__c=cbw.State;
                                            TJobShip.Shipment_Zip_code__c=cbw.Zipcode;
                                        }
                                        
                                        else
                                        {
                                            TJobShip.Shipment_Street_Address__c=cbw.CombinedClientContact.Shipping_Address__c;
                                            TJobShip.Shipment_Address_2__c=cbw.CombinedClientContact.Shipping_Address_2__c;
                                            TJobShip.Shipment_City__c=cbw.CombinedClientContact.City__c;
                                            TJobShip.Shipment_State__c=cbw.CombinedClientContact.State__c;
                                            TJobShip.Shipment_Zip_code__c=cbw.CombinedClientContact.Zip__c;
                                        
                                        }
                                        
                                        
                                        ShipmentList.add(TJobShip);
                                        
                                         
                                        Job_Spec__c CorporateSpec1=new Job_Spec__c();
                                            CorporateSpec1.Name='Promo Phone';
                                            CorporateSpec1.Description__c=cbw.Phone;
                                            CorporateSpec1.Job__c=ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                         SpecsList.add(CorporateSpec1);
                                        
                                        
                                        
                                   
                                        for(CombinedWrapperItem cm:cbw.itemsList)
                                        {
                                          
                                                  Production_Estimate__c ProdEstimate =new Production_Estimate__c ();
                                                  Material_Item__c jm =cm.mItem;
                                                  
                                                  ProdEstimate.Job__c =ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                                  ProdEstimate.Material_Item__c =jm.id;
                                                  ProdEstimate.GL_Code__c=jm.GL_Code__c;
                                                  ProdEstimate.GL_Department__c=jm.GL_Department__c;
                                                  ProdEstimate.Name=jm.name;  
                                                  ProdEstimate.Calc_Unit__c=jm.Calc_Unit__c;
                                                  
                                                  if(cm.enteredQty>0)
                                                  {
                                                      ProdEstimate.Quantity__c= cm.enteredQty; //cbw.MapQuan.get(cm);
                                                  }
                                                  else
                                                  {
                                                     ProdEstimate.Quantity__c=1;
                                                  }
                                                  
                                               //   ProdEstimate.Quantity__c= cm.enteredQty;//cbw.MapQuan.get(cm);
                                                  ProdEstimate.Qty_Up__c=1;
                                                  
                                                   if(jm.Calc_Unit__c=='Each')        
                                                  {     
                                                      ProdEstimate.EachQtyUpforUsed__c=(cm.enteredQty/1);       
                                                  }     
                                                  else if(jm.Calc_Unit__c=='Sheet')       
                                                  {     
                                                      ProdEstimate.SheetQtyUpforUsed__c=(cm.enteredQty/1);      
                                                  }
                                                  
                                                  
                                                 If(ProdEstimate.Quantity__c !=0)
                                                 ProdEstimateList.add(ProdEstimate);
                                                 
                                                 if(MatSpecItemMap.get(cm.mItem.Creative_Brief_Template__c) != null)
                                                 {
                                                     for(Spec_Item__c spitem : MatSpecItemMap.get(cm.mItem.Creative_Brief_Template__c))
                                                     {
                                                         Job_Spec__c jspec = new Job_Spec__c();
                                                         jspec.Name = spitem.Name;
                                                         jspec.Creative_Brief_Template__c = cm.mItem.Creative_Brief_Template__r.name  + ' -- ' + cm.mItem.name;
                                                         jspec.Description__c = spitem.Description__c;
                                                         jspec.Job__c = ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                                         jspec.Lock__c = spitem.Lock__c;
                                                         jspec.Sort_Order__c = spitem.Sort_Order__c;
                                                         jspec.Value__c = spitem.Value__c;
                                                         
                                                         SpecsList.add(jspec);
                                                     }
                                                 }
                                                 
                                                 if(MatSpecItemMap1.get(cm.mItem.Production_Estimate_Template__c) != null)
                                                 {
                                                     for(Production_Estimate_Temp_Line_Items__c spitem : MatSpecItemMap1.get(cm.mItem.Production_Estimate_Template__c))
                                                     {
                                                         Production_Estimate__c jpe= new Production_Estimate__c();
                                                         jpe.Name = spitem.Name;
                                                         jpe.PE_Template__c =  cm.mItem.Production_Estimate_Template__r.name + ' -- ' +cm.mItem.name;
                                                         jpe.Qty_Up__c= spitem.Qty_Up__c;
                                                         jpe.Job__c = ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                                         jpe.Material_Item__c = spitem.Material_Item__c;
                                                         jpe.Calc_Unit__c= spitem.Calc_Unit__c;
                                                         jpe.Quantity__c = spitem.Quantity__c;
                                                         
                                                         
                                                           
                                                          jpe.Color__c= spitem.Color__c;
                                                          jpe.Sided__c= spitem.Sided__c;
                                                          jpe.of_Pages__c= spitem.of_Pages__c;
                                                          jpe.Width_in_Inches__c= spitem.Width_in_Inches__c;
                                                          jpe.Divide_Sheets_By_Two__c= spitem.Divide_Sheets_By_Two__c;
                                                          jpe.Equipment_Type__c= spitem.Equipment_Type__c;
                                                          jpe.Length_in_Inches__c= spitem.Length_in_Inches__c;
                                                          jpe.Commission__c = spitem.Commission__c ;
                                                          jpe.SheetQtyUpforUsed__c = spitem.SheetQtyUpforUsed__c;
                                                          jpe.EachQtyUpforUsed__c = spitem.EachQtyUpforUsed__c;
                                                          jpe.Sort_Order__c=spitem.Sort_Order__c;
                                                          jpe.GL_Code__c=spitem.GL_Code__c;      
                                                          jpe.GL_Department__c=spitem.GL_Department__c;       
                                                          jpe.Vendor__c=spitem.Vendor__c;
                                                         
                                                         
                                                         ProdEstimateList.add(jpe);
                                                     }
                                                 }
                                                 
                                                   
                                        }
                                   }
                              }  
                             
                              insert ProdEstimateList;
                                insert ShipmentList;
                                insert SpecsList;
                                if(Cconlist.size()>0){
                                update Cconlist;}
                            
                            
                             if(isTab)
                            {
                                 PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                                pageRef.setRedirect(true);
                                return pageRef;
                            }
                                      
                        
                          PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');
                          pageRef.setRedirect(true);
                          return pageRef;
            
                  } 
            }  
            
            
            catch(Exception e)
            {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
                   return null;
            }
      
        return null;
     
           
        }
    
    
    
    
    
    
    
    
    
    
    // Client Contact Wrapper Class
    public class ClientContactsWrapper
    {
        public Client_Contact__c ClientConWrap{get;set;}
        public Boolean Contactselect{get;set;}
        Public ClientContactsWrapper()
        {
            ClientConWrap=new Client_Contact__c();
            Contactselect=false;
        }
    }
    
    // End of Client Contact Wrapper Class
         
         
    // Material Item Wrapper Class
    public class MaterialItemWrapper
    {
         public Material_Item__c MIWrap{get;set;}
         public Boolean MISelect{get;set;}
         public String  ContentVersionId {get;set;}
         public MaterialItemWrapper()
         {
             MIWrap= new Material_Item__c();
             MISelect = false;
         }
    }   
     // End of Material Item Wrapper Class
     
     
     
        public class CombinedWrapperItem
        {
            public Material_Item__c mItem{set;get;}
            public Integer enteredQty{Set;Get;}
            public boolean showQtyErrorMsg{Set;Get;}
            public string ErrMsg{Set;Get;}
            
            CombinedWrapperItem(Material_Item__c mItem)
            {
                this.mItem = mItem;
                enteredQty=1;
                showQtyErrorMsg=false;
            }
            public void checkQty()
            {
                ErrMsg='';
                showQtyErrorMsg=false;
                if(mItem.Max_Qty__c!=null && enteredQty!=null)
                {
                    if(mItem.Max_Qty__c < enteredQty)
                    {
                        showQtyErrorMsg=true;
                        ErrMsg = 'The Quantity must be less than Max Quantity of Material Item';
                        return;
                    }
                }
            }
            
        }
     
     
     
     
      public class CombinedWrapper
      {
         public Client_Contact__c CombinedClientContact{get;set;} 
         public map<string,Integer> MapQuan{get;set;}
         public list<CombinedWrapperItem> itemsList{Set;Get;}
         public String Attn{get;set;}
         public String Sap{get;set;}
         public String Wbs{get;set;}
         public String Address{get;set;}
         public String Address2{get;set;}
         public String City{get;set;}
         public String State{get;set;}
         public string Zipcode{get;set;}
         public string Phone{get;set;}
         public string BillingInstru{get;set;}
         public boolean editmode{get;set;}
         public boolean Acceptance{get;set;}
        
         public CombinedWrapper()
         {
             MapQuan= new map<string,Integer>();
             itemsList=new list<CombinedWrapperItem>();
             CombinedClientContact = new Client_Contact__c();
             Attn = '';
             Sap = '';
             Wbs = '';
             Address = '';
             Address2 = '';
             City = '';
             State = '';
             Zipcode = '';
             Phone = '';
             BillingInstru = '';
             editmode=false;
             Acceptance=false;
         }
         
            public void Editaddress()
            {
                 system.debug('>>>>>>>>>>>>>>>>Edit Method');
                 this.editmode = true;
            }
     }
     
     
     
       Public Pagereference Back()
        {
              PageReference pageRef = new PageReference('/apex/StorefrontJobRequestForm');
              pageRef.setRedirect(true);
              return pageRef;
        }
        
        
        Public void ConListBack()
        {
            ShowClientContacts=True;
            ShowMaterialItems=false;
        
        }
        
        Public void MIListBack()
        {
            ShowClientContacts=false;
            ShowMaterialItems=True;
            ShowCombinedData=false;
        
        }
    
    
    
}