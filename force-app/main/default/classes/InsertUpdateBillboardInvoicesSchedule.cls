Global Class InsertUpdateBillboardInvoicesSchedule implements schedulable{

global void execute(SchedulableContext sc) {
      InsertUpdateBillboardInvoices b = new InsertUpdateBillboardInvoices(); 
      database.executebatch(b,20);
   }

}