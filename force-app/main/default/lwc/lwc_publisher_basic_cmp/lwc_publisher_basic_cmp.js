import { LightningElement ,wire} from 'lwc';
import { fireEvent } from 'c/pubsub';

import { CurrentPageReference } from 'lightning/navigation';

export default class Lwc_publisher_basic_cmp extends LightningElement {
@wire(CurrentPageReference) pageRef;

handlepublish(event){
const msg = {
"Name":"Manindra sai ram","Role":"Salesforce consltant","Project":"Jobsuite"
};
fireEvent(this.pageRef,'pubsubpublisher',msg);
}
}