import { LightningElement,track,api} from 'lwc';

export default class Lwc_track_decorator_example extends LightningElement {

@track textvalue = 'Chennamsetty'; // Here if you add  track keyword or not rerenders component any way
handletext(event){
this.textvalue = event.target.value;
}
/*When manipulating complex types like objects and arrays, you must create a new object and assign it to the field for the change to be detected.
To avoid such issues when working with complex objects, use the @track decorator to deeply tracks mutations made to the field value.
Reference link : https://www.youtube.com/watch?v=zoW6zBiDCQM at 2.30 , useful link : https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.reactivity_fields */
 cars = {name:'Tata nexon ev',mileage:10,sunroof:true}; // if you remove @track or use @api keyword it wont rerender component
updatecarproperty(event){
this.cars.sunroof = false; //If @track keyword is used for cars object this line is applicable otherwise below two lines
//this.cars = { ...this.cars, sunroof: false } // Mutation detected
//this.cars = {sunroof : false};  // Mutation detected - redefining the object with the same value creates a new object
}
}