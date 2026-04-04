import { LightningElement,api,track } from 'lwc';

export default class Lwc_connected_callback extends LightningElement {
 listvalues = [];

connectedCallback(){
this.listvalues = ['apple','mango','bananna','orange',''];

console.log('connected callback === '+ this.listvalues);

this.listvalues.sort();
console.log('connected sort callback === '+ this.listvalues);


}
}