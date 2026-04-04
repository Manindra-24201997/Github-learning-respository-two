import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub';

export default class Pubsub_child_basic_example extends LightningElement {

    publishbutton(event){
        //step1 : compose message you want to send
        let messageval = {
            "Name" : "Manindra",
            "salary" : "fifty lakhs",
            "phone" : "1234567"
        };
        //step 2 : send/post message
        pubsub.fire('manindrapubsub',messageval);
    }
}