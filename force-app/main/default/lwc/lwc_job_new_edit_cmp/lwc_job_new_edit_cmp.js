import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import lightningstyles from '@salesforce/resourceUrl/lwcexternalcss';
import { loadStyle } from 'lightning/platformResourceLoader';

import getobjapiname from '@salesforce/apex/LDS_Controller.getObjectType';
import getobjlabelname from '@salesforce/apex/LDS_Controller.geLabelforObject';
//import getfieldsforjobobj from '@salesforce/apex/LDS_Controller.getFieldsforJobObject';
import getcustmsettingvalues from '@salesforce/apex/LDS_Controller.CustomSettingvalues';
//import rcdfieldvalues from '@salesforce/apex/LDS_Controller.getcurrentrcdfieldvalues';

import name_val from '@salesforce/schema/Job__c.Name';
import auto_num from '@salesforce/schema/Job__c.Job_Auto_Number__c';
import cmpgn from '@salesforce/schema/Job__c.Campaign__c';
import cmpgn_name from '@salesforce/schema/Job__c.Campaign__r.Name';
import { getRecord, getFieldValue,getRecordNotifyChange  } from "lightning/uiRecordApi";

const fields = [name_val,auto_num,cmpgn,cmpgn_name];

export default class Lwc_job_new_edit_cmp extends NavigationMixin(LightningElement) {
@api recordId;
objectapinamevalue = 'Job__c';
@api fieldSet = [];
@track fieldsetobj = [];
@api objectapiname = {};
objectlabelname;
PECustomSetting ={};
OrgInfo = {};
ProInfo = {};
ClientInfo = {};

cmpobj = {};
medobj = {};
schobj={};
clntobj={};
clntcntobj={};
creativebriefobj = {};

cmpobjonload = {};
mediaobjonload = {};
schobjonload = {};
clntobjonload = {};
clntcntobjonload={};
creativebriefonload = {};

clientidfordep;

@api isscheduleselected = false;
@api isremovedep = false;

@wire(CurrentPageReference) pageRef;


constructor(){
super();
console.log('constructor === '+this.recordId);

}

connectedCallback() {
    //The componenet related .css file is working for any where but except for quick actions buttons like edit facing modal issues so we are using external css 
    Promise.all([
            loadStyle(this, lightningstyles + '/lwcexternal/externalstyles/headercss/styles/headingnewcss.css')
         ])
 this.recordId = this.pageRef && this.pageRef.state && this.pageRef.state.recordId;
 console.log('connected Callback === ');
 this.loadRecord();
 }
 
renderedCallback() {
console.log('renderedCallback === '+this.recordId);
}

disconnectedCallback() {
console.log('element disconnected');
}


//The below is to display current detail page record
@wire(getRecord, {recordId: "$recordId", fields })jobrcd;

@wire(getRecord, { recordId: '$recordId', fields})record;

loadRecord() {
console.log('load record getFieldValue === '+this.recordId);
//getfieldsforjobobj() //To call unparametrized method in apex
this.fieldsetobj = [];
this.cmpobjonload = {};
let currentrcdobj = {};
getfieldsforjobobj({sObjName:'Job__c',fieldsetname:'Job_Field_sets'}) //To call parametrized method in apex
.then(result => {
console.log('result length === '+result.length);
for(var i= 0 ; i <result.length ; i++){
if(result[i] == 'Job_Auto_Number__c' ){
if(this.recordId != null){
this.fieldsetobj.push({fieldname : result[i],iscampaign:result[i] == 'Campaign__c',ismedia:result[i] == 'Media_Types__c',isschedule:result[i] == 'Schedule_Template__c',isclient:result[i] == 'JS_Client__c',isclientcontact:result[i] == 'JS_Client_Contact__c',iscreativebrief:result[i] == 'Specification_Template__c',  isreadonly : result[i] == 'Job_Auto_Number__c' });
}
}
else{
this.fieldsetobj.push({fieldname : result[i],iscampaign:result[i] == 'Campaign__c',ismedia:result[i] == 'Media_Types__c',isschedule:result[i] == 'Schedule_Template__c',isclient:result[i] == 'JS_Client__c',isclientcontact:result[i] == 'JS_Client_Contact__c',iscreativebrief:result[i] == 'Specification_Template__c', isreadonly : result[i] == 'Job_Auto_Number__c',required : result[i] == 'Name' || result[i] == 'Campaign__c' || result[i] == 'Media_Types__c' || result[i] == 'Schedule_Template__c'});
}
}
})
rcdfieldvalues({currentrcdid : this.recordId})
.then(result=>{
currentrcdobj = result;
console.log('currentrcdobj  === '+JSON.stringify(currentrcdobj));
console.log('currentrcdobj campaign === '+currentrcdobj.Campaign__c);
 if(typeof currentrcdobj.Campaign__c == 'undefined'){
    console.log(' if campaign is undefined or null');
    this.cmpobjonload = {};
}
else if(currentrcdobj.Campaign__c || currentrcdobj.Campaign__c != 'undefined' || currentrcdobj.Campaign__c != null || currentrcdobj.Campaign__c != ''){
    var CmpObj={"Id":currentrcdobj.Campaign__c, "Name":currentrcdobj.Campaign__r.Name,"fieldapiname":'Campaign__c'};
    this.cmpobjonload = CmpObj;
    }
else{
    this.cmpobjonload = {};
}

if(typeof currentrcdobj.Media_Types__c == 'undefined'){
    console.log(' if media is undefined or null');
    this.mediaobjonload = {};
}
else if(currentrcdobj.Media_Types__c != 'undefined' || currentrcdobj.Media_Types__c != null || currentrcdobj.Media_Types__c != ''){
    var medobj = {"Id":currentrcdobj.Media_Types__c, "Name":currentrcdobj.Media_Types__r.Name,"fieldapiname":'Media_Types__c'};
    this.mediaobjonload = medobj;
    }
    else{
        this.mediaobjonload = {};
    }

     if(typeof currentrcdobj.Schedule_Template__c == 'undefined'){
        console.log('schedule template is undefined or null');
        this.schobjonload = {};
    }
 else if(currentrcdobj.Schedule_Template__c != 'undefined' || currentrcdobj.Schedule_Template__c != null || currentrcdobj.Schedule_Template__c != ''){
        var schobj = {"Id":currentrcdobj.Schedule_Template__c, "Name":currentrcdobj.Schedule_Template__r.Name,"fieldapiname":'Schedule_Template__c'};
        this.schobjonload = schobj;
        }
        else{
            this.schobjonload = {};
        }

        if(typeof currentrcdobj.JS_Client__c == 'undefined'){
            console.log('client is undefined or null');
            this.clntobjonload = {};
        }
         else if(currentrcdobj.JS_Client__c != 'undefined' || currentrcdobj.JS_Client__c != null || currentrcdobj.JS_Client__c != ''){
            var cltobj = {"Id":currentrcdobj.JS_Client__c, "Name":currentrcdobj.JS_Client__r.Name,"fieldapiname":'JS_Client__c'};
            this.clntobjonload = cltobj;
        this.clientidfordep = currentrcdobj.JS_Client__c;
            }
            else{
                this.clntobjonload = {};
            }

           if(typeof currentrcdobj.JS_Client_Contact__c == 'undefined'){
                console.log('client contact is undefined or null');
                this.clntcntobjonload = {};
            }
            else if(currentrcdobj.JS_Client_Contact__c != 'undefined' || currentrcdobj.JS_Client_Contact__c != null || currentrcdobj.JS_Client_Contact__c != ''){
                var cltcntobj = {"Id":currentrcdobj.JS_Client_Contact__c, "Name":currentrcdobj.JS_Client_Contact__r.Name,"fieldapiname":'JS_Client_Contact__c'};
                this.clntcntobjonload = cltcntobj;
                }
                else{
                    this.clntcntobjonload = {};
                }

                if(typeof currentrcdobj.Specification_Template__c == 'undefined'){
                    console.log('creative brief is undefined or null');
                    this.creativebriefonload = {};
                }
                else if(currentrcdobj.Specification_Template__c != 'undefined' || currentrcdobj.Specification_Template__c != null || currentrcdobj.Specification_Template__c != ''){
                    var creativebriefobj = {"Id":currentrcdobj.Specification_Template__c, "Name":currentrcdobj.Specification_Template__r.Name,"fieldapiname":'Specification_Template__c'};
                    this.creativebriefonload = creativebriefobj;
                    }
                    else{
                        this.creativebriefonload = {};
                    }
})
.catch(error => {
//this.error = error;
console.log('error === '+JSON.stringify(error));
});
}

get autonumber() {
return getFieldValue(this.jobrcd.data,auto_num);
}

Refresh(event){
const inputfields = this.template.querySelectorAll('lightning-input-field');
inputfields.forEach(field=>{field.reset();});
const evt = new ShowToastEvent({
title: 'Refreshed',
message: 'Refreshed ' ,
variant: 'success',
});
this.dispatchEvent(evt);
}

//Below is to get object api name with field labels and api names in json string format from apex method
@wire(getobjapiname)  objapiname({error,data}){
if(data){
//console.log('object api name  new === '+data);
this.objectapiname = JSON.parse(data);
}
}//ends here

//Below is to get object label name from apex method
@wire(getobjlabelname,{sObjName:'Job__c'}) objlabelname({error,data}){
                                                    if(data){
                                                    console.log('object label name === '+data);
                                                    this.objectlabelname = data;   
                                                    }
                                                    }//ends here
                                                    
                                                    @wire(getcustmsettingvalues) customsettingval({error,data}){
                                                    if(data){
                                                    console.log('data === '+data);
                                                    this.PECustomSetting = data[0];
                                                    this.OrgInfo =  data[1];
                                                    this.ProInfo = data[2];
                                                    if(data.length==4){
                                                    this.ClientInfo = data[3];
                                                    }
                                                    }
                                                    }
                                                    
                                                    cancel(event){
                                                        event.preventDefault();
                                                        this.recordId = false;
                                                    /*this[NavigationMixin.Navigate]({
                                                    type: 'standard__objectPage',
                                                    attributes: {
                                                        objectApiName: 'Job__c',
                                                        actionName: 'list'
                                                    },
                                                    state: {
                                                        filterName: 'All'
                                                    },
                                                    });*/
}

handleload(event){
//for model : https://salesforce.stackexchange.com/questions/256007/how-do-you-define-an-element-with-an-id-attribute-using-lwc
console.log('handle load  ==== ');
/*var record = event.detail.records;
var fields = record[this.recordId].fields; 
console.log('JSON fields === '+JSON.stringify(fields));
console.log('fields value === '+fields.Campaign__c.value+' '+'fields api name  === '+fields.Campaign__r.displayValue);*/
let refClass =  this.template.querySelector('lightning-record-edit-form');
console.log('handle load === '+this.cmpobjonload+'and keys === '+Object.keys(this.cmpobjonload).length);
if(this.cmpobjonload && Object.keys(this.cmpobjonload).length > 0){
    console.log('campaign handle load === ');
refClass.querySelector('c-lwc_custom_lookup[data-my-id="Camplwcid"]').loadlookuprcd(this.cmpobjonload);
}

if(this.mediaobjonload && Object.keys(this.mediaobjonload).length > 0) {
    console.log('media handle load === ');
refClass.querySelector('c-lwc_custom_lookup[data-my-id="medlwcid"]').loadlookuprcd(this.mediaobjonload);
}

if(this.schobjonload && Object.keys(this.schobjonload).length > 0) {
    console.log('schedule handle load === ');
refClass.querySelector('c-lwc_custom_lookup_dependent[data-my-id="schlwcid"]').loadlookuprcddpdnt(this.mediaobjonload,this.schobjonload);
}
if(this.clntobjonload && Object.keys(this.clntobjonload).length > 0) {
    console.log('client handle load === ');
refClass.querySelector('c-lwc_custom_lookup[data-my-id="clientlwcid"]').loadlookuprcd(this.clntobjonload);
}
if(this.clntcntobjonload && Object.keys(this.clntcntobjonload).length > 0) {
    console.log('client contact handle load === ');
refClass.querySelector('c-lwc_custom_lookup_cltcnt_dependent[data-my-id="clientcnctlwcid"]').loadlookuprcddpdnt(this.clntobjonload,this.clntcntobjonload);
}
}

handlesubmit(event){
event.preventDefault();       // stop the form from submitting
const fields = event.detail.fields;
console.log('fields === '+fields);
fields.Campaign__c = this.cmpobj.Id;
fields.Media_Types__c = this.medobj.Id;
fields.Schedule_Template__c = this.schobj.Id;
fields.JS_Client__c = this.clntobj.Id;
fields.JS_Client_Contact__c = this.clntcntobj.Id;
this.template.querySelector('lightning-record-edit-form').submit(fields);
}

handlesuccess(event){
const evt = new ShowToastEvent({
title: 'Job created or updated',
message: 'Record ID: ' + event.detail.id,
variant: 'success',
});

this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: event.detail.id,
        objectApiName: 'Job__c',
        actionName: 'view'
    }
});
this.dispatchEvent(evt);
}

handlecmpselected(event){
console.log("The selected object api name === "+event.detail.selectedobjname);
console.log("The selected record id === "+event.detail.lookupid);
if(event.detail.selectedobjname == 'Campaign__c'){
var cmp = {"Id" : event.detail.lookupid};
this.cmpobj = cmp;
}
if(event.detail.selectedobjname == 'Media_Type__c'){
    console.log('value came from media type  cmp === '+event.detail.lookupid);
var med = {"Id" : event.detail.lookupid};
this.medobj = med;
if(event.detail.lookupid == 'No media selected'){
if(this.isscheduleselected){
console.log('Needs to remove');
this.isremovedep = true;
}
else{
    this.isremovedep = false;
    console.log('No Need to remove'); 
}
}
}
if(event.detail.selectedobjname == 'Schedule_Template__c'){
    console.log('value came from schedule template dependent cmp === '+event.detail.lookupid);
    var sch = {"Id" : event.detail.lookupid};
    this.schobj = sch;
    this.isscheduleselected = true;
    }
    if(event.detail.selectedobjname == 'Client__c'){
        console.log('value came from client cmp === '+event.detail.lookupid);
        var client = {"Id" : event.detail.lookupid};
        this.clntobj = client;
        this.clientidfordep = event.detail.lookupid;
    }
    if(event.detail.selectedobjname == 'Client_Contact__c'){
        console.log('value came from client contact cmp === '+event.detail.lookupid);
        var clientcnt = {"Id" : event.detail.lookupid};
        this.clntcntobj = clientcnt;
    }
    if(event.detail.selectedobjname == 'Job_Spec__c'){
        console.log('value came from creative brief cmp === '+event.detail.lookupid);
        var creatvebre = {"Id" : event.detail.lookupid};
        this.creativebriefobj = creatvebre;
    }
}

handlemediaselected(event){
console.log("The selected media record === "+event.detail);
}

/*get customizedfieldvalues(){
let iscustomizedfields = false;
for(var i=0;i<this.fieldSet.length;i++){
if(this.fieldSet[i] == 'Name' || this.fieldSet[i] == 'Status__c' || this.fieldSet[i] == 'Start_Time__c' || this.fieldSet[i] == 'End_Time__c' ||
this.fieldSet[i] == 'Schedule_Calc__c' || this.fieldSet[i] == 'Campaign__c' || this.fieldSet[i] == 'Media_Types__c' || this.fieldSet[i] == 'Schedule_Template__c' ||
this.fieldSet[i] == 'JS_Client__c' || this.fieldSet[i] == 'JS_Client_Contact__c' || this.fieldSet[i] == 'Specification_Template__c' || 
this.fieldSet[i] == 'UpdateSchedDateFieldCheck__c' || this.fieldSet[i] == 'Creative_Overview__c' ){
iscustomizedfields = true;
}
else if(this.fieldSet[i] == 'Job_Auto_Number__c'){
iscustomizedfields = false;
}
}
return iscustomizedfields;
}*/

}