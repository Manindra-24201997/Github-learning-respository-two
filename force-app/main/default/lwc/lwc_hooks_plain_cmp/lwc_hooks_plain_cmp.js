import { LightningElement,wire } from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.getAccList';
const clm=[
{label:'Name',fieldName:'Name'}
];
export default class Lwc_hooks_plain_cmp extends LightningElement {
returnlist;
@wire(getrcds) rtrndata({error,data}){
    if(data){
console.log('data === '+data);
this.returnlist = data;
    }
    else{
        console.log('data 2 === '+data);
    }
}

    constructor(){
super();
console.log('constructor lwc_hooks_plain_cmp === ');
    }


    connectedCallback(){
        //this.hello  = 'chennamsetty';
        console.log('connectedCallback lwc_hooks_plain_cmp === ');
    }

    renderedCallback(){
        console.log('renderedCallback lwc_hooks_plain_cmp === ');
    }

    disconnectedCallback(){
        console.log('disconnectedCallback lwc_hooks_plain_cmp === ');
    }

    errorCallback(error, stack){
        console.log('errorCallback lwc_hooks_plain_cmp === '+error);
        console.log('errorCallback lwc_hooks_plain_cmp === '+stack);
}

}