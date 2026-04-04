public class BB_Binder_Report_Pdf_Class {
    
    public string PDFData{set;get;}
    public list<ClienDistrictWrapper> CDWrapper{set;get;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;} 
    public BB_Binder_Report_Pdf_Class(){
        PDFData='';
        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' LIMIT 1];
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
    }
    
    public PageReference downloadPDF(){
        system.debug('PDFData----'+PDFData);       
        
        CDWrapper = (list<ClienDistrictWrapper>)JSON.deserialize(PDFData, list<ClienDistrictWrapper>.class);
        
        
        System.PageReference pageRef = new System.PageReference('/apex/BB_Binder_Report_Pdf_from_LC');
        
        
        
        return pageRef;
    }
    public class ClienDistrictWrapper
    {
        public List<ClientNameWrapper> CNWrapper{get;set;}
        public string strClientDist {get;set;} 
        public ClienDistrictWrapper()
        {
            if(CNWrapper== NULL) {CNWrapper= new List<ClientNameWrapper>();}
        }
    }
    
    public class ClientNameWrapper    
    { 
        public string strClientName {get;set;}
        public string strClientCode {get;set;}
        public List<BBWrapper> BWrapper{get;set;}
        public ClientNameWrapper()
        {
            if(BWrapper== NULL) {BWrapper= new List<BBWrapper>();}
        }  
    }
    
    public class BBWrapper
    {              
        public Billboard__c BB {get;set;}
        public String ContentVersionId {get;set;}
        public BBWrapper()
        {
            
        }
    }
    
}