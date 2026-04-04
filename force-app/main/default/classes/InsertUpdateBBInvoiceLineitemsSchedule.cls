Global Class InsertUpdateBBInvoiceLineitemsSchedule implements schedulable{

global void execute(SchedulableContext sc) {
      InsertUpdateBillboardInvoiceLineitems b = new InsertUpdateBillboardInvoiceLineitems(); 
      database.executebatch(b,1);
   }


}