import { LightningElement } from 'lwc';
import lightningstyles from '@salesforce/resourceUrl/LtngStyles';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class Lwc_job_delete extends LightningElement {

    connectedCallback(){
        console.log('connected callback in delete with css');
        Promise.all([
            loadStyle(this, lightningstyles + '/LtngStyles/LCmpModalandChart/Styles/ModalHederFooterStyles.css')
        ])
    }


}