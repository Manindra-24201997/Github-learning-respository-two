import {
    LightningElement
} from 'lwc';

export default class Methodcaller extends LightningElement {
    handleChange(event) {
        this.template.querySelector('c-inputmethod').changeUpperCase(event.target.value);

    }
}