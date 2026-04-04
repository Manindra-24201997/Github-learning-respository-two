/*
Purpose: This Class Used for Multi Store Order Process
Created By: SM (Jobsuite)


*/

public with sharing class MultiStoreOrderPageController {
    
    public boolean isTab{private set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4t' || theme=='Theme4d')?true:false;
    }
                        }
    
    /*  public boolean isMobile{ set; get{
String theme = UserInfo.getUITheme();
return (theme=='Theme4t')?true:false;
}
}*/
    
    // Variables Declaration
    
    public List<string> MediaIdList {get; set;}
    public list<ClientWrapper> CWrap{get; set;}
    public list<CombinedWrapper> CombineWrap{get; set;}
    public list<MultiMIWrapperList> Test{get; set;}
    public String toUnselect {get; set;}
    Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;} 
    public Map<Id,MIWrapper> rolewraps{get;set;}
    public Map<Id,MIWrapper> rolewraps2{get;set;}
    Public Transient List<Material_Item__c> MaterialItems{get;set;}
    Public boolean ShowStoreSupplies{get;set;}
    Public boolean ShowAddcartSection{get;set;}
    Public boolean ShowCartBackbutton{get;set;}
    Public boolean ShowStoreList{get;set;}
    Public boolean FirstWrapper{get;set;}
    public Boolean SecondWrapper{get;set;}
    public Boolean CombinedList{get;set;}
    public Boolean CombinedWrapperBackbutton{get;set;}
    public Boolean Order{get;set;}
    public Boolean NextButtonItemLayout{get;set;}
    Public String clientname;
    Public Set<string> Storegrps=new Set<string>(); 
    Public Media_Type__c NameStoreMediatype{get;set;}
    Public Schedule_Template__c NameStoreScheduletype{get;set;} 
    Public List<Client__c> clientselect = new List<Client__c>(); 
    
    //StoreSupplyOrdersSection
    public string MaterialTypeString {get; set;} 
    Public String MaterialItemNameString {get;set;}
    Public String MaterialItemDescString {get;set;}
    
    // Variables Declaration  
    
    
    //To get Mtarial Type values of Material Item Object
    
    public List<SelectOption> getMaterialType(){
        List<SelectOption> MaterialType= new List<selectOption>();
        MaterialType.add(new SelectOption('','-  Please Select  -'));
        MaterialType.add(new SelectOption('','All Categories'));
        
        for(schema.picklistEntry p : Material_Item__c.Type__c.getDescribe().getPicklistValues()){
            MaterialType.add(new SelectOption(p.getLabel(),p.getLabel()));
            
        }
        
        return MaterialType;
    } 
    
    
    
    
    // CONSTRUCTOR
    public MultiStoreOrderPageController(){
        
        MaterialItems=new List<Material_Item__c> ();
        roleWraps=new Map<Id,MIWrapper>();
        rolewraps2 = new Map<Id,MIWrapper>();
        
        
        CWrap= new list<ClientWrapper>();
        CombineWrap=new list<CombinedWrapper>();
        Test=new list<MultiMIWrapperList>();
        
        FirstWrapper=False;
        SecondWrapper=False;
        CombinedList=false;
        ShowStoreSupplies=False;
        ShowAddcartSection=false;
        ShowCartBackbutton=false;
        ShowStoreList=True;
        Order=FALSE;
        CombinedWrapperBackbutton=False;
        NextButtonItemLayout=False;
        
        
        NameStoreMediatype=[Select id ,name from Media_Type__c where name='Supplies' limit 1];
        
        NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Order' AND Media_Types__r.name='Supplies' limit 1];
        
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        clientcontact=[Select id,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        
        clientname=clientcontact.Client__r.Name;
        
        string fruit = clientcontact.Client__r.Client_Group__c;
        string[] split = fruit.Split(';');
        for(string item :split)
        {
            Storegrps.add(item);
        }
        
        /*  for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where id=:clientcontact.Client__c order by Client_Code__c]){
ClientWrapper varClientWrap = new ClientWrapper();
varClientWrap.varClient= loopClient;
varClientWrap.varCSelect= false;
CWrap.add(varClientWrap);
}*/
        
        
        if(clientname.contains('District')){
            
            for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where name like '%Store%' AND (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient= loopClient;    varClientWrap.varCSelect= false;    CWrap.add(varClientWrap);
            }
            
        }
        
        if(clientname.contains('Division')){
            
            for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where name like '%Store%' AND  (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient= loopClient;  varClientWrap.varCSelect= false;     CWrap.add(varClientWrap);
            }
            
        }
        
        
        if(clientname.contains('Corporate')){
            
            for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where name like '%Store%' AND  (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient= loopClient;  varClientWrap.varCSelect= false;     CWrap.add(varClientWrap);
            }
            
        }
        
    }
    
    // CONSTRUCTOR
    
    
    // Start Wrapper Class : This class will bind checkbox and its associated Client on layout
    public class ClientWrapper{
        
        
        public Client__c varClient{get;set;}
        public Boolean varCSelect{get;set;}
        public ClientWrapper(){
            varClient= new Client__c();      varCSelect= false;
        }
    }   
    // End of Wrapper Class
    
    
    
    // Start Wrapper Class will hold child wrapper MultiMIWrapperList
    public class CombinedWrapper{
        
        public Client__c varCombineClient{get;set;}    
        
        public List<MultiMIWrapperList> MultiitemMap2{get;set;}
        
        public CombinedWrapper(Client__c  varCombineClient, List<MultiMIWrapperList> MultiitemMap2){
            
            this.varCombineClient= varCombineClient;
            this.MultiitemMap2= MultiitemMap2;
        }
        
    }   
    // End of Wrapper Class 
    
    // Start Wrapper Class
    
    public class MultiMIWrapperList
    {
        public Material_Item__c MI{get;set;}
        public integer quantity{get;set;}
        public boolean showQtyErrorMsg{Set;Get;}
        public string ErrMsg{Set;Get;}
        
        public  MultiMIWrapperList(Material_Item__c MI, Integer quantity)
        {
            this.MI= MI;
            this.quantity=quantity;
            showQtyErrorMsg=false;
        }   
        
        
        
        public void checkQty()
        {
            ErrMsg='';
            showQtyErrorMsg=false;
            if(MI.Max_Qty__c!=null && quantity!=null)
            {
                if(MI.Max_Qty__c < quantity)
                {
                    showQtyErrorMsg=true;        ErrMsg = 'The Quantity must be less than Max Quantity of Material Item';     return;
                }
            }
        }
        
        
        
        
        
    }
    // End of Wrapper Class
    
    // To Navigate from Store List to Item List
    
    Public Pagereference ClientList(){
        
        System.debug('Clientwrapper'+CWrap.size());
        clientselect = new List<Client__c>(); 
        for(ClientWrapper wrap : CWrap){  
            /*Check if record is selected*/  
            if(wrap.varCSelect){  
                clientselect.add(wrap.varClient);  
            }  
        }   
        
        if(clientselect.size()>0){
            
            ShowStoreSupplies=True;    ShowStoreList=False;    return null;
        }
        
        else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select atleast one store'));
            return null;
        }
        
        
        
    }
    
    
    // To  combine store with Material Items
    
    Public Pagereference Combineddatalist(){
        
        ShowAddcartSection=False;
        ShowCartBackbutton=false;
        NextButtonItemLayout=False;
        CombinedList=true;
        CombinedWrapperBackbutton=True;
        Order=TRUE;
        
        List<Material_Item__c > newlist=new List<Material_Item__c >();
        
        for(Client__c cc:clientselect){
            
            //  CombineWrap.add(new CombinedWrapper(cc, newlist));
            List<MultiMIWrapperList> test=new List<MultiMIWrapperList>();
            
            
            for(Material_Item__c  Mi:[select id,name,Calc_Unit__c,Store_Front__c,Max_Qty__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c  where id in:rolewraps2.keyset()])
            {
                
                Test.add(new MultiMIWrapperList(Mi,1));  
                
            }
            
            CombineWrap.add(new CombinedWrapper(cc,Test));  
        }  
        
        return null;
        
        
        
        
    }
    
    // To  combine store with Material Items
    
    
    
    // final save method to create Multiple jobs
    
    Public Pagereference CreateJobswithchild()
    {
        
        list<Production_Estimate__c> ProdEstimateList =new List<Production_Estimate__c>();
        List<Job__c> JobsTobeInsert=new List<Job__c>();
        Map<String,String> ClientJobMap= new  Map<String,String> ();
        
        
        for(CombinedWrapper cbw:CombineWrap)
        {
            
            for(MultiMIWrapperList item:cbw.MultiitemMap2)
            {
                if(string.valueof(Item.Quantity).length()>2)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum order quantity is XX. Adjust your quantity to the specified amount.'));                       return null;
                }
                
                if(Item.Quantity > Item.Mi.Max_Qty__c)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Quantity must be less than Max Quantity of related Material Item'));                       return null;
                }
                
            }
            
        }
        
        
        try
        {
            
            if(!CombineWrap.isEmpty()){
                
                for(CombinedWrapper cbw : CombineWrap){
                    
                    Job__c StoreJob=new Job__c();
                    StoreJob.Media_Types__c=NameStoreMediatype.id;
                    StoreJob.Schedule_Template__c=NameStoreScheduletype.id;
                    StoreJob.JobFormTypeValues__c='Store Supply Orders';
                    StoreJob.JS_Client__c=cbw.varCombineClient.id;
                    
                    
                    JobsTobeInsert.add(StoreJob);
                    
                }
                
                insert JobsTobeInsert;
                
                for(Job__c j: JobsTobeInsert){
                    
                    System.debug('Job id'+j.id);
                    
                    ClientJobMap.put(j.JS_Client__c,j.id);
                    
                    
                }
                
                for(CombinedWrapper cbw:CombineWrap){
                    
                    if(ClientJobMap.containskey(cbw.varCombineClient.id)){
                        
                        
                        for(MultiMIWrapperList item:cbw.MultiitemMap2) {
                            string prodname='PE';
                            
                            
                            Production_Estimate__c ProdEstimate =new Production_Estimate__c ();
                            
                            ProdEstimate.Job__c =ClientJobMap.get(cbw.varCombineClient.id);
                            ProdEstimate.Material_Item__c =Item.Mi.id;
                            ProdEstimate.Name=prodname + '-' + Item.mi.name;  //+ StoreJobname; //+ ' - '
                            ProdEstimate.Calc_Unit__c=Item.Mi.Calc_Unit__c;
                            
                            if(item.quantity>0)
                            {
                                ProdEstimate.Quantity__c= item.quantity; //cbw.MapQuan.get(cm);
                            }
                            else
                            {
                                ProdEstimate.Quantity__c=1;
                            }
                            
                            
                            //  ProdEstimate.Quantity__c= item.quantity;
                            
                            ProdEstimate.Qty_Up__c=1;
                            
                            if(Item.Mi.Calc_Unit__c=='Each')
                            {
                                ProdEstimate.EachQtyUpforUsed__c=(item.quantity/1);
                            }
                            else if(Item.Mi.Calc_Unit__c=='Sheet')
                            {
                                ProdEstimate.SheetQtyUpforUsed__c=(item.quantity/1);
                            }
                            
                            
                            
                            If(ProdEstimate.Quantity__c !=0)ProdEstimateList.add(ProdEstimate);
                            
                            
                        }
                        
                    }
                    
                }  
                insert ProdEstimateList;
                
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning'); pageRef.setRedirect(true);  return pageRef;
                }
                
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
                
            }   
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button')); return null;
            
        }
        
        return null;
        
    }
    
    
    // final save method to create Multiple jobs  
    
    
    
    Public void ShowItems(){
        
        roleWraps.clear();
        
        MediaIdList = new List<string>();
        Map<string,string> MediaNameToRefIdMap= new Map<string,string>();
        List<string> MediaNameList= new List<string>();
        
        string MIname='%'+MaterialItemNameString+'%';
        //    string MIDesc='%'+MaterialItemDescString+'%';
        
        //    if(MIdesc==null)
        //    {
        
        if(MIname!=null && MaterialTypeString!=null)
        {
            
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where  (Name like: MIname OR Description__c like: MIname) AND Type__c=:MaterialTypeString AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC];
        }
        
        else if(MIname==null && MaterialTypeString !=null)
        {
            
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where   Type__c=:MaterialTypeString AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC limit 1000];
            
        }
        
        else if(MIname!=null && MaterialTypeString ==null)
        {
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c  where  (Name like: MIname OR Description__c like: MIname) AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC];
        }
        
        /*   }
else
{
if(MIname!=null && MaterialTypeString!=null && MIdesc!=null)
{
MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where  Name like:MIname AND Type__c=:MaterialTypeString AND Description__c like : MIdesc AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC];
}

else if(MIname==null && MaterialTypeString !=null && MIdesc!=null)
{
MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where   Type__c=:MaterialTypeString AND Description__c like : MIdesc AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC limit 1000];
}

else if(MIname!=null && MaterialTypeString ==null && MIdesc!=null)
{
MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c  where  Name like:MIname AND Description__c like : MIdesc AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC];
}
}   */  
        
        
        
        Set<Id> selectedEntries = new  Set<Id> ();
        for(Id  Item:roleWraps2.keyset())
        {
            selectedEntries.add(Item);
        }
        
        
        if(!MaterialItems.isEmpty())
        {
            
            Set<Id> contentDocumentIdSet =new Set<Id>();
            Map<Id,String> contentDocMap=new Map<Id,String>();
            for(Material_Item__c MI: MaterialItems){
                for(ContentDocumentLink cdl: MI.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
            
            
            for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
                if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                    contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
            }
            
            
            for(Material_Item__c MI: MaterialItems)
            {
                MIWrapper rw=new MIWrapper();
                rw.MI=MI;     rw.checked=false;      rw.ContentVersionId='';
                for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                    if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                        rw.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                        break;
                    }
                }
                roleWraps.put(rw.Mi.id,rw); 
                system.debug('sort record'+rw.mi.name);
            }
            if(rolewraps.size()>0)
                FirstWrapper=True;
            
            
            
            for(Id referenceId : rolewraps.keySet())
            {
                
                string MediaName = rolewraps.get(referenceId).mi.Name;
                MediaNameToRefIdMap.put(MediaName,referenceId);      MediaNameList.add(MediaName);
            }
            system.debug(MediaNameList);
            MediaNameList.sort();
            system.debug(MediaNameList);
            for(string MName : MediaNameList)
            {
                if(MediaNameToRefIdMap.containsKey(MName))
                    MediaIdList.add(MediaNameToRefIdMap.get(MName));
            }
            system.debug(MediaIdList);
        }    
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Items found'));
        
    }
    
    public pagereference AddToCart()
    {
        // This function runs when a user hits "Add To Cart" button 
        Map<string,string> MediaNameToRefIdMap= new Map<string,string>();
        List<string> MediaNameList= new List<string>();
        //MediaIdList  =new List<string>();
        
        for(Id Item: roleWraps.keyset())
        {
            if(roleWraps.get(Item).checked == true)
            {
                rolewraps2.put(Item,roleWraps.get(Item));    roleWraps.remove(Item);       MediaIdList.clear();
            }
            /* else
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Select any Item '));
}*/
        }
        if(rolewraps.size()>0)
        {
            
            for(Id referenceId : rolewraps.keySet())
            {
                string MediaName = rolewraps.get(referenceId).mi.Name;
                MediaNameToRefIdMap.put(MediaName,referenceId);
                MediaNameList.add(MediaName);
            }
            system.debug(MediaNameList);
            MediaNameList.sort();
            system.debug(MediaNameList);
            for(string MName : MediaNameList)
            {
                if(MediaNameToRefIdMap.containsKey(MName))
                    MediaIdList.add(MediaNameToRefIdMap.get(MName));
            }
            system.debug(MediaIdList);
        }    
        
        if(rolewraps2.size()>0)
        {
            SecondWrapper=True; ShowCartBackbutton=True; ShowStoreSupplies=false; ShowAddcartSection=True; NextButtonItemLayout=True;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Select any Item '));
        }
        
        
        return null;
        
        
        
    }
    
    
    public PageReference removeFromCart(){
        
        // This function runs when a user hits "remove" on an item in the "Selected Carts" section
        
        for(Id Item : roleWraps2.keyset()){
            if(Item ==toUnselect)
            {
                rolewraps2.remove(Item);   break;
            }
            
        }
        
        return null;
    }
    
    
    
    
    Public pagereference ViewToCart(){
        
        if(rolewraps2.size() > 0)
        {
            ShowCartBackbutton=True; ShowStoreSupplies=false; ShowAddcartSection=True; NextButtonItemLayout=True;
        }
        
        
        
        return null;
    }
    
    
    Public pagereference CancelfromCart()
    {
        ShowStoreSupplies=True;
        ShowAddcartSection=False;
        
        ShowCartBackbutton=false;
        NextButtonItemLayout=False;
        return null;
    }
    
    
    // End of Wrapper Class 
    
    
    
    // Start Wrapper Class 
    public class MIWrapper
    {
        public Material_Item__c MI{get;set;}
        public Boolean checked{get;set;}
        public String  ContentVersionId {get;set;}
        public  MIWrapper()
        {
            
        }   
    }
    // End of Wrapper Class
    
    Public Pagereference Back()
    {
        PageReference pageRef = new PageReference('/apex/StorefrontJobRequestForm');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void BacktoStore()
    {
        ShowStoreSupplies=false;
        ShowStoreList=true;
        ShowAddcartSection=False;
        ShowCartBackbutton=false;
        NextButtonItemLayout=False;
    }  
    
    
    Public Pagereference BackCombineList()
    {
        CombineWrap.clear();
        
        ShowAddcartSection=True;
        
        ShowCartBackbutton=True;
        NextButtonItemLayout=True;
        Order=False;
        CombinedWrapperBackbutton=False;
        CombinedList=False;
        return null;
        
    }  
    
    
}