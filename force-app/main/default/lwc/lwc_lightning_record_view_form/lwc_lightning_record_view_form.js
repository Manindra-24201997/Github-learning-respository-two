import { LightningElement,api } from 'lwc';
import Name_Field from '@salesforce/schema/Job__c.Name';
import Client_Field from '@salesforce/schema/Job__c.JS_Client__c'
import Client_Contact_Field from '@salesforce/schema/Job__c.JS_Client_Contact__c';
import Statusfield from '@salesforce/schema/Job__c.Status__c';
import stdte from '@salesforce/schema/Job__c.Start_Date__c';
import schdueclc from '@salesforce/schema/Job__c.Schedule_Calc__c';

export default class Lwc_lightning_record_view_form extends LightningElement {
@api objectApiName;
@api recordId;
Record_Name = Name_Field;
Record_clientname = Client_Field;
Record_clientcontact = Client_Contact_Field;
Record_status = Statusfield;
Record_startdate = stdte;
Record_schedulecalc = schdueclc;
}