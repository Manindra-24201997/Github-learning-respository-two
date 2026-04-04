Global with sharing class MapClassforClientDetail {
    Public List<Billboard__c> BillboardList {get;set;}
    //Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;}
    Public Client__c CC {get;set;}
    Public String centerLat{get; set;}
    Public String centerLang{get; set;}
    Public String ltlo{get; set;}
    
    public  MapClassforClientDetail(){
        system.debug('DisplayBillboardForClientContact constructor loaded === ');
        
        String clientid = apexpages.currentpage().getparameters().get('id');
        system.debug('client id === '+clientid);
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
       /* clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where Client__c =: clientid limit 1];
        system.debug('clientcontact ==== '+clientcontact.name);*/
        CC=[select id, name,Longitude__c, Latitude__c from Client__c  where id=:clientid];
        system.debug('client ==== '+CC.name);
        centerLat = cc.Latitude__c ;
        centerLang = cc.Longitude__c ;
        BillboardList =[Select id ,name ,Attachment_ID__c,Client_Name__c,BB_Vendor__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c,Latitude__c,Longitude__c from Billboard__c where Client_Name__c=:clientid and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch' OR Billboard_Status__c = 'Cancelled' OR Billboard_Status__c = 'Pending')];
        system.debug('BillboardList ==== '+BillboardList.size());
        if(CC != null && BillboardList.size() > 0){
        if((cc.Latitude__c == null || cc.Longitude__c == null) && (string.isNotBlank(BillboardList[0].Latitude__c) && string.isNotBlank(BillboardList[0].Longitude__c)))
        {
            ltlo = 'clientnull';
            centerLat = BillboardList[0].Latitude__c ;
            centerLang = BillboardList[0].Longitude__c  ;  
        }
        else if( (cc.Latitude__c == null || cc.Longitude__c == null) && (string.isBlank(BillboardList[0].Latitude__c) || string.isBlank(BillboardList[0].Longitude__c)))
        {
            ltlo = 'clientandbillboardnull';
            centerLat = '37.0902405' ;
            centerLang = '-95.7128906';
        }
        else{
            centerLat = cc.Latitude__c ;
            centerLang = cc.Longitude__c ; 
        }
        }
        else{
            if(string.isNotBlank(cc.Latitude__c) && string.isNotBlank(cc.Longitude__c))
            {
            centerLat = cc.Latitude__c ;
            centerLang = cc.Longitude__c ;
            }
            else{
               ltlo = 'clientandbillboardnull';
            centerLat = '37.0902405' ;
            centerLang = '-95.7128906'; 
            }
        }
        /* centerLat = cc.Latitude__c ;
centerLang = cc.Longitude__c ; */    
    }
    
    @RemoteAction         
    public static List<wrapper> findAll(string Clientid12) {
        // system.debug('client id from parameter  === '+Clientid12);
        /* string  Clientid12 = apexpages.currentpage().getparameters().get('id');
system.debug('client id in method === '+Clientid12);*/
        
        list<wrapper> wrapperlist=new list<wrapper>();     
        Client__c   CC1=[select id, name,Longitude__c, Latitude__c from Client__c  where id=:Clientid12];  
        list<Billboard__c> billboards;
        string clientname=CC1.name;
        
        if(clientname.contains('Store')){
            system.debug('store');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c,Latitude__c,Photo_1_New__c,Billboard_Status__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where Client_Name__c =:Clientid12 and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch' OR Billboard_Status__c = 'Cancelled' OR Billboard_Status__c = 'Pending')];
            system.debug('billboards size === '+billboards.size());
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else if(clientname.contains('District')){
            system.debug('District');
            billboards= [SELECT Id, Name, Longitude__c,Latitude__c, Attachment_ID__c,Photo_1_New__c,Billboard_Status__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where (Client_Name__c =:Clientid12 OR Client_Name__r.Hierarchy__c=:Clientid12) and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch'  OR Billboard_Status__c = 'Cancelled' OR Billboard_Status__c = 'Pending')];
            system.debug('billboards size === '+billboards.size());
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else if(clientname.contains('Division')){
            system.debug('Division');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c, Latitude__c,Photo_1_New__c,Billboard_Status__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where (Client_Name__c =:Clientid12 OR Client_Name__r.Hierarchy__c=:Clientid12 OR Client_Name__r.Hierarchy__r.Hierarchy__c=:Clientid12) and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch'  OR Billboard_Status__c = 'Cancelled' OR Billboard_Status__c = 'Pending')];
            system.debug('billboards size === '+billboards.size());
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else {
            system.debug('else');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c,Latitude__c,Photo_1_New__c,Billboard_Status__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where Client_Name__c =:Clientid12 and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch'  OR Billboard_Status__c = 'Cancelled' OR Billboard_Status__c = 'Pending')];
            system.debug('billboards size === '+billboards.size());
            wrapperlist=method(billboards);
            return wrapperlist;
        }    
        
    }
    
    public static list<wrapper> method(list<Billboard__c> billboards){
        system.debug('method called');
        Set<Id> contentDocumentIdSet=new set<ID>();
        Map<Id,String> contentDocMap=new map<Id,string>();
        list<wrapper> wrapperlist=new list<wrapper>();     
        for(Billboard__c bb: billboards){
            for(ContentDocumentLink cdl: bb.ContentDocumentLinks){  
                contentDocumentIdSet.add(cdl.ContentDocumentId);
            }
        }
        for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC]){
            if(!contentDocMap.containsKey(cv.ContentDocumentId)){
                contentDocMap.put(cv.ContentDocumentId,cv.Id);
            }
        }
        for(Billboard__c bb: billboards)
        {
            wrapper wrp=new wrapper();
            wrp.billboard=bb;
            for(ContentDocumentLink cdl:bb.ContentDocumentLinks) { 
                if(contentDocMap.containsKey(cdl.ContentDocumentId)){
                    wrp.contentversionId=contentDocMap.get(cdl.ContentDocumentId);
                    break;
                }
            }
            wrapperlist.add(wrp);
        }
        return wrapperlist;
    }
    global class wrapper{
        public Billboard__c billboard{get;set;}
        public string contentversionId {get;set;}
    }
}