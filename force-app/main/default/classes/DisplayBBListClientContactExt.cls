public class DisplayBBListClientContactExt {
    @AuraEnabled
    public static List<BillboardWrapper> DisplayBillboardList(){
        
        List<Billboard__c> BillboardList =new List<Billboard__c>();
        List<BillboardWrapper>  BBWrapperList = new List<BillboardWrapper>();
        
        User lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        Client_Contact__c clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        
        Client__c CC=[select id, name,Longitude__c,Hierarchy__c, Latitude__c from Client__c  where id=:clientcontact.Client__c];
        
        string clientname=cc.name;  
        
        if(clientname.contains('Store')){
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c];
        }
        
        else if(clientname.contains('District')){
            
            system.debug('>>>>>>>>>>clientcontact.Client__c>>>>>>>>>'+clientcontact.Client__r.name); 
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c];
            
            system.debug('>>>>>>>>>>>>>>>>>>>'+BillboardList);
            
        }
        
        else if(clientname.contains('Division')){
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Client_Name__r.Hierarchy__c,Client_Name__r.Hierarchy__r.Hierarchy__c,Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__c=:clientcontact.Client__c OR Client_Name__r.Hierarchy__r.Hierarchy__c=:clientcontact.Client__c];
        } 
        
        else{
            
            BillboardList =[Select id ,name ,Title__c,Client_Name__c,(SELECT ContentDocumentId, Id, IsDeleted FROM ContentDocumentLinks Order by SystemModstamp DESC),Photo_2_New__c,BB_Vendor__r.name,Latitude__c,Longitude__c,PMT__c,Illumination__c,Expiration_Date__c,Location__c,Billboard_Type__c,Photo_1_New__c,Billboard_Status__c from Billboard__c where Client_Name__c=:clientcontact.Client__c];
        }
        
        Set<Id> contentDocumentIdSet =new Set<Id>();
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    contentDocumentIdSet.add(cdl.ContentDocumentId);
                }
            }
        }
        
        Map<Id,String> contentDocMap=new Map<Id,String>();
        Map<Id,List<String>> contentVerMap=new Map<Id,List<String>>();
        
        List<ContentVersion> conVersList=[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion where ContentDocumentId IN:contentDocumentIdSet and isLatest=true and FileType!='SNOTE' Order by CreatedDate DESC];
        for(ContentVersion cv:conVersList){
            contentDocMap.put(cv.ContentDocumentId,cv.Id);
        }
        
        if(!BillboardList.isEmpty()){
            for(Billboard__c bb: BillboardList){
                for(ContentDocumentLink cdl: bb.ContentDocumentLinks){
                    if(contentDocMap.containskey(cdl.ContentDocumentId))
                    {
                        if(contentVerMap.containskey(bb.Id))
                        {
                            List<String> ConVeList=contentVerMap.get(bb.Id);
                            ConVeList.add(contentDocMap.get(cdl.ContentDocumentId));
                            contentVerMap.put(bb.Id,ConVeList);
                        }
                        else
                        {
                            contentVerMap.put(bb.Id,new List<string> {contentDocMap.get(cdl.ContentDocumentId)});
                        }
                    }
                }
            }
        }
        
        for(Billboard__c bb: BillboardList){
            if(!contentVerMap.containsKey(bb.Id))
            {
                list<String> aa=new List<string>();
                contentVerMap.put(bb.Id,aa);
            }
        }
        
        for(Billboard__c BB:BillboardList)
        {
            BillboardWrapper BBW = new BillboardWrapper();
            BBW.BBWrap= BB;
            BBW.ContentVersionId=new List<String>();
            for(ContentDocumentLink cdl:BB.ContentDocumentLinks){
                if(contentVerMap.containsKey(bb.Id)){
                    BBW.ContentVersionId=contentVerMap.get(bb.Id);                    break;
                }
            } 
            BBWrapperList.add(BBW);           
        }
        
        return BBWrapperList;
    }
    // Start Wrapper Class 
    public class BillboardWrapper
    {
        @AuraEnabled public Billboard__c BBWrap{get;set;}
        @AuraEnabled public List<String> ContentVersionId {get;set;}
        public BillboardWrapper()
        {
            BBWrap= new Billboard__c();
        }
        
    }   
    // End of Wrapper Class
}