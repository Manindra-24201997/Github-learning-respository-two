({
    FetchRequestTypes : function(component, event, helper) {
        
        var StoreRequestType = component.get("c.ShowStoreOrderRequestTypes");
        StoreRequestType.setCallback( helper, function( response ) {
            var Req=response.getReturnValue();
            console.log('>>>>>> Result of Store Request Type Value1111 >>>>>>>>>>'+ JSON.stringify(Req));
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Request Type SUCCESS >>>>>>>>>>');
                component.set('v.ShowStoreOrderValues',Req);
                console.log('>>>>>> Result of Store Request Type Value >>>>>>>>>>'+ JSON.stringify(Req));
            }
        });
        $A.enqueueAction(StoreRequestType);
        
        var ShowDistRequestType = component.get("c.ShowDistRequestTypeValue");
        ShowDistRequestType.setCallback( helper, function(response) {
            var DisReq=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Request Type SUCCESS >>>>>>>>>>');
                component.set('v.ShowDistrequestTypeValues',DisReq);
                console.log('>>>>>> Result of Show/Hide Dist/Div Request Type Value >>>>>>>>>>'+ JSON.stringify(DisReq));
            }
        });
        $A.enqueueAction(ShowDistRequestType); 
        
        var ShowCopRequestType = component.get("c.ShowCooperateRequestTypes");
        ShowCopRequestType.setCallback( helper, function(response) {
            var ShowCopReq=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Request Type SUCCESS >>>>>>>>>>');
                component.set('v.ShowCooperaterequestTypeValues',ShowCopReq);
                console.log('>>>>>> Result of Show/Hide Cooperate Request Type Value >>>>>>>>>>'+ JSON.stringify(ShowCopReq));
            }
        });
        $A.enqueueAction(ShowCopRequestType); 
        
        
        var CopRequestType = component.get("c.getCorpRequestTypes");
        CopRequestType.setCallback( helper, function(response) {
            var CopReq=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Request Type SUCCESS >>>>>>>>>>');
                component.set('v.CoprequestTypeValues',CopReq);
                console.log('>>>>>> Result of Show/Hide Cooperate Request Type Value >>>>>>>>>>'+ JSON.stringify(CopReq));
            }
        });
        $A.enqueueAction(CopRequestType); 
        
    },
    
    
   /* FetchBBList : function(component, event, helper) {
        var BBList = component.get( "c.getBillboardList" );
        BBList.setCallback( helper, function( response ) {
            var Req=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>> SUCCESS BBLIST>>>>>>>>>>');
                component.set('v.BBList',Req);
                console.log('>>>>>> Result of BBLIST >>>>>>>>>>'+ JSON.stringify(Req));
            }
        });
        $A.enqueueAction(BBList);  
    },
    
    FetchBBLOC : function(component, event, helper) {
        console.log('>>>>>> Enter BBLOC>>>>>>>>>>');
        var BBLoc = component.get("c.getBBLocation");
        BBLoc.setCallback( helper, function( response ) {
            var Req=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>> SUCCESS BBLOC>>>>>>>>>>');
                component.set('v.BBLocation',Req);
                console.log('>>>>>> Result of BBLOC >>>>>>>>>>'+ JSON.stringify(Req));
            }
        });
        $A.enqueueAction(BBLoc);  
    },*/
    
  /*  
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList) {
        // get the selected files using aura:id [return array of files]
        if(requestValue=='Billboard Repairs'){
            var fileInput = component.find("BBRFileupload").get("v.files");
        }
        if(requestValue=='Custom Order'){
            var fileInput = component.find("CustomOrderFileupload").get("v.files");
        }
        console.log('==fileInput==='+fileInput);
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        console.log('==uploadProcess===');
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '',requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList);
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList) {
        // call the apex method 'SaveFile'
        
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.SaveRequestForm");
        if(requestValue=='Billboard Repairs'){
            action.setParams({
                requestType:'Billboard Repairs',
                Formvalues:BillboardRepairValues,
                ListBBSignType:BBSignTypeList,
                ListBBRServiceIssue:BBRServiceIssueList,
                ListBBLight:BBLightList,
                fileName: file.name,
                base64Data: encodeURIComponent(getchunk),
                contentType: file.type,
                fileId: attachId
            });
        }
        if(requestValue=='Custom Order'){
            action.setParams({
                requestType:'Custom Order',
                Formvalues:CustomOrderValues,
                ListCOItemsNeeded:COItemsNeededList,
                fileName: file.name,
                base64Data: encodeURIComponent(getchunk),
                contentType: file.type,
                fileId: attachId
            });
        }
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            console.log('>>>>>>> Upload file attachId',attachId);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('>>>>>>>SUCCESS');
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList);
                } else {
                    //alert('File has been uploaded successfully');
                    // RequestType.setCallback( helper, function(response) {
                    // console.log("=====Response====", JSON.stringify(response.getReturnValue()));
                    var Storefrontresult = response.getReturnValue();
                    if (response.getState() === "SUCCESS") {
                        if(Storefrontresult=="true"){
                            var ToastMsg = $A.get("e.force:showToast");
                            ToastMsg.setParams({
                                "title": "Success!!",
                                "type": "Success",
                                "duration":'3000',
                                "message":"Your Order has successfully placed."
                            });
                            ToastMsg.fire();
                            window.setTimeout(
                                $A.getCallback(function() {
                                    var navigateEvent = $A.get("e.force:navigateToComponent");
                                    navigateEvent.setParams({
                                        componentDef: "c:JobsForClientContactLtCmp"
                                    });
                                    navigateEvent.fire();
                                }), 4000
                            );
                        }
                        else{
                            var ToastMsg = $A.get("e.force:showToast");
                            ToastMsg.setParams({
                                "title": "Error!!",
                                "type": "error",
                                "duration":'4000',
                                "message":Storefrontresult
                            });
                            ToastMsg.fire();
                        }
                    }
                }
            
            // handel the response errors        
        } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }*/
    
})