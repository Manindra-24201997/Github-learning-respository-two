import { LightningElement } from 'lwc';

export default class Lwc_declaratively_handling_basic_example_parent_cmp extends LightningElement {
volume=0;
labelnameis;
handleincreaseevt(event){
this.labelnameis = event.detail
if(this.volume < 101){
this.volume = this.volume + 1;
}
}

handledecreaseevt(event){
    console.log('value 1 === '+event.detail.text1);
     console.log('value 2 === '+event.detail.text2);
if(this.volume > 0){
this.volume = this.volume - 1;
}
}
}