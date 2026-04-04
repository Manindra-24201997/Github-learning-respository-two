public with sharing class MultiStoreOrderLigtningCmpCtrlPro {
    
 @AuraEnabled
    public static  list<ClientWrapper> getClientList(){
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c  clientcontact=[Select id,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        System.debug('ClientContact'+clientcontact.name);
        System.debug('Client'+clientcontact.Client__r.Name);
        string clientname=clientcontact.Client__r.Name;
        list<Client__c> jsClientlist=new list<Client__c>();
        list<ClientWrapper> CWrap= new list<ClientWrapper>();
        if(clientname.contains('District')){
            for(Client__c loopClient :[Select id,name,Client_Code__c,Hierarchy__r.Hierarchy__c from Client__c where name like '%Store%' AND (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient=loopClient;
                varClientWrap.varCSelect= false;
                CWrap.add(varClientWrap);
                //jsClientlist.add(loopClient);
            }
        }
        if(clientname.contains('Division')){
            for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where name like '%Store%' AND  (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient=loopClient;
                varClientWrap.varCSelect= false;
                CWrap.add(varClientWrap);
                //jsClientlist.add(loopClient);
            }
        }
        if(clientname.contains('Corporate')){
            for(Client__c loopClient :[Select id,name,Client_Code__c from Client__c where name like '%Store%' AND  (id=:clientcontact.Client__c OR Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__c=:clientcontact.Client__c OR Hierarchy__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c) order by Client_Code__c]){
                ClientWrapper varClientWrap = new ClientWrapper();
                varClientWrap.varClient=loopClient;
                varClientWrap.varCSelect= false;
                CWrap.add(varClientWrap);
                //jsClientlist.add(loopClient);
            }
        }
        return CWrap;
    }
    
    // Start Wrapper Class : This class will bind checkbox and its associated Client on layout
    public class ClientWrapper{
        @AuraEnabled   public Client__c varClient{get;set;}
        @AuraEnabled   public Boolean varCSelect{get;set;}
        public ClientWrapper(){
            varClient= new Client__c();  
            varCSelect= false;
        }
    }  
    // End of Wrapper Class
    
    @AuraEnabled
    public static list<string> getMaterialType(){
        list<string> MaterialType= new list<string>();        
        for(schema.picklistEntry p : Material_Item__c.Type__c.getDescribe().getPicklistValues()){
            MaterialType.add(p.getLabel());
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
        // list<MIWrapper> roleWraps = new list<MIWrapper>();
        Map<string,string> MediaNameToRefIdMap= new Map<string,string>();
        //List<string> MediaNameList= new List<string>();
        // List<string> MediaIdList = new List<string>();
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c  clientcontact=[Select id,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        string clntGroup = clientcontact.Client__r.Client_Group__c;
        string[] split = clntGroup.Split(';');
        for(string item :split)
        {
            Storegrps.add(item);
        }
        string MIname='%'+MaterialItemNameString+'%';
        
        if(MIname!='%%' && MaterialTypeString!='')
        {
            
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Out_of_Stock__c,Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where  Name like: MIname AND Type__c=:MaterialTypeString AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC  limit 1000];
        }
        
        else if(MIname=='%%' && MaterialTypeString !='')
        {
            
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Out_of_Stock__c,Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c where   Type__c=:MaterialTypeString AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC limit 1000];
            
        }
        
        else if(MIname!=null && MaterialTypeString =='')
        {
            MaterialItems=[select id,name,Calc_Unit__c,Max_Qty__c,Out_of_Stock__c,Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Store_Front__c,Type__c,Package_Type__c,File_Photo__c,Description__c from Material_Item__c  where  Name like: MIname  AND Store_Front__c=true AND Store_Type__c IN:Storegrps ORDER BY Name ASC  limit 100];
        }
        //MaterialItems = [select id, name, Calc_Unit__c, Out_of_Stock__c, Re_Stocking__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC), Store_Front__c, Max_Qty__c, Type__c, Attachment_ID__c, Package_Type__c, File_Photo__c, Description__c from Material_Item__c where  Type__c = : MaterialTypeString and Store_Front__c = true AND Store_Type__c IN: Storegrps ORDER BY Name ASC limit 1000];
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
                rw.greycolor = '';
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
            }
            /* for(Id referenceId : rolewraps.keySet())
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
system.debug(MediaIdList);*/
        }
        return roleWraps;
    }
    
    @AuraEnabled
    public static  list<CombinedWrapper> combinedDataList(list<Client__c> clientStoreSelectList,list<Id> cartItemIds){
        List<Material_Item__c > newlist=new List<Material_Item__c >();
        map<string,Cart_Items__c>crcdmap = new map<string,Cart_Items__c>();
        list<CombinedWrapper> CombineWrap=new list<CombinedWrapper>();
        system.debug('--clientStoreSelectList--'+clientStoreSelectList);
        system.debug('--cartItemIds--'+cartItemIds);
        list<Cart_Items__c>cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where  CreatedById=:userinfo.getuserid() order by Material_Item__c asc];
        for(Cart_Items__c crcd : cartrcds){
            crcdmap.put(crcd.Material_Item__c,crcd);
        }
        for(Client__c cc:clientStoreSelectList){
            //  CombineWrap.add(new CombinedWrapper(cc, newlist));
            List<MultiMIWrapperList> test=new List<MultiMIWrapperList>();
            for(Material_Item__c  Mi:[select id,name,Calc_Unit__c,Store_Front__c,Max_Qty__c,Type__c,Package_Type__c,File_Photo__c,Description__c,Re_Stocking__c from Material_Item__c  where id in:cartItemIds order by name asc limit 1000])
            {
                if(crcdmap.containskey(Mi.Name)){
                    Cart_Items__c cobj =  crcdmap.get(Mi.Name);
                    Test.add(new MultiMIWrapperList(Mi,integer.valueof(cobj.Quantity__c)));  
                }
                else{
                    Test.add(new MultiMIWrapperList(Mi,1));  
                }
            }
            CombineWrap.add(new CombinedWrapper(cc,Test));  
        }  
        system.debug('--CombineWrap-'+CombineWrap);
        return CombineWrap;
    }
    
    @AuraEnabled
    public static Map<Id,MIWrapper> getcartitemrcds(){
        Map<Id,MIWrapper> roleWraps=new Map<Id,MIWrapper>();
        map<string,Cart_Items__c>cartrcdsmap = new map<string,Cart_Items__c>();
        list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where CreatedById=:userinfo.getuserid() order by Material_Item__c asc];
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
                roleWraps.put(rw.Mi.id,rw);      
            }
        }        
        return roleWraps;
    }
    
    @AuraEnabled
    public static string deletecartitemrcds(string minamedelval){
        Cart_Items__c cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c=:minamedelval and CreatedById=:userinfo.getuserid() limit 1];
        if(cartrcds != null){
            delete cartrcds;
            return 'deleted';
        }
        else{
            return 'no rcds';
        }
    }
    
    
    @AuraEnabled    
    public static string submitTocheck(list<CombinedWrapper>CombineWrap){
        system.debug('---CombineWrap----jobs----'+CombineWrap);
        map<string,Material_Item__c>mimap = new map<string,Material_Item__c>();
        Map<String,String>clientmap = new Map<String,String>();
        Map<String,Client_Contact__c>clientcntmap = new Map<String,Client_Contact__c>();
        list<string>returntextvalues = new list<string>();
        list<string> clntids = new list<string>();
        list<string> peccdids = new list<string>();
        list<Cart_Items__c>cartrcds = new list<Cart_Items__c>();
        list<Cart_Items__c>cartrcdsneedstobeinsert = new list<Cart_Items__c>();
        map<string,Cart_Items__c>cartrcdsmap = new map<string,Cart_Items__c>();
        for(CombinedWrapper cbw:CombineWrap)
        {
            clntids.add(cbw.varCombineClient.id);
            /* clntids.add(cbw.varCombineClient.Hierarchy__c);
clntids.add(cbw.varCombineClient.Hierarchy__r.Hierarchy__c);*/
            clientmap.put(cbw.varCombineClient.id,cbw.varCombineClient.id); //store
            clientmap.put(cbw.varCombineClient.Hierarchy__c,cbw.varCombineClient.Hierarchy__c);//District
            clientmap.put(cbw.varCombineClient.Hierarchy__r.Hierarchy__c,cbw.varCombineClient.Hierarchy__r.Hierarchy__c);//Division
            //clientmap.put('a02G000000OvXy6IAF','a02G000000OvXy6IAF');
            for(MultiMIWrapperList item:cbw.MultiitemMap2)
            {
                mimap.put(Item.Mi.id,Item.Mi);//New line added here on 14 - 07 - 2022
                if(Item.Quantity > Item.Mi.Max_Qty__c){ return 'QuantityError';}
            }
            
        }
        Client__c crcd = [Select Id,name,Hierarchy__r.Hierarchy__c,Hierarchy__r.Hierarchy__r.name from Client__c where id =:clntids ];      
        
        // New logic added on 21 - 07 - 2022 for Same material item selected by GM  less than 5 days with store wise functionality
        string returntext = '';
        decimal days = 0 ;
        decimal workingDays = 0;
        list<Client_Contact__c> clncon=[select id,name,Client__c, Client__r.name,UserName__c from Client_Contact__c where Client__c =: clientmap.keySet() or Client__c =:crcd.Hierarchy__r.Hierarchy__c  WITH SECURITY_ENFORCED order by name asc];
        if(clncon.size() > 0){
            for(Client_Contact__c clncntusrnames : clncon){
                clientcntmap.put(clncntusrnames.UserName__c,clncntusrnames);
            }
            list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate,Job__r.JS_Client__c  from Production_Estimate__c
                                                           where Material_Item__c =: mimap.keySet() and CreatedBy.username =: clientcntmap.keySet()  and createddate >= LAST_N_DAYS:10 and Job__r.JS_Client__c =:clntids  order by createddate desc];  
            
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
                            if(pe.CreatedBy.userrole.name == 'District Manager' ||  pe.CreatedBy.userrole.name == 'Division Director' || pe.CreatedBy.userrole.name == 'Division Merch Manager'){
                                returntextvalues.add(pe.Material_Item__r.name);
                                //returntext =  'You already placed an order for this item this week';
                                //return string.valueof(workingDays) + 'You already placed an order for this item this week';
                            }
                            else{
                                returntextvalues.add(pe.Material_Item__r.name);
                                // returntext =  'GM';
                                //return string.valueof(workingDays) + 'GM';
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
            returntext = '';  
        }
        if(string.isNotBlank(returntext)){
            returntext = returntext.removeEnd(',');  
        }
        else{
            returntext = 'No records';
            cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c NOT IN:returntextvalues and CreatedById=:userinfo.getuserid()  order by Material_Item__c asc];
            if(cartrcds.size() > 0){
                for(Cart_Items__c crcds : cartrcds){
                    cartrcdsmap.put(crcds.Material_Item__c,crcds);
                }
            }
        }
        
        //Below items hold logic which are added to cart
        for(CombinedWrapper cbw:CombineWrap)
        {
            for(MultiMIWrapperList item:cbw.MultiitemMap2)
            {
                if(!cartrcdsmap.containskey(item.Mi.Name)){
                    if(!returntextvalues.contains(item.Mi.Name)){
                        Cart_Items__c cartitemssobj = new Cart_Items__c();
                        cartitemssobj.Material_Item__c = item.Mi.Name;
                        cartitemssobj.Quantity__c = 1;
                        cartrcdsneedstobeinsert.add(cartitemssobj);  
                    }
                }
            }
        }
        
        if(cartrcdsneedstobeinsert.size() > 0){
            insert cartrcdsneedstobeinsert;
        }
        return returntext;       
    }
    
    @AuraEnabled    
    public static string CreateJobswithchild(list<CombinedWrapper> CombineWrap){
        system.debug('---CombineWrap----jobs----'+CombineWrap);
        map<string,Material_Item__c>mimap = new map<string,Material_Item__c>();
        map<string,Material_Item__c>mimapnames = new map<string,Material_Item__c>();
        list<string>returntextvalues = new list<string>();
        map<string,Cart_Items__c>cartrcdsmap = new map<string,Cart_Items__c>();
        
        Map<String,String>clientmap = new Map<String,String>();
        Map<String,Client_Contact__c>clientcntmap = new Map<String,Client_Contact__c>();
        list<Production_Estimate__c> ProdEstimateList =new List<Production_Estimate__c>();
        List<Job__c> JobsTobeInsert=new List<Job__c>();
        Map<String,String> ClientJobMap= new  Map<String,String> ();
        Media_Type__c  NameStoreMediatype=[Select id ,name from Media_Type__c where name='Supplies' limit 1];
        system.debug('---NameStoreMediatype----jobs----'+NameStoreMediatype);
        Schedule_Template__c  NameStoreScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Store Order' AND Media_Types__r.name='Supplies' limit 1];
        system.debug('---NameStoreScheduletype----jobs----'+NameStoreScheduletype);
        list<string> clntids = new list<string>();
        for(CombinedWrapper cbw:CombineWrap)
        {
            clntids.add(cbw.varCombineClient.id);
            /* clntids.add(cbw.varCombineClient.Hierarchy__c);
clntids.add(cbw.varCombineClient.Hierarchy__r.Hierarchy__c);*/
            clientmap.put(cbw.varCombineClient.id,cbw.varCombineClient.id); //store
            clientmap.put(cbw.varCombineClient.Hierarchy__c,cbw.varCombineClient.Hierarchy__c);//District
            clientmap.put(cbw.varCombineClient.Hierarchy__r.Hierarchy__c,cbw.varCombineClient.Hierarchy__r.Hierarchy__c);//Division
            //clientmap.put('a02G000000OvXy6IAF','a02G000000OvXy6IAF');
            for(MultiMIWrapperList item:cbw.MultiitemMap2)
            {
                mimap.put(Item.Mi.id,Item.Mi);//New line added here on 14 - 07 - 2022
                mimapnames.put(item.Mi.Name,item.Mi);
                if(Item.Quantity > Item.Mi.Max_Qty__c){ return 'QuantityError';}
            }
        }
        Client__c crcd = [Select Id,name,Hierarchy__r.Hierarchy__c,Hierarchy__r.Hierarchy__r.name from Client__c where id =:clntids ];      
        
        
        // New logic added on 21 - 07 - 2022 for Same material item selected by GM  less than 5 days with store wise functionality
        string returntext = '';
        decimal days = 0 ;
        decimal workingDays = 0;
        list<Client_Contact__c> clncon=[select id,name,Client__c, Client__r.name,UserName__c from Client_Contact__c where Client__c =: clientmap.keySet() or Client__c=:crcd.Hierarchy__r.Hierarchy__c WITH SECURITY_ENFORCED order by name asc];
        if(clncon.size() > 0){
            for(Client_Contact__c clncntusrnames : clncon){
                clientcntmap.put(clncntusrnames.UserName__c,clncntusrnames);
            }
            list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate,Job__r.JS_Client__c  from Production_Estimate__c
                                                           where Material_Item__c =: mimap.keySet() and CreatedBy.username =: clientcntmap.keySet()  and createddate >= LAST_N_DAYS:10 and Job__r.JS_Client__c =:clntids order by createddate desc];  
            if(percd.size() > 0){
                //return string.valueof(percd.size());
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
                                //return 'You already placed an order for this item this week';
                                //return string.valueof(workingDays) + 'You already placed an order for this item this week';
                            }
                            else{
                                returntextvalues.add(pe.Material_Item__r.name);
                                //return 'GM';
                                //return string.valueof(workingDays) + 'GM';
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
            returntext = '';  
        }
        if(string.isNotBlank(returntext)){
            returntext = returntext.removeEnd(',');  
            return returntext;
        }
        else{
            returntext = 'No records';
        }
        
        //Below is logic for self user  DM - DM
        /*decimal days5 = 0 ;
decimal workingDays5 = 0;
list<Job__c>jrcd = [select id,name,JS_Client__c, JS_Client__r.name,(select id,name,Material_Item__c,Material_Item__r.name,CreatedDate from Production_Estimates__r) from Job__c where JS_Client__c =: clientcntmap.keySet() and createddate >=  LAST_N_DAYS:10 and CreatedById =: userinfo.getuserid() order by createddate desc];
if(jrcd.size() > 0){
for(Job__c jj : jrcd ){
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
if(pe.CreatedBy.userrole.name == 'District Manager' ||  pe.CreatedBy.userrole.name == 'Division Manager' || pe.CreatedBy.userrole.name == 'Division Merch Manager'){
return 'You already placed an order for this item this week';
}
}
else{
return 'GM';
}
}  
}
}
}

}*/
        
        //The below line user soql newly added on 14 - 07 - 2022
        /* set<string>usersset = new set<string>();
list<user> lstUser = [select firstname,Username,Id,Profile.Name,userrole.name  from user where userrole.name = 'General Manager' and IsActive = true order by name];
for(user usrnm:lstUser){
usersset.add(usrnm.Username);
}

//New logic added on 15 - 07 - 2022 for Same material item selected by GM less than  5 days.
decimal days = 0 ;
decimal workingDays = 0;
list<Production_Estimate__c>percd = [select id,name,Material_Item__c, Material_Item__r.name,Job__c,Job__r.name,createdby.name,createdby.IsActive, createdby.Username,CreatedBy.UserRole.name,CreatedDate  from Production_Estimate__c
where Material_Item__c =: mimap.keySet() and (CreatedBy.userrole.name = 'District Manager' or  CreatedBy.userrole.name = 'Division Manager' or CreatedBy.userrole.name = 'Division Merch Manager' or CreatedBy.userrole.name = 'General Manager') and createddate >= LAST_N_DAYS:10  WITH SECURITY_ENFORCED order by createddate desc];  
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
if(pe.CreatedBy.userrole.name == 'District Manager' ||  pe.CreatedBy.userrole.name == 'Division Manager' || pe.CreatedBy.userrole.name == 'Division Merch Manager'){
return 'You already placed an order for this item this week';
}
else{
return 'GM';
}
}
else{
workingDays = 0;  
}
}  
}
}*/
        //Ends Here
        
        try{
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
                            ProdEstimate.FromStoreFront__c=true;
                            //system.debug('----from storefront----'+  ProdEstimate.FromStoreFront__c);
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
                system.debug('----ProdEstimateList ProdEstimateList----'+ProdEstimateList);
                if(ProdEstimateList.size() > 0){
                    list<Cart_Items__c> cartrcds = [select id,name,Material_Item__c,Quantity__c,createddate,createdby.name,CreatedById from Cart_Items__c where Material_Item__c=:mimapnames.keyset() and CreatedById=:userinfo.getuserid()];
                    if(cartrcds.size() > 0){
                        delete   cartrcds;
                    }
                }
            }
            return 'success';
            //return 'success' + string.valueOf(workingDays);
        }
        catch(Exception e){
            return ''+e;
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
    
    // Start Wrapper Class
    public class MIWrapper
    {
        @AuraEnabled  public String  greycolor {get;set;}
        @AuraEnabled  public Material_Item__c MI{get;set;}
        @AuraEnabled  public Boolean checked{get;set;}
        @AuraEnabled  public String  ContentVersionId {get;set;}
        public  MIWrapper()
        {
        }  
    }
    // End of Wrapper Class
    
    // Start Wrapper Class will hold child wrapper MultiMIWrapperList
    
    public class CombinedWrapper{
        @AuraEnabled   public Client__c varCombineClient{get;set;}    
        @AuraEnabled   public List<MultiMIWrapperList> MultiitemMap2{get;set;}
        public CombinedWrapper(){
        }
        public CombinedWrapper(Client__c  varCombineClient, List<MultiMIWrapperList> MultiitemMap2){
            this.varCombineClient= varCombineClient;
            this.MultiitemMap2= MultiitemMap2;
        }
    }  
    // End of Wrapper Class
    
    public class MultiMIWrapperList
    {
        @AuraEnabled  public Material_Item__c MI{get;set;}
        @AuraEnabled  public integer quantity{get;set;}
        @AuraEnabled  public boolean showQtyErrorMsg{Set;Get;}
        @AuraEnabled  public string ErrMsg{Set;Get;}
        public  MultiMIWrapperList(){
        }
        public  MultiMIWrapperList(Material_Item__c MI, Integer quantity)
        {
            this.MI= MI;
            this.quantity=quantity;
            showQtyErrorMsg=false;
        }  
    }    
}