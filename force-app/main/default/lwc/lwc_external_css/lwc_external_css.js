import { LightningElement } from 'lwc';
//import lightningstyles from '@salesforce/resourceUrl/auraexternalcss';
import lightningstyles from '@salesforce/resourceUrl/lwcexternalcss';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class Lwc_external_css extends LightningElement {
    connectedCallback(){
        console.log('edited css');
    Promise.all([
           // loadStyle(this, lightningstyles + '/externalstyles/headercss/styles/headingnewcss.css')
           loadStyle(this, lightningstyles + '/lwcexternal/externalstyles/headercss/styles/headingnewcss.css')

        ])
    }
}