import { LightningElement, track } from 'lwc';

export default class RefreshOnDisconnectLWC extends LightningElement {
    @track isConnected = true;

    handleDisconnect() {
        // The element is disconnected, set isConnected to false
        this.isConnected = false;

        // Create and dispatch a custom event
        const disconnectEvent = new CustomEvent('elementdisconnected',{bubbles : true, composed : true});
        this.dispatchEvent(disconnectEvent);
    }
}