Global Class InsertUpdateBBInvoicePaymentSchedule implements schedulable{

global void execute(SchedulableContext sc) {
      InsertUpdateBillboardInvoicePayments b = new InsertUpdateBillboardInvoicePayments(); 
      database.executebatch(b,20);
   }

}