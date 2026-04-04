public with sharing class StorefrontJobRequestFormController {
    
    
    public boolean isTab{private set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4t' || theme=='Theme4d')?true:false;
    }
                        }
    
    
    
    
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    public string BusinessCardCompany{get;set;}
    public void CompanyChanged(){
        if(SelectCompany == 'Loves Travel Stops & Country Stores'){
            BusinessCardCompany='Loves';
        }
        else{
            BusinessCardCompany='NotLoves';
        }
    }
    
    public List<string> MediaIdList {get; set;}
    public Attachment myfile;
    public Attachment getmyfile()
    {
        myfile=new Attachment();
        return myfile;
        
    }
    public Attachment myfileattach;
    public Attachment getmyfileattach()
    {
        myfileattach=new Attachment();
        return myfileattach;
    }
    public String toUnselect {get; set;}
    Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;} 
    public Map<Id,MIWrapper> rolewraps{get;set;}
    public Map<Id,MIWrapper> rolewraps2{get;set;}
    Public Transient List<Material_Item__c> MaterialItems{get;set;}
    Public boolean ShowCMNForm{get;set;}  //  added new form CMN Form in Store Order type
    Public boolean ShowCMNBannerForm{get;set;}  //  added new form CMN Form in Store Order type
    Public boolean ShowNameTag{get;set;}
    Public boolean ShowStoreNameTag{get;set;}
    Public boolean ShowNamePlate{get;set;}
    Public boolean ShowStoreBusiness{get;set;}
    Public boolean ShowCorporateBusiness{get;set;}
    Public boolean ShowBillboardRepairs{get;set;}
    Public boolean ShowStoreSupplies{get;set;}
    Public boolean ShowJobRequestTypes{get;set;}
    Public boolean ShowSavebutton{get;set;}
    Public boolean ShowCancelbutton{get;set;}
    Public boolean ShowNextbutton{get;set;}
    Public boolean ShowCartBackbutton{get;set;}
    Public boolean ShowBackbutton{get;set;}
    Public boolean ShowAddcartSection{get;set;}
    Public boolean ShowStoretypeCustom{get;set;} // added new form Custom Store Order in Store order picklist  
    Public boolean ShowStoretypeMadeOrder{get;set;} // added new form MadeToOrder in Store order picklist  
    Public boolean ShowCustomStoreOrder{get;set;}  //  added new form Custom Store Order in Store Order type
    Public boolean ShowMadeToOrder{get;set;} // added new form MadeToOrder in Store Order type
    Public boolean ShowFleetSalesOrder{get;set;} //FleetSalesOrder Form
    Public boolean ShowFleetSalesOrdervalue{get;set;}//FleetSalesOrder Form
    Public boolean ShowTrilliumOrder{get;set;} // Trillium CNG Form
    Public boolean ShowTrilliumOrdervalue{get;set;} // Trillium CNG Form
    public String JobRequestTypes{get;set;}
    public String CorpJobRequestTypes{get;set;}
    public String DistDivJobRequestTypes{get;set;}
    Public boolean FirstWrapper{get;set;}
    public Boolean SecondWrapper{get;set;}
    Public Boolean ShowMultiStoreButton{get;set;}
    //  Public Boolean ShowMultiStoreButton{get;set;}
    
    Public Set<string> Storegrps=new Set<string>(); 
    Public String clientname;
    
    public List<SelectOption> IndividualItems; 
    
    public List<SelectOption> RequestTypes; 
    public List<SelectOption> getRequestTypes() 
    {
        
        user u= new user();
        Client_Contact__c  CCon=new Client_Contact__c();
        
        u= [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() limit 1];
        CCon=[Select id, Client__r.name,UserName__c  from Client_Contact__c where UserName__c =:u.Username limit 1];
        
        
        
        if(RequestTypes!= NULL) {            return RequestTypes;
                                }
        RequestTypes= new List<SelectOption>();
        
        /* RequestTypes.add(new SelectOption('Name Tag Requests','Name Tag Requests'));
RequestTypes.add(new SelectOption('Corporate Office Nameplate','Corporate Office Nameplate'));
RequestTypes.add(new SelectOption('Corporate Business Cards','Corporate Business Cards')); */
        RequestTypes.add(new SelectOption('','-- Please Select --'));
        if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG')
        {   
            
            RequestTypes.add(new SelectOption('Store Business Cards','Store Business Cards'));
            RequestTypes.add(new SelectOption('Store Name Tag','Store Name Tag'));
            RequestTypes.add(new SelectOption('Billboard Repairs','Billboard Repairs'));
            RequestTypes.add(new SelectOption('Store Supplies','Store Supplies'));
            RequestTypes.add(new SelectOption('Custom Order','Custom Order'));  // added new form Custom Store Order in Store Order type
            RequestTypes.add(new SelectOption('Made To Order','Made To Order'));  // added new form MadeToOrder in Store Order type
            //   RequestTypes.add(new SelectOption('CMN','CMN'));  //  added new form CMN Form in Store Order type
        }
        return RequestTypes;
    } 
    
    
    public List<SelectOption> CorpRequestTypes; 
    public List<SelectOption> getCorpRequestTypes() 
    {
        user u= new user();
        Client_Contact__c  CCon=new Client_Contact__c();
        
        u= [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid()  limit 1];
        CCon=[Select id, Client__r.name,UserName__c  from Client_Contact__c where UserName__c =:u.Username limit 1];
        
        
        
        if (CorpRequestTypes!= NULL) 
        {
            return CorpRequestTypes;
        }
        
        CorpRequestTypes= new List<SelectOption>();
        
        CorpRequestTypes.add(new SelectOption('','-- Please Select --'));
        
        if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG')
        { 
            
            CorpRequestTypes.add(new SelectOption('Corporate Name Tag','Corporate Name Tag'));
            CorpRequestTypes.add(new SelectOption('Corporate Office Nameplate','Corporate Office Nameplate'));
        }        
        
        CorpRequestTypes.add(new SelectOption('Corporate Business Cards','Corporate Business Cards'));
        
        if(CCon.Client__r.name=='Fleet Sales' )
        { 
            
            CorpRequestTypes.add(new SelectOption('Sales/Marketing Order','Sales/Marketing Order')); //FleetSalesOrder Form
        }
        
        if(CCon.Client__r.name=='Trillium CNG')
        { 
            CorpRequestTypes.add(new SelectOption('Corporate Office Nameplate','Corporate Office Nameplate'));
            CorpRequestTypes.add(new SelectOption('Trillium CNG order','Trillium CNG order')); // Trillium CNG Form
        }
        
        
        return CorpRequestTypes;
    } 
    
    
    public List<SelectOption> DistDivRequestTypes; 
    public List<SelectOption> getDistDivRequestTypes() {
        if (CorpRequestTypes!= NULL) {            return DistDivRequestTypes;
                                     }
        DistDivRequestTypes= new List<SelectOption>();
        DistDivRequestTypes.add(new SelectOption('','-- Please Select --'));
        DistDivRequestTypes.add(new SelectOption('Multi Store Supplies','Multi Store Supplies'));
        
        return DistDivRequestTypes;
    } 
    
    
    
    
    //NameTagSection
    
    Public String Tagtitle{get;set;}
    Public String Tagtitlecorp{get;set;}
    Public String TagFirstName{get;set;}
    Public String TagLastName{get;set;}
    Public String TagYearsWorked{get;set;}
    Public Media_Type__c NameMediatype{get;set;}
    Public Schedule_Template__c NameTagScheduletype{get;set;}
    public List<string> TagLogoList {get; set;} 
    public List<SelectOption> TagLogo; 
    public List<SelectOption> getTagLogo(){
        if (TagLogo!= NULL) {            return TagLogo;
                            }
        TagLogo= new List<SelectOption>();
        
        TagLogo.add(new SelectOption('Arby\'s ','Arby\'s ')); 
        TagLogo.add(new SelectOption('Baskin Robbins ','Baskin Robbins ')); 
        TagLogo.add(new SelectOption('Bojangle\'s','Bojangle\'s')); 
        TagLogo.add(new SelectOption('Carl\'s Jr ','Carl\'s Jr ')); 
        TagLogo.add(new SelectOption('Chester\'s','Chester\'s')); 
        TagLogo.add(new SelectOption('Dairy Queen ','Dairy Queen ')); 
        TagLogo.add(new SelectOption('Denny\'s ','Denny\'s '));
        TagLogo.add(new SelectOption('Del Taco','Del Taco')); 
        TagLogo.add(new SelectOption('Dunkin Donuts','Dunkin Donuts')); 
        TagLogo.add(new SelectOption('Godfather\'s Pizza','Godfather\'s Pizza')); 
        TagLogo.add(new SelectOption('Green Burrito','Green Burrito')); 
        TagLogo.add(new SelectOption('Hardee\'s','Hardee\'s')); 
        TagLogo.add(new SelectOption('IHOP Express','IHOP Express')); 
        TagLogo.add(new SelectOption('Loves','Loves')); 
        TagLogo.add(new SelectOption('Sonic ','Sonic ')); 
        TagLogo.add(new SelectOption('Speedco','Speedco'));
        TagLogo.add(new SelectOption('Subway','Subway'));
        TagLogo.add(new SelectOption('Taco Bell','Taco Bell')); 
        TagLogo.add(new SelectOption('Taco John\'s','Taco John\'s')); 
        
        
        return TagLogo;
    }   
    
    public string TagTitleNewString {get; set;} 
    public List<SelectOption> TagTitleNew; 
    public List<SelectOption> getTagTitleNew(){
        if (TagTitleNew!= NULL) {            return TagTitleNew;
                                }
        TagTitleNew= new List<SelectOption>();
        //  TagTitleNew.add(new SelectOption('Administrative Assistant','Administrative Assistant'));
        TagTitleNew.add(new SelectOption('Area Restaurant Manager','Area Restaurant Manager'));
        TagTitleNew.add(new SelectOption('Area Tire Care Manager','Area Tire Care Manager')); 
        TagTitleNew.add(new SelectOption('Assistant Manager','Assistant Manager'));
        TagTitleNew.add(new SelectOption('District Manager','District Manager'));
        TagTitleNew.add(new SelectOption('Divisional Director','Divisional Director'));
        TagTitleNew.add(new SelectOption('Divisional Merchandising Manager','Divisional Merchandising Manager')); 
        TagTitleNew.add(new SelectOption('Fresh Food Coordinator','Fresh Food Coordinator')); 
        TagTitleNew.add(new SelectOption('Fresh Food Manager','Fresh Food Manager')); 
        TagTitleNew.add(new SelectOption('General Manager','General Manager')); 
        TagTitleNew.add(new SelectOption('Inventory Management Coordinator','Inventory Management Coordinator'));
        TagTitleNew.add(new SelectOption('Maintenance','Maintenance'));
        TagTitleNew.add(new SelectOption('Operations Manager','Operations Manager'));
        TagTitleNew.add(new SelectOption('Restaurant General Manager','Restaurant General Manager'));
        TagTitleNew.add(new SelectOption('Restaurant Manager','Restaurant Manager'));
        TagTitleNew.add(new SelectOption('Restaurant Assistant Manager','Restaurant Assistant Manager'));
        TagTitleNew.add(new SelectOption('Service Manager','Service Manager')); 
        TagTitleNew.add(new SelectOption('Shift Leader','Shift Leader'));
        TagTitleNew.add(new SelectOption('Team Member','Team Member'));
        TagTitleNew.add(new SelectOption('Team Trainer','Team Trainer'));
        TagTitleNew.add(new SelectOption('Tire Care Manager','Tire Care Manager'));
        
        
        return TagTitleNew;
    }  
    
    
    
    
    
    //NameTagSection
    
    
    
    //Corporate Office Nameplate
    
    Public String PlateName{get;set;}
    Public String PlateTitle{get;set;}
    Public String PlateDate{get;set;}
    Public Schedule_Template__c NamePlateScheduletype{get;set;}
    
    /*  public List<string> PlateLogoList {get; set;} 
public List<SelectOption> PlateLogo; 
public List<SelectOption> getPlateLogo(){
if (PlateLogo!= NULL) {            return PlateLogo;
}
PlateLogo= new List<SelectOption>();
PlateLogo.add(new SelectOption('Musket','Musket'));
PlateLogo.add(new SelectOption('Gemini','Gemini'));
PlateLogo.add(new SelectOption('Loves','Loves')); 



return PlateLogo;
} 
*/
    
    
    
    public string PlateBuildingString {get; set;} 
    public List<SelectOption> PlateBuilding; 
    public List<SelectOption> getPlateBuilding(){
        if (PlateBuilding!= NULL) {            return PlateBuilding;
                                  }
        PlateBuilding= new List<SelectOption>();
        PlateBuilding.add(new SelectOption('300','300'));
        PlateBuilding.add(new SelectOption('Amarillo','Amarillo'));
        PlateBuilding.add(new SelectOption('Annex','Annex'));
        PlateBuilding.add(new SelectOption('Atrium Towers','Atrium Towers'));
        PlateBuilding.add(new SelectOption('Choctaw','Choctaw'));
        PlateBuilding.add(new SelectOption('Contact Center','Contact Center'));
        PlateBuilding.add(new SelectOption('Guymon','Guymon')); 
        PlateBuilding.add(new SelectOption('Loves 50','Loves 50'));
        PlateBuilding.add(new SelectOption('Watonga','Watonga'));
        
        
        return PlateBuilding;
    } 
    
    
    
    
    public List<string> PlateTypeList {get; set;} 
    public List<SelectOption> PlateType; 
    public List<SelectOption> getPlateType(){
        if (PlateType!= NULL) {            return PlateType;
                              }
        PlateType= new List<SelectOption>();
        PlateType.add(new SelectOption('Office','Office'));
        PlateType.add(new SelectOption('Cubicle','Cubicle'));
        
        
        
        
        return PlateType;
    } 
    
    
    
    
    
    //CorporatOfficeNameplate
    
    
    
    
    
    
    //StoreBusinessCardSection
    
    Public String BusinessName{get;set;}
    Public String BusinessStoreLogo {get;set;}
    Public String BusinesskTireCareLogo  {get;set;}
    Public String BusinesskWebsite  {get;set;}
    
    
    public string BusinessTitleString {get; set;} 
    public List<SelectOption> BusinessTitle; 
    public List<SelectOption> getBusinessTitle(){
        if (BusinessTitle!= NULL) {            return BusinessTitle;
                                  }
        BusinessTitle= new List<SelectOption>();
        
        // BusinessTitle.add(new SelectOption('Administrative Assistant','Administrative Assistant'));
        BusinessTitle.add(new SelectOption('General Manager','General Manager')); 
        BusinessTitle.add(new SelectOption('Mechanic','Mechanic'));
        BusinessTitle.add(new SelectOption('Operations Manager','Operations Manager'));
        BusinessTitle.add(new SelectOption('Restaurant Manager','Restaurant Manager'));
        BusinessTitle.add(new SelectOption('Restaurant Assistant Manager','Restaurant Assistant Manager')); 
        BusinessTitle.add(new SelectOption('Service Manager','Service Manager')); 
        BusinessTitle.add(new SelectOption('Tire Care Manager','Tire Care Manager'));
        
        
        
        return BusinessTitle;
    } 
    
    
    public string BusinessLogoString {get; set;} 
    public List<SelectOption> BusinessLogo; 
    public List<SelectOption> getBusinessLogo(){
        if (BusinessLogo!= NULL) {  
            return BusinessLogo;
        }
        BusinessLogo= new List<SelectOption>();
        BusinessLogo.add(new SelectOption('Store','Store'));
        BusinessLogo.add(new SelectOption('Speedco','Speedco'));
        BusinessLogo.add(new SelectOption('Restaurant Manager','Restaurant Manager')); 
        BusinessLogo.add(new SelectOption('Tire Care','Tire Care'));
        
        
        return BusinessLogo;
    }
    
    Public Schedule_Template__c NameBusinessCardScheduletype{get;set;}
    
    //End StoreBusinessCardSection
    
    // added new form Custom Store Order in Store order picklist
    
    /* public string JobTypeString{get;set;}
public list<selectoption> JobTypeList;
public list<selectoption> getJobTypeList()
{
JobTypeList=new list<selectoption>();
JobTypeList.add(new selectoption('Select','Select'));
JobTypeList.add(new selectoption('Custom Order','Custom Order'));
JobTypeList.add(new Selectoption('Made To Order','Made To Order'));
return JobTypeList;
}


public void CustomOrderMethod()
{
if(JobTypeString=='Custom Order')
{
ShowCustomStoreOrder=true;
ShowStoretypeCustom=false;
ShowSavebutton=true;
}
else
{
ShowMadeToOrder=true;
ShowStoretypeCustom=false;
ShowSavebutton=true;
}
} */
    
    
    
    // added new form Custom Store Order in Store Order type
    
    
    Public Schedule_Template__c NameCustomScheduletype{get;set;} 
    Public String CustomQuantityNeeded{get;set;}
    Public String CustomMeasurements{get;set;}
    Public String Customrequest{get;set;}
    Public String Customneedtosay{get;set;}
    Public String Customneedtogo{get;set;}  
    
    public List<string>  ItemsNeededList{get; set;} 
    public List<SelectOption>   ItemsNeeded; 
    public List<SelectOption> getItemsNeeded ()
    {
        if (ItemsNeeded!= NULL) 
        {      
            return ItemsNeeded;
        }
        ItemsNeeded= new List<SelectOption>();
        ItemsNeeded.add(new SelectOption('Banner','Banner'));
        ItemsNeeded.add(new SelectOption('Decals (Stickers)','Decals (Stickers)'));
        ItemsNeeded.add(new SelectOption('Interior Signage','Interior Signage'));
        ItemsNeeded.add(new SelectOption('Exterior Signage','Exterior Signage'));
        ItemsNeeded.add(new SelectOption('Restaurant Signage','Restaurant Signage'));
        ItemsNeeded.add(new SelectOption('Metal Signs','Metal Signs'));
        ItemsNeeded.add(new SelectOption('Echo Hearts Logo','Echo Hearts Logo'));
        ItemsNeeded.add(new SelectOption('Other (Specify)','Other (Specify)'));
        
        return ItemsNeeded;
    }  
    
    
    public String TurnTimeString { get; set; }
    public List<SelectOption>   TurnTime; 
    public List<SelectOption> getTurnTime ()
    {
        if (TurnTime!= NULL) 
        {      
            return TurnTime;
        }
        TurnTime= new List<SelectOption>();
        TurnTime.add(new SelectOption('4 Weeks','4 Weeks'));
        TurnTime.add(new SelectOption('6 Weeks','6 Weeks'));
        TurnTime.add(new SelectOption('8 Weeks','8 Weeks'));
        
        
        return TurnTime;
    } 
    
    //End added new form Custom Store Order in Store Order type
    
    
    //added new form MadeToOrder in Store Order type
    
    Public Schedule_Template__c NameMadeToOrderScheduletype{get;set;} 
    Public String SpecialDetails{get;set;}
    Public String Mqty{get;set;}
    
    public map<string,list<string>> categoryWithItemsMap{get;set;}
    
    public String  MadeItemsCategory{get; set;} 
    public List<SelectOption>   MadeItemsCategoryList; 
    public List<SelectOption> getMadeItemsCategoryList ()
    {
        if (MadeItemsCategoryList!= NULL) 
        {      
            return MadeItemsCategoryList;
        }
        
        MadeItemsCategoryList= new List<SelectOption>();
        MadeItemsCategoryList.add(new SelectOption('Banners','Banners'));
        MadeItemsCategoryList.add(new SelectOption('Decals','Decals'));
        MadeItemsCategoryList.add(new SelectOption('Metal Signs','Metal Signs'));
        MadeItemsCategoryList.add(new SelectOption('Other Signs','Other Signs'));
        
        
        
        
        /* MadeItemsCategoryList= new List<SelectOption>();
for(schema.picklistEntry p : Material_Item__c.Type__c.getDescribe().getPicklistValues()){

MadeItemsCategoryList.add(new SelectOption(p.getLabel(),p.getLabel()));
}*/
        
        
        return MadeItemsCategoryList;
    }
    
    
    public List<SelectOption>  MadeIndividualItemsNeededList{get; set;} 
    public String MadeIndividualItemsNeeded{get;set;}
    public map<string,string> mapIndividualItems{get;set;}
    //  public map<string,string> mapMaxQty{get;set;}
    Public pagereference ItemsInd()
    {
        mapIndividualItems = new map<string,string>();
        //   mapMaxQty = new map<string,string>();
        MadeIndividualItemsNeededList = new List<SelectOption>();
        string mto='Made to Order';
        for(Material_Item__c  jmi : [select id,name,Type__c,Max_Qty__c,Category__c from Material_Item__c where Type__c=:MadeItemsCategory and Category__c=:mto  AND Store_Type__c IN: Storegrps limit 1000 ])
        {
            MadeIndividualItemsNeededList.add(new SelectOption(jmi.id,jmi.name));
            mapIndividualItems.put(jmi.id,jmi.name);
            // mapMaxQty.put(jmi.id,jmi.Max_Qty__c);
            
        }
        return null;
        
    }
    
    
    public Material_Item__c  pic{get;set;}
    public String MadeToOrderpicId{get;set;}
    
    Public pagereference ItemsPic()
    {
        Set<Id> contentDocumentIdSet =new Set<Id>();
        MadeToOrderpicId='';
        if(string.isNotBlank(MadeIndividualItemsNeeded))
        {
            pic = [select id,name,Type__c,Max_Qty__c,File_Photo__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) from Material_Item__c where id=:MadeIndividualItemsNeeded];
            
            for(ContentDocumentLink cdl: pic.ContentDocumentLinks){
                contentDocumentIdSet.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> cvList=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC Limit 1];
            if(cvList.size()>0)
            {
                MadeToOrderpicId=cvList[0].Id;
            }
            
        }
        
        return null;
        
    }
    
    //End added new form MadeToOrder in Store Order type
    
    
    //CorporateCardSection
    Public String CorporateName{get;set;}
    Public String CorporateTitle{get;set;}
    Public String CorporateDepartment{get;set;}
    Public String CorporatePhone{get;set;}
    Public String CorporateFax{get;set;}
    Public String CorporateEmail{get;set;}
    Public String CorporateYahooIM{get;set;}
    Public String CorporateMobile{get;set;}
    
    
    Public Schedule_Template__c NameCorporateCardScheduletype{get;set;}
    public string  selectAddress{get; set;} 
    public List<SelectOption>   AddressSelections ; 
    public List<SelectOption> getAddressSelections (){
        if (AddressSelections!= NULL) {            return AddressSelections;
                                      }
        AddressSelections= new List<SelectOption>();
        AddressSelections.add(new SelectOption('10601 North Pennsylvania Ave.Oklahoma City,OK 73120','10601 North Pennsylvania Ave.Oklahoma City,OK 73120'));
        AddressSelections.add(new SelectOption('2929 Allen Parkway, Ste 4100 Houston, TX 77019','2929 Allen Parkway, Ste 4100 Houston, TX 77019')); 
        AddressSelections.add(new SelectOption('Terminal 5101 Lone Star Blvd Fort Worth,TX 76106','Terminal 5101 Lone Star Blvd Fort Worth,TX 76106'));
        AddressSelections.add(new SelectOption('One Renaissance Square 2 North Central Ave Suite 1220 Phoenix, AZ 85004','One Renaissance Square 2 North Central Ave Suite 1220 Phoenix, AZ 85004'));
        AddressSelections.add(new SelectOption('3601 NW 63rd Street Oklahoma City, OK 73116','3601 NW 63rd Street Oklahoma City, OK 73116'));
        
        
        
        return AddressSelections;
    }  
    
    
    
    public string SelectCompany {get; set;} 
    public List<SelectOption> CompanySelections; 
    public List<SelectOption> getCompanySelections ()
    {
        if (CompanySelections!= NULL) 
        {           
            return CompanySelections;
        }
        CompanySelections= new List<SelectOption>();
        CompanySelections.add(new SelectOption('Love\'s','Love\'s'));
        CompanySelections.add(new SelectOption('Gemini','Gemini')); 
        CompanySelections.add(new SelectOption('Musket','Musket'));
        CompanySelections.add(new SelectOption('Trillium','Trillium'));
        CompanySelections.add(new SelectOption('Speedco','Speedco'));
        CompanySelections.add(new SelectOption('Financial','Financial'));
        CompanySelections.add(new SelectOption('Recruiting','Recruiting'));
        CompanySelections.add(new SelectOption('Truck Tire Care','Truck Tire Care'));
        
        return CompanySelections;
    }  
    
    
    
    
    
    
    
    public string SelectCorporate{get; set;} 
    public List<SelectOption> CorporateWebsite; 
    public List<SelectOption> getCorporateWebsite(){
        if (CorporateWebsite!= NULL) {            return CorporateWebsite;
                                     }
        CorporateWebsite= new List<SelectOption>();
        CorporateWebsite.add(new SelectOption('www.loves.com','www.loves.com'));
        CorporateWebsite.add(new SelectOption('www.musketcorp.com','www.musketcorp.com')); 
        CorporateWebsite.add(new SelectOption('www.loves.com/hotels','www.loves.com/hotels'));
        CorporateWebsite.add(new SelectOption('www.loves.com/trillium','www.loves.com/trillium'));
        CorporateWebsite.add(new SelectOption('www.loves.com/gemini','www.loves.com/gemini'));
        CorporateWebsite.add(new SelectOption('www.loves.com/speedco','www.loves.com/speedco'));
        
        
        
        
        return CorporateWebsite;
    }  
    
    public string SelectCorporateLogo{get; set;} 
    public List<SelectOption> CorporateLogo; 
    public List<SelectOption> getCorporateLogo(){
        if (CorporateLogo!= NULL) {            return CorporateLogo;
                                  }
        CorporateLogo= new List<SelectOption>();
        CorporateLogo.add(new SelectOption('Musket  ','Musket  '));
        CorporateLogo.add(new SelectOption('Gemini  ','Gemini  '));
        CorporateLogo.add(new SelectOption('Loves   ','Loves   '));
        CorporateLogo.add(new SelectOption('Trillium ','Trillium '));
        
        
        return CorporateLogo;
    }   
    //CorporateCardSection
    
    //BillboardRepairSection
    
    
    Public Media_Type__c NameBillboardMediatype{get;set;}
    Public Schedule_Template__c NameBillboardScheduletype{get;set;}
    
    Public String BillboardStore{get;set;}
    Public String BillboardRequestor{get;set;}
    Public String BillboardReads{get;set;}
    Public String Billboardshouldread{get;set;}
    Public String Billboardlightout{get;set;}
    Public String BillboardNotes{get;set;}
    
    public List<string> BillboardSigntypeList {get; set;} 
    public List<SelectOption> BillboardSigntype; 
    public List<SelectOption> getBillboardSigntype(){
        if (BillboardSigntype!= NULL) {            return BillboardSigntype;
                                      }
        BillboardSigntype= new List<SelectOption>();
        BillboardSigntype.add(new SelectOption('Billboard  ','Billboard'));
        BillboardSigntype.add(new SelectOption('DOT','DOT'));
        
        return BillboardSigntype;
    }  
    
    public string BBList{get; set;} 
    public list<SelectOption> Billboardlist;
    
    public List<SelectOption> getBillboardList(){
        List<SelectOption> BillboardList= new List<selectOption>();
        BillboardList.add(new selectOption('', '- None -'));  
        
        
        if(clientname.contains('Store')){
            
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
                
            }
            
        }
        
        if(clientname.contains('District')){
            
            
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
                
            }
            
        }
        
        if(clientname.contains('Division')){
            
            for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c]){
                BillboardList.add(new SelectOption(p.name ,p.name ));
                
            }
            
        }
        
        
        return BillboardList;
    } 
    
    
    
    
    /* public string BillboardLocationString {get; set;} 
public List<SelectOption> BillboardLocation; 
public List<SelectOption> getBillboardLocation(){
if (BillboardLocation!= NULL) {            return BillboardLocation;
}
BillboardLocation= new List<SelectOption>();
BillboardLocation.add(new SelectOption('Corporate','Corporate'));
BillboardLocation.add(new SelectOption('Echo Media','Echo Media'));
BillboardLocation.add(new SelectOption(' Stores',' Stores'));


return BillboardLocation;
}  
*/
    Public String BBLName;
    public String getBBLName() { return BBLName; }
    public void setBBLName(String s) {  this.BBLName= s; }
    
    // This method is used to retrieve all Locatiopn into dropdown list
    public List<selectOption> getBBLocation() 
    {    
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Billboard__c gld : [Select id ,name ,Location__c,Client_Name__c FROM Billboard__c where Client_Name__c=:clientcontact.Client__c Order By Name]) 
        {  
            optionList.add(new selectOption(gld.Location__c, gld.Location__c));  
        }
        return optionList;  
    }   
    // End of method getBBLocation
    
    
    
    public List<string> BillboardLightList {get; set;} 
    public List<SelectOption> BillboardLight; 
    public List<SelectOption> getBillboardLight(){
        if (BillboardLight!= NULL) {            return BillboardLight;
                                   }
        BillboardLight= new List<SelectOption>();
        BillboardLight.add(new SelectOption('Light 1','Light 1'));
        BillboardLight.add(new SelectOption('Light 2','Light 2'));
        BillboardLight.add(new SelectOption('Light 3',' Light 3'));
        BillboardLight.add(new SelectOption('Light 4',' Light 4'));
        
        
        return BillboardLight;
    } 
    
    
    
    
    public List<string> BillboardServiceIssuesList {get; set;} 
    public List<SelectOption> BillboardServiceIssues; 
    public List<SelectOption> getBillboardServiceIssues(){
        if (BillboardServiceIssues!= NULL) {            return BillboardServiceIssues;
                                           }
        BillboardServiceIssues= new List<SelectOption>();
        BillboardServiceIssues.add(new SelectOption('Faded/Weathered Facing  ','Faded/Weathered Facing  '));
        BillboardServiceIssues.add(new SelectOption('Heart Issue','Heart Issue'));
        BillboardServiceIssues.add(new SelectOption('Incorrect Logos','Incorrect Logos'));
        BillboardServiceIssues.add(new SelectOption('Trim Trees/Brush','Trim Trees/Brush'));
        BillboardServiceIssues.add(new SelectOption('Needs White-Out/Taken Down(canceled)','Needs White-Out/Taken Down(canceled)'));
        BillboardServiceIssues.add(new SelectOption('Directional Information Incorrect','Directional Information Incorrect'));
        
        return BillboardServiceIssues;
    }  
    
    
    
    
    //BillboardRepairSection
    
    //StoreSupplyOrdersSection
    public string MaterialTypeString {get; set;} 
    Public String MaterialItemNameString {get;set;}
    Public String MaterialItemDescString {get;set;}
    
    public List<SelectOption> getMaterialType(){
        List<SelectOption> MaterialType= new List<selectOption>();
        MaterialType.add(new SelectOption('','-- Please Select --'));
        MaterialType.add(new SelectOption('', 'All Categories'));
        
        for(schema.picklistEntry p : Material_Item__c.Type__c.getDescribe().getPicklistValues()){
            MaterialType.add(new SelectOption(p.getLabel(),p.getLabel()));
            
        }
        
        return MaterialType;
    } 
    
    Public Media_Type__c NameStoreMediatype{get;set;}
    Public Schedule_Template__c NameStoreScheduletype{get;set;} 
    
    
    
    
    
    
    // CONSTRUCTOR
    public StorefrontJobRequestFormController(){
        
        BusinessCardCompany='Loves';
        
        MaterialItems=new List<Material_Item__c> ();
        
        roleWraps=new Map<Id,MIWrapper>();
        rolewraps2 = new Map<Id,MIWrapper>();
        // ShowJobRequestTypes=true;
        ShowNameTag=false;
        ShowStoretypeCustom=false;// added new form Custom Store Order in Store order picklist
        ShowStoretypeMadeOrder=false;
        ShowCustomStoreOrder=false; // added new form Custom Store Order in Store Order type
        ShowMadeToOrder=false;// added new form MadeToOrder in Store Order type
        ShowCMNForm=false;  //  added new form CMN Form in Store Order type
        ShowCMNBannerForm=false;
        ShowStoreNameTag=false;
        ShowStoreBusiness=false;
        ShowCorporateBusiness=false;
        ShowBillboardRepairs=false;
        ShowStoreSupplies=false;
        ShowSavebutton=false;
        ShowCancelbutton=false;
        ShowBackbutton=true;
        ShowCartBackbutton=false;
        ShowAddcartSection=false;
        FirstWrapper=False;
        SecondWrapper=False;
        ShowFleetSalesOrder=False; //FleetSalesOrder Form
        ShowTrilliumOrder=False; // Trillium CNG Form
        
        BusinesskWebsite='www.loves.com';  
        
        TagLogoList = new List<string>();
        
        NameMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
        
        NameBillboardMediatype=[Select id ,name from Media_Type__c where name='Outdoor' limit 1];
        
        NameStoreMediatype=[Select id ,name from Media_Type__c where name='Supplies' limit 1];
        
        NameTagScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Name Tag' AND Media_Types__r.name='Print' limit 1];
        
        NameCustomScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Custom Order' AND Media_Types__r.name='Print' limit 1];// added new form Custom Store Order in Store Order type
        
        NameMadeToOrderScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Made To Order' AND Media_Types__r.name='Print' limit 1];// added new form MadeToOrder in Store Order type
        
        NamePlateScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Corporate Office Nameplate' AND Media_Types__r.name='Print' limit 1];
        
        NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Order' AND Media_Types__r.name='Supplies' limit 1];
        
        NameBusinessCardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Business Card' AND Media_Types__r.name='Print' limit 1];
        
        NameCorporateCardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Corporate Business Card' AND Media_Types__r.name='Print' limit 1];
        
        NameBillboardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Billboard Repair' AND Media_Types__r.name='Outdoor' limit 1];
        
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        
        clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        
        clientname=clientcontact.Client__r.Name; 
        
        if(clientcontact.Client_Contact_Role__c!='Fleet Solutions' && clientcontact.Client_Contact_Role__c!='Trillium CNG')
        {
            //ShowFleetSalesOrdervalue=false;
            ShowJobRequestTypes=true;
        }
        
        if(clientcontact.Client_Contact_Role__c=='Fleet Solutions')
        {
            ShowFleetSalesOrdervalue=true;
        }
        
        if(clientcontact.Client_Contact_Role__c=='Trillium CNG')
        {
            ShowTrilliumOrdervalue=true;
        }
        
        if(clientname.contains('District') || clientname.contains('Division') || clientname.contains('Corporate')){
            
            ShowMultiStoreButton=true;
            
        }
        
        
        
        if(clientcontact.Client__r.Client_Group__c!=null) {
            
            string fruit = clientcontact.Client__r.Client_Group__c;
            string[] split = fruit.Split(';');
            
            
            for(string item :split)
            {
                Storegrps.add(item);
            }
            
        }
        
        
        
        
    }
    
    
    Public pagereference methodcontinue(){
        
        /*  if(JobRequestTypes =='Name Tag Requests'){
ShowNameTag=True;ShowJobRequestTypes=false;ShowSavebutton=true;
ShowCancelbutton=true;ShowBackbutton=false;
system.debug('**ShowNameTag**'+ShowNameTag);
}

if(JobRequestTypes =='Corporate Office Nameplate'){
ShowNamePlate=True;ShowJobRequestTypes=false;ShowSavebutton=true;
ShowCancelbutton=true;ShowBackbutton=false;
system.debug('**ShowNamePlate**'+ShowNamePlate);
}


if(JobRequestTypes =='Corporate Business Cards'){
ShowCorporateBusiness=True;ShowJobRequestTypes=false;ShowSavebutton=true;
ShowCancelbutton=true;ShowBackbutton=false;
system.debug('**ShowCorporateBusiness**'+ShowCorporateBusiness);
}*/
        
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        clientcontact=[Select id,Client_Contact_Role__c,Mobile_Phone__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        
        
        
        
        if(JobRequestTypes =='Store Business Cards'){
            ShowStoreBusiness=True;ShowJobRequestTypes=false;ShowSavebutton=true;
            ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;
            system.debug('**ShowStoreBusiness**'+ShowStoreBusiness);
            
        }
        
        if(JobRequestTypes =='Store Name Tag'){
            ShowStoreNameTag=True;ShowJobRequestTypes=false;ShowSavebutton=true;
            ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;
            system.debug('**ShowStoreNameTag**'+ShowStoreNameTag);
        }
        
        
        if(JobRequestTypes =='Billboard Repairs'){
            ShowBillboardRepairs=True;ShowJobRequestTypes=false;ShowSavebutton=true;
            ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;
            system.debug('**ShowBillboardRepairs**'+ShowBillboardRepairs);
        }
        
        // added new form Custom Store Order in Store Order type
        
        if(JobRequestTypes =='Custom Order'){
            /*  ShowCustomStoreOrder=True;ShowStoretypeCustom=False;ShowJobRequestTypes=false;ShowBackbutton=false;
ShowSavebutton=False;ShowCancelbutton=true;ShowNextbutton=true;ShowStoretypeMadeOrder=false;
system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);*/
            
            ShowCustomStoreOrder=True;ShowJobRequestTypes=false;ShowBackbutton=false;
            ShowSavebutton=False;ShowCancelbutton=true;ShowNextbutton=false;ShowStoretypeCustom=false;ShowStoretypeMadeOrder=false;
            system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);ShowSavebutton=true;
            
        }
        
        if(JobRequestTypes =='Made To Order'){
            /*ShowMadeToOrder=True; ShowStoretypeMadeOrder=false;ShowStoretypeCustom=False;ShowJobRequestTypes=false;ShowBackbutton=false;
ShowSavebutton=False;ShowCancelbutton=true;ShowNextbutton=true;
system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);*/
            
            
            ShowMadeToOrder=True;ShowJobRequestTypes=false;ShowBackbutton=false;
            ShowSavebutton=true;ShowCancelbutton=true;ShowNextbutton=false;ShowStoretypeCustom=false;ShowStoretypeMadeOrder=false;
            system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);ShowSavebutton=true;
        }
        
        
        //  added new form CMN Form in Store Order type
        if(JobRequestTypes =='CMN')
        {
            PageReference pageRef= new PageReference('/apex/CMNFormOrders');    
            pageRef.setRedirect(false);               return pageRef; 
        }
        
        if(JobRequestTypes =='Store Supplies')
        {
            if(clientcontact.Client__r.Client_Group__c!=null){
                ShowStoreSupplies=True;ShowJobRequestTypes=false;ShowSavebutton=false;
                ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;
                system.debug('**ShowStoreSupplies**'+ShowStoreSupplies);
            }
            
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'You are not assigned to a group of items to order.  Contact your admin.');
                ApexPages.addMessage(myMsg);
            }
        }
        
        return null;
        
    }
    
    /*  Public pagereference nextmethod()
{
if(JobRequestTypes =='Custom Order'){
ShowCustomStoreOrder=True;ShowJobRequestTypes=false;ShowBackbutton=false;
ShowSavebutton=False;ShowCancelbutton=true;ShowNextbutton=false;ShowStoretypeCustom=false;ShowStoretypeMadeOrder=false;
system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);ShowSavebutton=true;
}

if(JobRequestTypes =='Made To Order'){
ShowMadeToOrder=True;ShowJobRequestTypes=false;ShowBackbutton=false;
ShowSavebutton=true;ShowCancelbutton=true;ShowNextbutton=false;ShowStoretypeCustom=false;ShowStoretypeMadeOrder=false;
system.debug('**ShowCustomStoreOrder**'+ShowCustomStoreOrder);ShowSavebutton=true;
}
return null;
}*/
    
    Public pagereference Corpmethodcontinue(){
        
        if(CorpJobRequestTypes=='Corporate Name Tag'){
            ShowNameTag=True;ShowJobRequestTypes=false;ShowSavebutton=true;
            ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;
            system.debug('**ShowNameTag**'+ShowNameTag);
        }
        
        if(CorpJobRequestTypes=='Corporate Office Nameplate'){
            ShowNamePlate=True;ShowJobRequestTypes=false;ShowSavebutton=true;
            ShowCancelbutton=true;ShowBackbutton=false;ShowNextbutton=false;ShowTrilliumOrdervalue=false;
            system.debug('**ShowNamePlate**'+ShowNamePlate);
        }
        
        
        if(CorpJobRequestTypes=='Corporate Business Cards'){
            
            /*  PageReference pageRef= new PageReference('/apex/CorporateBusinessCard');    
pageRef.setRedirect(false);            
return pageRef; */
            
            ShowCorporateBusiness=True;ShowJobRequestTypes=false;ShowSavebutton=true;ShowNextbutton=false;
            ShowCancelbutton=true;ShowBackbutton=false;ShowFleetSalesOrdervalue=false;ShowTrilliumOrdervalue=false;
            system.debug('**ShowCorporateBusiness**'+ShowCorporateBusiness);
        }
        
        
        
        //FleetSalesOrder Form
        
        if(CorpJobRequestTypes=='Sales/Marketing Order')
        {
            
            PageReference pageRef= new PageReference('/apex/FleetSalesOrderPage');    
            pageRef.setRedirect(false);           return pageRef; 
            
        }
        
        // Trillium CNG Form
        
        if(CorpJobRequestTypes=='Trillium CNG order')
        {
            
            PageReference pageRef= new PageReference('/apex/TrilliumJobRequestFormPage');    
            pageRef.setRedirect(false);                return pageRef; 
            
        }
        
        
        
        return null;
        
    }
    
    
    
    
    Public pagereference DistDivmethodcontinue(){
        
        if(DistDivJobRequestTypes=='Multi Store Supplies'){
            
            PageReference pageRef= new PageReference('/apex/MultiStoreOrderPage');       pageRef.setRedirect(false);              return pageRef; 
            
            
            
        }
        
        return null;
        
    }
    
    
    
    
    
    Public pagereference Save(){
        
        
        /*  *************************   Name Tag Request    ****************************************     */
        
        if(ShowNameTag == True)
        {
            
            try
            { 
                Job__c TagJob=new Job__c();
                TagJob.Media_Types__c=NameMediatype.id;
                TagJob.Schedule_Template__c=NameTagScheduletype.id;
                TagJob.JS_Client__c=clientcontact.Client__c;
                TagJob.JS_Client_Contact__c=clientcontact.id;
                
                TagJob.JobFormTypeValues__c='Name Tag Request';
                insert TagJob;
                
                Job_Spec__c TagSpec1=new Job_Spec__c();
                TagSpec1.Name='Title';
                TagSpec1.Description__c=Tagtitlecorp;
                TagSpec1.Job__c=TagJob.id;
                insert TagSpec1;
                
                Job_Spec__c TagSpec2=new Job_Spec__c();
                TagSpec2.Name='First Name';
                TagSpec2.Description__c=TagFirstName;
                TagSpec2.Job__c=TagJob.id;
                insert TagSpec2;
                
                Job_Spec__c TagSpec3=new Job_Spec__c();
                TagSpec3.Name='Last Name';
                TagSpec3.Description__c=TagLastName;
                TagSpec3.Job__c=TagJob.id;
                insert TagSpec3;
                
                Job_Spec__c TagSpec4=new Job_Spec__c();
                TagSpec4.Name='Year of Hire';
                TagSpec4.Description__c=TagYearsWorked;
                TagSpec4.Job__c=TagJob.id;
                insert TagSpec4;
                
                List<Job_Spec__c> TagSpecList=new list<Job_Spec__c>();
                
                if(TagLogoList.size() >0 ){
                    for(string tagdesc:TagLogoList){
                        Job_Spec__c tagspec5 =new Job_Spec__c();
                        TagSpec5.Name='Logo';
                        TagSpec5.Job__c=TagJob.id;
                        TagSpec5.Description__c=tagdesc;
                        TagSpecList.add(TagSpec5);
                        
                    }
                }
                insert TagSpecList;
                
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);                    return pageRef;
                }
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
                
                
            }
            
            
            catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));  return null;
            }
            
            return null;
            
        }
        
        
        
        if(ShowStoreNameTag== True){
            
            if(((string.isBlank(TagLastName)) &&  (TagTitleNewString != 'Team Member')) || string.isBlank(TagYearsWorked) || TagLogoList.size() == 0 )
            {
                /*  if(string.isBlank(TagFirstName))
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the First Name'));
}*/
                if((string.isBlank(TagLastName)) && (TagTitleNewString != 'Team Member'))
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Last Name'));
                }
                if(string.isBlank(TagYearsWorked))
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Year of Hire'));
                }
                if(TagLogoList.size() == 0)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select the Logo'));
                }
                
            }
            
            
            
            else
            {
                try{
                    Job__c TagJob=new Job__c();
                    TagJob.Media_Types__c=NameMediatype.id;
                    TagJob.Schedule_Template__c=NameTagScheduletype.id;
                    TagJob.JS_Client__c=clientcontact.Client__c;
                    TagJob.JS_Client_Contact__c=clientcontact.id;
                    
                    TagJob.JobFormTypeValues__c='Name Tag Request';
                    insert TagJob;
                    
                    Job_Spec__c TagSpec1=new Job_Spec__c();
                    TagSpec1.Name='Title';
                    TagSpec1.Description__c=TagTitleNewString;
                    TagSpec1.Job__c=TagJob.id;
                    insert TagSpec1;
                    
                    Job_Spec__c TagSpec2=new Job_Spec__c();
                    TagSpec2.Name='First Name';
                    TagSpec2.Description__c=TagFirstName;
                    
                    TagSpec2.Job__c=TagJob.id;
                    insert TagSpec2;
                    
                    if(TagTitleNewString != 'Team Member')
                    {
                        Job_Spec__c TagSpec3=new Job_Spec__c();
                        TagSpec3.Name='Last Name';
                        TagSpec3.Description__c=TagLastName;
                        TagSpec3.Job__c=TagJob.id;
                        insert TagSpec3;
                    }            
                    Job_Spec__c TagSpec4=new Job_Spec__c();
                    TagSpec4.Name='Year of Hire';
                    TagSpec4.Description__c=TagYearsWorked;
                    TagSpec4.Job__c=TagJob.id;
                    insert TagSpec4;
                    
                    List<Job_Spec__c> TagSpecList=new list<Job_Spec__c>();
                    
                    if(TagLogoList.size() >0 ){
                        for(string tagdesc:TagLogoList){
                            Job_Spec__c tagspec5 =new Job_Spec__c();
                            TagSpec5.Name='Logo';
                            TagSpec5.Job__c=TagJob.id;
                            TagSpec5.Description__c=tagdesc;
                            TagSpecList.add(TagSpec5);
                            
                        }
                    }
                    insert TagSpecList;
                    
                    
                    if(isTab)
                    {
                        PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                        pageRef.setRedirect(true);                    return pageRef;
                    }
                    
                    
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                
                
                
                catch(Exception e)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));   return null;
                }
                
                return null;
                
            }
        }
        
        /*  *************************   Corporate Office Nameplate    ****************************************     */
        
        if(ShowNamePlate == True)
        {
            try
            {
                
                Job__c PlateJob=new Job__c();
                PlateJob.Media_Types__c=NameMediatype.id;
                PlateJob.Schedule_Template__c=NamePlateScheduletype.id;
                PlateJob.JS_Client__c=clientcontact.Client__c;
                PlateJob.JS_Client_Contact__c=clientcontact.id;
                
                PlateJob.JobFormTypeValues__c='Corporate Office Nameplate';
                insert PlateJob;
                
                Job_Spec__c PlateSpec1=new Job_Spec__c();
                PlateSpec1.Name='Title';
                PlateSpec1.Description__c=PlateTitle;
                PlateSpec1.Job__c=PlateJob.id;
                insert PlateSpec1;
                
                
                Job_Spec__c PlateSpec2=new Job_Spec__c();
                PlateSpec2.Name='Name';
                PlateSpec2.Description__c=PlateName;
                PlateSpec2.Job__c=PlateJob.id;
                insert PlateSpec2;
                
                Job_Spec__c PlateSpec3=new Job_Spec__c();
                PlateSpec3.Name='Year Of Hire';
                PlateSpec3.Description__c=PlateDate;
                PlateSpec3.Job__c=PlateJob.id;
                insert PlateSpec3;
                
                
                
                // List<Job_Spec__c> PlateBuildingSpecList=new list<Job_Spec__c>();
                
                Job_Spec__c PlateSpec4=new Job_Spec__c();
                PlateSpec4.Name='Building';
                PlateSpec4.Description__c=PlateBuildingString;
                PlateSpec4.Job__c=PlateJob.id;
                insert PlateSpec4;
                
                List<Job_Spec__c> PlateTypeSpecList=new list<Job_Spec__c>();
                
                if(PlateTypeList.size() >0 ){
                    for(string tagdesc1:PlateTypeList){
                        Job_Spec__c tagspec5 =new Job_Spec__c();
                        TagSpec5.Name='Name Plate Type';
                        TagSpec5.Job__c=PlateJob.id;
                        TagSpec5.Description__c=tagdesc1;
                        PlateTypeSpecList.add(TagSpec5);
                        
                    }
                }
                insert PlateTypeSpecList;
                
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);  pageRef.setRedirect(true);                    return pageRef;
                }
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
            }
            catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button')); return null;
            }
            
            return null;
        }
        
        
        /*  *************************   added new form in Custom Store Order Request Form    ****************************************     */
        
        if(ShowCustomStoreOrder== True){
            
            if(myfileattach.body == null )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose file'));
                // myfileattach.addError('Please Choose file field');
            }
            
            else
            {
                try  
                {
                    Job__c CustomJob=new Job__c();
                    
                    CustomJob.Media_Types__c=NameMediatype.id;
                    CustomJob.Schedule_Template__c=NameCustomScheduletype.id;
                    CustomJob.JS_Client__c=clientcontact.Client__c;
                    CustomJob.JS_Client_Contact__c=clientcontact.id;
                    
                    CustomJob.JobFormTypeValues__c='Custom Order';
                    insert CustomJob;
                    
                    
                    System.debug('******************************CustomJob.JobFormTypeValues__c**********************************'+CustomJob.JobFormTypeValues__c);
                    
                    
                    List<Job_Spec__c> ItemsNeededspecList=new list<Job_Spec__c>();
                    
                    if(ItemsNeededList.size() >0 )
                    {
                        for(string tagdesc1:ItemsNeededList)
                        {
                            Job_Spec__c tagspec7 =new Job_Spec__c();
                            TagSpec7.Name='Items Needed';        TagSpec7.Job__c=CustomJob.id;      TagSpec7.Description__c=tagdesc1;
                            ItemsNeededspecList.add(TagSpec7);
                        }
                    }
                    insert ItemsNeededspecList;
                    
                    Job_Spec__c PlateSpec6=new Job_Spec__c();
                    PlateSpec6.Name='Turn-Time';      PlateSpec6.Description__c=TurnTimeString;      PlateSpec6.Job__c=CustomJob.id;
                    insert PlateSpec6;
                    
                    
                    Job_Spec__c PlateSpec1=new Job_Spec__c();
                    PlateSpec1.Name='Quantity Needed';    PlateSpec1.Description__c=CustomQuantityNeeded;     PlateSpec1.Job__c=CustomJob.id;
                    insert PlateSpec1;
                    
                    
                    Job_Spec__c PlateSpec2=new Job_Spec__c();
                    PlateSpec2.Name='Provide Height and Width Measurements in Inches';
                    PlateSpec2.Description__c=CustomMeasurements;    PlateSpec2.Job__c=CustomJob.id;
                    insert PlateSpec2;
                    
                    Job_Spec__c PlateSpec3=new Job_Spec__c();
                    PlateSpec3.Name='Explain request in detail';      PlateSpec3.Description__c=Customrequest;    PlateSpec3.Job__c=CustomJob.id;
                    insert PlateSpec3;
                    
                    Job_Spec__c PlateSpec4=new Job_Spec__c();
                    PlateSpec4.Name='Explain, in detail, what signs/banners/etc. need to say';
                    PlateSpec4.Description__c=Customneedtosay;      PlateSpec4.Job__c=CustomJob.id;
                    insert PlateSpec4;
                    
                    Job_Spec__c PlateSpec5=new Job_Spec__c();
                    PlateSpec5.Name='Explain, in detail, where items will be installed';  PlateSpec5.Description__c=Customneedtogo;          PlateSpec5.Job__c=CustomJob.id;
                    insert PlateSpec5;
                    
                    if(!Test.isRunningTest()){  if(myfileattach.body != null ){
                        Job_Spec__c BillboardSpec11=new Job_Spec__c();
                        BillboardSpec11.Name='File';
                        BillboardSpec11.Description__c='Files & documents attached ';
                        BillboardSpec11.Job__c=CustomJob.id;
                        insert BillboardSpec11;
                        
                        Attachment SpecAttachment=new Attachment(parentId=BillboardSpec11.id,name=myfileattach.Name,body=myfileattach.body); //Create instance of Attachment and add fields to it
                        
                        insert SpecAttachment;
                        
                        
                        
                        //Insert ContentVersion
                        ContentVersion cVersion = new ContentVersion();
                        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                        cVersion.PathOnClient = SpecAttachment.Name;//File name with extention
                        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                        //cVersion.OwnerId = attach.OwnerId;//Owner of the file
                        cVersion.Title = SpecAttachment.Name;//Name of the file
                        cVersion.VersionData = SpecAttachment.Body;//File content
                        Insert cVersion;
                        
                        //After saved the Content Verison, get the ContentDocumentId
                        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
                        
                        //Insert ContentDocumentLink
                        ContentDocumentLink cDocLink = new ContentDocumentLink();
                        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                        cDocLink.LinkedEntityId = SpecAttachment.ParentId;//Add attachment parentId
                        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                        //  cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
                        Insert cDocLink;
                        
                        Attachment delAttach=[select id,name from Attachment where id=:SpecAttachment.Id];
                        
                        delete delAttach;
                        
                        SpecAttachment.body = null; // clears the viewstate
                        
                    }
                                              
                                             } 
                    
                    if(isTab)
                    {
                        PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                        pageRef.setRedirect(true);                        return pageRef;
                    }
                    
                    
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);                                      return pageRef;
                }  
                catch(Exception e)              {          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));                 return null;              }
                
                return null;
            }  
            
        }
        
        
        /*  *************************   added new form in Made To Order Request Form    ****************************************     */
        
        if(ShowMadeToOrder== True)
        {
            
            /*  if(Mqty.length()>2)
{
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum order quantity is XX. Adjust your quantity to the specified amount.'));
return null;
}*/
            if(string.valueof(pic.Max_Qty__c)!=null && string.valueof(pic.Max_Qty__c)<Mqty)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Quantity must be less than Max Quantity of Material Item'));
                return null;
            }
            
            
            try
            {
                
                Job__c CustomJob=new Job__c();
                
                CustomJob.Media_Types__c=NameMediatype.id;
                CustomJob.Schedule_Template__c=NameMadeToOrderScheduletype.id;
                CustomJob.JS_Client__c=clientcontact.Client__c;
                CustomJob.JS_Client_Contact__c=clientcontact.id;
                
                CustomJob.JobFormTypeValues__c='Made To Order';
                insert CustomJob;
                
                
                System.debug('******************************CustomJob.JobFormTypeValues__c**********************************'+CustomJob.JobFormTypeValues__c);
                
                
                //List<Job_Spec__c> MadeItemsCategoryListspecList=new list<Job_Spec__c>();
                
                /*Job_Spec__c MadeSpec1 =new Job_Spec__c();
MadeSpec1.Name='Items Category';
MadeSpec1.Job__c=CustomJob.id;
MadeSpec1.Description__c=MadeItemsCategory;
MadeItemsCategoryListspecList.add(MadeSpec1);

insert MadeSpec1;*/
                
                
                //   List<Job_Spec__c> MadeItemsListspecList=new list<Job_Spec__c>();
                
                Job_Spec__c MadeSpec2 =new Job_Spec__c();
                MadeSpec2.Name='Items';
                MadeSpec2.Job__c=CustomJob.id;
                MadeSpec2.Description__c=mapIndividualItems.get(MadeIndividualItemsNeeded);
                
                insert MadeSpec2;
                
                Job_Spec__c MadeSpec4=new Job_Spec__c();
                MadeSpec4.Name='Qty';    MadeSpec4.Description__c=Mqty;    MadeSpec4.Job__c=CustomJob.id;
                insert MadeSpec4;
                
                Job_Spec__c MadeSpec3=new Job_Spec__c();
                MadeSpec3.Name='Special Details';      MadeSpec3.Description__c=SpecialDetails;    MadeSpec3.Job__c=CustomJob.id;
                insert MadeSpec3;
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);                        return pageRef;
                }
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);                                      return pageRef;
            }  
            
            catch(Exception e)            {      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));                     return null;             }
            
            return null;
        }    
        
        
        
        /*  *************************   Store Business Card    ****************************************     */
        
        if(ShowStoreBusiness == True){
            
            if(string.isBlank(BusinessName))
            {
                if(string.isBlank(BusinessName))
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Name'));
                }
            }
            
            else
            {
                
                try
                {
                    
                    Job__c BusinessJob=new Job__c();
                    BusinessJob.Media_Types__c=NameMediatype.id;
                    BusinessJob.Schedule_Template__c=NameBusinessCardScheduletype.id; 
                    BusinessJob.JS_Client__c=clientcontact.Client__c;
                    BusinessJob.JS_Client_Contact__c=clientcontact.id;
                    
                    BusinessJob.JobFormTypeValues__c='Store Business Card';
                    insert BusinessJob;
                    
                    Job_Spec__c BusinessSpec1=new Job_Spec__c();
                    BusinessSpec1.Name='Name';
                    BusinessSpec1.Description__c=BusinessName;
                    BusinessSpec1.Job__c=BusinessJob.id;
                    insert BusinessSpec1;  
                    
                    
                    Job_Spec__c BusinessSpec2=new Job_Spec__c();
                    BusinessSpec2.Name='Title';
                    BusinessSpec2.Description__c=BusinessTitleString;
                    BusinessSpec2.Job__c=BusinessJob.id;
                    insert BusinessSpec2;
                    
                    
                    
                    Job_Spec__c BusinessSpec3=new Job_Spec__c();
                    BusinessSpec3.Name='Address';
                    BusinessSpec3.Description__c=clientcontact.Client__r.Billing_Street__c;
                    BusinessSpec3.Job__c=BusinessJob.id;
                    insert BusinessSpec3;
                    
                    Job_Spec__c BusinessSpec4=new Job_Spec__c();
                    BusinessSpec4.Name='City';
                    BusinessSpec4.Description__c=clientcontact.Client__r.Billing_City__c;
                    BusinessSpec4.Job__c=BusinessJob.id;
                    insert BusinessSpec4;
                    
                    Job_Spec__c BusinessSpec5=new Job_Spec__c();
                    BusinessSpec5.Name='State';
                    BusinessSpec5.Description__c=clientcontact.Client__r.Billing_State__c;
                    BusinessSpec5.Job__c=BusinessJob.id;
                    insert BusinessSpec5;
                    
                    Job_Spec__c BusinessSpec6=new Job_Spec__c();
                    BusinessSpec6.Name='Zip';
                    BusinessSpec6.Description__c=clientcontact.Client__r.Billing_Postal_Code__c;
                    BusinessSpec6.Job__c=BusinessJob.id;
                    insert BusinessSpec6;
                    
                    Job_Spec__c BusinessSpec7=new Job_Spec__c();
                    BusinessSpec7.Name='Phone';
                    BusinessSpec7.Description__c=clientcontact.Business_Phone__c;
                    BusinessSpec7.Job__c=BusinessJob.id;
                    insert BusinessSpec7;
                    
                    Job_Spec__c BusinessSpec8=new Job_Spec__c();
                    BusinessSpec8.Name='Fax';
                    BusinessSpec8.Description__c=clientcontact.Fax__c;
                    BusinessSpec8.Job__c=BusinessJob.id;
                    insert BusinessSpec8;
                    
                    Job_Spec__c BusinessSpec9=new Job_Spec__c();
                    BusinessSpec9.Name='Email';
                    BusinessSpec9.Description__c=clientcontact.Email__c;
                    BusinessSpec9.Job__c=BusinessJob.id;
                    insert BusinessSpec9;
                    
                    /* Job_Spec__c BusinessSpec10=new Job_Spec__c();
BusinessSpec10.Name='Store Logo';
BusinessSpec10.Description__c=BusinessStoreLogo;
BusinessSpec10.Job__c=BusinessJob.id;
insert BusinessSpec10;

Job_Spec__c BusinessSpec11=new Job_Spec__c();
BusinessSpec11.Name='Tire Care Logo';
BusinessSpec11.Description__c=BusinesskTireCareLogo;
BusinessSpec11.Job__c=BusinessJob.id;
insert BusinessSpec11;*/
                    
                    Job_Spec__c BusinessSpec10=new Job_Spec__c();
                    BusinessSpec10.Name=' Logo';
                    BusinessSpec10.Description__c=BusinessLogoString;
                    BusinessSpec10.Job__c=BusinessJob.id;
                    insert BusinessSpec10;
                    
                    
                    
                    Job_Spec__c BusinessSpec12=new Job_Spec__c();
                    BusinessSpec12.Name='Web Site';
                    BusinessSpec12.Description__c=Businesskwebsite;
                    BusinessSpec12.Job__c=BusinessJob.id;
                    insert BusinessSpec12;
                    
                    if(isTab)
                    {
                        PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                    
                    
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                catch(Exception e)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
                    return null;
                }
                
                return null;
            }    
            
        }
        
        
        /*  *************************   Corporate Business Card    ****************************************     */
        
        if(ShowCorporateBusiness == True)
        {
            
            /* if(string.isBlank(CorporatePhone))
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Phone'));
'(' Substring(phoneNumber,1,3) + ') ' + Substring(phoneNumber,4,3) + '-' + Substring(phoneNumber,7,4);
}*/
            
            
            
            
            if(string.isNotBlank(CorporatePhone))
            {
                
                String phoneNumber = CorporatePhone.replaceAll('[^0-9]','');
                
                if(phoneNumber.length() == 10 && phoneNumber.isNumeric()) 
                {
                    
                    CorporatePhone =   '(' + phoneNumber.SubString(0,3) + ') ' + phoneNumber.SubString(3, 6) + '-' + phoneNumber.SubString(6);
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter 10 digits Number only for Phone Ex: 1234567890'));
                    return null;
                    
                }
                
            }  
            
            
            if(string.isNotBlank(CorporateFax))
            {
                
                String FaxNumber = CorporateFax.replaceAll('[^0-9]','');
                
                
                if(FaxNumber.length() == 10 && FaxNumber.isNumeric()) 
                {
                    CorporateFax=   '(' + FaxNumber.SubString(0,3) + ') ' + FaxNumber.SubString(3, 6) + '-' + FaxNumber.SubString(6);
                }
                
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter 10 digits Number only for Fax Ex: 1234567890'));
                    return null;
                }
                
            }  
            
            if(string.isNotBlank(CorporateMobile))
            {
                
                String mobileNumber = CorporateMobile.replaceAll('[^0-9]','');
                
                
                if(mobileNumber.length() == 10 && mobileNumber.isNumeric()) 
                {
                    CorporateMobile =   '(' + mobileNumber.SubString(0,3) + ') ' + mobileNumber.SubString(3, 6) + '-' + mobileNumber.SubString(6);
                }
                
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter 10 digits Number only for Mobile Ex: 1234567890'));
                    return null;
                }
                
                
            }  
            
            // try{
            Job__c CorporateJob=new Job__c();
            CorporateJob.Media_Types__c=NameMediatype.id;
            CorporateJob.Schedule_Template__c=NameCorporateCardScheduletype.id;
            CorporateJob.JS_Client__c=clientcontact.Client__c;
            CorporateJob.JS_Client_Contact__c=clientcontact.id;
            CorporateJob.JobFormTypeValues__c='Corporate Business Card';
            insert CorporateJob;
            
            Job_Spec__c CorporateSpec1=new Job_Spec__c();
            CorporateSpec1.Name='Name';
            CorporateSpec1.Description__c=CorporateName;
            CorporateSpec1.Job__c=CorporateJob.id;
            insert CorporateSpec1;
            
            Job_Spec__c CorporateSpec2=new Job_Spec__c();
            CorporateSpec2.Name='Title';
            CorporateSpec2.Description__c=CorporateTitle;
            CorporateSpec2.Job__c=CorporateJob.id;
            insert CorporateSpec2;
            
            Job_Spec__c CorporateSpec21=new Job_Spec__c();
            CorporateSpec21.Name='Department';
            CorporateSpec21.Description__c=CorporateDepartment;
            CorporateSpec21.Job__c=CorporateJob.id;
            insert CorporateSpec21;
            
            
            Job_Spec__c CorpoarateSpec3=new Job_Spec__c();
            CorpoarateSpec3.Name='Address';
            CorpoarateSpec3.Job__c=CorporateJob.id;
            CorpoarateSpec3.Description__c=selectAddress;
            
            insert CorpoarateSpec3;
            
            
            Job_Spec__c CorpoarateSpec11=new Job_Spec__c();
            CorpoarateSpec11.Name='Company';
            CorpoarateSpec11.Job__c=CorporateJob.id;
            CorpoarateSpec11.Description__c=SelectCompany;
            
            insert CorpoarateSpec11;
            
            Job_Spec__c CorporateSpec4=new Job_Spec__c();
            CorporateSpec4.Name='Phone';
            CorporateSpec4.Description__c=CorporatePhone;
            CorporateSpec4.Job__c=CorporateJob.id;
            insert CorporateSpec4;
            
            
            Job_Spec__c CorporateSpec5=new Job_Spec__c();
            
            CorporateSpec5.Name='Fax';
            CorporateSpec5.Description__c=CorporateFax;
            CorporateSpec5.Job__c=CorporateJob.id;
            insert CorporateSpec5;
            
            Job_Spec__c CorporateSpec6=new Job_Spec__c();
            
            CorporateSpec6.Name='Email';
            CorporateSpec6.Description__c=CorporateEmail;
            CorporateSpec6.Job__c=CorporateJob.id;
            insert CorporateSpec6;
            
            Job_Spec__c CorporateSpec7=new Job_Spec__c();
            CorporateSpec7.Name='Mobile';
            CorporateSpec7.Description__c=CorporateMobile;
            CorporateSpec7.Job__c=CorporateJob.id;
            insert CorporateSpec7;
            
            
            Job_Spec__c CorpoarateSpec8=new Job_Spec__c();
            CorpoarateSpec8.Name='Web Site';
            CorpoarateSpec8.Job__c=CorporateJob.id;
            CorpoarateSpec8.Description__c=SelectCorporate;
            
            insert CorpoarateSpec8;
            
            Job_Spec__c CorporateSpec9=new Job_Spec__c();
            CorporateSpec9.Name='ICE Chat';
            CorporateSpec9.Description__c=CorporateYahooIM;
            CorporateSpec9.Job__c=CorporateJob.id;
            insert CorporateSpec9;
            
            
            Job_Spec__c CorpoarateSpec10=new Job_Spec__c();
            CorpoarateSpec10.Name='Logo';
            CorpoarateSpec10.Job__c=CorporateJob.id;
            CorpoarateSpec10.Description__c=SelectCorporateLogo;
            
            insert CorpoarateSpec10;
            
            
            /* Business Card 2.0 Saving as attachment to job*/
            
            //PageReference pdf = Page.LovesBussinessCardTemplate;
            //pdf.getParameters().put('jobid',CorporateJob.id);
            
            attachment.Name = 'BackOptionImage';
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = CorporateJob.id;
            attachment.IsPrivate = false;
            if(attachment.body != null){
                insert attachment;
                
                
                
                //Insert ContentVersion
                ContentVersion cVersion = new ContentVersion();
                cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                cVersion.PathOnClient = attachment.Name;//File name with extention
                cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                //cVersion.OwnerId = attach.OwnerId;//Owner of the file
                cVersion.Title = attachment.Name;//Name of the file
                cVersion.VersionData = attachment.Body;//File content
                Insert cVersion;
                
                //After saved the Content Verison, get the ContentDocumentId
                Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
                
                //Insert ContentDocumentLink
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                cDocLink.LinkedEntityId = attachment.ParentId;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                // cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
                Insert cDocLink;
                
                Attachment delAttach= [select id,name from Attachment where id=:attachment.Id];
                
                delete delAttach;
            }       
            
            
            //Database.executeBatch(new LovesBusinessCardTemplateBatchClass(CorporateJob.id), 1);
            
            
            if(isTab)
            {
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
            }
            
            PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
            pageRef.setRedirect(true);
            return pageRef;
            
            /*}

catch(Exception e)
{
//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, string.valueof(e))); 
return null;
}*/
            
            
            return null;
        }    
        
        
        
        
        
        
        /*    *************************   Billboard Repair Request    ****************************************     */
        if(ShowBillboardRepairs == True)
        {
            
            try
            {
                
                Job__c BillboardJob=new Job__c();
                
                BillboardJob.Media_Types__c=NameBillboardMediatype.id;
                BillboardJob.Schedule_Template__c=NameBillboardScheduletype.id;
                BillboardJob.JobFormTypeValues__c='Billboard Repair Request';
                BillboardJob.JS_Client__c=clientcontact.Client__c;
                BillboardJob.JS_Client_Contact__c=clientcontact.id;
                
                insert BillboardJob;
                
                Job_Spec__c BillboardSpec1=new Job_Spec__c();
                BillboardSpec1.Name='District';
                BillboardSpec1.Description__c=clientcontact.Client__r.Dummy_Picklist_1__c;
                BillboardSpec1.Job__c=BillboardJob.id;
                insert BillboardSpec1;
                
                
                Job_Spec__c BillboardSpec123=new Job_Spec__c();
                BillboardSpec123.Name='Billboard';
                BillboardSpec123.Description__c=BBList;
                BillboardSpec123.Job__c=BillboardJob.id;
                insert BillboardSpec123;
                
                Job_Spec__c BillboardSpec2=new Job_Spec__c();
                BillboardSpec2.Name='Store Name';
                BillboardSpec2.Description__c=clientcontact.Client__r.Name;
                BillboardSpec2.Job__c=BillboardJob.id;
                insert BillboardSpec2;
                
                Job_Spec__c BillboardSpec3=new Job_Spec__c();
                BillboardSpec3.Name='Requestor';
                BillboardSpec3.Description__c=clientcontact.name;
                BillboardSpec3.Job__c=BillboardJob.id;
                insert BillboardSpec3;
                
                List<Job_Spec__c> BillboardSigntypeSpecList =new list<Job_Spec__c>();
                if( BillboardSigntypeList.size() != null && BillboardSigntypeList.size() >0 ){
                    for(string Billsign:BillboardSigntypeList ){
                        Job_Spec__c BillboardSpec4=new Job_Spec__c();
                        BillboardSpec4.Name='Sign type';
                        BillboardSpec4.Job__c=BillboardJob.id;
                        BillboardSpec4.Description__c=Billsign;
                        BillboardSigntypeSpecList.add(BillboardSpec4);
                        
                    }
                }
                insert BillboardSigntypeSpecList;
                
                Job_Spec__c BillboardSpec5=new Job_Spec__c();
                BillboardSpec5.Name='Location';
                BillboardSpec5.Description__c=BBLName;
                BillboardSpec5.Job__c=BillboardJob.id;
                insert BillboardSpec5;
                
                List<Job_Spec__c> BillboardServiceIssuesSpecList =new list<Job_Spec__c>();
                if(BillboardServiceIssuesList.size() >0 ){
                    for(string BillService:BillboardServiceIssuesList  ){
                        Job_Spec__c BillboardSpec6=new Job_Spec__c();
                        BillboardSpec6.Name='Service Issues';
                        BillboardSpec6.Job__c=BillboardJob.id;
                        BillboardSpec6.Description__c=BillService;
                        BillboardServiceIssuesSpecList.add(BillboardSpec6);
                        
                    }
                }
                insert BillboardServiceIssuesSpecList ;
                
                
                Job_Spec__c BillboardSpec7=new Job_Spec__c();
                BillboardSpec7.Name='Currently Reads';
                BillboardSpec7.Description__c=BillboardReads;
                BillboardSpec7.Job__c=BillboardJob.id;
                insert BillboardSpec7;
                
                
                Job_Spec__c BillboardSpec8=new Job_Spec__c();
                BillboardSpec8.Name='Should Read';
                BillboardSpec8.Description__c=Billboardshouldread;
                BillboardSpec8.Job__c=BillboardJob.id;
                insert BillboardSpec8;
                
                
                List<Job_Spec__c> BillboardLightSpecList=new list<Job_Spec__c>();
                if(BillboardLightList.size() >0 ){
                    for(string BillLight: BillboardLightList){
                        Job_Spec__c BillboardSpec9=new Job_Spec__c();
                        BillboardSpec9.Name='Lighting';
                        BillboardSpec9.Job__c=BillboardJob.id;
                        BillboardSpec9.Description__c=BillLight;
                        BillboardLightSpecList.add(BillboardSpec9);
                        
                    }
                }
                insert BillboardLightSpecList;
                
                Job_Spec__c BillboardSpec10=new Job_Spec__c();
                BillboardSpec10.Name='What time(s) are the lights being reported out';
                BillboardSpec10.Description__c=Billboardlightout;
                BillboardSpec10.Job__c=BillboardJob.id;
                insert BillboardSpec10;
                
                
                
                Job_Spec__c BillboardSpec12=new Job_Spec__c();
                BillboardSpec12.Name='Notes';
                BillboardSpec12.Description__c=BillboardNotes;
                BillboardSpec12.Job__c=BillboardJob.id;
                insert BillboardSpec12;
                
                
                if(!Test.isRunningTest()){  if(myfile.body != null ){
                    Job_Spec__c BillboardSpec11=new Job_Spec__c();
                    BillboardSpec11.Name='File';
                    BillboardSpec11.Description__c='Files & documents attached';
                    BillboardSpec11.Job__c=BillboardJob.id;
                    insert BillboardSpec11;
                    
                    Attachment SpecAttachment=new Attachment(parentId=BillboardSpec11.id,name=myfile.Name,body=myfile.body); //Create instance of Attachment and add fields to it
                    
                    insert SpecAttachment;
                    
                    //Insert ContentVersion
                    ContentVersion cVersion = new ContentVersion();
                    cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                    cVersion.PathOnClient = SpecAttachment.Name;//File name with extention
                    cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                    //cVersion.OwnerId = attach.OwnerId;//Owner of the file
                    cVersion.Title = SpecAttachment.Name;//Name of the file
                    cVersion.VersionData = SpecAttachment.Body;//File content
                    Insert cVersion;
                    
                    //After saved the Content Verison, get the ContentDocumentId
                    Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
                    
                    //Insert ContentDocumentLink
                    ContentDocumentLink cDocLink = new ContentDocumentLink();
                    cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                    cDocLink.LinkedEntityId = SpecAttachment.ParentId;//Add attachment parentId
                    cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                    //  cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
                    Insert cDocLink;
                    
                    Attachment delAttach= [select id,name from Attachment where id=:SpecAttachment.Id];
                    
                    delete delAttach;
                    
                    
                    
                    SpecAttachment.body = null; // clears the viewstate
                    
                }
                                          
                                         }  
                
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
            }
            catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
                return null;
            }
            
            return null;
        }    
        
        
        /*    *************************   Store Orders    ****************************************     */
        
        if(ShowAddcartSection==True)
        {
            
            
            for(Id  item:rolewraps2.keyset()) 
            {
                
                if(string.valueof(roleWraps2.get(Item).Quantity).length()>2)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum order quantity is XX. Adjust your quantity to the specified amount.'));
                    return null;
                }
                if(roleWraps2.get(Item).Quantity > roleWraps2.get(Item).Mi.Max_Qty__c)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Quantity must be less than Max Quantity of related Material Item'));
                    return null;
                }
                
            }
            
            
            try
            {
                
                Job__c StoreJob=new Job__c();
                StoreJob.Media_Types__c=NameStoreMediatype.id;
                StoreJob.Schedule_Template__c=NameStoreScheduletype.id;
                StoreJob.JobFormTypeValues__c='Store Supply Orders';
                StoreJob.JS_Client__c=clientcontact.Client__c;
                StoreJob.JS_Client_Contact__c=clientcontact.id;
                StoreJob.Job_Description__c = 'created from vf pages';
                
                
                
                insert StoreJob;
                string jobid=StoreJob.id;
                String StoreJobname=[select id, name from Job__c where id =:jobid limit 1].name;
                string prodname='PE';
                list<Production_Estimate__c> ProdEstimateList =new List<Production_Estimate__c>();
                
                for(Id  item:rolewraps2.keyset()) {
                    Production_Estimate__c ProdEstimate =new Production_Estimate__c ();
                    
                    
                    ProdEstimate.Job__c =StoreJob.id;
                    ProdEstimate.Material_Item__c =roleWraps2.get(Item).Mi.id;
                    ProdEstimate.Name=prodname + '-' + roleWraps2.get(Item).Mi.name;  //+ StoreJobname; //+ ' - '
                    ProdEstimate.Calc_Unit__c=roleWraps2.get(Item).MI.Calc_Unit__c;
                    ProdEstimate.Quantity__c= roleWraps2.get(Item).Quantity;
                    ProdEstimate.Qty_Up__c=1;
                    if(roleWraps2.get(Item).Mi.Calc_Unit__c=='Each')
                    {
                        ProdEstimate.EachQtyUpforUsed__c=(roleWraps2.get(Item).Quantity/1);
                    }
                    else if(roleWraps2.get(Item).Mi.Calc_Unit__c=='Sheet')
                    {
                        ProdEstimate.SheetQtyUpforUsed__c=(roleWraps2.get(Item).Quantity/1);
                    }
                    
                    
                    
                    ProdEstimateList.add(ProdEstimate);
                }
                insert ProdEstimateList ;
                
                if(isTab)
                {
                    PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContactLightning');//('/apex/MaterialLineDetailpage?id='+Strid);
                    pageRef.setRedirect(true);                    return pageRef;
                }
                
                PageReference pageRef = new PageReference('/apex/DisplayJobsforClientContact');//('/apex/MaterialLineDetailpage?id='+Strid);
                pageRef.setRedirect(true);
                return pageRef;
                
            }
            catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e.getMessage()));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please wait for a few seconds and then click on "Order" Button'));
                return null;
            }
            
            return null;
        }    
        
        
        return null;
    }
    
    Public Pagereference Cancel(){
        PageReference pageRef = new PageReference('/apex/StorefrontJobRequestForm');//('/apex/MaterialLineDetailpage?id='+Strid);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    Public Pagereference Back(){
        PageReference pageRef = new PageReference('/home/home.jsp');//('/apex/MaterialLineDetailpage?id='+Strid);
        pageRef.setRedirect(true);
        return pageRef;
        
        
        
    }
    
    Public void ShowItems(){
        
        
        
        roleWraps.clear();
        
        MediaIdList = new List<string>();
        Map<string,string> MediaNameToRefIdMap= new Map<string,string>();
        List<string> MediaNameList= new List<string>();
        
        string MIname='%'+MaterialItemNameString+'%';
        // string MIdesc = '%' + MaterialItemDescString + '%';
        
        //   if (MIdesc == null) {
        
        if (MIname != null && MaterialTypeString != null) {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where (Name like: MIname OR Description__c like: MIname) AND Type__c = : MaterialTypeString AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC];
        } else if (MIname == null && MaterialTypeString != null) {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Type__c = : MaterialTypeString AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
        } else if (MIname != null && MaterialTypeString == null) {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where (Name like: MIname OR Description__c like: MIname) AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC];
        } 
        
        /*} else {
if (MIname != null && MaterialTypeString != null && MIdesc != null) {
MaterialItems = [select id, name, Calc_Unit__c, Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Name like: MIname AND Type__c = : MaterialTypeString AND Description__c like: MIdesc AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC];
} else if (MIname == null && MaterialTypeString != null && MIdesc != null) {
MaterialItems = [select id, name, Calc_Unit__c, Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Type__c = : MaterialTypeString AND Description__c like: MIdesc AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
} else if (MIname != null && MaterialTypeString == null && MIdesc != null) {
MaterialItems = [select id, name, Calc_Unit__c, Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Name like: MIname AND Description__c like: MIdesc AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC];
}
}*/
        
        
        
        
        
        
        Set<Id> selectedEntries = new  Set<Id> ();
        for(Id  Item:roleWraps2.keyset()){
            selectedEntries.add(Item);
        }
        
        Set<Id> contentDocumentIdSet =new Set<Id>();
        Map<Id,String> contentDocMap=new Map<Id,String>();
        if(!MaterialItems.isEmpty()){
            
            for(Material_Item__c MI: MaterialItems){
                for(ContentDocumentLink cdl: MI.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
            
            //List<ContentVersion> cvList =[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC];
            //return cvList;
            
            for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
                if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                    contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
            }
            
            
            for(Material_Item__c MI: MaterialItems)
            {
                
                MIWrapper rw=new MIWrapper();
                rw.MI=MI;
                rw.checked=false;
                rw.ContentVersionId='';
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
            
            
            
            for(Id referenceId : rolewraps.keySet()){
                
                string MediaName = rolewraps.get(referenceId).mi.Name;
                MediaNameToRefIdMap.put(MediaName,referenceId);
                MediaNameList.add(MediaName);
            }
            system.debug(MediaNameList);
            MediaNameList.sort();
            system.debug(MediaNameList);
            for(string MName : MediaNameList){
                if(MediaNameToRefIdMap.containsKey(MName))
                    MediaIdList.add(MediaNameToRefIdMap.get(MName));
            }
            system.debug(MediaIdList);
        }    
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Items found'));
        
        
        
        
        
        
    }
    public void AddToCart(){
        
        // This function runs when a user hits "Add To Cart" button 
        Map<string,string> MediaNameToRefIdMap= new Map<string,string>();
        List<string> MediaNameList= new List<string>();
        
        for(Id Item: roleWraps.keyset()){
            if(roleWraps.get(Item).checked == true){
                rolewraps2.put(Item,roleWraps.get(Item));    roleWraps.remove(Item);   MediaIdList.clear();
                
                
                
            }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Select any Item '));}
        }
        if(rolewraps.size()>0){
            
            for(Id referenceId : rolewraps.keySet()){
                
                string MediaName = rolewraps.get(referenceId).mi.Name;
                MediaNameToRefIdMap.put(MediaName,referenceId);         MediaNameList.add(MediaName);
            }
            system.debug(MediaNameList);
            MediaNameList.sort();
            system.debug(MediaNameList);
            for(string MName : MediaNameList){
                if(MediaNameToRefIdMap.containsKey(MName))
                    MediaIdList.add(MediaNameToRefIdMap.get(MName));
            }
            system.debug(MediaIdList);
        }    
        
        
        if(rolewraps2.size()>0)
            SecondWrapper=True;
        
    }
    
    public PageReference removeFromCart(){
        
        // This function runs when a user hits "remove" on an item in the "Selected Carts" section
        
        for(Id Item : roleWraps2.keyset()){
            if(Item ==toUnselect){
                rolewraps2.remove(Item);                break;
            }
            
        }
        
        return null;
    }
    
    Public pagereference ViewToCart(){
        if(rolewraps2.size() > 0){
            
            ShowAddcartSection=True;        ShowStoreSupplies=false;        ShowSavebutton=true;        ShowCancelbutton=false;        ShowCartBackbutton=True;}
        
        
        
        return null;
    }
    
    Public pagereference CancelfromCart(){
        ShowAddcartSection=False;
        ShowStoreSupplies=True;
        ShowSavebutton=False;
        ShowCancelbutton=True;
        ShowCartBackbutton=false;
        
        return null;
    }
    
    
    // End of Wrapper Class 
    
    
    
    // Start Wrapper Class 
    public class MIWrapper
    {
        public Material_Item__c MI{get;set;}
        public Boolean checked{get;set;}
        public String  ContentVersionId {get;set;}
        public integer quantity{get; set;}
        
        
        public  MIWrapper(){
            quantity=1;
        }   
        
        
        
        
        
    }
    // End of Wrapper Class
    
    
    
}