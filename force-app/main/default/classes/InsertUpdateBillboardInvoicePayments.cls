/*
Purpose of code: 
Created by:  (Dhruvsoft)
Created Date: 
*/
public class InsertUpdateBillboardInvoicePayments Implements DataBase.Batchable<BB_Invoice_Payment__c>,Database.AllowsCallouts,database.stateful{
    public  boolean dynamicdatetime;
    public InsertUpdateBillboardInvoicePayments (){
        dynamicdatetime=false;
    }
   Public  class cls_data {
        public String workId;   //000007976968
        public String createDt; //2015-06-01T11:36:43.000Z
        public String checkNbr;
       // public String chekNbr; //1001094924
        public String checkDate;  //2015-06-11T00:00:00.000Z
        public String invNbr;   //9415  
        
       /* public String queueEntryDt; //2015-06-12T05:10:30.000Z
        public String billNbr;  //
        public String invDate;  //2015-06-01T00:00:00.000Z
        public Decimal invAmt;  //1800
        public String docType;  //BIL
        public String queue;  //CHECK_WAIT
        public String invDueDate;   //2015-06-11T00:00:00.000Z
        public String remarks;  // 
        
       */ 
        
        
    }
    
    
    
    
    
       public Iterable <BB_Invoice_Payment__c> start(Database.Batchablecontext bc){

        return new List<BB_Invoice_Payment__c>{ new BB_Invoice_Payment__c()};
    }
    
    
    public void Execute(Database.BatchableContext bc,list<BB_Invoice_Payment__c> BBinvoicepayment){
    
      try{
    
      List<cls_data > rgstrsles=new list<cls_data > ();
    JobsuiteEchoMediaSettings__c authsetng= [select Access_Token__c,BBInvoicePaymentUpdateTime__c,Api_Endpoint__c from JobsuiteEchoMediaSettings__c];
    
             Datetime yourDate = authsetng.BBInvoicePaymentUpdateTime__c;
             String dateOutput = yourDate.format('yyyy-MM-dd');
             System.debug(dateOutput);
             string tobeurlencode=dateOutput+'T23:00:00z';
             string  targetString = EncodingUtil.URLENCODE(tobeurlencode,'UTF-8');  
                      
                
            Http httpprotocal= new Http();
            HttpRequest  req=new HttpRequest();
           // req.setEndpoint(authsetng.Api_Endpoint__c+'payments?timestamp=1433454276125&access_token='+authsetng.Access_Token__c );
           
            req.setEndpoint(authsetng.Api_Endpoint__c+'payments?timestamp='+targetString+'&access_token='+authsetng.Access_Token__c );

            req.setMethod('GET');
            req.settimeout(120000);
            req.setHeader('Content-Type', 'application/json');
           
            system.debug('Request is'+req);
            HTTPResponse response = httpprotocal.send(req);
            
            system.debug('Response deforder it is sent to site'+response );
            System.debug('Returned result is'+response.getBody());   
    
            if(response.getStatuscode()==200 || response.getStatuscode()==201 )
            {
             string  res=response .getBody();
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
           
               List<BB_Invoice_Payment__c> ListwithInvoices=new List<BB_Invoice_Payment__c>();
               List<BB_Invoice_Payment__c> ListwithoutBBinvoices=new List<BB_Invoice_Payment__c>();
               Map<String,BB_Invoice_Payment__c> MapPaymentInvoice=new Map<String,BB_Invoice_Payment__c>();
               List<BB_Invoice_Payment__c> Listofpaymentstobeupdate=new  List<BB_Invoice_Payment__c>();
               
               for(BB_Invoice_Payment__c BBIP:[select id,name,WorkId_Payments__c  from BB_Invoice_Payment__c ]){
               
               MapPaymentInvoice.put(BBIP.WorkId_Payments__c ,BBIP);
               
               
               }
               
               
               Set<string> BBISet=new Set<string>();
               map<string,Billboard_Invoice__c> MapinsertBillboardforinvoice=new Map<string,Billboard_Invoice__c>();
               
               Billboard_Invoice__c  BillboardInvoice=[Select id,name from  Billboard_Invoice__c where name='Billboard Invoice 000' limit 1];
           
            if(rgstrsles.size()>0){
                
                   for(cls_data a1:rgstrsles)
                    {
                        BBISet.add(a1.workId);
                        
                    }
                   system.debug('the Billboard Invoice set is-----------------------'+BBISet);
                   
                
                 for(Billboard_Invoice__c   BBI:[SELECT ID,Name,WorkId_Echomedia__c FROM Billboard_Invoice__c   WHERE WorkId_Echomedia__c in:BBISet])
                    {
                        MapinsertBillboardforinvoice.put(BBI.WorkId_Echomedia__c,BBI);
                    }
                    system.debug('the Billboard Invoice Map is------------------------------------'+MapinsertBillboardforinvoice);
               
                 For(cls_data a1:rgstrsles){
                 
                   
                   if(!MapPaymentInvoice.containskey(a1.workId)){
                 
                   if(MapinsertBillboardforinvoice.containskey(a1.workId)){
                   
                   BB_Invoice_Payment__c BillboardnvoicePayment=new BB_Invoice_Payment__c();
                   
                   BillboardnvoicePayment.Billboard_Invoice__c=MapinsertBillboardforinvoice.get(a1.workId).ID;
                   
                   BillboardnvoicePayment.Check_New__c=(!String.Isempty(a1.checkNbr)?(a1.checkNbr):'');
                 //  BillboardnvoicePayment.Check_Amount__c=Date.valueOf(a1.invDueDate);
                   BillboardnvoicePayment.Check_Date__c=(a1.checkDate!=null?Date.valueOf(a1.checkDate):null);
                   BillboardnvoicePayment.WorkId_Payments__c=a1.workid;
                   
                   ListwithInvoices.add(BillboardnvoicePayment);
                   
                   }else{
                   
                   BB_Invoice_Payment__c  BillboardnvoicePayment=new BB_Invoice_Payment__c ();
                   
                   BillboardnvoicePayment.Billboard_Invoice__c=BillboardInvoice.id;
                   
                   BillboardnvoicePayment.Check_New__c=(!String.Isempty(a1.checkNbr)?(a1.checkNbr):'');
                //   BillboardnvoicePayment.Check_Amount__c=Date.valueOf(a1.invDueDate);
                   BillboardnvoicePayment.Check_Date__c=(a1.checkDate!=null?Date.valueOf(a1.checkDate):null);
                   BillboardnvoicePayment.WorkId_Payments__c=a1.workid;
                   
                   ListwithoutBBinvoices.add(BillboardnvoicePayment);
                   
                   
                   }
                 }else{
                 
                 BB_Invoice_Payment__c payment=MapPaymentInvoice.get(a1.workid);
                 
                if(!String.Isempty(a1.checkNbr))payment.Check_New__c=a1.checkNbr;
                 if(a1.checkDate!=null) payment.Check_Date__c=Date.valueOf(a1.checkDate);
                 Listofpaymentstobeupdate.add(payment);
                 
                 }
                 
                 
                 } 
                 
                  if(ListwithInvoices.size()!=0)
                  {
                     Insert ListwithInvoices;
                      dynamicdatetime=True;
                  }
                   if(ListwithoutBBinvoices.size()!=0 )
                   {
                     Insert ListwithoutBBinvoices;
                      dynamicdatetime=True;
                   }
                   if(Listofpaymentstobeupdate.size()!=0)
                   {
                       Update Listofpaymentstobeupdate;
                        dynamicdatetime=True;
                   }
                  
                               
                  
                
            }
            
            }
            else{Messaging.SingleEmailMessage mssge=new Messaging.SingleEmailMessage();string[] mail=new list<string>{'manikanta@dhruvsoft.com'};mssge.setSubject('Authorazation has failed in LovesechomediaBillboardInvoicesPayments Class');mssge.setPlainTextBody('The Error Message is \n'+response.getStatusCode()+'\n'+response.getBody()+'\n'+response.getStatus());mssge.setToAddresses(mail);Messaging.SendEmailResult [] send=Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mssge});    
               }
            system.debug('size of Payments is'+rgstrsles.size());
            }
        Catch(Exception E){
            System.debug('The Exception is'+E);
            System.debug('The following   exception has occurred: ' + e.getMessage());
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {'manikanta@dhruvsoft.com'};
            String subject ='Billboard Invoices Payments Class Exception';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('This is system generated message, \n  The InsertUpdateBillboardInvoicePayments class is aborted due to the Reason\n.'+e.getMessage()+'\n\nThank you');
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
        }
           
    
    
    }
    
     public void Finish(Database.BatchableContext BC){
         system.debug('The Dynamic Time is'+dynamicdatetime);
        if( dynamicdatetime==True){
            JobsuiteEchoMediaSettings__c authsetng1= [select Access_Token__c,BBInvoicePaymentUpdateTime__c,BBInvoiceUpdateTime__c,Api_Endpoint__c from JobsuiteEchoMediaSettings__c];     
            authsetng1.BBInvoicePaymentUpdateTime__c=authsetng1.BBInvoicePaymentUpdateTime__c.adddays(1);
            update authsetng1;
            system.debug('the present data and time value is'+authsetng1.BBInvoicePaymentUpdateTime__c);
        }  
    
    }
    
    
    }