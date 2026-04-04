import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import libUrl from '@salesforce/resourceUrl/lib';
import myfilesUrl from '@salesforce/resourceUrl/myfiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import mimeTypes from './mimeTypes'
import { fireEvent } from 'c/pubsub';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import saveDocument from '@salesforce/apex/PDFTron_ContentVersionController.saveDocument';
import postAComment from '@salesforce/apex/PDFTron_ContentVersionController.postAComment';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //this is how you will retreive the USER ID of current in user.
import NAME_FIELD from '@salesforce/schema/User.Name';
import fetchJSMetadata from '@salesforce/apex/PDFTron_ContentVersionController.fetchJSMetadata';

import { refreshApex } from '@salesforce/apex';

//import getJobTeamList from '@salesforce/apex/PDFTron_ContentVersionController.getJobTeamList';

import getUsersList from '@salesforce/apex/PDFTron_ContentVersionController.fetchUsersList';


function _base64ToArrayBuffer(base64) {
  var binary_string =  window.atob(base64);
  var len = binary_string.length;
  var bytes = new Uint8Array( len );
  for (var i = 0; i < len; i++)        {
      bytes[i] = binary_string.charCodeAt(i);
  }
  return bytes.buffer;
} 

export default class PdftronWvInstance extends LightningElement {

  _listenForMessage;
  @track isSaved = false;
  @track loadSaveFinished = false;
  @track error ;
  @track userName;
  @track dataloadFinished = false;
  wiredDataResult;
  connectedCallRefresh = false;
  @track userData;

  
  wiredMetadataRecords;
  licenseKey;
  @wire( fetchJSMetadata )  
  wiredRecs( value ) {
      this.wiredMetadataRecords = value;
      const { data, error } = value;
      if ( data ) {
          this.licenseKey = data[0].JobSuite__Token__c;
         // console.log('>>>this.licenseKey>>>>>>>',this.licenseKey);
          this.error = undefined;
      } else if ( error ) {
          this.error = error;
          this.licenseKey = undefined;

      }

  }  

  @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] }) 

  document(result) {
    this.wiredDataResult = result;
    if (result.data) {
      this.userName = result.data.fields.Name.value;
      console.log('>>>>>>>>> wire UserName >>>>>>>>>>>>>>>>>>>',this.userName);
    } else if (result.error) {
      this.error = result.error;
      console.error(this.error);
    }
  }


  wiredUserDataResult;
  @wire(getUsersList) 
  UsersRec(result) {
      this.wiredUserDataResult = result;
      this.UsersListt = '';
      if(result.data) {
          result.data.forEach((UserRecords) => {
              console.log('>>>>>>>>>>>UserRecords',JSON.stringify(UserRecords));
              var staff = UserRecords.Name;
              var email = UserRecords.email;
              const userData = {
                  value: staff,
                  email: email
              };
              console.log('>>>>>>>>>>>userData',JSON.stringify(userData));
              this.UsersListt = [ ...this.UsersListt, userData ];
          });
          console.log('>>>>>>>>>>>this.UsersListt',JSON.stringify(this.UsersListt));
          
          this.error = undefined;
          //this.loadFinished = true;
      } else if (result.error) {
          console.error(result.error);
          this.error = result.error;
          this.userData = undefined;
        //  let def_message = 'We have encountered an error while loading up your document. '
          this.showNotification('Error',  error.body.message, 'error');
      }
  };



 /* wiredJobTeamDataResult;
    @wire(getJobTeamList, {recordId: "$recordId"}) 
    jobTeam(result) {
        this.wiredJobTeamDataResult = result;
        this.jobTeamListt = '';
        if(result.data) {
            result.data.forEach((jobTeamRecords) => {
                console.log('>>>>>>>>>>>jobTeamRecords',JSON.stringify(jobTeamRecords));
                var staff = jobTeamRecords.JobSuite__Staff__c;
                var email = jobTeamRecords.JobSuite__Email__c;
                const userData = {
                    value: staff,
                    email: email
                };
                console.log('>>>>>>>>>>>userData',JSON.stringify(userData));
                this.jobTeamListt = [ ...this.jobTeamListt, userData ];
            });
            console.log('>>>>>>>>>>>this.jobTeamListt',JSON.stringify(this.jobTeamListt));
            
            this.error = undefined;
            //this.loadFinished = true;
        } else if (result.error) {
            console.error(result.error);
            this.error = result.error;
            this.userData = undefined;
          //  let def_message = 'We have encountered an error while loading up your document. '
            this.showNotification('Error',  error.body.message, 'error');
        }
    };*/

  source = 'My file';
  fullAPI = true;
  enableRedaction = true;
  enableFilePicker = true;
  uiInitialized=false;
  @api recordId;

  @wire(CurrentPageReference)
  pageRef;
  count=0;
  
  connectedCallback() {
    //console.log('>>>>>>>connectedCallback>>>>>>>>');
    //console.log('>>>>>>>connectedCallback User Name>>>>>>>>',this.userName);

    this._listenForMessage = this.handleReceiveMessage.bind(this);
    const currentpageUrl = location.href;
    //console.log('>>>>>>>currentpageUrl>>>>>>>>',currentpageUrl);
    window.addEventListener("click", event => {
    //  console.log('>>>>>>>Location change>>>>>>>>',location.href);
      if(currentpageUrl!= location.href)
      {
        window.removeEventListener('message', this._listenForMessage);
      }
    });
   
    /*window.addEventListener('beforeunload', (event) => {
      console.log('>>>>>>beforeunload Add Event Listner>>>>>>>>>>',this.isSaved);
      if(this.isSaved){
         // mouseinClearSetTimeFunction();
          event.preventDefault();
          event.returnValue = 'Please save the File';
          return 'please save fileeeee';
      }
    });*/
    
   // registerListener('onchangesavealt', this.handlesavechanges,this);
   // registerListener('onrefreshbutton', this.renderedCallback,this);
   
    registerListener('blobSelected', this.handleBlobSelected, this);
    window.addEventListener('message', this._listenForMessage);
   
     setTimeout(() => {
        console.log('>>>>>>>>>>>connectedCallback this.UsersListt',JSON.stringify(this.UsersListt));
        const userslist=this.UsersListt;
        this.iframeWindow.postMessage({type: 'UserListNames', userslist} , '*');
      }, 10000);

  }


  showNotification(title, message, variant) {
      const evt = new ShowToastEvent({
          title: title,
          message: message,
          variant: variant,
      });
      this.dispatchEvent(evt);
  }

  disconnectedCallback() {
    //console.log('>>>>>>>disconnectedCallback>>>>>>>>');
    //console.log('>>>>>>>disconnectedCallback User Name>>>>>>>>',this.userName);
    unregisterAllListeners(this);
    //window.removeEventListener('message', this.handleReceiveMessage.bind(this), true);
    window.removeEventListener('message', this._listenForMessage);
  }
  
  mouseOut(evt) {
    //console.log('mouse out event fire',this.isSaved);
    if(this.isSaved){
      //mouseOutSetTimeFunction();
      const evte = new ShowToastEvent({
        title: 'Warning',
        message: 'Annotations: Your changes have not been saved. Please click the save button.',
        variant: 'Warning',
        mode: 'dismissable'
      });
      this.dispatchEvent(evte);
    }
  }

  handleBlobSelected(record) {

      this.isSaved=false;
      this.dataloadFinished = true;
      record = JSON.parse(record);

      var blobby = new Blob([_base64ToArrayBuffer(record.body)], {
        type: mimeTypes[record.FileExtension]
      });

      const payload = {
        blob: blobby,
        extension: record.cv.FileExtension,
        filename: record.cv.Title + "." + record.cv.FileExtension,
        documentId: record.cv.Id,
        docId:record.cv.ContentDocumentId
      };
      //console.log('>>>>>>documentId>>>>>>>>',record.cv.ContentDocumentId);
      this.iframeWindow.postMessage({type: 'OPEN_DOCUMENT_BLOB', payload} , '*');

     
  }
  
  renderedCallback() {
   // console.log('>>>>>>>renderedCallback');
    var self = this;
    if (this.uiInitialized) {
        return;
    }
    this.uiInitialized = true;
    setTimeout(() => {
      Promise.all([
          loadScript(self, libUrl + '/webviewer.min.js')
      ])
      .then(() => this.initUI())
      .catch(console.error); 
    }, 2500);
  }

  initUI() {
    //console.log('>>>>>>>>>initUI>>>>>>>>>>>>>>>>>>>',this.userName);
    var myObj = {
      libUrl: libUrl,
      fullAPI: this.fullAPI || false,
      namespacePrefix: '',
    };
    var url = myfilesUrl + '/webviewer-demo-annotated.pdf';
    const viewerElement = this.template.querySelector('div')
    // eslint-disable-next-line no-unused-vars
    //const viewer = new PDFTron.WebViewer({
    const viewer = new PDFTron.WebViewer({
      path: libUrl, // path to the PDFTron 'lib' folder on your server
      custom: JSON.stringify(myObj),
      backendType: 'ems',
      config: myfilesUrl + '/config_apex.js',
      fullAPI: this.fullAPI,
      annotationUser : this.userName,
      enableFilePicker: this.enableFilePicker,
      enableRedaction: this.enableRedaction,
      enableMeasurement: this.enableMeasurement,
      loadAsPDF : true,
      //selectAnnotationOnCreation : true,
      disabledElements: ['fileAttachmentToolGroupButton','stampToolGroupButton','signaturePanelButton'],
      l: this.licenseKey,
      
    }, viewerElement);
   
    viewerElement.addEventListener('ready', () => {
      this.iframeWindow = viewerElement.querySelector('iframe').contentWindow;
     // console.log('>>>>>>>>>>>InItUI this.jobTeamListt',JSON.stringify(this.jobTeamListt));
    });
 
  }

  handleReceiveMessage(event) {
    const me = this;
    this.loadSaveFinished = false;
    //console.log('>>>>>>>>>>>>>handleReceiveMessage Job>>>>>>>>>>>>>>');
    if (event.isTrusted && typeof event.data === 'object') {
     // console.log('>>>>>>>>>>>>>event.data.type>>>>>>>>>>>>>>',event.data.type);
      switch (event.data.type) {
        
        case 'SAVE_DOCUMENT':
              this.isSaved=false;
              let data =  JSON.stringify(JSON.parse(JSON.stringify(event.data.payload)));
             // this.loadSaveFinished = true;
              //console.log('>>>>>>>>>>save data Job>>>>>>>>>>>>>>');
              saveDocument({ json:data, recordId: this.recordId }).then(setTimeout((response) => {
                me.iframeWindow.postMessage({ type: 'DOCUMENT_SAVED', response }, '*');
                fireEvent(this.pageRef, 'fileNameRefresh', '');
               /*this.loadSaveFinished = false;
               console.log('success!!!!!!!!', response);
               const evt = new ShowToastEvent({
                  title: 'Success',
                  message: 'Document Saved',
                  variant: 'success',
                  mode: 'dismissable'
               });
               this.dispatchEvent(evt);*/
              },3000)).catch(error => {
                console.log('>>>>>>>saveDocument error>>>>>'+JSON.stringify(error));
                this.loadSaveFinished = false;
                console.error(JSON.stringify(error));
                  const evt = new ShowToastEvent({
                    title: 'Application Warning',
                    message: JSON.stringify(error.body.message),
                    variant: 'error',
                    mode: 'dismissable'
                  });
                  this.dispatchEvent(evt);
              });
          break;
          case 'saveOnMouseOut':
           // console.log('>>>>>saveOnMouseOut >>>>>>>>',event.data.isSaved);
            if(event.data.isSaved===true)
            {
              this.isSaved=event.data.isSaved;
             // console.log('>>>>>saveOnMouseOut if>>>>>>>>',this.isSaved);
            }
          break; 
          case 'webViewerComment':
           /* console.log('>>>>>webViewerComment JS File>>>>>>>>',event.data.Content);
            console.log('>>>>>webViewerComment mentAdd>>>>>>>>',event.data.mentAdd);
            console.log('>>>>>webViewerComment mentMod>>>>>>>>',event.data.mentMod);
            console.log('>>>>>webViewerComment annonDel >>>>>>>>',event.data.annonDel);*/
            console.log('>>>>>webViewerComment annonDel >>>>>>>>',event.data.stepdet);
            if(event.data.Content===undefined || event.data.Content===' ' || event.data.Content===null)
            {
             // console.log('>>>>>webViewerComment if enter>>>>>>>>',event.data.Content);
            }else{
               // console.log('>>>>>webViewerComment else enter>>>>>>>>',event.data.Content);
                postAComment({ ChatterContent:event.data.Content, ContThread:event.data.ContentThread, recordId: this.recordId, Author:event.data.Author, fileName:event.data.FileName, AddMent:event.data.mentAdd, ModMent:event.data.mentMod, DelAnn:event.data.annonDel, stedetail:event.data.stepdet});
               //postAComment({ ChatterContent:event.data.Content, recordId: this.recordId, Author:event.data.Author, fileName:event.data.FileName, AddMent:event.data.mentAdd, ModMent:event.data.mentMod, DelMen:event.data.mentDel});
            }
          break; 
        default:
          break;
      }
    }
  }
	
	handleCallout(endpoint, token){
		fetch(endpoint,
		{
			method : "GET",
			headers : {
				"Content-Type": "application/pdf",
				"Authorization": token
			}
		}).then(function(response) {
			return response.json();
		})
		.then((myJson) =>{
			// console.log('%%%%'+JSON.stringify(myJson));
			let doc_list = [];
			for(let v of Object.values(myJson.results)){
				console.log('%%%%'+JSON.stringify(v));
				// console.log('$$$$'+v.title);
				doc_list.push();
			}
			
			this.documents = doc_list;
			
		})
		.catch(e=>console.log(e));
	}

  @api
  openDocument() {
  }

  @api
  closeDocument() {
    this.iframeWindow.postMessage({type: 'CLOSE_DOCUMENT' }, '*')
  }
}