import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {CloseActionScreenEvent} from 'lightning/actions'
import nme_field from '@salesforce/schema/Sample_Object_1__c.Name';
import accountlookup_field from '@salesforce/schema/Sample_Object_1__c.Account__c';

export default class Lwc_quickactioncmp1 extends LightningElement {
    @api recordId;
    @api objectApiName = 'Sample_Object_1__c';
    Nme = nme_field;
    acclkup = accountlookup_field;

    handlesubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        console.log('fields === '+JSON.stringify(fields));
        fields.Name =  fields.Name + ' Custom Updated';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.Handlecancel();
    }

    Handlecancel(event){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

handlesuccess(event){
    const evt = new ShowToastEvent({
    title: 'Record created or updated',
    message: 'Record ID: ' + event.detail.id,
    variant: 'success',
});
this.dispatchEvent(evt);
}

}