import { LightningElement } from 'lwc';

export default class Lwc_dynamic_css extends LightningElement {

//stylecss = 'color:blue;';

get stylecss(){
return 'color:blue';
}

arraydatacustom = [
    {id:524,name:'Manindra',age:25,developer:true,stylecolor:'text-align:center;color:blue'},
    {id:527,name:'chennamsetty',age:25,developer:true,stylecolor:'color:blue'}
    ]
}