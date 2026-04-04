import { LightningElement,wire } from 'lwc';
/*import pubsub from 'c/pubsub';*/
import { registerListener, unregisterListener } from 'c/pubsub'; 
import { CurrentPageReference } from 'lightning/navigation';

export default class Lwc_subscriber_basic_cmp extends LightningElement {
@wire(CurrentPageReference) pageRef;

pubsubvalue;
pubsubrolevalue;
pubsubprojectvalue;
connectedCallback(){
    console.log('connected callback');
this.register();
}

register(){
registerListener('pubsubpublisher',this.handlevalue.bind(this),this);
}

handlevalue(msgfrompubsub){
this.pubsubvalue = msgfrompubsub ? JSON.stringify(msgfrompubsub) : 'No value from pubsub';
console.log('msgfrompubsub.role === '+JSON.stringify(msgfrompubsub.Role));
this.pubsubrolevalue = JSON.stringify(msgfrompubsub.Role);
this.pubsubprojectvalue = JSON.stringify(msgfrompubsub.Project);
}

unregistercallback(){
unregisterListener('pubsubpublisher',this.handlevalue.bind(this),this);  
}

disconnect(){
this.disconnectedCallback();
}
disconnectedCallback(){
unregisterAllListeners(this);
}

}