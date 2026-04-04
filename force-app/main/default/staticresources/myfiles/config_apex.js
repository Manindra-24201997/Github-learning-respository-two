var resourceURL = '/resource/'
window.CoreControls.forceBackendType('ems');

var urlSearch = new URLSearchParams(location.hash)
var custom = JSON.parse(urlSearch.get('custom'));
resourceURL = resourceURL + custom.namespacePrefix;
console.log('>>>>>>resourceURL>>>>>>>',resourceURL);

let fileDocId; 
let isTaskFile=false;
/**
 * The following `window.CoreControls.set*` functions point WebViewer to the
 * optimized source code specific for the Salesforce platform, to ensure the
 * uploaded files stay under the 5mb limit
 */
// office workers

window.CoreControls.setOfficeWorkerPath(resourceURL + 'JobSuite__office')
window.CoreControls.setOfficeAsmPath(resourceURL + 'JobSuite__office_asm');
window.CoreControls.setOfficeResourcePath(resourceURL + 'JobSuite__office_resource');

// pdf workers
window.CoreControls.setPDFResourcePath(resourceURL + 'JobSuite__resource')
if (custom.fullAPI) {
  window.CoreControls.setPDFWorkerPath(resourceURL + 'JobSuite__pdf_full')
  window.CoreControls.setPDFAsmPath(resourceURL + 'JobSuite__asm_full');
} else {
  window.CoreControls.setPDFWorkerPath(resourceURL + 'JobSuite__pdf_lean')
  window.CoreControls.setPDFAsmPath(resourceURL + 'JobSuite__asm_lean');
}

// external 3rd party libraries
window.CoreControls.setExternalPath(resourceURL + 'JobSuite__external')
window.CoreControls.setCustomFontURL('https://pdftron.s3.amazonaws.com/custom/ID-zJWLuhTffd3c/vlocity/webfontsv20/');

async function saveDocument() {
  console.log('>>>>>>saveDocument>>>>>>>>>');
  const doc = docViewer.getDocument();
  
  if (!doc) {
    return;
  }
  readerControl.openElement('loadingModal');
  const fileType = doc.getType();
  const filenameExt = doc.getFilename();
  const filenamm = filenameExt.split('.').slice(0, -1).join('.');
  const filename = filenamm+'.pdf';
  const xfdfString = await docViewer.getAnnotationManager().exportAnnotations();
  const data = await doc.getFileData({
    // Saves the document with annotations in it
    xfdfString
  });

  let binary = '';
  const bytes = new Uint8Array(data);
  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  const base64Data = window.btoa(binary);

  const payload = {
    title: filename.replace(/\.[^/.]+$/, ""),
    filename,
    base64Data,
    contentDocumentId: fileDocId
  }
 
    if(isTaskFile){
      parent.postMessage({ type: 'SAVE_DOCUMENTTask', payload }, '*');
    }
    else{
      parent.postMessage({ type: 'SAVE_DOCUMENT', payload }, '*');
    }
    
   
}

window.addEventListener('documentLoaded', () => {

  const doc1 = docViewer.getDocument();
  const filenameExt1 = doc1.getFilename();
  const filenamm1 = filenameExt1.split('.').slice(0, -1).join('.');
  const filename1 = filenamm1+'.pdf';

  let mentionsAdded=false;
  let mentionsModify=false;
  let mentionsDelete=false;
  let annonAdded=false;
  let annonModify=false;
  let annonDelete=false;
  let stepDetail=false;
  let newReplies = [];
  let counter = 0;


  readerControl.mentions.on('mentionChanged', (mentions, Maction) => {
      if (Maction === 'add') {
        console.log('>>>>>mentions Add>>>>>>>');
        mentionsAdded=true;
      }

      if (Maction === 'modify') {
        console.log('>>>>>mentions Modified>>>>>>>');
        mentionsModify=true;
      }

      if (Maction === 'delete') {
        console.log('>>>>>mentions Delete>>>>>>>');
        mentionsDelete=true;
      }
  })


  const annotManager = docViewer.getAnnotationManager();
  annotManager.on('annotationChanged', (annotations, action, { imported }) => {
    if (imported) {
      return;
    }
    if(action === 'add'){
      console.log('>>>>>annon Added>>>>>>>');
      annonAdded=true;
    }
    if(action === 'modify'){
      console.log('>>>>>annon Modify>>>>>>>');
      annonModify=true;
    }
    if(action === 'delete'){
      console.log('>>>>>annon Delete>>>>>>>');
      annonDelete=true;
    }

    let email_content = ""; //string to hold root comment + all replies
    if (!imported && (action === 'add' || action === 'modify' || action === 'delete')) { //only newly added annotations
      newReplies = annotations.filter(annotation => annotation.isReply()); //filter new annotations for replies only

      newReplies.forEach((reply) => {
        let rootAnnot = annotManager.getRootAnnotation(reply); //get the root comment of the new reply
        console.log('>>>>>rootAnnot>>>>>>>',rootAnnot);
        if(!rootAnnot) return; //skip if no root found
        
         /* if(rootAnnot.Wf["trn-mention"].contents == undefined){
          }
          else{*/
            //get the content of the root comment
            let comment = 'Original Post: \n\n  '+ filename1 +' -- '+ rootAnnot.AJ +' \n  '+ rootAnnot.MJ +'\n\n '+rootAnnot.Wf["trn-mention"].contents;
            email_content = comment; //build thread by adding comment

            let thread = rootAnnot.getReplies(); //array of all comment replies

            thread.forEach(reply => {
              console.log('>>>>>>>>>>>>>>Before',counter);
              counter = counter + 1;
              console.log('>>>>>>>>>>>>>>After',counter);
              console.log('>>>>>rootAnnot forEachhh>>>>>>>',reply);
              comment = reply.AJ +' \n    '+ reply.MJ +'\n \n   '+reply.Wf["trn-mention"].contents;//get first comment content of all replies

              email_content += '\n\n --------------- Reply '+counter+ ' ---------------- \n\n   '; //formatting for string
              email_content += comment; //append comment to string
              
            })
            counter = 0;
        //  }
      })
      parent.postMessage({ type: 'saveOnMouseOut', isSaved:true}, '*');
      
      console.log("" + email_content); //final comment thread string
    } 

    annotations.forEach((annot) => {//annot.getContents()

      if(isTaskFile){
        stepDetail=true;
        parent.postMessage({ type: 'webViewerCommentTask', ContentThread:email_content, Content:annot.getContents(), Author:annot.Author, FileName:filename1, mentAdd:mentionsAdded, mentMod:mentionsModify, annonDel:annonDelete, stepdet:stepDetail}, '*');
      }
      else{
        parent.postMessage({ type: 'webViewerComment', ContentThread:email_content, Content:annot.getContents(), Author:annot.Author, FileName:filename1, mentAdd:mentionsAdded, mentMod:mentionsModify, annonDel:annonDelete, stepdet:stepDetail }, '*');
      }
     // parent.postMessage({ type: 'webViewerComment', ContentThread:email_content, Content:annot.getContents(), Author:annot.Author, FileName:filename1, mentAdd:mentionsAdded, mentMod:mentionsModify, annonDel:annonDelete }, '*');
    });

  })

});


window.addEventListener('viewerLoaded', async function() {
  /**
   * On keydown of either the button combination Ctrl+S or Cmd+S, invoke the
   * saveDocument function
   */

    readerControl.hotkeys.on('ctrl+s, command+s', e => {
    e.preventDefault();
    saveDocument();
  });

  // Create a button, with a disk icon, to invoke the saveDocument function
  readerControl.setHeaderItems(function(header) {
   var count=0;
   //var executed = false;
    var myCustomButton = {
      type: 'actionButton',
      dataElement: 'saveDocumentButton',
      title: 'SaveDocument',
      img: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>',
      onClick: function() {  
        console.log('>>>>>>onClick>>>>>>>>>');
        saveDocument();
      }
    }
    header.get('viewControlsButton').insertBefore(myCustomButton);
  });
});

window.addEventListener("message", receiveMessage, false);

function receiveMessage(event) {
  if (event.isTrusted && typeof event.data === 'object') {
    console.log('>>>>>>>receiveMessage config>>>>>>>',event.data.type);
    switch (event.data.type) {
      
      case 'OPEN_DOCUMENT':
        event.target.readerControl.loadDocument(event.data.file)
        break;
      case 'OPEN_DOCUMENT_BLOB':
        const { blob, extension, filename, documentId,docId,taskFile } = event.data.payload;
        console.log('>>>>>>>OPEN_DOCUMENT_BLOB docId>>>>>>>',docId);
        fileDocId = docId;
        isTaskFile = taskFile;
        event.target.readerControl.loadDocument(blob, { extension, filename, documentId })
        break;
      case 'DOCUMENT_SAVED':
        readerControl.showErrorMessage('Document saved!')
        setTimeout(() => {
          readerControl.closeElements(['errorModal', 'loadingModal'])
        }, 2000)
        break;
      case 'CLOSE_DOCUMENT':
        event.target.readerControl.closeDocument()
        break;
      case 'UserListNames':
        readerControl.mentions.setUserData(event.data.userslist);
        break;
      default:
        break;
    }
  }
}