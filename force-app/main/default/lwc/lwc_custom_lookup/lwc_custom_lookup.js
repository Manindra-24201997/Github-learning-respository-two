import { LightningElement, track, wire,api } from 'lwc';
import lookUp from '@salesforce/apex/lwc_customLookUpController.search';
import pubsub from 'c/pubsub';

const DELAY = 300;

export default class ExploreAccountLookup extends LightningElement {

//Another cmp variables
@api objname;
@api label;
@api iconName;
@api filter = '';
@api searchPlaceholder='Search';
@track selectedName;
@track records;
@track blurTimeout;
@track searchTerm  = '';
@track showAccountsListFlag = false;
@track isValueSelected = false;
@track showlistbox ;
@api selectediconname ;
@api isdep;
@api mediaidisdep;

connectedCallback(){
 
}

renderedCallback(){
  
}

@wire(lookUp, {searchTerm:'$searchTerm',objname:'$objname'})
wiredRecords({ error, data }) {
            if (data) {
            console.log('data length in custom lookup === '+data.length);
            this.error = undefined;
            this.records = data;
            if(data.length > 0){
              console.log('if data length in custom lookup === '+data.length);
           this.showlistbox = true;
            }
            else{
              console.log('else data length in custom lookup === '+data.length);
              this.showlistbox = false; 
            }
            }
            else if (error) {
            console.log('error in custom lookup === '+JSON.stringify(error));
            this.error = error;
            this.records = undefined;
            this.showlistbox = false;
            }
            else{
              console.log('else in custom lookup === '+JSON.stringify(data));
              this.error = error;
              this.records = undefined;
              this.showlistbox = false;
            }
            }
            
            handleKeyUp(event) {
              const searchKey = event.target.value;
                if(searchKey != null || searchKey != 'undefined' || searchKey != ''){
                  console.log('handle key up custom lookup object name === '+this.objname+'search value === '+event.target.value);
                this.searchTerm = searchKey;
              }
                }
                
                handleOptionSelect(event) {
                  console.log('handleOptionSelect === ');
                let selectedName = event.currentTarget.dataset.name;
                this.selectedName = selectedName;
                let selectedId = event.currentTarget.dataset.id;
                //console.log('selectid === '+selectedId);
                //console.log('handleOptionSelect === '+JSON.stringify(event.currentTarget.dataset));
                this.searchTerm = '';
                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:{lookupid:selectedId,lookupname:selectedName,selectedobjname :this.objname}});
                 this.dispatchEvent(valueSelectedEvent);

                 if(this.objname == 'Media_Type__c'){
      //step1 : compose message you want to send
        let messageval = {
          "Name" : "Manindra",
          "salary" : "fifty lakhs",
          "phone" : "1234567",
          "Mediaid" : selectedId
      };
      //step 2 : send/post message
     pubsub.fire('manindrapubsub',messageval);
    }
    else if(this.objname == 'Client__c'){ 
      console.log('else if custom lookup === '+this.objname+' and client id === '+selectedId);
      let messageval = {
        "Name" : "Manindra",
        "salary" : "fifty lakhs",
        "phone" : "1234567",
        "Clientid" : selectedId
    };
    //step 2 : send/post message
   pubsub.fire('manindrapubsubclient',messageval);
    }
    this.template
                .querySelector('.slds-dropdown')
                .classList.add('slds-hide');           
    this.isValueSelected = true;
      }

                handleRemoveSelectedOption(event) {
                console.log('handleRemoveSelectedOption === '+this.objname);
                if(this.objname == 'Media_Type__c'){
                 //this.selectedNamesch = null;
                  let messageval = {
                   "Name" : "Manindra",
                   "salary" : "7.5 lakhs",
                    "phone" : "1234567",
                    "objname":"Media_Type__c"
                    };
               //step 2 : send/post message
                 pubsub.fire('manindrapubsub',messageval);

                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:{lookupid:'media removed',selectedobjname :this.objname}});
                this.dispatchEvent(valueSelectedEvent); //14-9-2023
                }

               else if(this.objname == 'Client__c'){
                  //this.selectedNamesch = null;
                   let messageval = {
                    "Name" : "Manindra Client",
                    "salary" : "7.5 lakhs",
                     "phone" : "1234567",
                     "objname":"Client__c",
                     "Clientid" : null
                     };
                //step 2 : send/post message
                  pubsub.fire('manindrapubsubclient',messageval);
 
                 const valueSelectedEvent = new CustomEvent('lookupselected', {detail:{lookupid:'client removed',selectedobjname :this.objname}});
                 this.dispatchEvent(valueSelectedEvent); //14-9-2023
                 }
                this.isValueSelected = false;
                }

              @api loadlookuprcd(lookupobject){
                if(lookupobject.Name){
                console.log('mthd called name === '+lookupobject.Name);
                console.log('field api name === '+lookupobject.fieldapiname);
                  this.selectedName = lookupobject.Name;
                  this.isValueSelected = true;
                }
                else{
                  console.log('else mthd called name === ');
                console.log('else field api name === ');
                  this.selectedName = ''; 
                  this.isValueSelected = false;
                }
                }

                 @api loadlookuprcddpdnt(lookupparentobject,lookupdepobject){
                  console.log('parent mthd called name === '+lookupparentobject.Name+'field api name === '+lookupparentobject.fieldapiname);
                  console.log('dependent mthd called name === '+lookupdepobject.Name+'field api name === '+lookupdepobject.fieldapiname);
                }
              }