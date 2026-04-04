import {LightningElement,  wire} from 'lwc';
import { refreshApex } from '@salesforce/apex';

// importing Apex Class
import getOppdata from '@salesforce/apex/lwc_class.retriveOpportunities';

// Datatable Columns
const columns = [
{
label: 'Opportunity Name',
fieldName: 'Name',
type: 'text',
}, {
label: 'Account Name',
fieldName: 'AccountName',
type: 'text'
}, {
label: 'Account Owner',
fieldName: 'AccountOwner',
type: 'text'}

];
export default class ReferenceDataInLwcDatatable extends LightningElement {
data = [];
columns = columns;

@wire(getOppdata) opp({error, data}) {
        if(data) {
            let currentData = [];
            data.forEach((row) => {
                let rowData = {};
                rowData.Name = row.Name;            
                // Account related data
                if (row.Account) {
                    rowData.AccountName = row.Account.Name;
                    rowData.AccountOwner = row.Account.Owner.Name;
                }
                currentData.push(rowData);
            });
            this.data = currentData;
        }
        else if(error) {
            window.console.log(error);
        }
    }

    refreshbutton(event){
refreshApex(data);
    }
}