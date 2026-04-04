import { LightningElement,api } from 'lwc';
import pubsub from 'c/pubsub';

export default class Pubsub_parent_basic_example extends LightningElement 
{

messageval;
connectedCallback()
{
    console.log('connected callback in subscriber');
}

renderedCallback(){
    //this.register();//we need to use only register keyword.

    console.log('rendered callback in subscriber');
}

register(){
    console.log('register function in subscriber');
pubsub.register('manindrapubsubchecking',this.handleval.bind(this));
}

handleval(msgfrompubsubword){
//alert('called === '+JSON.stringify(msgfrompubsubword));   

//this.messageval = msgfrompubsubword ? JSON.stringify(msgfrompubsubword,null,'\t'):'no msg payload';

}
}