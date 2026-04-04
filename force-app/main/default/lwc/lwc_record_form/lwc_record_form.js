import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
export default class LightningRecordFormEditExampleLWC extends LightningElement {
@api recordId;
@api objectApiName;
fields = [NAME_FIELD, REVENUE_FIELD, INDUSTRY_FIELD];

handleSubmit(event){
//you can change values from here
//const fields = event.detail.fields;
//fields.Name = 'My Custom  Name'; // modify a field
event.preventDefault(); // stop the form from submitting
const fields = event.detail.fields;
fields.Name = 'Manindra Accounts'; // modify a field
console.log('Account detail : ',event.detail.fields);
console.log('Account name : ',event.detail.fields.Name);
const inputfields = this.template.querySelectorAll('lightning-record-form');
console.log('inputfields === '+inputfields);
console.log('json inputfields === '+JSON.stringify(inputfields));
const inputFields = this.template.querySelectorAll(
    'lightning-input-field'
);
if (inputFields) {
    inputFields.forEach(field => {
        console.log('fields === '+JSON.stringify(field));
        /*if(field.name === "email") {
            field.reset();
        }*/
    });
}
template.querySelector('lightning-record-form').submit(fields);
}

Refresh(event){
const inputfields = this.template.querySelectorAll('lightning-record-form');
inputfields.forEach(field=>{field.reset();});
}

handleSuccess(event) {
const evt = new ShowToastEvent({
    title: 'Account created',
    message: 'Record ID: ' + event.detail.id,
    variant: 'success',
});
this.dispatchEvent(evt);
}

}