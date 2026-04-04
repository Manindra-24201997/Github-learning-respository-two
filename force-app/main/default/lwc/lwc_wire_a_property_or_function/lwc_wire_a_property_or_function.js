import { LightningElement,wire,track} from 'lwc';
import getrcdsonparam from '@salesforce/apex/lwc_class.getrecordsbasedonparam';
export default class Lwc_wire_a_property_or_function extends LightningElement {
nameval ;
namevalue;
handletextforeach(event){
this.nameval = event.target.value;
}
handletextiteratoritem(event){
this.namevalue = event.target.value;
}

@wire(getrcdsonparam,{Searchname:'$nameval'}) returnrcd; // wire a property i.e., to get records without any modifications

/*The below is wire a function with map very useful example  working example.
It is is referenced by this blog link : https://somnath1690.medium.com/cannot-add-property-object-is-not-extensible-while-running-lwc-salesforce-1d6bcee676e1
*/
@track returnrcddata = [];
error;
/*@wire(getrcdsonparam,{Searchname:'$namevalue'})
jobrcds({error,data}){
if(data){
console.log(JSON.stringify(data));
this.processData(data);
}
else if (error) {
this.error = error;
console.log('error === '+error);
}
}

processData(dataToManipulate) { //function used by above wire logic 
let reformedClaimsData = dataToManipulate.map((element, index, array) => {
return {
"Id": element.Id,
"Name": element.Name+ ' custom'
}
});
console.log('reformedClaimsData === '+reformedClaimsData);
this.returnrcddata = reformedClaimsData;
}*/

@wire(getrcdsonparam,{Searchname:'$namevalue'}) returnedjobrecords({error,data}){
if(data){
//console.log('data === '+JSON.stringify(data));
let arrayofrecord = [];
data.forEach((row)=>{
let objectrecord = {};
objectrecord.Name = row.Name+''+'custom';
arrayofrecord.push(objectrecord);
});
//alert('arrayofrecord === '+arrayofrecord);
this.returnrcddata = arrayofrecord;
//alert('if this.returnrcddata === '+this.returnrcddata);

//Below is normal for loop need to work
/*let jobdata = []; 
console.log('data length === '+data.length);
for(let i =0; i < data.length;i++){
console.log('data[i] === '+JSON.stringify(data[i]));
let jobrcd = {};
jobrcd.Name = jobrcd[i].Name + 'working';
jobdata.push(jobrcd[i]);
}
console.log('jobdata length === '+jobdata.length);
this.returnrcddata = jobdata;*/
}
else{
this.returnrcddata = []; 
console.log('else this.returnrcddata === '+this.returnrcddata);
}
}
}