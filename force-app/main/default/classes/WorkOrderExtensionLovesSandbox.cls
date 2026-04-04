public class WorkOrderExtensionLovesSandbox {
    // Global variables  
    public DateTime today{get;set;}
    String jobid;
    public List<Job_Team__c> JobTeam{get;set;} 
    public list<Production_Estimate__c>PEMIfields{get;set;}
    public List<Job_Task__c> JobTask{get;set;} 
    public List<Job_Spec__c> CreativeBrief{get;set;}
    public List<Tag__c> Tags{get;set;}
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public string Barcodeimageurl {get;set;}
    public List<Document> lstDoc;
    public boolean imageNotFound{get;set;}
    public String queryString{get;set;}
    public boolean Tagrender{get;set;}
    public map<string,list<Job_Spec__c>> MapCB{get;set;}
    
    // End Global variables
    
    // Start Constructor
    
    public WorkOrderExtensionLovesSandbox(ApexPages.StandardController controller) 
    {
        // To display Subscriber Organization Logo
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
            String imageId =  lstDoc[0].Id;
            imageBody = imageURL+imageId; 
            imageNotFound = False;
        }    
        else
        {
            imageNotFound = True;
        }
        
        jobid = ApexPages.currentpage().getParameters().get('id');
        system.debug('job id === '+jobid+'\n');
        Job__c jrcd = [select id,name,Job_Id__c, Job_Auto_Number__c from Job__c where id=:jobid limit 1];
        JobTeam = [select id,Name,Role__c,Staff__c from Job_Team__c where Job__c =: jobid WITH SECURITY_ENFORCED];
        PEMIfields = [select id,name,Material_Item__c,Material_Item__r.name,Qty_Used__c,Lf_Used__c,GL_Code__c,GL_Code__r.name,GL_Department__c,GL_Department__r.name,Vendor__c,Vendor__r.name,Calc_Unit__c,PO_Created__c,Approved__c,Job__c,Job__r.name,Quantity__c,Material_Item__r.Size__c from Production_Estimate__c where Job__c =: jobid WITH SECURITY_ENFORCED];
        //imageUrl='https://www.barcodesinc.com/generator/image.php?code='+Paylist .get(0).name+'&style=325&type=C128B&width=200&height=50&xres=1&font=3';
      // Barcodeimageurl = 'https://www.barcodesinc.com/generator/image.php?code='+jrcd.Job_Auto_Number__c+'&style=325&type=C128B&width=200&height=50&xres=1&font=3';
        system.debug('job auto number === '+jrcd.Job_Auto_Number__c+'\n');
   Barcodeimageurl = 'https://www.webarcode.com/barcode/image.php?code='+jrcd.Job_Auto_Number__c+'&type=C128B&xres=1&height=50&width=167&font=3&output=png&style=197';
        // Barcodeimageurl = 'https://www.webarcode.com/barcode/image.php?code='+jrcd.Job_Auto_Number__c+'&style=325&type=C128B&width=200&height=50&xres=1&font=3';
        system.debug('Barcodeimageurl === '+Barcodeimageurl+'\n');
        CreativeBrief = [select id,Name,Description__c,Creative_Brief_Template__c  from Job_Spec__c where Job__c =: jobid WITH SECURITY_ENFORCED order by Sort_Order__c];
        JobTask = [select id,Name,Due_Date__c,Start_Date__c,Revised_Due_Date__c,Task_Order__c,Marked_Done__c,Assigned_Users__c from Job_Task__c where Job__c =: jobid WITH SECURITY_ENFORCED Order By Task_Order__c];
        // Tags = [SELECT Id,name, Job__c, Tag_Program_Title__c, Tag_Start_Date__c, Tag_End_Date__c, Tag_Due_Date__c, Tag_Air_Date__c, Tag_Air_Time__c, Tag_Lengths__c, Dummy_Date_1__c, Dummy_Date_2__c, Dummy_Date_3__c, Dummy_Date_4__c, Dummy_Picklist_1__c, Dummy_Picklist_2__c, Dummy_Picklist_3__c, Dummy_Picklist_4__c, Dummy_Text_1__c, Dummy_Text_2__c, Dummy_Text_3__c, Dummy_Text_4__c FROM Tag__c where Job__c =: jobid];
        
        queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Tag__c.FieldSets.TagsFieldsets.getFields()) {
            queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Tag__c where Job__c =: jobId  WITH SECURITY_ENFORCED ORDER BY CreatedDate';
        
        Tags= Database.query(queryString);
        
        if(Tags.size()>0)
        {
            Tagrender=true;
        }
        else{
            Tagrender=false;
        }
        
        MapCB = new map<string,list<Job_Spec__c>>();
        
        for(Job_Spec__c JS:CreativeBrief)
        {
            if(MapCB.containsKey(js.Creative_Brief_Template__c))
            {
                List <Job_Spec__c > jSpeclist =  MapCB.get(js.Creative_Brief_Template__c);
                jSpeclist.add(js);
                MapCB.put(js.Creative_Brief_Template__c,jSpeclist );  
            }
            else
            {
                MapCB.put(js.Creative_Brief_Template__c, new List<Job_Spec__c >{js}) ;
            }   
        }
        today=System.NOW();
    }
    // End Constructor 
    
    
}