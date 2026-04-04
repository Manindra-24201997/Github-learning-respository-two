public class CustomOrderRequestFormExt {
    
    public boolean savebtn{get;set;}
    Public Client_Contact__c  clientContact{get;set;}
    Public User lstUser{get;set;} 
    Public Media_Type__c NameMediatype{get;set;}
    Public Schedule_Template__c NameCustomScheduletype{get;set;} 
    Public String CustomQuantityNeeded{get;set;}
    Public String CustomMeasurements{get;set;}
    Public String Customrequest{get;set;}
    Public String Customneedtosay{get;set;}
    Public String Customneedtogo{get;set;}
    public Attachment myfileattach;
    public Attachment getmyfileattach()
    {
        myfileattach=new Attachment();
        return myfileattach;
    }
    
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
    
    public CustomOrderRequestFormExt(){
        savebtn=false;
        NameMediatype=[Select id ,name from Media_Type__c where name='Print' limit 1];
        NameCustomScheduletype=[Select id , name,Media_Types__c from Schedule_Template__c where name ='Custom Order' AND Media_Types__r.name='Print' limit 1];// added new form Custom Store Order in Store Order type
        
        lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid() ];
        
        clientcontact=[Select id,Mobile_Phone__c,Client_Contact_Role__c,Business_Phone__c,Fax__c,Email__c , name,Client__c,UserName__c,Client__r.Dummy_Picklist_1__c, Client__r.Client_Group__c,Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
        
    }
    
    Public pagereference Save(){
        
        
        if(myfileattach.body == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose file'));
            // myfileattach.addError('Please Choose file field');
            return null;
        }
        
        else
        {
            savebtn=true;
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
                        TagSpec7.Name='Items Needed';        
                        TagSpec7.Job__c=CustomJob.id;      
                        TagSpec7.Description__c=tagdesc1;
                        TagSpec7.Sort_Order__c=1;
                        ItemsNeededspecList.add(TagSpec7);
                    }
                }
                insert ItemsNeededspecList;
                
                Job_Spec__c PlateSpec6=new Job_Spec__c();
                PlateSpec6.Name='Turn-Time';      
                PlateSpec6.Description__c=TurnTimeString;      
                PlateSpec6.Job__c=CustomJob.id;
                PlateSpec6.Sort_Order__c=2;
                insert PlateSpec6;
                
                
                Job_Spec__c PlateSpec1=new Job_Spec__c();
                PlateSpec1.Name='Quantity Needed';    
                PlateSpec1.Description__c=CustomQuantityNeeded;     
                PlateSpec1.Job__c=CustomJob.id;
                PlateSpec1.Sort_Order__c=3;
                insert PlateSpec1;
                
                
                Job_Spec__c PlateSpec2=new Job_Spec__c();
                PlateSpec2.Name='Provide Height and Width Measurements in Inches';
                PlateSpec2.Description__c=CustomMeasurements;    
                PlateSpec2.Job__c=CustomJob.id;
                PlateSpec2.Sort_Order__c=4;
                insert PlateSpec2;
                
                Job_Spec__c PlateSpec3=new Job_Spec__c();
                PlateSpec3.Name='Explain request in detail';      
                PlateSpec3.Description__c=Customrequest;    
                PlateSpec3.Job__c=CustomJob.id;
                PlateSpec3.Sort_Order__c=5;
                insert PlateSpec3;
                
                Job_Spec__c PlateSpec4=new Job_Spec__c();
                PlateSpec4.Name='Explain, in detail, what signs/banners/etc. need to say';
                PlateSpec4.Description__c=Customneedtosay;      
                PlateSpec4.Job__c=CustomJob.id;
                PlateSpec4.Sort_Order__c=6;
                insert PlateSpec4;
                
                Job_Spec__c PlateSpec5=new Job_Spec__c();
                PlateSpec5.Name='Explain, in detail, where items will be installed';  
                PlateSpec5.Description__c=Customneedtogo;          
                PlateSpec5.Job__c=CustomJob.id;
                PlateSpec5.Sort_Order__c=7;
                insert PlateSpec5;
                
                if(!Test.isRunningTest()){  
                    if(myfileattach.body != null ){
                        Job_Spec__c BillboardSpec11=new Job_Spec__c();
                        BillboardSpec11.Name='File';      BillboardSpec11.Description__c='Files & documents attached ';           BillboardSpec11.Job__c=CustomJob.id;BillboardSpec11.Sort_Order__c=8;
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
                        
                        Attachment delAttach=[select id,name from Attachment where id=:SpecAttachment.Id];   delete delAttach;
                        
                        SpecAttachment.body = null; // clears the viewstate
                        PageReference pageRef = new PageReference('/lightning/n/Orders');//('/apex/MaterialLineDetailpage?id='+Strid);
                        pageRef.setRedirect(true);   return pageRef;
                    } 
                }
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
    Public pagereference back(){
        PageReference pageRef = new PageReference('/lightning/n/Store_Fronts');//('/apex/MaterialLineDetailpage?id='+Strid);
        pageRef.setRedirect(true);                                      
        return pageRef;
    
    }
    
    
}