import { LightningElement,api} from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

export default class Lwc_imperatively_create_example extends LightningElement {
nameupdate ;
emailupdate;
descriptionupdate;
@api objectApiName;

changename(event){
this.nameupdate = event.detail.value;
}

changeemail(event){
this.emailupdate = event.detail.value;
}

changedescription(event){
this.descriptionupdate = event.detail.value;
}

handleClick(event){
const fields = {'Name':this.nameupdate,'Job_Description__c':this.descriptionupdate,'Requestor_Email__c':this.emailupdate};
const insertrcd = {apiName:this.objectApiName,fields};
createRecord(insertrcd).then(response=>{
    console.log('response.message === '+JSON.stringify(response.message));
    const evt = new ShowToastEvent({
        title: 'created record',
        message: 'created record ',
        variant: 'success',
        });
        this.dispatchEvent(evt);

       
}).catch(error=>{
    console.log('error==='+JSON.stringify(error));
    console.log('error.message ==='+error.body.message)

    const errorevt = new ShowToastEvent({
        title: 'Error in record cretion',
        message: error.body.message,
        variant: 'error',
        });
        this.dispatchEvent(errorevt);

});

}
}