import { LightningElement,wire,api} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import JOB_OBJECT from '@salesforce/schema/Job__c';
import namercdvalue from '@salesforce/schema/Job__c.Name';
import status from '@salesforce/schema/Job__c.Status__c';

//https://salesforcediaries.com/2020/01/19/object-information-in-lightning-web-component/ ,
// https://jayakrishnasfdc.wordpress.com/2020/12/06/wire-service-in-lightning-web-component-lwc/#:~:text=Lightning%20web%20components(LWC)%20use,side%20methods%20using%20wire%20services. - imp link

export default class Lwc_wire_basic extends LightningElement {
@api recordId;
namercdvalue;
status;
//fields = [namercdvalue,status]; // or we can store in array i.e., {fields}

@wire(getObjectInfo, { objectApiName: JOB_OBJECT })
objectdetails;

@wire(getObjectInfo, { objectApiName: JOB_OBJECT })
objectInfo;

@wire(getRecord, { recordId: '$recordId', fields: [namercdvalue,status] })
fieldsinfo;

handleinsert(event){
console.log('this api object returns complete details of object === '+JSON.stringify(this.objectdetails));
console.log('this api object returns complete details of object info === '+JSON.stringify(this.objectInfo));
console.log('name and status === '+JSON.stringify(namercdvalue)+'and status ==== '+JSON.stringify(status));
console.log('this returns  details of field info === '+JSON.stringify(this.fieldsinfo));
}



}