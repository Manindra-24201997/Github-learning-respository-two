@isTest
public class TrilliumJobRequestLtCtrlTest {
    static testmethod void tesmethod(){
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
        insert testSpec1;
        
        Production_Estimate_Template__c testPEtemp=new Production_Estimate_Template__c(Name='Testing PE Temp');
        insert testPEtemp;
        
         
         
        Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id);
        insert testSPI1;     
        
        
        Material_Item__c  Material=new Material_Item__c (name='test 123',Type__c='Trillium CNG',Store_Type__c ='test',Store_Front__c=true,Creative_Brief_Template__c=testSpec1.id,Production_Estimate_Template__c=testPEtemp.id);
        insert Material;
        
        Production_Estimate_Temp_Line_Items__c testPELine=new Production_Estimate_Temp_Line_Items__c(Name='PELine',Material_Item__c=Material.id,Production_Estimate_Template__c=testPEtemp.id);
        insert testPELine;
        
        Client__c testClient=new Client__c(Name='Trillium CNG',Client_Group__c='Test;ui');
        insert testClient;
        
        
        Client_Contact__c testclientcontact = new Client_Contact__c(Client__c=testClient.id,Active__c=true,Email__c='demo3@gmail.com',UserName__c='demo3@test1.com',First_Name__c='demo3',Last_Name__c='Testing3',Salesforce_User__c=true  );         
        insert  testclientcontact ;  
        
        user lstUser = [select firstname ,Username,Id, Profile.Name  from user where Username=:testclientcontact.UserName__c ];
        
        Client_Contact__c TestClientCon=[select id, name,UserName__c,Client__c, Client__r.Name   from Client_Contact__c  where UserName__c =:lstUser.Username];
        
        Media_Type__c MediaType= new Media_Type__c (name='Print');
        insert MediaType;
        
        Media_Type__c StoreMediaType= new Media_Type__c (name='Supplies');
        insert StoreMediaType;
        
        Media_Type__c BillboardMediatype= new Media_Type__c (name='Outdoor');
        insert BillboardMediatype;
        
        Schedule_Template__c NameTagScheduletype =new Schedule_Template__c ( name ='Name Tag',Media_Types__c = MediaType.id);
        insert NameTagScheduletype ;
        
        Schedule_Template__c NamePlateScheduletype =new Schedule_Template__c ( name ='Corporate Office Nameplate',Media_Types__c = MediaType.id);
        insert NamePlateScheduletype ;
        
        Schedule_Template__c NameStoreScheduletype=new Schedule_Template__c ( name ='Made To Order',Media_Types__c = MediaType.id);
        insert NameStoreScheduletype;  
        
        Schedule_Template__c NameBusinessCardScheduletype=new Schedule_Template__c ( name ='Store Business Card',Media_Types__c = MediaType.id);
        insert NameBusinessCardScheduletype;  
        
        Schedule_Template__c NameCorporateCardScheduletype=new Schedule_Template__c ( name ='Corporate Business Card',Media_Types__c = MediaType.id);
        insert NameCorporateCardScheduletype;
        
        Schedule_Template__c NameBillboardScheduletype=new Schedule_Template__c ( name ='Billboard Repair',Media_Types__c = BillboardMediatype.id);
        insert NameBillboardScheduletype;
        
        Holiday__c holiday=new Holiday__c(Date__c=System.today());
        insert holiday;
        
       // System.runAs(lstUser) 
        //{
            TrilliumJobRequestLtCtrl.getClientContacts();
            TrilliumJobRequestLtCtrl.getMaterialItemList();
            TrilliumJobRequestLtCtrl.showItems('test');
            TrilliumJobRequestLtCtrl.MaterialItemWrapper miWrpr=new TrilliumJobRequestLtCtrl.MaterialItemWrapper();
            miWrpr.MIWrap=Material;
            miWrpr.MISelect=true;
            TrilliumJobRequestLtCtrl.getCombinedList(new list<Client_Contact__c>{testclientcontact}, new list<TrilliumJobRequestLtCtrl.MaterialItemWrapper>{miWrpr});
            TrilliumJobRequestLtCtrl.CombinedWrapper cmbWrpr=new TrilliumJobRequestLtCtrl.CombinedWrapper();
            TrilliumJobRequestLtCtrl.CombinedWrapperItem cmbItem=new TrilliumJobRequestLtCtrl.CombinedWrapperItem();
            cmbItem.mItem=Material;
            cmbItem.enteredQty=2;
            cmbWrpr.Email='test@test.com';
            cmbWrpr.BillingInstru='test';
            cmbWrpr.itemsList=new list< TrilliumJobRequestLtCtrl.CombinedWrapperItem>{cmbItem};
            TrilliumJobRequestLtCtrl.placeOrder(new list<TrilliumJobRequestLtCtrl.CombinedWrapper>{cmbWrpr},new list<Material_Item__c>{Material});
            cmbWrpr.editmode=true;
            TrilliumJobRequestLtCtrl.placeOrder(new list<TrilliumJobRequestLtCtrl.CombinedWrapper>{cmbWrpr},new list<Material_Item__c>{Material});
            cmbWrpr.Acceptance=true;
            TrilliumJobRequestLtCtrl.placeOrder(new list<TrilliumJobRequestLtCtrl.CombinedWrapper>{cmbWrpr},new list<Material_Item__c>{Material});
       	
       // }
    } 
}