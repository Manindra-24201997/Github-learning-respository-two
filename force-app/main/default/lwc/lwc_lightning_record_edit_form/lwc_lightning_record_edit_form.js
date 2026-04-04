import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import name from '@salesforce/schema/Job__c.Name';
import clnt from '@salesforce/schema/Job__c.JS_Client__c';
import clntcnt from '@salesforce/schema/Job__c.JS_Client_Contact__c';
import Statusfield from '@salesforce/schema/Job__c.Status__c';
import stdte from '@salesforce/schema/Job__c.Start_Date__c';
import schdueclc from '@salesforce/schema/Job__c.Schedule_Calc__c';

export default class Lwc_lightning_record_edit_form extends LightningElement {
@api recordId;
@api objectApiName;
nme = name;
clientname = clnt;
clientcontact = clntcnt;
status = Statusfield;
startdate = stdte;
schedulecalc = schdueclc;

// fields = [name,clnt,clntcnt,Statusfield,stdte,schdueclc]; //like this it is not worked so commented

connectedCallback(){

}

renderedCallback(){
 console.log('nme === '+JSON.stringify(this.nme));  
 console.log('clientname === '+JSON.stringify(this.clientname));   
 console.log('clientcontact === '+this.clientcontactnme);   
}

handlesubmit(event){
const fields = event.detail.fields;
fields.Status__c =  'completed';
this.template.querySelector('lightning-record-edit-form').submit(fields);
}

Refresh(event){
const inputfields = this.template.querySelectorAll('lightning-input-field');
inputfields.forEach(field=>{field.reset();});
const evt = new ShowToastEvent({
    title: 'Refreshed',
    message: 'Refreshed ' ,
    variant: 'success',
});
this.dispatchEvent(evt);
}

handlesuccess(event){
const evt = new ShowToastEvent({
    title: 'Job created or updated',
    message: 'Record ID: ' + event.detail.id,
    variant: 'success',
});
this.dispatchEvent(evt);
}


}