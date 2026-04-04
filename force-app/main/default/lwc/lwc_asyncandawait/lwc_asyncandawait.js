import { LightningElement } from 'lwc';
import getrcds from '@salesforce/apex/lwc_class.retriveOpportunities';
export default class Lwc_asyncandawait extends LightningElement {

    //connectedcallback comparision
    connectedCallback(){
          console.log('1️⃣ connectedCallback start');
          // Call an async function
        this.asyncFunction();
       // this.asyncFunction2();
        // Call a normal (non-async) function
        this.normalFunction();
        console.log('4️⃣ connectedCallback end');
    }

    normalFunction() {
        console.log('2️⃣ normalFunction start');
        console.log('3️⃣ normalFunction end');
    }

    async asyncFunction() {
        console.log('A️⃣ asyncFunction start');
        // Simulate async Apex call with Promise
        await new Promise((resolve, reject) => {
            setTimeout(() => {
                console.log('B️⃣ inside async promise');
                getrcds().then(response=>{
    if(response){
         //resolve(response);
        console.log('reposnse === '+response);
    }
    else{
        console.log('no response in then');
    }
})
               
            }, 1000);
        }).catch(error => {
                    reject(error);
                });
        console.log('C️⃣ 1 asyncFunction after await');
    }

    async asyncFunction2() {
        console.log('A️⃣ asyncFunction 2 start');
           await getrcds().then(response=>{
    if(response){
        console.log('reposnse 2 === '+response);
    }
    else{
        console.log('no response 2 in then');
    }
})
              
        console.log('C️⃣ 2 asyncFunction2 after await');
    }

     thenfunction(){
getrcds().then(response=>{
    if(response){
        console.log('reposnse === '+response);
    }
    else{
        console.log('no response in then');
    }
})
console.log('then bottom');

    }

async handleasync(event){
const res = await getrcds();
if(res){
console.log('res === '+res);
}
else{
    console.log('no response in async');
}
console.log('async bottom');
    }
}