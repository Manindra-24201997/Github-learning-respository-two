import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import name from '@salesforce/schema/Job__c.Name';
import clnt from '@salesforce/schema/Job__c.JS_Client__c';
import clntcnt from '@salesforce/schema/Job__c.JS_Client_Contact__c';
import Statusfield from '@salesforce/schema/Job__c.Status__c';
import stdte from '@salesforce/schema/Job__c.Start_Date__c';
import schdueclc from '@salesforce/schema/Job__c.Schedule_Calc__c';

export default class Lwc_forms extends LightningElement {
//objectApiName = 'Job__c';//hardcoding object api name or you can get dynamically by using (@api objectApiName)
//rcdid = 'a028c00000YivXUAAZ'; //hardcoding record id or you can get dynamically by using (@api recordId)
@api recordId;
@api objectApiName;
nme = name;
clientname = clnt;
clientcontact = clntcnt;
status = Statusfield;
startdate = stdte;
schedulecalc = schdueclc;

fields = [name,clnt,clntcnt,Statusfield,stdte,schdueclc];

handleSubmit(event){
alert('fields === ');
//event.preventDefault(); // stop the form from submitting

//const fields = event.detail.fields;
//fields.status = 'cancelled'; // modify a field
//this.template.querySelector('lightning-record-form').submit(fields);
}

handleSuccess(event) {
const evt = new ShowToastEvent({
title: 'Job created',
message: 'Record created '+event.detail.id,
variant: 'success',
});
this.dispatchEvent(evt);
}

}