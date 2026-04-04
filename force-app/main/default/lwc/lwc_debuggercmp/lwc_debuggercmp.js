import { LightningElement } from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.retriveOpportunities';

export default class Lwc_debuggercmp extends LightningElement {
namevalue;

    connectedCallback(){
    this.fetchopps();
    }

    handleonchange(event){
    console.log('handleonchange === '+event.target.value);
    debugger;
    this.namevalue = event.target.value;
    debugger;
    }

fetchopps(event){
    debugger;
                getrcds().then(response=>{
    if(response){
         //resolve(response);
         debugger;
        console.log('reposnse === '+response);
    }
    else{
        console.log('no response in then');
    }
    debugger;
})
}


}