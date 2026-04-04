import { LightningElement,wire,track } from 'lwc';
import getrcd from '@salesforce/apex/lwc_class.getrecordsbasedonparamsforevent';
import { refreshApex } from '@salesforce/apex';

const colums = [
{label:'Job #',fieldName:'Job_Auto_Number__c'},
{label:'Name',fieldName:'Name'},
{label:'Status',fieldName:'Status__c'},
{label:'Recalculate schedule',fieldName:'UpdateSchedDateFieldCheck__c'}
];
export default class Lwc_declaratively_event_handling_own_datatable_cmp extends LightningElement {
column = colums;
returnjobrecords;
nameventvalue;
recalceventvalue;
 fetchedrecords = [];

handlefetchevent(event){
//here we assigning event passed values to nameventvalue , recalceventvalue.
this.nameventvalue = event.detail.serachedname;
this.recalceventvalue = event.detail.recalcschd;
console.log('handlefetchevent detail === '+event.detail.serachedname+'recalc === '+event.detail.recalcsch);
//console.log('handlefetchevent target === '+event.target.serachedname); // event target shoulduse only for lightning input here event.detail is not working

}

@wire(getrcd,{Searchname:'$nameventvalue',recalc:'$recalceventvalue'}) jobreturnrcd({error,data}){
    if(data){
        console.log('wire in data === '+data);
        data.forEach(listofrcds =>
            fetchedrecords.push(listofrcds)
        );
        console.log('fetchedrecords === '+fetchedrecords);
    }
    else{
        console.log('error === '+error);
    }
}


callrefresh(event){
   refreshApex();
}

}