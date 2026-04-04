import { LightningElement } from 'lwc';

export default class Lwc_dropdown extends LightningElement {

    constructor() {
        super();

    }

    connectedCallback(){

    }

    renderedCallback(){
        this.template.querySelector('select.slds-select[data-my-id=select-03]').value = 'Option Three';   

       console.log('rendered callbck ==== '+this.template.querySelectorAll('select.slds-select').value);

    }

    handleonchange(event){
        console.log('handle change value in lwc === '+event.target.value);
        //console.log('handle change select value in lwc through  query selector === '+this.template.querySelector('select.slds-select').value); 
        //console.log('handle change select value in lwc through data id  === '+this.template.querySelector('select.slds-select[data-my-id=select-01]').value);
        //console.log('handle change select value in lwc through data id edited === '+this.template.querySelector('select[data-my-id=select-01]').value);
        console.log('handle change select value in lwc through data id 3 === '+this.template.querySelector('select.slds-select[data-my-id=select-03]').value);
        console.log('handle change select value in lwc through data id 3 edited === '+this.template.querySelector('select[data-my-id=select-03]').value);

    }

   
}