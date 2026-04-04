import { LightningElement } from 'lwc';
export default class DemoLookup extends LightningElement {
    parentAccountSelectedRecord;
    handleValueSelectedOnAccount(event) {
        this.parentAccountSelectedRecord = event.detail;
    }
}