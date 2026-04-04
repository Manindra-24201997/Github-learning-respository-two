import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub';

export default class Pubsub_parent_basic_example extends LightningElement 
{

messageval;
connectedCallback()
{
    console.log('connected callback in subscriber');
this.register();//we need to use only register keyword.
}

renderedCallback(){
    console.log('rendered callback in subscriber');
}

register(){
    console.log('register function in subscriber');
pubsub.register('manindrapubsub',this.handleval.bind(this));
}

handleval(msgfrompubsubword){
//alert('called === '+JSON.stringify(msgfrompubsubword));   

this.messageval = msgfrompubsubword ? JSON.stringify(msgfrompubsubword,null,'\t'):'no msg payload';

}
}