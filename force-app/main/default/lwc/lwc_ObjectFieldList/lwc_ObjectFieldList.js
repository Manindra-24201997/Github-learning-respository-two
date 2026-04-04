import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Job_OBJECT from '@salesforce/schema/Job__c';

export default class Lwc_ObjectFieldList extends LightningElement {
    @track fields = [];

    @wire(getObjectInfo, { objectApiName: Job_OBJECT })
    objectInfoHandler({ data, error }) {
        if (data) {
            const fieldData = data.fields;
            this.fields = Object.keys(fieldData).map(fieldApiName => {
                const field = fieldData[fieldApiName];
                return {
                    apiName: fieldApiName,
                    label: field.label,
                    dataType: field.dataType,
                    required: field.required
                };
            });
        } else if (error) {
            console.error('Error fetching object info:', error);
        }
    }

}