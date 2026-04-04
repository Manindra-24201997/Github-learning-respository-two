import { LightningElement,api } from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions'

export default class Lwc_quickactioncmp2 extends LightningElement {
    @api currentrcdid;
    @api objectApiName = 'Sample_Object_1__c';


    Handlecancel(event){
            this.dispatchEvent(new CloseActionScreenEvent());
        }
}