public class StoreFrontComponentExt {
    
    /***************************************** Store Order Type Picklist values ******************************************/
    
    @AuraEnabled
    public static boolean ShowStoreOrderRequestTypes()
    {
        user u= new user();
        Client_Contact__c  CCon=new Client_Contact__c();
        
        u= [select firstname ,Username,Id, Profile.Name,UserRole.Name  from user where id=:userinfo.getuserid() limit 1];
        CCon=[Select id,Client__r.name,UserName__c,Client_Contact_Role__c from Client_Contact__c where UserName__c =:u.Username limit 1];
        
        boolean ShowStoreOrders=False;
        //   if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG') // old if
        
        if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG' && u.UserRole.Name == 'General Manager' || u.UserRole.Name == 'Restaurant Manager'|| u.UserRole.Name == 'Tire Shop Manager')
        {  
            ShowStoreOrders=True;
        }
        return ShowStoreOrders;
    }
    
    /************************************* District/Division Order Type Picklist Values *****************************************************/
    
    @AuraEnabled
    public static boolean ShowDistRequestTypeValue()
    {
        user u= new user();
        Client_Contact__c  CCon=new Client_Contact__c();
        String clientname;
        boolean ShowMultiStoreOrder=False;
        
        u= [select firstname ,Username,Id, Profile.Name,UserRole.Name  from user where id=:userinfo.getuserid() limit 1];
        CCon=[Select id, Client__r.name,UserName__c  from Client_Contact__c where UserName__c =:u.Username limit 1];
        clientname=CCon.Client__r.Name;
        // if(clientname.contains('District') || clientgetunserrolesname.contains('Division') || clientname.contains('Corporate')){ // old if
        if(clientname.contains('District') || clientname.contains('Division') || u.UserRole.Name == 'District Manager' || u.UserRole.Name == 'Division Director' || u.UserRole.Name == 'Division Merch Manager'){
            ShowMultiStoreOrder=True;
        }
        return ShowMultiStoreOrder;
    }
    
    
    /***************************************** Corporate Order Type Picklist option Show/Hide ******************************************/
    
    @AuraEnabled
    public static boolean ShowCooperateRequestTypes()
    {
        user u= new user();
        String UserRole;
        u= [select firstname ,Username,Id, Profile.Name,UserRole.Name from user where id=:userinfo.getuserid() limit 1];
        boolean ShowCooperateRequestTypes=False;
        UserRole=u.UserRole.Name;
        //if(UserRole == 'Corporate' || UserRole == 'Fleet Solutions' || UserRole == 'Trillium CNG' || UserRole == 'District Manager' || UserRole == 'Division Director' || UserRole == 'Division Merch Manager') //old if
        if(UserRole == 'Corporate' || UserRole == 'Fleet Solutions' || UserRole == 'Trillium CNG')      
        {
            ShowCooperateRequestTypes=True;
        }
        return ShowCooperateRequestTypes;
    }
    
    /***************************************** Corporate Order Type Picklist Values Show/Hide ******************************************/
    
    @AuraEnabled
    public static List<String> getCorpRequestTypes()
    {
        List<String> CorpRequestTypes=new List<String>();
        user u= new user();
        Client_Contact__c  CCon=new Client_Contact__c();
        
        u= [select firstname ,Username,Id, Profile.Name,UserRole.Name  from user where id=:userinfo.getuserid()  limit 1];
        CCon=[Select id, Client__r.name,UserName__c  from Client_Contact__c where UserName__c =:u.Username limit 1];
        // if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG')
        if(CCon.Client__r.name!='Fleet Sales' && CCon.Client__r.name!='Trillium CNG' && u.UserRole.Name == 'Corporate')
        {
            CorpRequestTypes.add('Corporate Name Tag');
            CorpRequestTypes.add('Corporate Office Nameplate');
            CorpRequestTypes.add('Corporate Business Cards');
        }        
        
        // CorpRequestTypes.add('Corporate Business Cards'); //this line we adding inside below for loop
        
        if(CCon.Client__r.name=='Fleet Sales' )
        {
            CorpRequestTypes.add('Corporate Business Cards'); // This line added newly
            CorpRequestTypes.add('Sales/Marketing Order'); //FleetSalesOrder Form
        }
        
        if(CCon.Client__r.name=='Trillium CNG')
        {
            CorpRequestTypes.add('Corporate Business Cards'); // This line added newly
            CorpRequestTypes.add('Corporate Office Nameplate');
            CorpRequestTypes.add('Trillium Energy'); // Trillium CNG Form
        }
        return CorpRequestTypes;
    }
    
    @AuraEnabled
    public static string getunserroles(){
        
        user usrrcd= [select id,name,UserRole.Name,IsActive from user where isactive = true and id =: userinfo.getUserId() limit 1];
        if(usrrcd.UserRole.Name == 'General Manager' || usrrcd.UserRole.Name == 'Restaurant Manager' || usrrcd.UserRole.Name == 'Tire Shop Manager'){
            return 'Store Order Type';
        }
        else if(usrrcd.UserRole.Name =='Corporate'){
            return 'Corporate';
        }
        else if(usrrcd.UserRole.Name == 'District Manager' || usrrcd.UserRole.Name == 'Division Director' || usrrcd.UserRole.Name == 'Division Merch Manager ') {
            return 'Division Or District Order';
        }
        else{
            return '';
        }
    }
    
    
    /* @AuraEnabled
public static List<String> getBillboardList(){

List<user> lstUser= [select firstname,Username,Id,Profile.Name from user where id=:userinfo.getuserid()];
Client_Contact__c clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser[0].Username];
System.debug('ClientContact'+clientcontact.name);
System.debug('Client'+clientcontact.Client__r.Name);

String clientname=clientcontact.Client__r.Name;

List<String> BillboardList= new List<String>();

if(clientname.contains('Store')){
for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c]){
BillboardList.add(p.name);
}
}

if(clientname.contains('District')){
for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c]){
BillboardList.add(p.name);
}
}

if(clientname.contains('Division')){
for(Billboard__c  p : [Select id ,name ,Title__c,Client_Name__c,Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c]){
BillboardList.add(p.name);
}
}

return BillboardList;
}


// This method is used to retrieve all Location into dropdown list
@AuraEnabled
public static List<string> getBBLocation()
{  
List<user> lstUser= [select firstname,Username,Id,Profile.Name from user where id=:userinfo.getuserid()];
Client_Contact__c clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser[0].Username];
System.debug('ClientContact'+clientcontact.name);
System.debug('Client'+clientcontact.Client__r.Name);
List<string> optionList = new List<string>();
for (Billboard__c gld : [Select id ,name ,Location__c,Client_Name__c FROM Billboard__c where Client_Name__c=:clientcontact.Client__c Order By Name])
{  
optionList.add(gld.Location__c);  
}
return optionList;  
}  
// End of method getBBLocation*/
    
    // Made To Order form Items Needed Picklist value
    @AuraEnabled
    Public static map<string,string> ItemsInd(String MadeItemsCategory)
    {
        map<string,string> mapIndividualItems = new map<string,string>();
        Set<string> Storegrps=new Set<string>();
        List<user> lstUser= [select firstname,Username,Id,Profile.Name from user where id=:userinfo.getuserid()];
        Client_Contact__c clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser[0].Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        
        if(clientcontact.Client__r.Client_Group__c!=null) {
            
            string fruit = clientcontact.Client__r.Client_Group__c;
            string[] split = fruit.Split(';');
            
            for(string item :split)
            {
                Storegrps.add(item);
            }
        }
        
        string mto='Made to Order';
        for(Material_Item__c  jmi : [select id,name,Type__c,Max_Qty__c,Category__c from Material_Item__c where Type__c=:MadeItemsCategory and Category__c=:mto  AND Store_Type__c IN: Storegrps limit 1000 ])
        {
            mapIndividualItems.put(jmi.id,jmi.name);
        }
        return mapIndividualItems;
    }
    
    // Made To Order form Selected Items Image preview
    @AuraEnabled
    Public static List<object> ItemsPic(string MadeIndividualItemsNeeded)
    {
        Set<Id> contentDocumentIdSet =new Set<Id>();
        String MadeToOrderpicId='';
        String DisplayItemURL='/sfc/servlet.shepherd/version/download/';
        List<object> ItemList=new List<object>();
        if(string.isNotBlank(MadeIndividualItemsNeeded))
        {
            List<Material_Item__c> pic = [select id,name,Type__c,Max_Qty__c,File_Photo__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) from Material_Item__c where id=:MadeIndividualItemsNeeded];
            
            for(ContentDocumentLink cdl: pic[0].ContentDocumentLinks){
                contentDocumentIdSet.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> cvList=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC Limit 1];
            if(cvList.size()>0)
            {
                MadeToOrderpicId=DisplayItemURL+cvList[0].Id;
                ItemList.add(MadeToOrderpicId);
            }
            
            ItemList.add(pic[0].Max_Qty__c);
        }
        return ItemList;
    }
    
    @AuraEnabled
    public static string SaveRequestForm(string requestType,List<string> Formvalues,List<string> ListBBSignType,List<string> ListBBRServiceIssue,List<string> ListBBLight,String fileName, String base64Data, String contentType, List<string> ListStoreNameTagLogo, List<string> ListCOItemsNeeded, List<string> ListCopNameTagLogo, List<string> ListCopOfficeNameType)
    {
        if(base64Data!=null){
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        }
        
        system.debug('>>>>>>>>fileName>>>>>>>>>>>>>>>>>'+fileName);
        system.debug('>>>>>>>>base64Data>>>>>>>>>>>>>>>>>'+base64Data);
        system.debug('>>>>>>>>contentType>>>>>>>>>>>>>>>>>'+contentType);
        
        List<user> lstUser= [select firstname,Username,Id,Profile.Name from user where id=:userinfo.getuserid()];
        
        Client_Contact__c clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser[0].Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        
        
        Media_Type__c NameMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
        
        /******************************************************* Store Business Card Values ******************************************************************/  
        
        if(requestType=='Store Business Cards')
        {
            try{
                Schedule_Template__c NameBusinessCardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Business Card' AND Media_Types__r.name='Print' limit 1];
                
                Job__c BusinessJob=new Job__c();
                BusinessJob.Media_Types__c=NameMediatype.id;
                BusinessJob.Schedule_Template__c=NameBusinessCardScheduletype.id;
                BusinessJob.JS_Client__c=clientcontact.Client__c;
                BusinessJob.JS_Client_Contact__c=clientcontact.id;
                
                BusinessJob.JobFormTypeValues__c='Store Business Card';
                insert BusinessJob;
                
                Job_Spec__c BusinessSpec1=new Job_Spec__c();
                BusinessSpec1.Name='Name';
                BusinessSpec1.Description__c=Formvalues[0];
                BusinessSpec1.Job__c=BusinessJob.id;
                BusinessSpec1.Sort_Order__c=1;
                insert BusinessSpec1;  
                
                Job_Spec__c BusinessSpec2=new Job_Spec__c();
                BusinessSpec2.Name='Title';
                BusinessSpec2.Description__c=Formvalues[1];
                BusinessSpec2.Job__c=BusinessJob.id;
                BusinessSpec2.Sort_Order__c=2;
                insert BusinessSpec2;
                
                Job_Spec__c BusinessSpec3=new Job_Spec__c();
                BusinessSpec3.Name='Address';
                BusinessSpec3.Description__c=clientcontact.Client__r.Billing_Street__c;
                BusinessSpec3.Job__c=BusinessJob.id;
                BusinessSpec3.Sort_Order__c=3;
                insert BusinessSpec3;
                
                Job_Spec__c BusinessSpec4=new Job_Spec__c();
                BusinessSpec4.Name='City';
                BusinessSpec4.Description__c=clientcontact.Client__r.Billing_City__c;
                BusinessSpec4.Job__c=BusinessJob.id;
                BusinessSpec4.Sort_Order__c=4;
                insert BusinessSpec4;
                
                Job_Spec__c BusinessSpec5=new Job_Spec__c();
                BusinessSpec5.Name='State';
                BusinessSpec5.Description__c=clientcontact.Client__r.Billing_State__c;
                BusinessSpec5.Job__c=BusinessJob.id;
                BusinessSpec5.Sort_Order__c=5;
                insert BusinessSpec5;
                
                Job_Spec__c BusinessSpec6=new Job_Spec__c();
                BusinessSpec6.Name='Zip';
                BusinessSpec6.Description__c=clientcontact.Client__r.Billing_Postal_Code__c;
                BusinessSpec6.Job__c=BusinessJob.id;
                BusinessSpec6.Sort_Order__c=6;
                insert BusinessSpec6;
                
                Job_Spec__c BusinessSpec7=new Job_Spec__c();
                BusinessSpec7.Name='Phone';
                BusinessSpec7.Description__c=clientcontact.Business_Phone__c;
                BusinessSpec7.Job__c=BusinessJob.id;
                BusinessSpec7.Sort_Order__c=7;
                insert BusinessSpec7;
                
                Job_Spec__c BusinessSpec8=new Job_Spec__c();
                BusinessSpec8.Name='Fax';
                BusinessSpec8.Description__c=clientcontact.Fax__c;
                BusinessSpec8.Job__c=BusinessJob.id;
                BusinessSpec8.Sort_Order__c=8;
                insert BusinessSpec8;
                
                Job_Spec__c BusinessSpec9=new Job_Spec__c();
                BusinessSpec9.Name='Email';
                BusinessSpec9.Description__c=clientcontact.Email__c;
                BusinessSpec9.Job__c=BusinessJob.id;
                BusinessSpec9.Sort_Order__c=9;
                insert BusinessSpec9;
                
                Job_Spec__c BusinessSpec10=new Job_Spec__c();
                BusinessSpec10.Name=' Logo';
                BusinessSpec10.Description__c=Formvalues[2];
                BusinessSpec10.Job__c=BusinessJob.id;
                BusinessSpec10.Sort_Order__c=10;
                insert BusinessSpec10;
                
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }  
        
        /******************************************************* Store Name Tag Values *********************************************************************/
        
        if(requestType=='Store Name Tag')
        {
            try{
                
                Schedule_Template__c NameTagScheduletype=[Select id,name,Media_Types__c from Schedule_Template__c where name ='Name Tag' AND Media_Types__r.name='Print' limit 1];
                
                Job__c StoreNameTagJob=new Job__c();
                StoreNameTagJob.Media_Types__c=NameMediatype.id;
                StoreNameTagJob.Schedule_Template__c=NameTagScheduletype.id;
                StoreNameTagJob.JS_Client__c=clientcontact.Client__c;
                StoreNameTagJob.JS_Client_Contact__c=clientcontact.id;
                StoreNameTagJob.JobFormTypeValues__c='Name Tag Request';
                insert StoreNameTagJob;
                
                List<Job_Spec__c> TagSpecList=new list<Job_Spec__c>();
                integer i=4;
                if(ListStoreNameTagLogo.size() >0 ){
                    for(string tagdesc:ListStoreNameTagLogo){
                        Job_Spec__c tagspec5 =new Job_Spec__c();
                        TagSpec5.Name='Logo';
                        TagSpec5.Job__c=StoreNameTagJob.id;
                        TagSpec5.Description__c=tagdesc;
                        TagSpec5.Sort_Order__c=i+1;
                        TagSpecList.add(TagSpec5);
                    }
                }
                insert TagSpecList;
                
                Job_Spec__c TagSpec4=new Job_Spec__c();
                TagSpec4.Name='Year of Hire';
                TagSpec4.Description__c=Formvalues[3];
                TagSpec4.Job__c=StoreNameTagJob.id;
                TagSpec4.Sort_Order__c=4;
                insert TagSpec4;
                
                
                Job_Spec__c TagSpec3=new Job_Spec__c();
                TagSpec3.Name='Last Name';
                TagSpec3.Description__c=Formvalues[2];
                TagSpec3.Job__c=StoreNameTagJob.id;
                TagSpec3.Sort_Order__c=3;
                insert TagSpec3;
                
                Job_Spec__c TagSpec2=new Job_Spec__c();
                TagSpec2.Name='First Name';
                TagSpec2.Description__c=Formvalues[1];
                TagSpec2.Job__c=StoreNameTagJob.id;
                TagSpec2.Sort_Order__c=2;
                insert TagSpec2;
                
                Job_Spec__c TagSpec1=new Job_Spec__c();
                TagSpec1.Name='Title';
                TagSpec1.Description__c=Formvalues[0];
                TagSpec1.Job__c=StoreNameTagJob.id;
                TagSpec1.Sort_Order__c=1;
                insert TagSpec1;
                
                
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }
        
        /************************************************* Billboard/Dot Service Request Form Values ****************************************************/
        
        /* if(requestType=='Billboard Repairs')
{
try{
Media_Type__c NameBillboardMediatype=[Select id ,name from Media_Type__c where name='Outdoor' limit 1];
Schedule_Template__c NameBillboardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Billboard Repair' AND Media_Types__r.name='Outdoor' limit 1];

Job__c BillboardJob=new Job__c();
BillboardJob.Media_Types__c=NameBillboardMediatype.id;
BillboardJob.Schedule_Template__c=NameBillboardScheduletype.id;
BillboardJob.JS_Client__c=clientcontact.Client__c;
BillboardJob.JS_Client_Contact__c=clientcontact.id;

BillboardJob.JobFormTypeValues__c='Billboard Repair Request';
insert BillboardJob;



if(!Test.isRunningTest()){  
if(base64Data!=null){
system.debug('>>>>>>>>BBR fileName>>>>>>>>>>>>>>>>>'+fileName);
system.debug('>>>>>>>>BBR base64Data>>>>>>>>>>>>>>>>>'+base64Data);
system.debug('>>>>>>>>BBR contentType>>>>>>>>>>>>>>>>>'+contentType);

Job_Spec__c BillboardSpec11=new Job_Spec__c();
BillboardSpec11.Name='File';
BillboardSpec11.Description__c='Files & documents attached';
BillboardSpec11.Job__c=BillboardJob.id;
insert BillboardSpec11;

Attachment SpecAttachment=new Attachment(parentId=BillboardSpec11.id,name=fileName,body=EncodingUtil.base64Decode(base64Data),ContentType = contentType); //Create instance of Attachment and add fields to it

insert SpecAttachment;

//Insert ContentVersion
ContentVersion cVersion = new ContentVersion();
cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
cVersion.PathOnClient = SpecAttachment.Name;//File name with extention
// cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
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
cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
Insert cDocLink;

Attachment delAttach= [select id,name from Attachment where id=:SpecAttachment.Id];
delete delAttach;

SpecAttachment.body = null; // clears the viewstate
}
}



Job_Spec__c BillboardSpec12=new Job_Spec__c();
BillboardSpec12.Name='Notes';
BillboardSpec12.Description__c=Formvalues[5];
BillboardSpec12.Job__c=BillboardJob.id;
insert BillboardSpec12;



Job_Spec__c BillboardSpec10=new Job_Spec__c();
BillboardSpec10.Name='What time(s) are the lights being reported out';
BillboardSpec10.Description__c=Formvalues[4];
BillboardSpec10.Job__c=BillboardJob.id;
insert BillboardSpec10;

List<Job_Spec__c> BillboardLightSpecList=new list<Job_Spec__c>();
if(ListBBLight.size() >0 ){
for(string BillLight: ListBBLight){
Job_Spec__c BillboardSpec9=new Job_Spec__c();
BillboardSpec9.Name='Lighting';
BillboardSpec9.Job__c=BillboardJob.id;
BillboardSpec9.Description__c=BillLight;
BillboardLightSpecList.add(BillboardSpec9);

}
}
insert BillboardLightSpecList;

Job_Spec__c BillboardSpec8=new Job_Spec__c();
BillboardSpec8.Name='Should Read';
BillboardSpec8.Description__c=Formvalues[3];
BillboardSpec8.Job__c=BillboardJob.id;
insert BillboardSpec8;

Job_Spec__c BillboardSpec7=new Job_Spec__c();
BillboardSpec7.Name='Currently Reads';
BillboardSpec7.Description__c=Formvalues[2];
BillboardSpec7.Job__c=BillboardJob.id;
insert BillboardSpec7;

List<Job_Spec__c> BillboardServiceIssuesSpecList =new list<Job_Spec__c>();
if(ListBBRServiceIssue.size() >0 ){
for(string BillService:ListBBRServiceIssue){
Job_Spec__c BillboardSpec6=new Job_Spec__c();
BillboardSpec6.Name='Service Issues';
BillboardSpec6.Job__c=BillboardJob.id;
BillboardSpec6.Description__c=BillService;
BillboardServiceIssuesSpecList.add(BillboardSpec6);

}
}
insert BillboardServiceIssuesSpecList ;

Job_Spec__c BillboardSpec5=new Job_Spec__c();
BillboardSpec5.Name='Location';
BillboardSpec5.Description__c=Formvalues[0];
BillboardSpec5.Job__c=BillboardJob.id;
insert BillboardSpec5;

List<Job_Spec__c> BillboardSigntypeSpecList =new list<Job_Spec__c>();
if( ListBBSignType.size() != null && ListBBSignType.size() >0 ){
for(string Billsign:ListBBSignType ){
Job_Spec__c BillboardSpec4=new Job_Spec__c();
BillboardSpec4.Name='Sign type';
BillboardSpec4.Job__c=BillboardJob.id;
BillboardSpec4.Description__c=Billsign;
BillboardSigntypeSpecList.add(BillboardSpec4);

}
}
insert BillboardSigntypeSpecList;

Job_Spec__c BillboardSpec3=new Job_Spec__c();
BillboardSpec3.Name='Requestor';
BillboardSpec3.Description__c=clientcontact.name;
BillboardSpec3.Job__c=BillboardJob.id;
insert BillboardSpec3;

Job_Spec__c BillboardSpec2=new Job_Spec__c();
BillboardSpec2.Name='Store Name';
BillboardSpec2.Description__c=clientcontact.Client__r.Name;
BillboardSpec2.Job__c=BillboardJob.id;
insert BillboardSpec2;

Job_Spec__c BillboardSpec123=new Job_Spec__c();
BillboardSpec123.Name='Billboard';
BillboardSpec123.Description__c=Formvalues[1];
BillboardSpec123.Job__c=BillboardJob.id;
insert BillboardSpec123;

Job_Spec__c BillboardSpec1=new Job_Spec__c();
BillboardSpec1.Name='District';
BillboardSpec1.Description__c=clientcontact.Client__r.Dummy_Picklist_1__c;
BillboardSpec1.Job__c=BillboardJob.id;
insert BillboardSpec1;


}
catch(Exception e){
return ''+e.getMessage();
}
return 'true';      
}*/
        
        /************************************************************* Custom Order Request Form ******************************************************************/
        
        /*  if(requestType=='Custom Order')
{
try{

Schedule_Template__c NameCustomScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Custom Order' AND Media_Types__r.name='Print' limit 1];// added new form Custom Store Order in Store Order type

Job__c CustomJob=new Job__c();
CustomJob.Media_Types__c=NameMediatype.id;
CustomJob.Schedule_Template__c=NameCustomScheduletype.id;
CustomJob.JS_Client__c=clientcontact.Client__c;
CustomJob.JS_Client_Contact__c=clientcontact.id;
CustomJob.JobFormTypeValues__c='Custom Order';
insert CustomJob;

System.debug('*******CustomJob.JobFormTypeValues__c**********'+CustomJob.JobFormTypeValues__c);

if(!Test.isRunningTest()){  
if(base64Data!=null){
Job_Spec__c SpecFile=new Job_Spec__c();
SpecFile.Name='File';
SpecFile.Description__c='Files & documents attached ';
SpecFile.Job__c=CustomJob.id;
insert SpecFile;

Attachment SpecAttachment=new Attachment(parentId=SpecFile.id,name=fileName,body=EncodingUtil.base64Decode(base64Data),ContentType = contentType); //Create instance of Attachment and add fields to it

insert SpecAttachment;

//Insert ContentVersion
ContentVersion cVersion = new ContentVersion();
cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
cVersion.PathOnClient = SpecAttachment.Name;//File name with extention
// cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
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
cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
Insert cDocLink;

Attachment delAttach=[select id,name from Attachment where id=:SpecAttachment.Id];

delete delAttach;

SpecAttachment.body = null; // clears the viewstate

}
}

Job_Spec__c PlateSpec5=new Job_Spec__c();
PlateSpec5.Name='Explain, in detail, where items will be installed';
PlateSpec5.Description__c=Formvalues[5];        
PlateSpec5.Job__c=CustomJob.id;
insert PlateSpec5;

Job_Spec__c PlateSpec4=new Job_Spec__c();
PlateSpec4.Name='Explain, in detail, what signs/banners/etc. need to say';
PlateSpec4.Description__c=Formvalues[4];    
PlateSpec4.Job__c=CustomJob.id;
insert PlateSpec4;

Job_Spec__c PlateSpec3=new Job_Spec__c();
PlateSpec3.Name='Explain request in detail';    
PlateSpec3.Description__c=Formvalues[3];    
PlateSpec3.Job__c=CustomJob.id;
insert PlateSpec3;

Job_Spec__c PlateSpec2=new Job_Spec__c();
PlateSpec2.Name='Provide Height and Width Measurements in Inches';
PlateSpec2.Description__c=Formvalues[2];  
PlateSpec2.Job__c=CustomJob.id;
insert PlateSpec2;

Job_Spec__c PlateSpec1=new Job_Spec__c();
PlateSpec1.Name='Quantity Needed';  
PlateSpec1.Description__c=Formvalues[1];    
PlateSpec1.Job__c=CustomJob.id;
insert PlateSpec1;

Job_Spec__c PlateSpec6=new Job_Spec__c();
PlateSpec6.Name='Turn-Time';    
PlateSpec6.Description__c=Formvalues[0];    
PlateSpec6.Job__c=CustomJob.id;
insert PlateSpec6;


List<Job_Spec__c> ItemsNeededspecList=new list<Job_Spec__c>();

if(ListCOItemsNeeded.size() >0 )
{
for(string tagdesc1:ListCOItemsNeeded)
{
Job_Spec__c tagspec7 =new Job_Spec__c();
TagSpec7.Name='Items Needed';        
TagSpec7.Job__c=CustomJob.id;      
TagSpec7.Description__c=tagdesc1;
ItemsNeededspecList.add(TagSpec7);
}
}
insert ItemsNeededspecList;


}

catch(Exception e){
return ''+e.getMessage();
}
return 'true';      
}*/
        
        /*********************************************************** Made To Order Request Form ******************************************************************/
        
        if(requestType=='Made To Order')
        {
            try{
                Schedule_Template__c NameMadeToOrderScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Made To Order' AND Media_Types__r.name='Print' limit 1];
                
                Job__c MtoJob=new Job__c();
                MtoJob.Media_Types__c=NameMediatype.id;
                MtoJob.Schedule_Template__c=NameMadeToOrderScheduletype.id;
                MtoJob.JS_Client__c=clientcontact.Client__c;
                MtoJob.JS_Client_Contact__c=clientcontact.id;
                
                MtoJob.JobFormTypeValues__c='Made To Order';
                insert MtoJob;
                
                Job_Spec__c MtoSpec1=new Job_Spec__c();
                MtoSpec1.Name='Items';
                MtoSpec1.Description__c=Formvalues[0];
                MtoSpec1.Job__c=MtoJob.id;
                MtoSpec1.Sort_Order__c=1;
                insert MtoSpec1;
                
                Job_Spec__c MtoSpec2=new Job_Spec__c();
                MtoSpec2.Name='Qty';
                MtoSpec2.Description__c=Formvalues[1];
                MtoSpec2.Job__c=MtoJob.id;
                MtoSpec2.Sort_Order__c=2;
                insert MtoSpec2;
                
                Job_Spec__c MtoSpec3=new Job_Spec__c();
                MtoSpec3.Name='Special Details';
                MtoSpec3.Description__c=Formvalues[2];
                MtoSpec3.Job__c=MtoJob.id;
                MtoSpec3.Sort_Order__c=3;
                insert MtoSpec3;
                
            }
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }
        
        /*********************************************************** Corporate Name Tag Request Form ******************************************************************/
        
        if(requestType=='Corporate Name Tag')
        {
            try{
                Schedule_Template__c NameTagScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Name Tag' AND Media_Types__r.name='Print' limit 1];
                
                Job__c CopNameTagJob=new Job__c();
                CopNameTagJob.Media_Types__c=NameMediatype.id;
                CopNameTagJob.Schedule_Template__c=NameTagScheduletype.id;
                CopNameTagJob.JS_Client__c=clientcontact.Client__c;
                CopNameTagJob.JS_Client_Contact__c=clientcontact.id;
                CopNameTagJob.JobFormTypeValues__c='Name Tag Request';
                insert CopNameTagJob;
                
                List<Job_Spec__c> TagSpecList=new list<Job_Spec__c>();
                
                if(ListCopNameTagLogo.size() >0 ){
                    for(string tagdesc:ListCopNameTagLogo){
                        Job_Spec__c CopNameTagspec5 =new Job_Spec__c();
                        CopNameTagspec5.Name='Logo';
                        CopNameTagspec5.Job__c=CopNameTagJob.id;
                        CopNameTagspec5.Description__c=tagdesc;
                        CopNameTagspec5.Sort_Order__c=5;
                        TagSpecList.add(CopNameTagspec5);
                    }
                }
                insert TagSpecList;
                
                Job_Spec__c CopNameTagJobSpec4=new Job_Spec__c();
                CopNameTagJobSpec4.Name='Year of Hire';
                CopNameTagJobSpec4.Description__c=Formvalues[3];
                CopNameTagJobSpec4.Job__c=CopNameTagJob.id;
                CopNameTagJobSpec4.Sort_Order__c=4;
                insert CopNameTagJobSpec4;
                
                Job_Spec__c CopNameTagJobSpec3=new Job_Spec__c();
                CopNameTagJobSpec3.Name='Last Name';
                CopNameTagJobSpec3.Description__c=Formvalues[2];
                CopNameTagJobSpec3.Job__c=CopNameTagJob.id;
                CopNameTagJobSpec3.Sort_Order__c=3;
                insert CopNameTagJobSpec3;
                
                Job_Spec__c CopNameTagJobSpec2=new Job_Spec__c();
                CopNameTagJobSpec2.Name='First Name';
                CopNameTagJobSpec2.Description__c=Formvalues[1];
                CopNameTagJobSpec2.Job__c=CopNameTagJob.id;
                CopNameTagJobSpec2.Sort_Order__c=2;
                insert CopNameTagJobSpec2;
                
                Job_Spec__c CopNameTagJobSpec1=new Job_Spec__c();
                CopNameTagJobSpec1.Name='Title';
                CopNameTagJobSpec1.Description__c=Formvalues[0];
                CopNameTagJobSpec1.Job__c=CopNameTagJob.id;
                CopNameTagJobSpec1.Sort_Order__c=1;
                insert CopNameTagJobSpec1;
                
            }    
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }
        
        /*********************************************************** Corporate Office Nameplate Request Form ******************************************************************/
        
        if(requestType=='Corporate Office Nameplate')
        {
            try{
                Schedule_Template__c NamePlateScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Corporate Office Nameplate' AND Media_Types__r.name='Print' limit 1];
                
                Job__c CopOfficeNamePlateJob=new Job__c();
                CopOfficeNamePlateJob.Media_Types__c=NameMediatype.id;
                CopOfficeNamePlateJob.Schedule_Template__c=NamePlateScheduletype.id;
                CopOfficeNamePlateJob.JS_Client__c=clientcontact.Client__c;
                CopOfficeNamePlateJob.JS_Client_Contact__c=clientcontact.id;
                CopOfficeNamePlateJob.JobFormTypeValues__c='Corporate Office Nameplate';
                insert CopOfficeNamePlateJob;
                
                
                List<Job_Spec__c> PlateTypeSpecList=new list<Job_Spec__c>();
                
                if(ListCopOfficeNameType.size() >0 ){
                    for(string tagdesc1:ListCopOfficeNameType){
                        Job_Spec__c tagspec5 =new Job_Spec__c();
                        TagSpec5.Name='Name Plate Type';
                        TagSpec5.Job__c=CopOfficeNamePlateJob.id;
                        TagSpec5.Description__c=tagdesc1;
                        TagSpec5.Sort_Order__c=5;
                        PlateTypeSpecList.add(TagSpec5);
                        
                    }
                }
                insert PlateTypeSpecList;
                
                Job_Spec__c PlateSpec4=new Job_Spec__c();
                PlateSpec4.Name='Building';
                PlateSpec4.Description__c=Formvalues[3];
                PlateSpec4.Job__c=CopOfficeNamePlateJob.id;
                PlateSpec4.Sort_Order__c=4;
                insert PlateSpec4;
                
                Job_Spec__c PlateSpec3=new Job_Spec__c();
                PlateSpec3.Name='Year Of Hire';
                PlateSpec3.Description__c=Formvalues[2];
                PlateSpec3.Job__c=CopOfficeNamePlateJob.id;
                PlateSpec3.Sort_Order__c=3;
                insert PlateSpec3;
                
                Job_Spec__c PlateSpec2=new Job_Spec__c();
                PlateSpec2.Name='Name';
                PlateSpec2.Description__c=Formvalues[1];
                PlateSpec2.Job__c=CopOfficeNamePlateJob.id;
                PlateSpec2.Sort_Order__c=2;
                insert PlateSpec2;
                
                Job_Spec__c PlateSpec1=new Job_Spec__c();
                PlateSpec1.Name='Title';
                PlateSpec1.Description__c=Formvalues[0];
                PlateSpec1.Job__c=CopOfficeNamePlateJob.id;
                PlateSpec1.Sort_Order__c=1;
                insert PlateSpec1;
            }    
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }
        
        
        /*********************************************************** Corporate Business Cards Request Form ******************************************************************/
        
        if(requestType=='Corporate Business Cards')
        {
            try{
                Schedule_Template__c NameCorporateCardScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Corporate Business Card' AND Media_Types__r.name='Print' limit 1];
                
                Job__c CorporateBCJob=new Job__c();
                CorporateBCJob.Media_Types__c=NameMediatype.id;
                CorporateBCJob.Schedule_Template__c=NameCorporateCardScheduletype.id;
                CorporateBCJob.JS_Client__c=clientcontact.Client__c;
                CorporateBCJob.JS_Client_Contact__c=clientcontact.id;
                CorporateBCJob.JobFormTypeValues__c='Corporate Business Card';
                insert CorporateBCJob;
                
                Job_Spec__c CorporateSpec9=new Job_Spec__c();
                CorporateSpec9.Name='ICE Chat';
                CorporateSpec9.Description__c=Formvalues[6];
                CorporateSpec9.Job__c=CorporateBCJob.id;
                CorporateSpec9.Sort_Order__c=10;
                insert CorporateSpec9;
                
                Job_Spec__c CorpoarateSpec8=new Job_Spec__c();
                CorpoarateSpec8.Name='Web Site';
                CorpoarateSpec8.Job__c=CorporateBCJob.id;
                CorpoarateSpec8.Description__c=Formvalues[5];
                CorpoarateSpec8.Sort_Order__c=9;
                insert CorpoarateSpec8;
                
                Job_Spec__c CorporateSpec7=new Job_Spec__c();
                CorporateSpec7.Name='Mobile';
                CorporateSpec7.Description__c=Formvalues[9];
                CorporateSpec7.Job__c=CorporateBCJob.id;
                CorporateSpec7.Sort_Order__c=8;
                insert CorporateSpec7;
                
                Job_Spec__c CorporateSpec6=new Job_Spec__c();
                CorporateSpec6.Name='Email';
                CorporateSpec6.Description__c=Formvalues[4];
                CorporateSpec6.Job__c=CorporateBCJob.id;
                CorporateSpec6.Sort_Order__c=7;
                insert CorporateSpec6;
                
                Job_Spec__c CorporateSpec5=new Job_Spec__c();
                CorporateSpec5.Name='Fax';
                CorporateSpec5.Description__c=Formvalues[8];
                CorporateSpec5.Job__c=CorporateBCJob.id;
                CorporateSpec5.Sort_Order__c=6;
                insert CorporateSpec5;
                
                Job_Spec__c CorporateSpec4=new Job_Spec__c();
                CorporateSpec4.Name='Phone';
                CorporateSpec4.Description__c=Formvalues[7];
                CorporateSpec4.Job__c=CorporateBCJob.id;
                CorporateSpec4.Sort_Order__c=5;
                insert CorporateSpec4;
                
                Job_Spec__c CorpoarateSpec11=new Job_Spec__c();
                CorpoarateSpec11.Name='Company';
                CorpoarateSpec11.Job__c=CorporateBCJob.id;
                CorpoarateSpec11.Description__c=Formvalues[0];
                CorpoarateSpec11.Sort_Order__c=4;
                insert CorpoarateSpec11;
                
                Job_Spec__c CorpoarateSpec3=new Job_Spec__c();
                CorpoarateSpec3.Name='Address';
                CorpoarateSpec3.Job__c=CorporateBCJob.id;
                CorpoarateSpec3.Description__c=Formvalues[1];
                CorpoarateSpec3.Sort_Order__c=3;
                insert CorpoarateSpec3;
                
                Job_Spec__c CorporateSpec2=new Job_Spec__c();
                CorporateSpec2.Name='Title';
                CorporateSpec2.Description__c=Formvalues[3];
                CorporateSpec2.Job__c=CorporateBCJob.id;
                CorporateSpec2.Sort_Order__c=2;
                insert CorporateSpec2;
                
                
                Job_Spec__c CorporateSpec1=new Job_Spec__c();
                CorporateSpec1.Name='Name';
                CorporateSpec1.Description__c=Formvalues[2];
                CorporateSpec1.Job__c=CorporateBCJob.id;
                CorporateSpec1.Sort_Order__c=1;
                insert CorporateSpec1;
                
                
            }    
            catch(Exception e){
                return ''+e.getMessage();
            }
            return 'true';      
        }
        
        return 'true';      
    }
    
    @AuraEnabled
    public static string getcartitems(){
        string returnvalue = '';
        list<Cart_Items__c> cartrcds = [select id,name,Store__c,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where CreatedById=:userinfo.getuserid() order by createddate desc];
        if(cartrcds.size() > 0){
            returnvalue = 'Records Exists';
        }
        else{
            returnvalue = 'No Records';   
        }
        return returnvalue;
    }
    
}