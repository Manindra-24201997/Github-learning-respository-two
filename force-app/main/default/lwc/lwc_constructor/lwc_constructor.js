import { LightningElement } from 'lwc';

export default class Lwc_constructor extends LightningElement {
constructor(){
super();


var divblock = this.template.querySelector('[data-id="divblock"]');
if(divblock){
this.template.querySelector('[data-id="divblock"]').className='class1';
}
}


handleClick1(){

var divblock = this.template.querySelector('[data-id="divblock"]');
if(divblock){
this.template.querySelector('[data-id="divblock"]').className='class1';
}        
}
handleClick2(){
var divblock = this.template.querySelector('[data-id="divblock"]');
if(divblock){
this.template.querySelector('[data-id="divblock"]').className='class2';
}
}
}