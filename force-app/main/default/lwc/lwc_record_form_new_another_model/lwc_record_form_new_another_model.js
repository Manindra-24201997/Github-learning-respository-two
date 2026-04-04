import { LightningElement,api} from 'lwc';
import name from '@salesforce/schema/Job__c.Name';
import clnt from '@salesforce/schema/Job__c.JS_Client__c';
import clntcnt from '@salesforce/schema/Job__c.JS_Client_Contact__c';
import Statusfield from '@salesforce/schema/Job__c.Status__c';
import stdte from '@salesforce/schema/Job__c.Start_Date__c';
import schdueclc from '@salesforce/schema/Job__c.Schedule_Calc__c';
export default class Lwc_record_form_new_another_model extends LightningElement {
@api recordId;
@api objectApiName;
 fields = [name,clnt,clntcnt,Statusfield,stdte,schdueclc]; //like this it is not worked so commented


 handleSubmit(event){
    const fields = event.detail.fields;
    fields.Status__c =  'active'; //This update will work when you use any one mode in cmp 
    this.template.querySelector('lightning-record-form').submit(fields);
    }
    
    Refresh(event){
    const inputfields = this.template.querySelectorAll('lightning-record-form');//Here refreshing  is not working so we removed from template
    //const inputfields = event.detail.fields;
    inputfields.forEach(field=>{field.reset();});
    const evt = new ShowToastEvent({
    title: 'Refreshed',
    message: 'Refreshed is not working' ,
    variant: 'success',
    });
    this.dispatchEvent(evt);
    }
    
    handleSuccess(event){
    const evt = new ShowToastEvent({
    title: 'Job created or updated',
    message: 'Record ID: ' + event.detail.id,
    variant: 'success',
    });
    this.dispatchEvent(evt);
    }
    


}