import {
    LightningElement,
    api,
    track
} from 'lwc';

export default class Inputmethod extends LightningElement {
    @track upperCase;
    @api
    changeUpperCase(text) {
        this.upperCase = text.toUpperCase();
    }
   
}