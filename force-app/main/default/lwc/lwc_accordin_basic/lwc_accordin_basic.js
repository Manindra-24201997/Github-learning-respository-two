import { LightningElement, track } from 'lwc';
import lightningstyles from '@salesforce/resourceUrl/lwcexternalcss';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class ExampleComponent extends LightningElement {

 
        connectedCallback(){
            console.log('edited css');
        Promise.all([
               loadStyle(this, lightningstyles + '/lwcexternal/externalstyles/headercss/styles/lwcaccordincss.css')

            ])
        }
    

    renderedCallback(){
        /*const accordionSections = this.template.querySelector('lightning-accordion-section[data-my-id=section1]');
        accordionSections.style.backgroundColor = 'gainsboro';
        /*accordionSections.forEach(section => {
            section.style.backgroundColor = 'gainsboro';
        }); */

    }
}