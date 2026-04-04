import { LightningElement,api,wire,track } from 'lwc';
import schdtemp from '@salesforce/apex/lwc_customLookUpController.getschtemprcd';
import pubsub from 'c/pubsub';


const DELAY = 300;
export default class Lwc_custom_lookup_dependent extends LightningElement {

//Another cmp variables
@api objname;
@api label;
@api iconName;
@api filter = '';
@api searchPlaceholder='Search';
@track selectedName;
@track selectedNameClient;
@track records;
@track blurTimeout;
@track searchTerm  = '';
@track isValueSelected = false;
@track showlistbox ;
@api selectediconname ;

@api mediaidisdep;//This attribite is refered in parent cmp
@api clientidisdep;
@api scheduleidisselected;//This attribite is refered in parent cmp
@api isremovefield ;//This attribite is refered in parent cmp

messageval;
isselected = false;

connectedCallback(){
 //console.log('remove field value in connected callback ==== '+this.isremovefield);
 console.log('this.isselected in connectedcallback === '+this.isselected);
}

renderedCallback(){
  //console.log('remove field value in rendered callback ==== '+this.isremovefield);
  console.log('this.isselected in renderedCallback === '+this.isselected);
  if(this.isselected){
    this.register();//we need to use only register keyword.
  }
}

register(){
console.log('register function in subscriber');
pubsub.register('manindrapubsub',this.handleval.bind(this));
}

handleval(msgfrompubsubword){
//alert('called === '+JSON.stringify(msgfrompubsubword));  
this.messageval = msgfrompubsubword ? JSON.stringify(msgfrompubsubword,null,'\t'):'no msg payload';
this.isValueSelected = false;
this.showlistbox = false;
this.mediaidisdep = this.messageval.Mediaid;
console.log('message val === '+this.messageval.Mediaid+'handle val === '+this.isValueSelected+'and media is === '+this.mediaidisdep+'this.selectedName === '+this.selectedName); 
}

            handleKeyUp(event) {
              console.log('handle key up custom lookup dependent value === '+event.target.value+' and object name === '+this.objname);
              this.isselected = false;
              const searchKey = event.target.value;
              console.log('serach key === '+searchKey);
              this.isremovefield = false;
                console.log('media id handleKeyUp === '+this.mediaidisdep);
                schdtemp({searchTerm:searchKey,mediaid:this.mediaidisdep}).then(data => {
                  console.log('schedule records under selected media === '+data.length);
                  if (data) {
                    console.log('if data === '+data.length);
                    this.records = data;
                    this.error = undefined;
                    this.showlistbox = true;

                    if(data.length > 0){
                      console.log('data in handle keyup dependent === '+data.length > 0);
                    }
                    else{
                        console.log('else data === '+data.length);
                      this.showlistbox = false; 
                    }
                    }
                    else if (error) {
                    console.log('error data === '+JSON.stringify(error));
                    this.error = error;
                    this.records = undefined;
                    this.showlistbox = false;
                    }
                    else{
                      console.log('else data === '+JSON.stringify(data));
                      this.error = error;
                      this.records = undefined;
                      this.showlistbox = false;
                    }
                })
            }
                
                handleOptionSelectDep(event){
                    let selectedName = event.currentTarget.dataset.name;
                    console.log('handleOptionSelect in custom lookup dependent === '+selectedName);
                      this.selectedName = selectedName;
                    let selectedId = event.currentTarget.dataset.id;
                    console.log('selectid === '+selectedId);
                    console.log('handleOptionSelect === '+JSON.stringify(event.currentTarget.dataset));
                    this.searchTerm = '';
                    this.template
                .querySelector('.slds-dropdown')
                .classList.add('slds-hide');
                this.isValueSelected = true;
                this.isselected = true;     // new attribute on 11 - 09 - 2023
                this.isremovefield = false;
                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:{lookupid:selectedId,lookupname:selectedName,selectedobjname :this.objname}});
                this.dispatchEvent(valueSelectedEvent);
                }

                handleremovedependentvalue(event) {
               console.log('handleremovedependentvalue in custom lookup dependent === '+this.objname);
                this.selectedName = null;
                this.scheduleidisselected = false;
                this.showlistbox = false;
                 console.log('this.showlistbox === '+this.showlistbox);
                this.isValueSelected = false;
                this.isremovefield = false;
                this.isselected = false;   
                this.selectedName = null;// new attribute on 11 - 09 - 2023
                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:{lookupid:'schedule removed',selectedobjname :this.objname}});
                 this.dispatchEvent(valueSelectedEvent);
                }

                 @api loadlookuprcddpdnt(lookupparentobject,lookupdepobject){
                  console.log('parent mthd called name === '+lookupparentobject.Name+'field api name === '+lookupparentobject.fieldapiname);
                  console.log('dependent mthd called name === '+lookupdepobject.Name+'field api name === '+lookupdepobject.fieldapiname);
                  if(lookupdepobject.Name){
                    console.log('child rcd onload name === '+lookupdepobject.Name);
                    console.log('child rcd field api name === '+lookupdepobject.fieldapiname);
                    this.mediaidisdep = lookupparentobject.Id;//Assigning media id for onload
                    this.isselected = true; // This is very important because when we click edit button lookup values should populate with value then we need to keep isselected = true
                      this.selectedName = lookupdepobject.Name;
                      this.isValueSelected = true;
                    }
                    else{
                      this.selectedName = ''; 
                      this.isValueSelected = false;
                    }
                }
}