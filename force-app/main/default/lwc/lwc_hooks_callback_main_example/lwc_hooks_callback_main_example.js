import { LightningElement } from 'lwc';

export default class Lwc_hooks_callback_main_example extends LightningElement {
error;
stack;
constructor(){
super();
console.log('constructor === ');
this.classList.add('.class1');

}


connectedCallback(){
console.log('connectedCallback === ');
this.classList.add('.class1');

}

disconnectedCallback(){
console.log('disconnectedCallback === ');
}

/*render(){
console.log('render === ');
return null;
}*/

renderedCallback(){
console.log('renderedCallback === ');
}

errorCallback(error, stack) {
console.log('errorCallback === ');
this.error = error;
}  


}