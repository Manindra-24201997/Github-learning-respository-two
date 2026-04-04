import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions'; // 👈 Import to close the action

export default class Lwc_quickactioncmp1_version2 extends LightningElement {
     @api recordId;
       
    @api invoke() {
        console.log('Headless Action Executing for Record ID: ' + this.recordId);

        // 1. Execute the main logic (e.g., dispatch a toast, call an Apex method)
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success!',
                message: 'Headless quick action executed successfully for record ' + this.recordId,
                variant: 'success'
            })
        );
        
        // 2. Crucial Step: Immediately dispatch an event to close the quick action
        // This stops the loading spinner and dismisses the action window.
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}