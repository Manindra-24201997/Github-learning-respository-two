public class StoreSuppliesLightingCmpCtrlPro {
    
    @AuraEnabled
    public static list<string> getMaterialType(string micategory){
        list<string> MaterialType= new list<string>();     
        if(string.isBlank(micategory)){
            for(schema.picklistEntry p : Material_Item__c.Type__c.getDescribe().getPicklistValues()){
                MaterialType.add(p.getLabel());
            }          
        }
        else{
            MaterialType.add(micategory);
        }
        return MaterialType;
    }
    
    @AuraEnabled
    public static list<string> getStockLabels(){
        list<String> labels=new list<String>();
        String OutStacklabel = Material_Item__c.Out_of_Stock__c.getDescribe().getLabel();
        labels.add(OutStacklabel);
        String reStacklabel = Material_Item__c.Re_Stocking__c.getDescribe().getLabel();
        labels.add(reStacklabel);
        return labels;
    }
    
    @AuraEnabled
    Public static Map<Id,MIWrapper> ShowItems(string MaterialItemNameString,string MaterialTypeString){
        
        system.debug('---MaterialItemNameString--'+MaterialItemNameString);
        system.debug('---MaterialTypeString---'+MaterialTypeString);
        list<Material_Item__c> MaterialItems=new list<Material_Item__c>();
        Set<string> Storegrps=new Set<string>();
        Map<Id,MIWrapper> roleWraps=new Map<Id,MIWrapper>();
        Map<string,Material_Item__c>minames=new Map<string,Material_Item__c>();
        Map<string,Cart_Items__c>cartitems=new Map<string,Cart_Items__c>();
        
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c  clientcontact=[Select id,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        
        if(clientcontact.Client__r.Client_Group__c!=null) {
            string clntGroup = clientcontact.Client__r.Client_Group__c;
            string[] split = clntGroup.Split(';');
            for(string item :split)
            {
                Storegrps.add(item);
            }
        }
        string MIname='%'+MaterialItemNameString+'%';
        if(MIname!='%%' && MaterialTypeString!='') {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Name like: MIname AND Type__c = : MaterialTypeString AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
            system.debug('If material item');
        }
        else if(MIname=='%%' && MaterialTypeString !='') {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Type__c = : MaterialTypeString AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
            system.debug('else If material item');
        }
        else if(MIname!=null && MaterialTypeString =='') {
            MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where Name like: MIname AND Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC  limit 1000];
            system.debug('else If material item 3');
        } 
        // MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where  Type__c = : MaterialTypeString and Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
        
        if(!MaterialItems.isEmpty())
        {
            Set<Id> contentDocumentIdSet =new Set<Id>();
            Map<Id,String> contentDocMap=new Map<Id,String>();
            for(Material_Item__c MI: MaterialItems){
                minames.put(MI.Name,MI);
                for(ContentDocumentLink cdl: MI.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
            
            list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c=:minames.keyset() and CreatedById=:userinfo.getUserId()];
            for(Cart_Items__c cit : cartrcds){
                cartitems.put(cit.Material_Item__c,cit);
            }
            
            for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
                if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                    contentDocMap.put(cv.ContentDocumentId,cv.Id);
                }
            }
            
            for(Material_Item__c MI: MaterialItems)
            {
                MIWrapper rw=new MIWrapper();
                if(cartitems.containskey(MI.Name)){
                    rw.greycolor = 'green';
                }
                else{
                    rw.greycolor = '';   
                }
                rw.MI=MI;
                rw.checked=false;  
                rw.ContentVersionId='';
                for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                    if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                        rw.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                        break;
                    }
                }
                rw.quantity=1;
                roleWraps.put(rw.Mi.id,rw);            
            }
            
        }
        return roleWraps;
    }
    
    @AuraEnabled
    public static Map<Id,MIWrapper> getcartitemrcds(){
        Map<Id,MIWrapper> roleWraps=new Map<Id,MIWrapper>();
        map<string,Cart_Items__c>cartrcdsmap = new map<string,Cart_Items__c>();
        list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where CreatedById=:userinfo.getuserid()];
        for(Cart_Items__c crcd : cartrcds){
            cartrcdsmap.put(crcd.Material_Item__c,crcd);
        }
        list<Material_Item__c>MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where name=:cartrcdsmap.keyset() ORDER BY Name ASC limit 1000];
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
        
        for(Material_Item__c MI : MaterialItems){
            if(cartrcdsmap.containskey(MI.name)){
                Cart_Items__c crcd =  cartrcdsmap.get(MI.name);  
                MIWrapper rw=new MIWrapper();
                rw.greycolor = 'grey';
                rw.MI=MI;
                rw.checked=true;  
                rw.ContentVersionId='';
                for(ContentDocumentLink cdl:MI.ContentDocumentLinks){
                    if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                        rw.ContentVersionId=contentDocMap.get(cdl.ContentDocumentId);
                        break;
                    }
                }
                if(crcd.Quantity__c >1){
                    rw.quantity=integer.valueof(crcd.Quantity__c);   
                }
                else{
                    rw.quantity = 1;  
                }
                roleWraps.put(rw.Mi.id,rw);       
            }
        }        
        return roleWraps;
    }
    
    @AuraEnabled
    public static string submitToPlaceOrder( list<MIWrapper> cartItems){
        map<string,Material_Item__c>mimap = new map<string,Material_Item__c>();
        map<string,Material_Item__c>mimapnames = new map<string,Material_Item__c>();
        list<string>returntextvalues = new list<string>();
        list<string>clientids = new list<string>();
        string jobclientids = '' ;
        Map<String,Client_Contact__c>clientcntmap = new Map<String,Client_Contact__c>();
        Media_Type__c  NameStoreMediatype=[Select id ,name from Media_Type__c where name='Supplies' limit 1];
        system.debug('---NameStoreMediatype----jobs----'+NameStoreMediatype);
        Schedule_Template__c  NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Order' AND Media_Types__r.name='Supplies' limit 1];
        system.debug('---NameStoreScheduletype----jobs----'+NameStoreScheduletype);
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c clientcontact = [Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c,
                                                     Client__r.Hierarchy__c,Client__r.Hierarchy__r.name,Client__r.Hierarchy__r.Hierarchy__c,Client__r.Hierarchy__r.Hierarchy__r.name   from Client_Contact__c where UserName__c =:lstUser.Username limit 1];
        jobclientids = clientcontact.Client__c ; // logged in user  job client id
        // list<Production_Estimate__c>percd = new list<Production_Estimate__c>();
        clientids.add(clientcontact.Client__c); //gm client
        clientids.add(clientcontact.Client__r.Hierarchy__c); //district
        clientids.add(clientcontact.Client__r.Hierarchy__r.Hierarchy__c);  //division
        system.debug('---Client contact id ---'+clientcontact.id);
        system.debug('---cartItems---'+cartItems);
        
        for(MIWrapper  item:cartItems)
        {  
            mimap.put(item.Mi.id,item.Mi);  //This line New logic added on 12 - 04 - 2022 for Same material item selecting with in a week.
            mimapnames.put(item.Mi.Name,item.Mi);
            if(Item.Quantity > Item.Mi.Max_Qty__c)  {
                return 'QuantityError';
            }
        }
        
        // New logic added on 21 - 07 - 2022 for Same material item selected by DM less than 5 days with store wise functionality
        decimal days = 0 ;
        decimal workingDays = 0;
        string returntext = '';
        list<Client_Contact__c>clncon = [select id,name,Client__c,UserName__c from Client_Contact__c where Client__c =: clientids  WITH SECURITY_ENFORCED order by name asc];  
        if(clncon.size() > 0){
            for(Client_Contact__c clncntusrnames : clncon){
                clientcntmap.put(clncntusrnames.UserName__c,clncntusrnames);
            }
            list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,Job__r.JS_Client__c ,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate  from Production_Estimate__c
                                                           where Job__r.JS_Client__c =:jobclientids and Material_Item__c =: mimap.keySet() and CreatedBy.username =: clientcntmap.keySet()  and createddate >= LAST_N_DAYS:10   order by createddate desc];  
            if(percd.size() > 0){
                // return string.valueof(percd.size());
                for(Production_Estimate__c pe : percd){
                    if(mimap.containskey(pe.Material_Item__c)){
                        days = date.valueOf(pe.CreatedDate).daysBetween(system.today());
                        system.debug('days === '+days);
                        for(integer i=0; i <= days; i++)  
                        {  
                            Date dt = date.valueOf(pe.CreatedDate) + i;  
                            //system.debug('dt === '+pe.CreatedDate+'integer i === '+i);
                            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                            // system.debug('currDate === '+currDate);
                            String todayDay = currDate.format('EEEE');  
                            system.debug('todayDay === '+todayDay + ''+i);
                            if(todayDay != 'Saturday' && todayDay !='Sunday')  
                            {  
                                workingDays = workingDays + 1;  
                                //system.debug('workingDays === '+workingDays);
                            }    
                        }  
                        system.debug('workingDays number === '+workingDays);  
                        if(workingDays <= 5  ){
                            if(pe.CreatedBy.userrole.name == 'District Manager' ||  pe.CreatedBy.userrole.name == 'Division Director' || pe.CreatedBy.userrole.name == 'Division Merch Manager'){
                                returntextvalues.add(pe.Material_Item__r.name);
                                //return 'DM';
                                //return 'DM' + string.valueOf(workingDays);
                            }
                            else{
                                returntextvalues.add(pe.Material_Item__r.name);
                                //return 'You already placed an order for this item this week';
                                //return 'You already placed an order for this item this week'+ string.valueOf(workingDays);
                            }
                        }
                        else{
                            returntext =  '';
                            workingDays = 0;  
                        }
                    }  
                }
            }  
        }    
        //Ends here
        
        if(returntextvalues.size() > 0){
            for(string value : returntextvalues){
                returntext +=  value + ','  ; 
            }
        }
        else{
            returntext = ''  ;  
        }
        
        if(string.isNotBlank(returntext)){
            returntext = returntext.removeEnd(',');  
            return returntext;
        }
        else{
            returntext = 'No records'  ;    
        }
        
        //New logic added on 15 - 07 - 2022 for Same material item selected by DM less than 5 days.
        /* set<string>usersset = new set<string>();
list<user> lstUserroles = [select firstname,Username,Id,Profile.Name,userrole.name,IsActive,name   from user where IsActive = true and (userrole.name = 'District Manager' or  userrole.name = 'Division Manager' or userrole.name = 'Division Merch Manager') order by name asc];
for(user usrnm:lstUserroles){
usersset.add(usrnm.Username);
}        
decimal days = 0 ;
decimal workingDays = 0;
list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate  from Production_Estimate__c  where Material_Item__c =: mimap.keySet() and createddate >= LAST_N_DAYS:10 and (CreatedBy.userrole.name = 'District Manager' or  CreatedBy.userrole.name = 'Division Manager' or CreatedBy.userrole.name = 'Division Merch Manager' or CreatedBy.userrole.name = 'General Manager' ) order by createddate desc];
if(percd.size() > 0){
for(Production_Estimate__c pe : percd){
if(mimap.containskey(pe.Material_Item__c)){
days = date.valueOf(pe.CreatedDate).daysBetween(system.today());
system.debug('days === '+days);
for(integer i=0; i <= days; i++)  
{  
Date dt = date.valueOf(pe.CreatedDate) + i;  
//system.debug('dt === '+pe.CreatedDate+'integer i === '+i);
DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
// system.debug('currDate === '+currDate);
String todayDay = currDate.format('EEEE');  
system.debug('todayDay === '+todayDay + ''+i);
if(todayDay != 'Saturday' && todayDay !='Sunday')  
{  
workingDays = workingDays + 1;  
//system.debug('workingDays === '+workingDays);
}    
}  
system.debug('workingDays number === '+workingDays);  
if(workingDays <= 5  ){
if(pe.CreatedBy.userrole.name == 'General Manager'){
return 'You already placed an order for this item this week';
}
else{
return 'DM';
}
}
else{
workingDays = 0;  
}
}  
}
}*/
        //Ends Here
        
        //New logic added on 12 - 04 - 2022 for Same material item selecting less than 5 days by a same user.
        //The Below logic is for login user 5 days Limit initial logic
        /*  
decimal days5 = 0 ;
decimal workingDays5 = 0;
list<Job__c> jobrcd5= [select id,name,Status__c,CreatedDate,JS_Client_Contact__c,(select id,name,Material_Item__c,Material_Item__r.name,CreatedDate from Production_Estimates__r) from Job__c where JS_Client_Contact__c =: clientcontact.id  order by createddate desc limit 1];
if(jobrcd5.size() > 0){
for(Job__c jj : jobrcd5 ){
if(jj.Production_Estimates__r.size() > 0){
for(Production_Estimate__c pe : jj.Production_Estimates__r){
if(mimap.containskey(pe.Material_Item__c)){
days = date.valueOf(pe.CreatedDate).daysBetween(system.today());
system.debug('days === '+days);
for(integer i=0; i <= days; i++)  
{  
Date dt5 = date.valueOf(pe.CreatedDate) + i;  
//system.debug('dt === '+pe.CreatedDate+'integer i === '+i);
DateTime currDate5 = DateTime.newInstance(dt5.year(), dt5.month(), dt5.day());  
// system.debug('currDate === '+currDate5);
String todayDay5 = currDate5.format('EEEE');  
system.debug('todayDay === '+todayDay5 + ''+i);
if(todayDay5 != 'Saturday' && todayDay5 !='Sunday')  
{  
workingDays5 = workingDays5 + 1;  
//system.debug('workingDays5 === '+workingDays5);
}    
}  
system.debug('workingDays5 number === '+workingDays5);  
if(workingDays5 <= 5  ){
return 'You already placed an order for this item this week';
}
}  
}
}
}
}*/
        //Ends here
        try
        {
            Job__c StoreJob=new Job__c();
            StoreJob.Media_Types__c=NameStoreMediatype.id;
            StoreJob.Schedule_Template__c=NameStoreScheduletype.id;
            StoreJob.JobFormTypeValues__c='Store Supply Orders';
            StoreJob.JS_Client__c=clientcontact.Client__c;
            StoreJob.JS_Client_Contact__c=clientcontact.id;
            
            insert StoreJob;
            string jobid=StoreJob.id;
            String StoreJobname=[select id, name from Job__c where id =:jobid limit 1].name;
            string prodname='PE';
            list<Production_Estimate__c> ProdEstimateList =new List<Production_Estimate__c>();
            
            for(MIWrapper  item:cartItems) {
                Production_Estimate__c ProdEstimate =new Production_Estimate__c ();
                
                
                ProdEstimate.Job__c =StoreJob.id;
                ProdEstimate.Material_Item__c =Item.Mi.id;
                ProdEstimate.Name=prodname + '-' + Item.Mi.name;  //+ StoreJobname; //+ ' - '
                ProdEstimate.Calc_Unit__c=Item.MI.Calc_Unit__c;
                ProdEstimate.Quantity__c= Item.Quantity;
                ProdEstimate.Qty_Up__c=1;
                ProdEstimate.FromStoreFront__c=true;
                if(Item.Mi.Calc_Unit__c=='Each')
                {
                    ProdEstimate.EachQtyUpforUsed__c=(Item.Quantity/1);
                }
                else if(Item.Mi.Calc_Unit__c=='Sheet')
                {
                    ProdEstimate.SheetQtyUpforUsed__c=(Item.Quantity/1);
                }
                ProdEstimateList.add(ProdEstimate);
            }
            
            insert ProdEstimateList ;
            if(ProdEstimateList.size() > 0){
                list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c=:mimapnames.keyset() and CreatedById=:userinfo.getuserid()];
                if(cartrcds.size() > 0){
                    delete   cartrcds;
                }
            }
            return 'success';
            //return 'success'+ string.valueOf(workingDays);
        }
        catch(exception ex){
            return ex.getMessage();
        }
    }
    
    @AuraEnabled
    public static boolean checkcartitemrcds(){
        list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where CreatedById=:userinfo.getuserid()];
        if(cartrcds.size() > 0){
            return true;
        } 
        else{
            return false;
        }
    }    
    
    // Start Wrapper Class
    public class MIWrapper
    {
        @AuraEnabled  public String  greycolor {get;set;}
        @AuraEnabled  public Material_Item__c MI{get;set;}
        @AuraEnabled  public Boolean checked{get;set;}
        @AuraEnabled  public String  ContentVersionId {get;set;}
        @AuraEnabled  public integer quantity{get; set;}
        
        public  MIWrapper(){
            //
        }  
    }
    // End of Wrapper Class
    
    @AuraEnabled
    public static string deletecartitemrcds(string minamedelval){
        Cart_Items__c cartrcds = [select id,name,Material_Item__c,Quantity__c,CreatedById from Cart_Items__c where Material_Item__c=:minamedelval and CreatedById=:userinfo.getuserid() limit 1];
        if(cartrcds != null){
            delete cartrcds;
            return 'deleted';
        }
        else{
            return 'no rcds';
        }
    }
    
    @AuraEnabled
    public static string deletecartitemrcdsforcancelbutton(){
        try{
            string val = '';
            list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where CreatedById=:userinfo.getuserid()];
            if(cartrcds.size() > 0){
                delete cartrcds;
                val = 'deleted';
            }
            else{
                val = 'No rcords';    
            }
            return val;
        }
        catch(exception e)
        {
            string val = '';
            system.debug('exception === '+e.getMessage());
            val = e.getMessage(); 
            return val;
            
        }
    }
    
    //The below method added to check before added to cart on 08 - 09 - 2022
    @AuraEnabled
    public static string submitTocheck(list<MIWrapper>cartItems){
        map<string,Material_Item__c>mimap = new map<string,Material_Item__c>();
        map<string,Material_Item__c>mimapnames = new map<string,Material_Item__c>();
        list<string>returntextvalues = new list<string>();
        list<string>clientids = new list<string>();
        list<Cart_Items__c>cartrcds = new list<Cart_Items__c>();
        list<Cart_Items__c>cartrcdsneedstobeinsert = new list<Cart_Items__c>();
        map<string,Cart_Items__c>cartrcdsmap = new map<string,Cart_Items__c>();
        string jobclientids = '' ;
        Map<String,Client_Contact__c>clientcntmap = new Map<String,Client_Contact__c>();
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c clientcontact = [Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c,
                                                     Client__r.Hierarchy__c,Client__r.Hierarchy__r.name,Client__r.Hierarchy__r.Hierarchy__c,Client__r.Hierarchy__r.Hierarchy__r.name   from Client_Contact__c where UserName__c =:lstUser.Username limit 1];
        jobclientids = clientcontact.Client__c ; // logged in user  job client id
        // list<Production_Estimate__c>percd = new list<Production_Estimate__c>();
        clientids.add(clientcontact.Client__c); //gm client
        clientids.add(clientcontact.Client__r.Hierarchy__c); //district
        clientids.add(clientcontact.Client__r.Hierarchy__r.Hierarchy__c);  //division
        system.debug('---Client contact id ---'+clientcontact.id);
        system.debug('---cartItems---'+cartItems);
        for(MIWrapper  item:cartItems)
        { 
            mimap.put(item.Mi.id,item.Mi); 
            mimapnames.put(item.Mi.Name,item.Mi); 
            if(Item.Quantity > Item.Mi.Max_Qty__c)  {
                return 'QuantityError';
            }
        }
        
        // New logic added on 08 - 09 - 2022 for Same material item selected by DM less than 5 days with store wise functionality
        string returntext = '';
        decimal days = 0 ;
        decimal workingDays = 0;
        list<Client_Contact__c>clncon = [select id,name,Client__c,UserName__c from Client_Contact__c where Client__c =: clientids  WITH SECURITY_ENFORCED order by name asc];  
        
        if(clncon.size() > 0){
            for(Client_Contact__c clncntusrnames : clncon){
                clientcntmap.put(clncntusrnames.UserName__c,clncntusrnames);
            }
            list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,Job__r.JS_Client__c ,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate  from Production_Estimate__c
                                                           where Job__r.JS_Client__c =:jobclientids and Material_Item__c =: mimap.keySet() and CreatedBy.username =: clientcntmap.keySet()  and createddate >= LAST_N_DAYS:10   order by createddate desc];  
            if(percd.size() > 0){
                for(Production_Estimate__c pe : percd){
                    if(mimap.containskey(pe.Material_Item__c)){
                        days = date.valueOf(pe.CreatedDate).daysBetween(system.today());
                        system.debug('days === '+days);
                        for(integer i=0; i <= days; i++)  
                        {  
                            Date dt = date.valueOf(pe.CreatedDate) + i;  
                            //system.debug('dt === '+pe.CreatedDate+'integer i === '+i);
                            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                            // system.debug('currDate === '+currDate);
                            String todayDay = currDate.format('EEEE');  
                            system.debug('todayDay === '+todayDay + ''+i);
                            if(todayDay != 'Saturday' && todayDay !='Sunday')  
                            {  
                                workingDays = workingDays + 1;  
                                //system.debug('workingDays === '+workingDays);
                            }    
                        }  
                        system.debug('workingDays number === '+workingDays);  
                        if(workingDays <= 5  ){
                            if(pe.CreatedBy.userrole.name == 'District Manager' ||  pe.CreatedBy.userrole.name == 'Division Director' || pe.CreatedBy.userrole.name == 'Division Merch Manager')
                            {
                                returntextvalues.add(pe.Material_Item__r.name);
                                workingDays = 0;  
                                //returntext =  'DM';
                                //return 'DM' + string.valueOf(workingDays);
                            }
                            else{
                                returntextvalues.add(pe.Material_Item__r.name);
                                workingDays = 0;  
                                // returntext =  'You already placed an order for this item this week';
                                //return 'You already placed an order for this item this week'+ string.valueOf(workingDays);
                            }
                        }
                        else{
                            returntext =  '';
                            workingDays = 0;  
                        }
                    }
                }
            }
        }
        
        if(returntextvalues.size() > 0){
            for(string value : returntextvalues){
                returntext +=  value + ','  ; 
            }
        }
        else{
            returntext = ''  ;  
        }
        
        if(string.isNotBlank(returntext)){
            returntext = returntext.removeEnd(',');  
        }
        else{
            returntext = 'No records'  ;
            cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c NOT IN:returntextvalues and CreatedById=:userinfo.getuserid()  order by Material_Item__c asc];
            if(cartrcds.size() > 0){
                for(Cart_Items__c crcds : cartrcds){
                    cartrcdsmap.put(crcds.Material_Item__c,crcds);
                }
            } 
        }
        
        //Below items hold logic which are added to cart
        for(MIWrapper  item:cartItems)
        { 
            if(!cartrcdsmap.containskey(item.Mi.Name)){
                if(!returntextvalues.contains(item.Mi.Name)){
                    Cart_Items__c cartitemssobj = new Cart_Items__c();
                    cartitemssobj.Material_Item__c = item.Mi.Name;
                    cartitemssobj.Quantity__c = item.quantity;
                    cartrcdsneedstobeinsert.add(cartitemssobj);
                }
            }
            // returntext = string.valueof(cartrcdsneedstobeinsert.size())  ;  
        }
        
        if(cartrcdsneedstobeinsert.size() > 0){
            insert cartrcdsneedstobeinsert;
        }
        return returntext;
    } 
    
    @AuraEnabled
    public static string updatecartitemrcd(string miname,decimal quantity){
        try{
            Cart_Items__c cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c=:miname and CreatedById=:userinfo.getuserid() limit 1];
            if(cartrcds != null){
                cartrcds.Quantity__c = quantity;
                update cartrcds;
            }
            return 'success';
        }
        catch(exception e){
            return e.getMessage();
        }
    }
    
}