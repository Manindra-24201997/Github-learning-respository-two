/*
Purpose of code: 
Created by:  (Dhruvsoft)
Created Date: 
*/
Global class InsertUpdateBillboardInvoiceLineitems Implements DataBase.Batchable <Sobject>,Database.AllowsCallouts,database.stateful{
    
    public InsertUpdateBillboardInvoiceLineitems (){
        
    }
    
    Public  class cls_data {
    
        
        public String workId;   //000007976983
        public String glAcctCode;   //006091
        public String glDesc;   //BILLBOARD - RENT
        public decimal glAmt;   //1195
        public String glAcctSub; //0001
        
       /* public String rpmRId;   //3167102
        public String glBusUnit;    //001
        public String glDiv;    //0001
        public String glChrgDept;   //0305
        public String glApprDept;   //BBIn*/
        
    }
    
    
    
     Global database.QueryLocator start(Database.Batchablecontext bc){
     
      

        return database.getQueryLocator( 'Select id,name,WorkId_Echomedia__c from Billboard_Invoice__c where Lastmodifieddate=Today And WorkId_Echomedia__c !=null');
    }

    Global void Execute(Database.BatchableContext bc,list<Billboard_Invoice__c> BBinvoice){
    
    
     try{
     
     List<cls_data > rgstrsles=new list<cls_data > ();
     JobsuiteEchoMediaSettings__c authsetng= [select Access_Token__c,Api_Endpoint__c from JobsuiteEchoMediaSettings__c];
     Billboard_Invoice__c  BillboardInvoice=[Select id,name from  Billboard_Invoice__c where name='Billboard Invoice 000' limit 1];
     GL_Department__c Gd=[Select id,name from GL_Department__c where name='Outdoor' limit 1];
     GL_Code__c Gl1=[Select id,name,GL_ID__c  from GL_Code__c where GL_ID__c ='1000' limit 1];
     map<string,GL_Code__c> MapCheckGlCodes=new map<string,GL_Code__c>();
     for(GL_Code__c gl:[Select id,name,GL_ID__c from GL_Code__c ]){
     
     MapCheckGlCodes.put(gl.GL_ID__c,gl);
     }
     
     map<string,Billboard_Invoice__c > Mapinsertinvoiceforlines=new map<string,Billboard_Invoice__c>();
     Map<string,Billboard_Invoice_Line_Item__c> MapCheckBBILines=new map<string,Billboard_Invoice_Line_Item__c>();
     List<Billboard_Invoice_Line_Item__c> InsertListforBBILines=new List<Billboard_Invoice_Line_Item__c>();
     List<Billboard_Invoice_Line_Item__c> UpdateListforBBILines=new List<Billboard_Invoice_Line_Item__c>();
     
     
     
     for(Billboard_Invoice__c   BBI:[SELECT ID,Name,WorkId_Echomedia__c FROM Billboard_Invoice__c  ])
     {
              Mapinsertinvoiceforlines.put(BBI.WorkId_Echomedia__c,BBI);
     }
     
     
     for(Billboard_Invoice_Line_Item__c   BBIL:[SELECT ID,Name,Work_Id__c FROM Billboard_Invoice_Line_Item__c ])
     {
         MapCheckBBILines.put(BBIL.Work_Id__c,BBIL);
      }
      
     system.debug('---------------------------------------------access_token'+authsetng.Access_Token__c);
   
     for(Billboard_Invoice__c BBI:BBinvoice){
     
            Http httpprotocal= new Http();
            HttpRequest  req=new HttpRequest();
            req.setEndpoint(authsetng.Api_Endpoint__c+'invoices/'+BBI.WorkId_Echomedia__c +'/lines' );
            
            req.setMethod('GET');
            req.settimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accesstoken', +authsetng.Access_Token__c);
            system.debug('Request is'+req);
            HTTPResponse response = httpprotocal.send(req);
            
            system.debug('Response deforder it is sent to site'+response );
            System.debug('Returned result is'+response.getBody());   
            
           if(response.getStatuscode()==200 || response.getStatuscode()==201 )
            {

            
            string  res=response.getBody();
             jsonParser prser=json.createParser(res);
                prser.nextToken();
                While(prser.nextToken()!=null)
                {
                 
                  if (prser.getCurrentToken() == JSONToken.START_ARRAY) {
                        while (prser.nextToken() != null) {
                              system.debug(prser.getCurrentToken());
                            If(prser.getCurrentToken()==JsonToken.START_OBJECT)
                            {
                                system.debug(prser.getCurrentToken());
                                cls_data prsr=(cls_data )prser.ReadValueAs(cls_data.Class);
                                rgstrsles.add(prsr);
                                system.debug('Payments'+rgstrsles);
                                String s = JSON.serialize(prsr);
                                system.debug('Serialized Payments: ' + s);   
                            }
                        }
                    }
                }
                system.debug('size of Payments is'+rgstrsles.size());
           }else{Messaging.SingleEmailMessage mssge=new Messaging.SingleEmailMessage();string[] mail=new list<string>{'manikanta@dhruvsoft.com'}; mssge.setSubject('Authorazation has failed for LovesEchomediaBBInvoiceLineitems Class');mssge.setPlainTextBody('The Error Message is \n'+response.getStatusCode()+'\n'+response.getBody()+'\n'+response.getStatus()); mssge.setToAddresses(mail); Messaging.SendEmailResult [] send=Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mssge});     
              }
         }  
              For(cls_data a1:rgstrsles){
              
              if(!MapCheckBBILines.containskey(a1.workId)){
              
              Billboard_Invoice_Line_Item__c BBILI=new Billboard_Invoice_Line_Item__c();
              BBILI.Billboard_Invoice__c=Mapinsertinvoiceforlines.get(a1.workId).id;
              BBILI.Amount__c=a1.glAmt;
              BBILI.Work_Id__c=a1.workId;
              
              BBILI.GL_Department__c=Gd.id;
              if(a1.glAcctSub != NULL)
              BBILI.GL_Code__c=(MapCheckGlCodes.containskey(a1.glAcctCode+'.'+a1.glAcctSub)?(MapCheckGlCodes.get(a1.glAcctCode+'.'+a1.glAcctSub).ID):Gl1.id);
              else
              BBILI.GL_Code__c=(MapCheckGlCodes.containskey(a1.glAcctCode)?(MapCheckGlCodes.get(a1.glAcctCode).ID):Gl1.id);
              
              InsertListforBBILines.add(BBILI);
              
             }else{
              
                 Billboard_Invoice_Line_Item__c  ILines=MapCheckBBILines.get(a1.workId);
                 ILines.Amount__c=a1.glAmt;
                // ILines.GL_Code__c=(MapCheckGlCodes.containskey(a1.glAcctCode)?(MapCheckGlCodes.get(a1.glAcctCode).ID):Gl1.id);
                if(a1.glAcctSub != NULL)
                ILines.GL_Code__c=(MapCheckGlCodes.containskey(a1.glAcctCode+'.'+a1.glAcctSub)?(MapCheckGlCodes.get(a1.glAcctCode+'.'+a1.glAcctSub).ID):Gl1.id);
                else
                ILines.GL_Code__c=(MapCheckGlCodes.containskey(a1.glAcctCode)?(MapCheckGlCodes.get(a1.glAcctCode).ID):Gl1.id);
                 
                 
                 UpdateListforBBILines.add(ILines);
                 } 
              }
     
     
     if(InsertListforBBILines.size()>0){
        Insert InsertListforBBILines;
     }
     if(UpdateListforBBILines.size()>0){
        Update UpdateListforBBILines;
     }
     
     }
        Catch(Exception E){
            System.debug('The Exception is'+E);
            System.debug('The following   exception has occurred: ' + e.getMessage());
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {'manikanta@dhruvsoft.com'};
            String subject ='LovesEchomediaBBInvoiceLineitems Class Exception';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('This is system generated message, \n  The InsertUpdateBillboardInvoiceLineitems class is aborted due to the Reason\n.'+e.getMessage()+'\n\nThank you');
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
        }
     
    
    
    }
    
    public void Finish(Database.BatchableContext bc){
    
    }
    
  }