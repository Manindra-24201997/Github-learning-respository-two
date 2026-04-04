/*
Purpose of code: 
Created by:  (Dhruvsoft)
Created Date: 
*/
public class InsertUpdateBillboardInvoices Implements DataBase.Batchable<Billboard_Invoice__c>,Database.AllowsCallouts,database.stateful{
    public  boolean dynamicdatetime;
    public InsertUpdateBillboardInvoices (){
        dynamicdatetime=false;
    }
    
  
   Public  class cls_data {
        public String workId;   //000007976968
       
        public String queueEntryDt; //2015-06-12T05:10:30.000Z
        public String createDt; //2015-06-01T11:36:43.000Z
        public String vendorNbr;    //0004502006
        public String vendorName;   //Justice Outdoor Displays
        
        public String invNbr;   //9415
        public String invDate;  //2015-06-01T00:00:00.000Z
        public String invAmt;  //1800
        public String invSalesTaxAmt;  //0
        public String invDueDate;   //2015-06-11T00:00:00.000Z
        public String remarks;  //
        public String uploadDt; //2015-06-10T09:00:57.133Z
        public String billNbr;  //
        public String altVendorNbr; //24615
     }
   
    
    
    public Iterable <Billboard_Invoice__c> start(Database.Batchablecontext bc){

        return new List<Billboard_Invoice__c>{ new Billboard_Invoice__c()};
    }

    public void Execute(Database.BatchableContext bc,list<Billboard_Invoice__c> BBinvoice){
         
         try{
         
         
           JobsuiteEchoMediaSettings__c authsetng= [select Access_Token__c,BBInvoiceUpdateTime__c,Api_Endpoint__c from JobsuiteEchoMediaSettings__c];
          /*  DateTime newtime=system.now();
            integer myDay=newtime.Day();
            integer mymonth= newtime.Month();
            integer myyear=newtime.Year();
            Date myDate = newtime.Date();
            string tobeurlencode=myyear+'-'+mymonth+'-'+myDay+'T00:00:00z';
            string  targetString = EncodingUtil.URLENCODE(tobeurlencode,'UTF-8');
            system.debug('targetString '+targetString );*/
            
            Datetime yourDate = authsetng.BBInvoiceUpdateTime__c;
             String dateOutput = yourDate.format('yyyy-MM-dd');
             System.debug(dateOutput);
             string tobeurlencode=dateOutput+'T21:00:00z';
             string  targetString = EncodingUtil.URLENCODE(tobeurlencode,'UTF-8');                       
            
            
            
            
            List<cls_data > rgstrsles=new list<cls_data > ();
         
            
                
            Http httpprotocal= new Http();
            HttpRequest  req=new HttpRequest();
          //  req.setEndpoint(authsetng.Api_Endpoint__c+'invoices?timestamp=1433454276125&access_token='+authsetng.Access_Token__c );
            req.setEndpoint(authsetng.Api_Endpoint__c+'invoices?timestamp='+targetString+'&access_token='+authsetng.Access_Token__c );
            
            string s1=authsetng.Api_Endpoint__c+'invoices?timestamp='+targetString+' &access_token='+authsetng.Access_Token__c ;
            system.debug('setendpoint'+s1);
            
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
                                system.debug('Invoices'+rgstrsles);
                                String s = JSON.serialize(prsr);
                                system.debug('Serialized Invoices: ' + s);   
                            }
                        }
                    }
                }
                system.debug('size of Invoices is'+rgstrsles.size());
                 
                 List<Billboard_Invoice__c> ListwithBillboards=new List<Billboard_Invoice__c >();
                 List<Billboard_Invoice__c> ListwithoutBillboards=new List<Billboard_Invoice__c >();
                 Map<string,Billboard_Invoice__c> MapInvoice=new Map<string,Billboard_Invoice__c>();
               List<Billboard_Invoice__c> Listofinvoicestobeupdate=new  List<Billboard_Invoice__c>();
               
               for(Billboard_Invoice__c BBI:[select id,name,WorkId_Echomedia__c from Billboard_Invoice__c]){
               
               MapInvoice.put(BBI.WorkId_Echomedia__c,BBI);
               
               
               }
                 
                 
                 
                 
                 Set<string> BBSet=new Set<string>();
                 Set<string> VendorSet=new Set<string>(); 
                 map<string,Vendor__c> MapinsertVendorforinvoice=new Map<string,Vendor__c>();
                 map<string,Billboard__c> MapinsertBillboardforinvoice=new Map<string,Billboard__c>();
                 Vendor__c vendor=[Select id,name from  Vendor__c  where name='AAASampleBillboard Vendor' limit 1];
                 Billboard__c  Billboard=[Select id,name from  Billboard__c where name='Billboard 000' limit 1];
                          
                if(rgstrsles.size()>0){
                
                   for(cls_data a1:rgstrsles)
                    {
                        BBSet.add(a1.billNbr);
                        VendorSet.add(a1.vendorNbr); 
                    }
                   system.debug('the Billboard set is-----------------------'+BBSet);
                   system.debug('the Vendor  set is-----------------------'+VendorSet);
                
                  for(Vendor__c vend:[SELECT ID,Vendor__c FROM Vendor__c WHERE Vendor__c In:VendorSet])
                    {
                        MapinsertVendorforinvoice.put(vend.Vendor__c,vend);
                    }
                    system.debug('the Vendor Map is------------------------------------'+MapinsertVendorforinvoice);
                
                  for(Billboard__c BB:[SELECT ID,Name FROM Billboard__c WHERE Name in:BBSet])
                    {
                        MapinsertBillboardforinvoice.put(BB.Name,BB);
                    }
                    system.debug('the Billboard Map is------------------------------------'+MapinsertBillboardforinvoice);
                
                
                
                
                
                  
                 For(cls_data a1:rgstrsles){
                 
                 if(!MapInvoice.containskey(a1.workid)){
                 
                   if(MapinsertBillboardforinvoice.containskey(a1.billNbr)){
                   
                   Billboard_Invoice__c Billboardnvoice=new Billboard_Invoice__c();
                   
                   Billboardnvoice.Billboard__c=MapinsertBillboardforinvoice.get(a1.billNbr).ID;
                   Billboardnvoice.Name=(!String.Isempty(a1.invNbr)?(a1.invNbr):'');
                   Billboardnvoice.WorkId_Echomedia__c=a1.workId;
                   Billboardnvoice.Billboard_Vendor__c=(MapinsertVendorforinvoice.containskey(a1.vendorNbr)?(MapinsertVendorforinvoice.get(a1.vendorNbr).ID):vendor.id);
                   Billboardnvoice.BB_Invoice_Due_Date__c=(a1.invDueDate!=null?Date.valueOf(a1.invDueDate):null);
                   Billboardnvoice.Invoice_Created_Date_Echo_Media__c=(a1.createDt!=null?Date.valueOf(a1.createDt):null);
                   
                   ListwithBillboards.add(Billboardnvoice);
                   
                   }else{
                   
                   Billboard_Invoice__c Billboardnvoice=new Billboard_Invoice__c();
                   
                   Billboardnvoice.Billboard__c=Billboard.id;
                   Billboardnvoice.Name=(!String.Isempty(a1.invNbr)?(a1.invNbr):'');
                   Billboardnvoice.WorkId_Echomedia__c=a1.workId;
                   Billboardnvoice.Billboard_Vendor__c=(MapinsertVendorforinvoice.containskey(a1.vendorNbr)?(MapinsertVendorforinvoice.get(a1.vendorNbr).ID):vendor.id);
                   Billboardnvoice.BB_Invoice_Due_Date__c=(a1.invDueDate!=null?Date.valueOf(a1.invDueDate):null);
                   Billboardnvoice.Invoice_Created_Date_Echo_Media__c=(a1.createDt!=null?Date.valueOf(a1.createDt):null);
                   
                   
                   ListwithoutBillboards.add(Billboardnvoice);
                   
                   
                   }
                   
                   }else{
                   
                  Billboard_Invoice__c  inv=MapInvoice.get(a1.workid);
                 
                   inv.Name=(!String.Isempty(a1.invNbr)?(a1.invNbr):'');
                   inv.WorkId_Echomedia__c=a1.workId;
                  //update done to check new changes 
                   if(a1.vendorNbr!=null) inv.Billboard_Vendor__c=(MapinsertVendorforinvoice.containskey(a1.vendorNbr)?(MapinsertVendorforinvoice.get(a1.vendorNbr).ID):vendor.id);
                   if(a1.invDueDate!=null) inv.BB_Invoice_Due_Date__c=Date.valueOf(a1.invDueDate);
                   if(a1.createDt!=null)  inv.Invoice_Created_Date_Echo_Media__c=Date.valueOf(a1.createDt);
                   
                   Listofinvoicestobeupdate.add(inv);
                   
                   
                   }
                 } 
                
                  
                  if(ListwithoutBillboards.size()!=0 )
                  {
                  Insert ListwithoutBillboards;
                  dynamicdatetime=true;
                  }
                  if(ListwithBillboards.size()!=0 )
                  {
                  Insert ListwithBillboards;
                  dynamicdatetime=true;
                  }
                if(Listofinvoicestobeupdate.size()!=0)
                {
                  Update Listofinvoicestobeupdate;
                  dynamicdatetime=true;
                }
             
             }
            }else{Messaging.SingleEmailMessage mssge=new Messaging.SingleEmailMessage(); string[] mail=new list<string>{'manikanta@dhruvsoft.com'};mssge.setSubject('Authorazation has failed in LoveEchomediaBBInvoice Class');mssge.setPlainTextBody('The Error Message is \n'+response.getStatusCode()+'\n'+response.getBody()+'\n'+response.getStatus());mssge.setToAddresses(mail); Messaging.SendEmailResult [] send=Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mssge});      
              }
         }Catch(Exception E){
            System.debug('The Exception is'+E);
            System.debug('The following   exception has occurred: ' + e.getMessage());
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {'manikanta@dhruvsoft.com'};
            String subject ='Billboard Invoices insertion from Echomedia Exception';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('This is system generated message, \n  The InsertUpdateBillboardInvoices  class is aborted due to the Reason\n.'+e.getMessage()+'\n\nThank you');
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
        }
}
   public void Finish(Database.BatchableContext BC){
         system.debug('The Dynamic Time is'+dynamicdatetime);
        if( dynamicdatetime==True){
   JobsuiteEchoMediaSettings__c authsetng1= [select Access_Token__c,BBInvoiceUpdateTime__c,Api_Endpoint__c from JobsuiteEchoMediaSettings__c];     
            authsetng1.BBInvoiceUpdateTime__c=authsetng1.BBInvoiceUpdateTime__c.adddays(1);
            update authsetng1;
            system.debug('the present data and time value is'+authsetng1.BBInvoiceUpdateTime__c);
            
        }  
    }
}