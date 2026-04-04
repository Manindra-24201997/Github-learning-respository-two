import { LightningElement } from 'lwc';

export default class Lwc_declaratively_event_handling_own_child_cmp extends LightningElement {
namevalue;
 recalculateschedulevalue;


handlenamechange(event){
this.namevalue = event.target.value;
console.log('name value === '+this.namevalue);
}

handlerecalcchange(event){
this.recalculateschedulevalue = event.target.checked;
console.log('recalculateschedulevalue value === '+this.recalculateschedulevalue);

}

handlesubmit(event){
const evtdefine = new CustomEvent('fetchrecords',{detail:{serachedname:this.namevalue,recalcschd:this.recalculateschedulevalue}});
this.dispatchEvent(evtdefine);
}

}