import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class ExampleComponent extends LightningElement {
    recordId = 'a028c00000YivXKAAZ';

    connectedCallback() {
        this.loadRecord();
    }

    loadRecord() {
        console.log('recordId ==== '+this.recordId);
        getRecord({ recordId: this.recordId, fields: ['Job__c.Name', 'Job__c.Campaign__c'] })
            .then(result => {
                console.log('result === '+result.fields.Job__c.Name.value);
                // Access the field values from the result

               /* const field1Value = result.fields.ObjectApiName.Field1__c.value;
                const field2Value = result.fields.ObjectApiName.Field2__c.value;
                console.log('Field1 Value:', field1Value);
                console.log('Field2 Value:', field2Value);*/
            })
            .catch(error => {
                // Handle any errors
                console.error('Error loading record:', error);
            });
    }
}