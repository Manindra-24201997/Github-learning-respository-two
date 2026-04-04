import { LightningElement,wire} from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.getrecords';
import getrcdsonparam from '@salesforce/apex/lwc_class.getrecordsbasedonparam';

const actions = [
{ label: 'Show details', name: 'show_details' },
{ label: 'Delete', name: 'delete' },
];

const columns = [
{label : 'Name', fieldName : 'Name',type: 'text'},
{label : 'Status', fieldName : 'Status',type: 'text'},
{label : 'Client Name', fieldName : 'Client',type: 'url',
typeAttributes: { label: { fieldName: 'Clientname' }, target: '_blank', tooltip:{ fieldName: 'Clientname' }}
},
{
type: 'action',
typeAttributes: { rowActions: actions },
},
];

export default class Lwc_wire_basic_example extends LightningElement {
recordsdata = []; //lightning datatable array
columns = columns;
searchtext;
jobsdata;
/*@wire(getrcds) 
manindra({error,data}){
if(data){
let arrayofrecords = [];
console.log('JSON.stringify data new === '+JSON.stringify(data)+'\n');
data.forEach((row)=>{
let arrayofobjrecords = {};
console.log(' data new === '+row.name+'\n');
if(row.JS_Client__c){
arrayofobjrecords.Name = row.Name;
arrayofobjrecords.Status = row.Status__c;
arrayofobjrecords.Client = '/'+row.JS_Client__c;
arrayofobjrecords.Clientname = row.JS_Client__r.Name;
}
arrayofrecords.push(arrayofobjrecords);

});
console.log('arrayofrecords === '+arrayofrecords+'\n');
this.recordsdata = arrayofrecords;
}
else if(error)
{
this.error = error;
}
}*/

handlesearch(event){
this.searchtext = event.target.value;  
}

refreshbutton() {
        refreshApex(this.recordsdata);
    }

@wire(getrcds,{Searchname:'$searchtext'}) manindra({error,data}){
if(data){
    console.log('searchtext === '+this.searchtext);
let arrayofrecords = [];
console.log('JSON.stringify data new === '+JSON.stringify(data)+'\n');
data.forEach((row)=>{
let arrayofobjrecords = {};
console.log(' data new === '+row.name+'\n');
if(row.JS_Client__c){
arrayofobjrecords.Name = row.Name+'custom';
arrayofobjrecords.Status = row.Status__c;
arrayofobjrecords.Client = '/'+row.JS_Client__c;
arrayofobjrecords.Clientname = row.JS_Client__r.Name;
}
arrayofrecords.push(arrayofobjrecords);

});
console.log('arrayofrecords === '+arrayofrecords.length+'\n');
this.recordsdata = arrayofrecords;
}
else if(error)
{
this.error = error;
}
}




handleRowAction(event) {
const actionName = event.detail.action.name;
const row = event.detail.row;
switch (actionName) {
case 'delete':
this.deleteRow(row);
break;
case 'show_details':
this.showRowDetails(row);
break;
default:
}
}

deleteRow(row) {
const { id } = row;
const index = this.findRowIndexById(id);
if (index !== -1) {
this.data = this.data
.slice(0, index)
.concat(this.data.slice(index + 1));
}
}

findRowIndexById(id) {
let ret = -1;
this.data.some((row, index) => {
if (row.id === id) {
ret = index;
return true;
}
return false;
});
return ret;
}

showRowDetails(row) {
this.record = row;
}


}