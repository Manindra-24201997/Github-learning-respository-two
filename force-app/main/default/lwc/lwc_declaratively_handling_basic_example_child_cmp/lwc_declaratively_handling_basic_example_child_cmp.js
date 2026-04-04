import { LightningElement } from 'lwc';

export default class Lwc_declaratively_handling_basic_example_child_cmp extends LightningElement {

increasevalue(event){
//const incevt = new CustomEvent('increaseevent'); // create an event
const incevt = new CustomEvent('increaseevent',{detail:'Volume number is'}); // create an event and sending params basic string

this.dispatchEvent(incevt); // dispatch event
}

decreasevalue(event){
const decevt = new CustomEvent('decreaseevent',{detail:{text1:'Manindra',text2:'Chennamsetty'}});

this.dispatchEvent(decevt); 

// or

//this.dispatchEvent(new customEvent('decreaseevent')); //single line event define
}
}