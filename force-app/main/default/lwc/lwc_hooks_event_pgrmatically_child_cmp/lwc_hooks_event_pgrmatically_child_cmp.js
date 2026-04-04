import { LightningElement } from 'lwc';

export default class Lwc_hooks_event_pgrmatically_child_cmp extends LightningElement {

namevalue;
recalcvalue;

handlename(event){
//The below is one model
this.dispatchEvent(new CustomEvent('manindrahooksnamevalue',{detail:{nme:event.target.value,sampletext:'Manindra'},bubbles:true,composed:true}));
}

handlerecalcchange(event){
//this.dispatchEvent(new CustomEvent('manindrahooksrecalcvalue',{detail:event.target.checked,bubbles:true,composed:true}));
//or The below is another model
this.dispatchEvent(new CustomEvent('manindrahooksrecalcvalue',{detail:{recalc:event.target.checked},bubbles:true,composed:true}));
}

}