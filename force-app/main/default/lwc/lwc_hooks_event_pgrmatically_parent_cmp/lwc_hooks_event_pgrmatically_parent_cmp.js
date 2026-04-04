import { LightningElement,wire } from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.getrecordsbasedonparamsforevent';
const clm=[
{label:'Name',fieldName:'Name'},
{label:'Recalculate schedule',fieldName:'UpdateSchedDateFieldCheck__c'},
{label:'Status',fieldName:'Status__c'}
];
export default class Lwc_hooks_event_pgrmatically_parent_cmp extends LightningElement {
namesearch;
recalcval;
colm = clm;
constructor(){
super();
console.log('lwc_hooks_event_pgrmatically_parent_cmp constructor === ');
this.template.addEventListener('manindrahooksnamevalue',this.handlenameevt.bind(this));
this.template.addEventListener('manindrahooksrecalcvalue',this.handlerecalcevt.bind(this));
}

connectedcallback(){
console.log('lwc_hooks_event_pgrmatically_parent_cmp connectedCallback  === ');
}

renderedCallback(){
console.log('lwc_hooks_event_pgrmatically_parent_cmp renderedCallback  === ');
}

disconnectedCallback(){
console.log('lwc_hooks_event_pgrmatically_parent_cmp disconnectedCallback  === ');
}

handlenameevt(event){
console.log('event.detail nme === '+event.detail.nme);
console.log('event detail sampletext === '+event.detail.sampletext);
this.namesearch     = event.detail.nme;
}

handlerecalcevt(event){
console.log('event.detail recalc ==='+event.detail.recalc);
this.recalcval = event.detail.recalc;
}

@wire(getrcds,{Searchname:'$namesearch',recalc:'$recalcval'}) jobrcd;

}