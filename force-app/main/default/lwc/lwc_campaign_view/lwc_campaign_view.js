import { LightningElement,api,wire, track } from 'lwc';
import lightningstyles from '@salesforce/resourceUrl/lwcexternalcss';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue,getRecordNotifyChange  } from "lightning/uiRecordApi";
import { RefreshEvent } from 'lightning/refresh';

import getobjapiname from '@salesforce/apex/LDS_Controller.getObjectType';
import getobjlabelname from '@salesforce/apex/LDS_Controller.geLabelforObject';
import getfieldsforjobobj from '@salesforce/apex/LDS_Controller.getFieldsforJobObject';
import getcustmsettingvalues from '@salesforce/apex/LDS_Controller.CustomSettingvalues';
import cmpgnrcdfieldvalues from '@salesforce/apex/LDS_Controller.getcmpncurrentrcdfieldvalues'

export default class ExampleComponent extends NavigationMixin(LightningElement) {
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
    
    showjobnewlayout = false;
    showjobnewlayouttrail = false;
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
@wire(CurrentPageReference) pageRef;

    connectedCallback(){
        console.log('edited css');
        
    Promise.all([
           loadStyle(this, lightningstyles + '/lwcexternal/externalstyles/headercss/styles/lwcaccordincss.css')
        ])
    }

    renderedCallback(){
        /*To apply color for individual accordin section based on id with this.template.querySelector only
        const accordionSections = this.template.querySelector('lightning-accordion-section[data-my-id=section1]');
        accordionSections.style.backgroundColor = 'gainsboro';*/
        /*To apply color for all accordin section with this.template.querySelectorall
              const accordionSections = this.template.querySelectorall('lightning-accordion-section[data-my-id=section1]');
       accordionSections.forEach(section => {
            section.style.backgroundColor = 'gainsboro';
        }); */
    }

    disconnectedCallback(event) {
        console.log('element disconnected');
        }
    

    NewJobRedirect(){
   console.log('NewJobRedirect === '+this.recordId);
   let currentrcdobj = {};
   this.cmpobjonload = {};
   this.fieldsetobj = [];
    this.showjobnewlayout = true; 
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
                this.fieldsetobj.push({fieldname : result[i],iscampaign:result[i] == 'Campaign__c',ismedia:result[i] == 'Media_Types__c',isschedule:result[i] == 'Schedule_Template__c',isclient:result[i] == 'JS_Client__c',isclientcontact:result[i] == 'JS_Client_Contact__c',iscreativebrief:result[i] == 'Specification_Template__c', isreadonly : result[i] == 'Job_Auto_Number__c',required : result[i] == 'Name' ||  result[i] == 'Media_Types__c' || result[i] == 'Schedule_Template__c'});
                }
        }
        })
        cmpgnrcdfieldvalues({currentrcdid : this.recordId})
        .then(result=>{
        currentrcdobj = result;
        console.log('currentrcdobj  === '+JSON.stringify(currentrcdobj));
        console.log('currentrcdobj campaign === '+currentrcdobj.Id);
           var CmpObj={"Id":currentrcdobj.Id, "Name":currentrcdobj.Name,"fieldapiname":'Campaign__c'};
            this.cmpobjonload = CmpObj;
        })
        .catch(error => {
            //this.error = error;
            this.cmpobjonload = {};
            console.log('error === '+JSON.stringify(error));
            }); 
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
    }

    handlesubmit(event){
        var recId=this.recordId;
        var PECustomSetting=this.PECustomSetting;
        var OrgInfo=this.OrgInfo;
        var ProInfo=this.ProInfo; 
        var ShowNotrequiredJob =PECustomSetting.Remove_Required_of_Job_name__c;
        var ShowNotReScheduleJob=PECustomSetting.Recalculate_Schedule_Job__c;
        var ShowPE=PECustomSetting.Active__c;
        console.log('===PECustomSetting=='+JSON.stringify(PECustomSetting));
        console.log('===OrgInfo=='+JSON.stringify(OrgInfo));
        console.log('===ProInfo=='+JSON.stringify(ProInfo));
        console.log('===ShowNotrequiredJob=='+JSON.stringify(ShowNotrequiredJob));
        console.log('===ShowNotReScheduleJob=='+JSON.stringify(ShowNotReScheduleJob));
        event.preventDefault();       // stop the form from submitting

       const fields = event.detail.fields;
        console.log('===fields=='+JSON.stringify(fields));
        var NamemissField="";
        var SchuCalMissing="";
        var SchuCal="";
        var missField="";

        if(ShowNotrequiredJob==false) {
            if(( OrgInfo.Id !='00DG0000000k48JMAQ' || OrgInfo.Id !='00DJ000000371J9MAI' )){
                NamemissField=fields.Name;
                if(NamemissField==null || NamemissField=='' ){
                    NamemissField="Name";
                }
            }
        }
        SchuCalMissing=fields.Schedule_Calc__c;
        if(SchuCalMissing==null || SchuCalMissing==''){
            missField="Schedule Calc";
        }
else{
    SchuCal=fields.Schedule_Calc__c;
    if(SchuCal=='Start Date'){
        var StartDate=fields.Start_Date__c;
        if( (SchuCal=='Start Date') && (StartDate=='' || StartDate==null)){
            missField='Start Date';
        }
}
  if(SchuCal=='End Date'){
    var DueDate=fields.Due_Date__c;
    if( (SchuCal=='End Date') && (DueDate=='' || DueDate==null)){
        missField='Due Date';
    }
}

console.log('NamemissField === '+NamemissField);
console.log('missField === '+missField);

        const ToastMsgName = new ShowToastEvent({
            title: NamemissField,
            message:  NamemissField+' Field is required.',
            variant: 'error',
            });

            const ToastMsg = new ShowToastEvent({
                title: missField,
                message:  missField+' Field is required.',
                variant: 'error',
                });
        
        if(NamemissField=="Name"){
            this.dispatchEvent(ToastMsgName);
            event.preventDefault();
        }

        else if(missField=="Schedule Calc"){
            this.dispatchEvent(ToastMsg);
            event.preventDefault();
        }
        
            else if(missField=="Start Date"){
                this.dispatchEvent(ToastMsg);
                event.preventDefault();
            }
        
                else if(missField=="Due Date"){
                    this.dispatchEvent(ToastMsg);
                    event.preventDefault();
                }

                else if(this.medobj.Id==null || this.medobj.Id== 'media removed' ){
                    const ToastMsg1 = new ShowToastEvent({
                        title: 'Media Template',
                        message: 'Media Template Field is required.',
                        variant: 'error',
                        });
                        this.dispatchEvent(ToastMsg1);
                    event.preventDefault();   
                }
                else if(this.schobj.Id==null || this.schobj.Id == 'schedule removed' ){
                    const ToastMsg2 = new ShowToastEvent({
                        title: 'Schedule Template',
                        message: 'Schedule Template Field is required.',
                        variant: 'error',
                        });
                        this.dispatchEvent(ToastMsg2);
                    event.preventDefault();   
                }

                else{
                    if(typeof this.cmpobjonload.Id === "undefined"){
                        fields.Campaign__c = '';
                    }
                    else{
                        fields.Campaign__c =this.cmpobjonload.Id;  
                    }
                    if(typeof this.medobj.Id === "undefined"){
                        fields.Media_Types__c = '';
                    }
                    else{
                        fields.Media_Types__c =this.medobj.Id;  
                    }
                    if(typeof this.schobj.Id === "undefined"){
                        fields.Schedule_Template__c = '';
                    }
                    else{
                        fields.Schedule_Template__c =this.schobj.Id;  
                    }
                    if(typeof this.clntobj.Id === "undefined"){
                        fields.JS_Client__c = '';
                    }
                    else{
                        fields.JS_Client__c =this.clntobj.Id;  
                    }
                    if(typeof this.clntcntobj.Id === "undefined"){
                        fields.JS_Client_Contact__c = '';
                    }
                    else{
                        fields.JS_Client_Contact__c =this.clntcntobj.Id;  
                    }

                    if((OrgInfo.Id == '00DG0000000k48JMAQ' || OrgInfo.Id == '00DJ000000371J9MAI') && recId==null){
                        var jbName = '';
                        if(typeof this.cmpobjonload.Id !='undefined'){
                            jbName += this.cmpobjonload.Name + ' ';
                        }
                        
                        if(typeof this.schobj.Id !='undefined'){
                            jbName += this.schobj.Name + ' ';
                        }
                        
                        var d = new Date();
                        jbName +=d.getFullYear();
                        fields.Name = jbName;  
                    }

                    if(recId!=null ){
                        //line number 325 in aura here mark done and approva all logic is pending in handlesubmit for edit scenario this is related to modal
                    }
                    fields.Media_Types__c = this.medobj.Id;
                     fields.Schedule_Template__c = this.schobj.Id;
               //line number 325 in aura here start and edn time logic is pending in handlesubmit
        console.log('===fields final with confiramtion of submit=='+JSON.stringify(fields));
        //Note : still on component custom setting logic is pending in handlesubmit
        this.template.querySelector('lightning-record-edit-form').submit(fields);
                }
    }
        }

    handlesuccess(event){
        console.log('handle success');
        const evt = new ShowToastEvent({
            title: 'Job created or updated',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
            });
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Campaign__c',
                    actionName: 'list'
                },
                state: {
                    filterName: 'All'
                },
                });
//After saving record timing status logic is pending in handlesubmit
            this.dispatchEvent(evt);
    }

    
    handlecmpselected(event){
        console.log("The selected object api name === "+event.detail.selectedobjname);
        console.log("The selected record id === "+event.detail.lookupid);
        if(event.detail.selectedobjname == 'Campaign__c'){
        var cmp = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
        this.cmpobjonload = cmp;
        }
        if(event.detail.selectedobjname == 'Media_Type__c'){
            console.log('value came from media type  cmp === '+event.detail.lookupid);
        var med = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
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
            var sch = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
            this.schobj = sch;
            this.isscheduleselected = true;
            }
            if(event.detail.selectedobjname == 'Client__c'){
                console.log('value came from client cmp === '+event.detail.lookupid);
                var client = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
                this.clntobj = client;
                this.clientidfordep = event.detail.lookupid;
            }
            if(event.detail.selectedobjname == 'Client_Contact__c'){
                console.log('value came from client contact cmp === '+event.detail.lookupid);
                var clientcnt = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
                this.clntcntobj = clientcnt;
            }
            if(event.detail.selectedobjname == 'Job_Spec__c'){
                console.log('value came from creative brief cmp === '+event.detail.lookupid);
                var creatvebre = {"Id" : event.detail.lookupid,"Name" : event.detail.lookupname};
                this.creativebriefobj = creatvebre;
            }
        }
        
    handlemediaselected(event){
    console.log("The selected media record === "+event.detail);
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

    cancelcmpgn(event){
        event.preventDefault();
        this.showjobnewlayout = false;  
        // refresh the standard related list
     this.dispatchEvent(new RefreshEvent());
    /* this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: event.detail.id,
            objectApiName: 'Job__c',
            actionName: 'view'
        }
    });
    this.dispatchEvent(evt);*/
}
}