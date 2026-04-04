public class FleetSalesOrderCmpCtrl {
    // Client_Contact List
    @AuraEnabled
    public static  List<ClientContactWrapper>  getClientContacts(){         
        List<Client_Contact__c> ClientContactList = new List<Client_Contact__c> ();
        List<ClientContactWrapper> CCWrapperList = new List<ClientContactWrapper>();
        ClientContactList=[select id,name,Client__c from Client_Contact__c where Client__r.name=:'Fleet Sales' order by name];
        for(Client_Contact__c CC:ClientContactList)
        {
            ClientContactWrapper c = new ClientContactWrapper();
            c.varClientCon = CC;
            c.varCSelect = false;
            CCWrapperList.add(c);
        }
        return CCWrapperList;
    }
    // Material Item List
    @AuraEnabled
    public static  List<MaterialItemWrapper>  getMaterialItemList(){   
        List<Material_Item__c> MaterialItemList = new List<Material_Item__c>();
        List<MaterialItemWrapper> MIWrapperList = new List<MaterialItemWrapper>();
        Set<Id> contentDocumentIdSet =new Set<Id>();
        Map<Id,String> contentDocMap=new Map<Id,String>();
        MaterialItemList=[select id,name,File_Photo__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Type__c,Description__c,Max_Qty__c,Calc_Unit__c,GL_Code__c,Category__c,GL_Department__c,Creative_Brief_Template__c,Creative_Brief_Template__r.name,Production_Estimate_Template__c,Production_Estimate_Template__r.name from Material_Item__c where Category__c=:'Fleet Sales' order by name]; 
        
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
            M.varMI = MI;
            M.varMISelect  = False;
            M.ContentVersionId='';
            for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                    M.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                    break;
                }
            } 
            MIWrapperList.add(M);
        }
        return MIWrapperList;
    } 
    
    @AuraEnabled
    public static List<MaterialItemWrapper> showItems(string MaterialItemNameString){
        string MIname='%'+MaterialItemNameString+'%';
        List<Material_Item__c> MaterialItemList = new List<Material_Item__c>();
        List<MaterialItemWrapper> MIWrapperList = new List<MaterialItemWrapper>();
        Set<Id> contentDocumentIdSet =new Set<Id>();
        Map<Id,String> contentDocMap=new Map<Id,String>();
        
        if(MIname!=null)
        {
            MaterialItemList=[select id,name,File_Photo__c,Type__c,Description__c,Max_Qty__c,Calc_Unit__c,GL_Code__c,Category__c,GL_Department__c,Creative_Brief_Template__c,Creative_Brief_Template__r.name,Production_Estimate_Template__c,Production_Estimate_Template__r.name from Material_Item__c where  (Name like: MIname OR Description__c like: MIname) AND Category__c=:'Fleet Sales' ORDER BY Name ASC];
        }
        
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
            M.varMI = MI;
            M.varMISelect  = False;
             M.ContentVersionId='';
            for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                    M.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                    break;
                }
            }
            MIWrapperList.add(M);           
        }
        return MIWrapperList;
    }
    @AuraEnabled
    public static list<CombinedWrapper> getCombinedList(List<Client_Contact__c> clientContactSelectList, List<MaterialItemWrapper> MIWrapperList){
        List<Material_Item__c> MIListVal = new list<Material_Item__c>();
        List<CombinedWrapper>  CombinedWrapperList = new List<CombinedWrapper>();
        for(Client_Contact__c  CC: clientContactSelectList)
        {
            list<CombinedWrapperItem> test=new list<CombinedWrapperItem>();
            CombinedWrapper CombineWrapper = new CombinedWrapper();
            CombineWrapper.CombinedClientContact = CC;
            for(MaterialItemWrapper mi:MIWrapperList){
                test.add(new CombinedWrapperItem(mi.varMI,1));
            }
            CombineWrapper.itemsList=test;
            CombinedWrapperList.add(CombineWrapper);
        }
        return CombinedWrapperList;
    }
    
    // Save Method
    @AuraEnabled
    public static string OrderMethod(List<CombinedWrapper>  CombinedWrapperList,List<Material_Item__c> MIWrapperList)
    {
        
        List<Job__c> JobsTobeInsert=new List<Job__c>();
        Map<String,Job__c > ClientJobMap= new  Map<String,Job__c > ();
        list<Production_Estimate__c> ProdEstimateList = new List<Production_Estimate__c>();
        list<Job_Spec__c> SpecsList = new List<Job_Spec__c>();
        list<Shipment__c> ShipmentList = new list<Shipment__c>();
        
        system.debug('-CombinedWrapperList---'+CombinedWrapperList);
        system.debug('-MIWrapperList---'+MIWrapperList);
        
        if(!CombinedWrapperList.isEmpty())
        {
            for(CombinedWrapper cbw : CombinedWrapperList)
            {
                for(CombinedWrapperItem cm:cbw.itemsList)
                {   
                    system.debug('-------cm.mItem.Max_Qty__c---'+cm.mItem.Max_Qty__c);
                    system.debug('-------cm.enteredQty---'+cm.enteredQty);
                    system.debug('cbw.BillingInstru------'+cbw.BillingInstru);
                    if(cm.mItem.Max_Qty__c < cm.enteredQty)
                    {
                        return 'QuantittError';
                    }
                }
                 if(string.isBlank(cbw.Email) && (string.isBlank(cbw.BillingInstru) || cbw.BillingInstru=='None'))
                {
                    return 'Email and BillingInstructions';
                }
                if(string.isBlank(cbw.BillingInstru) || cbw.BillingInstru=='None')
                {
                    return 'BillingInstructions';
                }
                 if(string.isBlank(cbw.Email) )
                {
                    return 'Email';
                }
            }
        }
        
        try
        {  
            
            if(!CombinedWrapperList.isEmpty())
            {
                
                
                set<string> creativeBIds = new set<string>();
                set<string> creativeBIds1 = new set<string>();
                for(Material_Item__c mi:MIWrapperList){
                    if(Test.isRunningTest()){
                         creativeBIds.add(mi.Creative_Brief_Template__c);
                    creativeBIds1.add(mi.Production_Estimate_Template__c);
                    } 
                    else{
                    creativeBIds.add(mi.Creative_Brief_Template__r.id);
                    creativeBIds1.add(mi.Production_Estimate_Template__r.id);
                    }
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
                
                List<Production_Estimate_Temp_Line_Items__c> specs1 = [select id,Name,Vendor__c,GL_Department__c,GL_Code__c,Production_Estimate_Template__c,Quantity__c,Calc_Unit__c,Material_Item__c,Qty_Up__c,Color__c,Sided__c,of_Pages__c,Width_in_Inches__c,Divide_Sheets_By_Two__c,Equipment_Type__c,Length_in_Inches__c,Commission__c,SheetQtyUpforUsed__c,EachQtyUpforUsed__c,Sort_Order__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c in :creativeBIds1];
                
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
                
                
                Set<Datetime> holidaysNew= new Set<Datetime>();
                
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
                Media_Type__c NameStoreMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
                Schedule_Template__c NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Sales/Marketing' AND Media_Types__r.name='Print' limit 1];
                for(CombinedWrapper cbw : CombinedWrapperList)
                {
                    
                    Job__c FleetJob=new Job__c();
                    FleetJob.Media_Types__c=NameStoreMediatype.id;
                    FleetJob.Schedule_Template__c=NameStoreScheduletype.id;
                    FleetJob.Start_Date__c=system.today();
                    FleetJob.Due_Date__c=date.valueof(duedate.adddays(-1));
                    FleetJob.JobFormTypeValues__c='Fleet Sales';
                    FleetJob.JS_Client__c=cbw.CombinedClientContact.Client__c;
                    FleetJob.JS_Client_Contact__c=cbw.CombinedClientContact.id;
                    FleetJob.Traffic_Notes__c= cbw.BillingInstru;
                    JobsTobeInsert.add(FleetJob);
                    
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
                        Shipment__c FleetShip=new Shipment__c();
                        
                        FleetShip.TO_ATTN__c=cbw.Attn;
                        FleetShip.Shipment_Email__c=cbw.Email;
                        FleetShip.Shipment_Phone__c=cbw.Phone;
                        FleetShip.Shipment_Status__c='Pending';
                        FleetShip.Shipment_Street_Address__c=cbw.Address;
                        FleetShip.Shipment_Address_2__c=cbw.Address2;
                        FleetShip.Shipment_City__c=cbw.City;
                        FleetShip.Shipment_State__c=cbw.State;
                        FleetShip.Shipment_Zip_code__c=cbw.Zipcode;
                        FleetShip.Job__c=ClientJobMap.get(cbw.CombinedClientContact.id).id;
                        FleetShip.Shipment_Name__c=ClientJobMap.get(cbw.CombinedClientContact.id).name;
                        
                        ShipmentList.add(FleetShip);
                        
                        Job_Spec__c CorporateSpec1=new Job_Spec__c();
                        CorporateSpec1.Name='Promo Phone';
                        CorporateSpec1.Description__c=cbw.Phone;
                        CorporateSpec1.Job__c=ClientJobMap.get(cbw.CombinedClientContact.id).id;
                        SpecsList.add(CorporateSpec1);
                        
                        
                        
                        for(CombinedWrapperItem cm:cbw.itemsList)
                        {
                            
                            Production_Estimate__c ProdEstimate =new Production_Estimate__c ();
                            Material_Item__c jm = cm.mItem; //MapMaterialItem.get(cm);
                            
                            ProdEstimate.Job__c =ClientJobMap.get(cbw.CombinedClientContact.id).id;
                            ProdEstimate.Material_Item__c =jm.id;
                            ProdEstimate.GL_Code__c=jm.GL_Code__c;
                            ProdEstimate.GL_Department__c=jm.GL_Department__c;
                            ProdEstimate.Name=jm.name;
                            ProdEstimate.FromStoreFront__c=true;
                            ProdEstimate.Calc_Unit__c=jm.Calc_Unit__c;
                            if(cm.enteredQty>0)
                            {
                                ProdEstimate.Quantity__c= cm.enteredQty; //cbw.MapQuan.get(cm);
                            }
                            else{
                                ProdEstimate.Quantity__c=1;
                            }
                            ProdEstimate.Qty_Up__c=1;
                            
                            if(jm.Calc_Unit__c=='Each')
                            {
                                ProdEstimate.EachQtyUpforUsed__c=(cm.enteredQty/1);
                            }
                            else if(jm.Calc_Unit__c=='Sheet')
                            {
                                ProdEstimate.SheetQtyUpforUsed__c= (cm.enteredQty/1);
                            }
                            
                            If(ProdEstimate.Quantity__c !=0)
                                ProdEstimateList.add(ProdEstimate);
                             string cbTemmpId;
                            if(Test.isRunningTest()){
                                  cbTemmpId=cm.mItem.Creative_Brief_Template__c;
                            } 
                            else{
                                 cbTemmpId=cm.mItem.Creative_Brief_Template__r.id;
                            }
                           
                            if(MatSpecItemMap.get(cbTemmpId) != null)
                            {
                                for(Spec_Item__c spitem : MatSpecItemMap.get(cbTemmpId))
                                {
                                    Job_Spec__c jspec = new Job_Spec__c();
                                    jspec.Name = spitem.Name;
                                    jspec.Creative_Brief_Template__c =cm.mItem.Creative_Brief_Template__r.name  + ' -- ' +cm.mItem.name;
                                    jspec.Description__c = spitem.Description__c;
                                    jspec.Job__c = ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                    jspec.Lock__c = spitem.Lock__c;
                                    jspec.Sort_Order__c = spitem.Sort_Order__c;
                                    jspec.Value__c = spitem.Value__c;
                                    
                                    SpecsList.add(jspec);
                                }
                            }
                              string pdTemmpId;
                            if(Test.isRunningTest()){
                                  pdTemmpId=cm.mItem.Production_Estimate_Template__c;
                            } 
                            else{
                                 pdTemmpId=cm.mItem.Production_Estimate_Template__r.id;
                            }
                            if(MatSpecItemMap1.get(pdTemmpId) != null)
                            {
                                for(Production_Estimate_Temp_Line_Items__c spitem : MatSpecItemMap1.get(pdTemmpId))
                                {
                                    Production_Estimate__c jpe = new Production_Estimate__c();
                                    jpe.Name = spitem.Name;
                                    jpe.PE_Template__c =  cm.mItem.Production_Estimate_Template__r.name + ' -- ' + cm.mItem.name;
                                    jpe.Qty_Up__c= spitem.Qty_Up__c;
                                    jpe.Job__c = ClientJobMap.get(cbw.CombinedClientContact.id).id;
                                    jpe.Material_Item__c = spitem.Material_Item__c;
                                    jpe.Calc_Unit__c= spitem.Calc_Unit__c;
                                    jpe.Quantity__c = spitem.Quantity__c*cm.enteredQty;
                                    
                                    // jspec.Quantity__c =cbw.MapQuan.get(cm);
                                    
                                    jpe.Color__c= spitem.Color__c;
                                    jpe.Sided__c= spitem.Sided__c;
                                    jpe.of_Pages__c= spitem.of_Pages__c;
                                    jpe.Width_in_Inches__c= spitem.Width_in_Inches__c;
                                    jpe.Divide_Sheets_By_Two__c= spitem.Divide_Sheets_By_Two__c;
                                    jpe.Equipment_Type__c= spitem.Equipment_Type__c;
                                    jpe.Length_in_Inches__c= spitem.Length_in_Inches__c;
                                    jpe.Commission__c = spitem.Commission__c ;
                                    
                                    if(jpe.Calc_Unit__c=='Sheet' && jpe.Sided__c=='Double' && jpe.Qty_Up__c !=null && jpe.Divide_Sheets_By_Two__c==true){
                                        jpe.SheetQtyUpforUsed__c=((spitem.Quantity__c*cm.enteredQty)/spitem.Qty_Up__c)/2;
                                    }
                                    else if (jpe.Calc_Unit__c=='Sheet' && jpe.Sided__c=='Double' && jpe.Qty_Up__c !=null && jpe.Divide_Sheets_By_Two__c==false){
                                        jpe.SheetQtyUpforUsed__c=((spitem.Quantity__c*cm.enteredQty)/spitem.Qty_Up__c);
                                    }
                                    else if(jpe.Calc_Unit__c=='Sheet' && jpe.Sided__c=='Single' && jpe.Qty_Up__c !=null){
                                       jpe.SheetQtyUpforUsed__c=((spitem.Quantity__c*cm.enteredQty)/spitem.Qty_Up__c);
                                    }
                                    else if(jpe.Calc_Unit__c=='Each' && jpe.Qty_Up__c !=null){
                                        jpe.EachQtyUpforUsed__c=((spitem.Quantity__c*cm.enteredQty)/spitem.Qty_Up__c);
                                    } 
                                    
                                    //jpe.SheetQtyUpforUsed__c = spitem.SheetQtyUpforUsed__c;
                                   // jpe.EachQtyUpforUsed__c = spitem.EachQtyUpforUsed__c;
                                    jpe.Sort_Order__c=spitem.Sort_Order__c;
                                    
                                    jpe.GL_Code__c=spitem.GL_Code__c;
                                    jpe.GL_Department__c=spitem.GL_Department__c;
                                    jpe.Vendor__c=spitem.Vendor__c;
                                    
                                    ProdEstimateList.add(jpe);
                                }
                            }
                            system.debug('----speclist---after--'+SpecsList);
                            system.debug('----ProdEstimateList---after--'+ProdEstimateList);
                        } 
                    }  
                    
                }
                insert ProdEstimateList;
                insert ShipmentList;
                insert SpecsList;
            }
            return 'Success';
        }  
        catch(Exception e)
        {
            system.debug('>>>>>Exception>>>>>>>'+e.getMessage()+e.getStackTraceString());
            return 'Please wait for a few seconds and then click on "Order" Button';
        }
    }
    
    // Client Contact Wrapper Class
    public class ClientContactWrapper
    {
        @AuraEnabled  public Client_Contact__c varClientCon{get;set;}
        @AuraEnabled  public Boolean varCSelect{get;set;}
        public ClientContactWrapper()
        {
            varClientCon= new Client_Contact__c();
            varCSelect= false;
        }
    }
    
    // Material Item Wrapper Class
    public class MaterialItemWrapper
    {
        @AuraEnabled   public Material_Item__c varMI{get;set;}
        @AuraEnabled  public Boolean varMISelect{get;set;}
        @AuraEnabled   public String  ContentVersionId {get;set;}
        public MaterialItemWrapper()
        {
            varMI = new Material_Item__c();
            varMISelect = false;
        }
    }   
    // End of Material Item Wrapper Class
    
    public class CombinedWrapper
    {
        @AuraEnabled  public Client_Contact__c CombinedClientContact{set;get;}    
        @AuraEnabled  public list<CombinedWrapperItem> itemsList{set;get;}  
        @AuraEnabled  public String Attn{set;get;}
        @AuraEnabled  public String Email{set;get;}
        @AuraEnabled  public String Address{set;get;}
        @AuraEnabled  public String Address2{set;get;}
        @AuraEnabled  public String City{set;get;}
        @AuraEnabled  public String State{set;get;}
        @AuraEnabled  public string Zipcode{set;get;}
        @AuraEnabled  public string Phone{set;get;}
        @AuraEnabled  public string BillingInstru{set;get;}
        @AuraEnabled  public List<string>  BillingInstruList{set;get;} 
        
        public CombinedWrapper()
        {
            BillingInstruList=new list<string>{'None','Factoring','Tire Services','Fleet Sales'};
                itemsList=new list<CombinedWrapperItem>();
            CombinedClientContact = new Client_Contact__c();
            Attn = '';
            Email= '';
            Address = '';
            Address2 = '';
            City = '';
            State = '';
            Zipcode = '';
            Phone = '';
            BillingInstru = '';
            
        }         
    }
    
    
    public class CombinedWrapperItem
    {
        @AuraEnabled   public Material_Item__c mItem{set;get;}
        @AuraEnabled   public Integer enteredQty{Set;Get;}
        @AuraEnabled   public boolean showQtyErrorMsg{Set;Get;}
        @AuraEnabled   public string ErrMsg{Set;Get;}
        
        public  CombinedWrapperItem(Material_Item__c mItem,Integer enteredQty)
        {
            this.mItem = mItem;
            this.enteredQty=enteredQty;
            showQtyErrorMsg=false;
        }
        public  CombinedWrapperItem(){
            
        }
    } 
}