import {NavigationMixin} from 'lightning/navigation';
import { LightningElement} from 'lwc';

export default class Lwc_api_and_track extends NavigationMixin(LightningElement) {
namevalue;
agevalue;
cityvalue;

valname;
valage;
valcity;

namechange(event){
this.namevalue=event.target.value;
}

agechange(event){
this.agevalue=event.target.value;
}

citychange(event){
this.cityvalue=event.target.value;
}

buttonclicked(event){
this.valname = this.namevalue;
this.valage = this.agevalue;
this.valcity=this.cityvalue;
}
}