import { LightningElement,track } from 'lwc';

export default class Lwc_modal_recordeditform extends LightningElement {

    @track openmodel = false;
    openmodal() {
        this.openmodel = true
    }
    closeModal() {
        this.openmodel = false
    } 
    saveMethod() {

        this.closeModal();
    }
}