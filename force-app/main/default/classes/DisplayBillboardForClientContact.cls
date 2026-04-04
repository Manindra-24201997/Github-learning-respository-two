Global with sharing class DisplayBillboardForClientContact{
    
    Public List<Billboard__c> BillboardList {get;set;}
    Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;}
    Public Client__c CC {get;set;}
    Public String centerLat{get; set;}
    Public String centerLang{get; set;}
    
    public  DisplayBillboardForClientContact(){
        system.debug('DisplayBillboardForClientContact constructor loaded === ');
        
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        system.debug('clientcontact ==== '+clientcontact.name);
        CC=[select id, name,Longitude__c, Latitude__c from Client__c  where id=:clientcontact.Client__c];
        system.debug('client ==== '+CC.name);
        centerLat = cc.Latitude__c ;
        centerLang = cc.Longitude__c ;
        
        
        BillboardList =[Select id ,name ,Attachment_ID__c,Client_Name__c,BB_Vendor__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch')];
        system.debug('BillboardList ==== '+BillboardList.size());
        
    }
    
    @RemoteAction         
    global static List<wrapper> findAll(String Clientid12) {
        system.debug('findAll called');
        list<wrapper> wrapperlist=new list<wrapper>();     
        Client__c   CC1=[select id, name,Longitude__c, Latitude__c from Client__c  where id=:Clientid12];  
        list<Billboard__c> billboards;
        string clientname=CC1.name;
        
        if(clientname.contains('Store')){
            system.debug('store');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c,Latitude__c,Photo_1_New__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where Client_Name__c =:Clientid12 and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch')];
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else if(clientname.contains('District')){
            system.debug('District');
            billboards= [SELECT Id, Name, Longitude__c,Latitude__c, Attachment_ID__c,Photo_1_New__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where (Client_Name__c =:Clientid12 OR Client_Name__r.Hierarchy__c=:Clientid12) and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch')];
            
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else if(clientname.contains('Division')){
            system.debug('Division');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c, Latitude__c,Photo_1_New__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where (Client_Name__c =:Clientid12 OR Client_Name__r.Hierarchy__c=:Clientid12 OR Client_Name__r.Hierarchy__r.Hierarchy__c=:Clientid12) and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch')];
            wrapperlist=method(billboards);
            return wrapperlist;
        }
        
        else {
            system.debug('else');
            billboards= [SELECT Id, Name, Longitude__c, Attachment_ID__c,Latitude__c,Photo_1_New__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC) FROM Billboard__c where Client_Name__c =:Clientid12 and (Billboard_Status__c = 'Active' OR Billboard_Status__c ='Active-Batch')];
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
            for(ContentDocumentLink cdl:bb.ContentDocumentLinks){
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