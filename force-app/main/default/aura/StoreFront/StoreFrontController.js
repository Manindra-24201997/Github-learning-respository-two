({
    doInit : function(component, event, helper) {
        helper.FetchRequestTypes(component,event,helper);
    },
    
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    /*********************************************** Request Type Form value onchange *****************************************/
    RequestTypeChange: function(component, event, helper) {
        console.log('>>>>> OnChange >>>>>');
        var requestValue=component.find("ReqType").get("v.value");
        console.log('>>>>> ReqValue>>>>>'+requestValue);
        component.set('v.SelectedrequestTypeValue',requestValue);
        console.log('>>>>> SelectedrequestTypeValue>>>>>'+component.get("v.SelectedrequestTypeValue"));
        if(requestValue=='Store Business Cards')
        {
            console.log('>>>>> Store Business >>>>>');
            component.set('v.isStoreBusinessCard',true);
            component.set('v.isFormOpen',false);
        }
        if(requestValue=='Store Name Tag')
        {
            console.log('>>>>> Store Name Tag >>>>>');
            component.set('v.isStoreNameTag',true);
            component.set('v.isFormOpen',false);
        }
        if(requestValue=='Billboard Repairs')
        {
            console.log('>>>>> BillBoard Repairs >>>>>');
            window.open('/one/one.app#/alohaRedirect/apex/BillboardRepairForm','_self'); 
           /* component.set('v.isBBRepair',true);
            component.set('v.isFormOpen',false);
            helper.FetchBBList(component,event,helper);
            helper.FetchBBLOC(component,event,helper);*/
        }
        if(requestValue=='Store Supplies')
        {
            console.log('>>>>> Store Supplies >>>>>');
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:StoreSuplliesRequestFormCmp"
            });
            navigateEvent.fire();
            component.set('v.isFormOpen',false);
        }
        if(requestValue=='Custom Order')
        {
            console.log('>>>>> Custom Order >>>>>');
            window.open('/one/one.app#/alohaRedirect/apex/CustomOrderRequestForm','_self'); 
            
           // component.set('v.isCustomOrder',true);
           // component.set('v.isFormOpen',false);
        }
        if(requestValue=='Made To Order')
        {
            console.log('>>>>> Custom Order >>>>>');
            component.set('v.isMadetoOrder',true);
            component.set('v.isFormOpen',false);
        }
        if(requestValue=='CMN')
        {
            console.log('>>>>> CMN Order >>>>>');
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:CMNFormComponent"
            });
            navigateEvent.fire();
            component.set('v.isFormOpen',false);
        }
        
    },
    
    DistDivTypeChange: function(component, event, helper) {
        console.log('>>>>> OnChange >>>>>');
        var DistDivrequestValue=component.find("DDorderType").get("v.value");
        console.log('>>>>> DistDivrequestValue >>>>>'+DistDivrequestValue);
        // component.set('v.SelectedDistrequestTypeValue',DistDivrequestValue);
        // console.log('>>>>> SelectedDistrequestTypeValue>>>>>'+component.get("v.SelectedDistrequestTypeValue"));
        if(DistDivrequestValue=='Division/District Order Form')
        {
            console.log('>>>>> Division/District Order Form >>>>>');
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:MultiStoreOrderLigtningCmp"
            });
            navigateEvent.fire();
            component.set('v.isFormOpen',false);
        }
    },
    
    /*********************************************** Cooperate Request Type Form value onchange *****************************************/
    
    CopRequestTypeChange: function(component, event, helper) {
        console.log('>>>>>Cooperate Order Type OnChange >>>>>');
        console.log('>>>>> Selected option'+event.getSource().get("v.value"));
        var CoprequestValue=event.getSource().get("v.value");
        console.log('>>>>>Cooperate ReqValue>>>>>'+CoprequestValue);
        component.set('v.SelectedCoprequestTypeValue',CoprequestValue);
        console.log('>>>>> SelectedrequestTypeValue >>>>>'+component.get("v.SelectedrequestTypeValue"));
        if(CoprequestValue=='Corporate Business Cards')
        {
            console.log('>>>>> Corporate Business Cards >>>>>');
            component.set('v.isCopBusinessCard',true);
            component.set('v.isFormOpen',false);
        }
        if(CoprequestValue=='Corporate Name Tag')
        {
            console.log('>>>>> Corporate Name Tag >>>>>');
            component.set('v.isCopNameTag',true);
            component.set('v.isFormOpen',false);
        }
        if(CoprequestValue=='Corporate Office Nameplate')
        {
            console.log('>>>>> Corporate Office Nameplate >>>>>');
            component.set('v.isCopOfficeName',true);
            component.set('v.isFormOpen',false);
        }
        if(CoprequestValue=='Sales/Marketing Order')
        {
            console.log('>>>>> Sales/Marketing Order >>>>>');
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:FleetSalesOrderLightningCmp"
            });
            navigateEvent.fire();
            component.set('v.isFormOpen',false);
        }
        if(CoprequestValue=='Trillium Energy')
        { 
            console.log('>>>>> Trillium Energy >>>>>'); 
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
                componentDef: "c:TrilliumJobRequestFormLtCmp"
            });
            navigateEvent.fire();
            component.set('v.isFormOpen',false);
        }
        
        
    },
    
    BackForm: function(component, event, helper) {
        component.set('v.isStoreBusinessCard',false);
        component.set('v.isStoreNameTag',false);
        component.set('v.isBBRepair',false);
        component.set('v.isCustomOrder',false);
        component.set('v.isMadetoOrder',false);
        component.set('v.isCopNameTag',false);
        component.set('v.isCopOfficeName',false);
        component.set('v.isCopBusinessCard',false);
        component.set('v.isFormOpen',true);
    },
    
    /***************************************** Made To Order form Selected Items Values *****************************************/
    
    MtoItemsNeeded: function(component, event, helper) {
        var ItemsNeed=document.getElementById("MtoItemsNeeded").value;
        console.log('>>>>> Made to Order Items Needed Onchange >>>>>'+ItemsNeed);
        var MtoItems = component.get("c.ItemsInd");
        MtoItems.setParams({
            MadeItemsCategory:ItemsNeed,
        })
        MtoItems.setCallback( helper, function( response ) {
            var Req=response.getReturnValue();
            var ItemNeededList=[];
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Made to Order Items >>>>>>>>>>'+Req);
                for(var key in Req){
                    ItemNeededList.push({
                        key: key,
                        value: Req[key]
                    });
                }  
                component.set("v.MtoItemsNeeded",ItemNeededList);
            }
        });
        $A.enqueueAction(MtoItems);  
    },
    
    /****************************************** Made To Order form Items preview **********************************************/
    
    DispalyItemPic: function(component, event, helper) {
        var SelectedItemsNeed=document.getElementById("SelectedItems").value;
        console.log('>>>>> Made to Order Item needed Onchange >>>>>'+SelectedItemsNeed);
        var MtoItemspic = component.get("c.ItemsPic");
        MtoItemspic.setParams({
            MadeIndividualItemsNeeded:SelectedItemsNeed
        })
        MtoItemspic.setCallback( helper, function(response) {
            var Req=response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                console.log('>>>>>>Made to Order Items Display pic>>>>>>>>>>'+JSON.stringify(Req));
                component.set("v.MtoItemsNeededpic",Req);
            }
        });
        $A.enqueueAction(MtoItemspic);  
    },
    
    /********************* Checked the Qty value in Made to Order form *****************************************/
    
    checkQty: function(component, event, helper) {
        var QtyonHand=component.get("v.MtoItemsNeededpic[1]");
        var EnterQty=component.find("MtoQty").get("v.value");
        // var EnterQty=document.getElementById("MtoQty").value;
        console.log('>>>>> QtyonHand >>>>>'+QtyonHand);
        console.log('>>>>> EnterQty >>>>>'+EnterQty);
        
        if(QtyonHand<EnterQty)
        {
            console.log('>>>>> QtyonHand >>>>>'+QtyonHand);
            console.log('>>>>> EnterQty >>>>>'+EnterQty);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Qty',
                message:'The Quantity must be less than Max Quantity of Material Item',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            event.preventDefault(); 
        }
    },
    
    NumberFormat: function(component, event, helper) {
        console.log('>>>>> NumberFormat Enter >>>>>');
        var BCPhone=component.find("CopBCPhone").get("v.value");
        console.log('>>>>> BCPhone >>>>>',BCPhone.length);
        if(BCPhone!=null && BCPhone.length==10)
        {
            var CorporatePhone = "(" + BCPhone.substring(0, 3) + ")" + BCPhone.substring(3, 6) + "-" + BCPhone.substring(6);
            console.log('>>>>> CorporatePhone >>>>>',CorporatePhone);
            component.find("CopBCPhone").set("v.value",CorporatePhone);
        }
        
    },
    
    saveForm: function(component, event, helper) {
        console.log('>>>>> Save >>>>>');
        component.set("v.isSpinner", true);
        var requestValue=component.get("v.SelectedrequestTypeValue");
        var CoprequestValue=component.get("v.SelectedCoprequestTypeValue");
        console.log('>>>>> Save requestValue >>>>>'+requestValue);
        console.log('>>>>> Save CoprequestValue >>>>>'+CoprequestValue);
        
        var RequestType = component.get("c.SaveRequestForm");
        
        /**************************************** Store Business Card Values *****************************************************/   
        if(requestValue=='Store Business Cards'){
            var BusinessCard=component.find("BN").get("v.value");
            var BusinessTitle=component.find("BusinessTitle").get("v.value");
            var BusinessLogo=component.find("BusinessLogo").get("v.value");
            console.log('>>>>> BusinessName >>>>>'+BusinessCard);
            console.log('>>>>> BusinessTitle >>>>>'+BusinessTitle);
            console.log('>>>>> BusinessLogo >>>>>'+BusinessLogo);
            
            var StoreBusinessCardValues=[];
            StoreBusinessCardValues.push(BusinessCard);
            StoreBusinessCardValues.push(BusinessTitle);
            StoreBusinessCardValues.push(BusinessLogo);
            console.log('>>>>> Business Card Params >>>>>'+StoreBusinessCardValues);
            
            if(BusinessCard==null || BusinessCard==undefined || BusinessCard=='')
            {
                console.log('>>>>> BusinessName if enter >>>>>'+BusinessCard);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Name',
                    message:'Please Enter the Name',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
                console.log('>>>>> BusinessName After if enter >>>>>'+BusinessCard);
                event.preventDefault(); 
            }
            else
            {
                console.log('>>>>> Enter the else Statement >>>>>'+StoreBusinessCardValues);
                RequestType.setParams({
                    requestType:'Store Business Cards',
                    Formvalues:StoreBusinessCardValues,
                })
                
                RequestType.setCallback( helper, function(response) {
                    console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
                });
                
            }
        }
        
        /**************************************** Store Name Tag Values *****************************************************/   
        if(requestValue=='Store Name Tag'){
            
            var StoreNameTagLogoList=[];
            var StoreNameTagTitle=component.find("StoreNameTagTitle").get("v.value");
            var StoreNameTagFN=component.find("StoreNameTagFN").get("v.value");
            var StoreNameTagLN=component.find("StoreNameTagLN").get("v.value");
            var StoreNameTagYOH=component.find("StoreNameTagYOH").get("v.value");
            var StoreNameTagLogo=document.getElementById("StoreNameTagLogo");
            console.log('>>>>> StoreNameTag Logo ele>>>>>'+StoreNameTagLogo.options.Length);
            
            for (var i = 0; i < StoreNameTagLogo.options.length; i++) {
                if(StoreNameTagLogo.options[i].selected ==true){
                    StoreNameTagLogoList.push(StoreNameTagLogo.options[i].value);
                }
            }
            
            console.log('>>>>> StoreNameTag Title >>>>>'+StoreNameTagTitle);
            console.log('>>>>> StoreNameTag First Name >>>>>'+StoreNameTagFN);
            console.log('>>>>> StoreNameTag Last Name >>>>>'+StoreNameTagLN);
            console.log('>>>>> StoreNameTag Year of Hire >>>>>'+StoreNameTagYOH);
            console.log('>>>>> StoreNameTag List of Logo >>>>>'+StoreNameTagLogoList);
            
            var StoreNameTagValues=[];
            StoreNameTagValues.push(StoreNameTagTitle);
            StoreNameTagValues.push(StoreNameTagFN);
            StoreNameTagValues.push(StoreNameTagLN);
            StoreNameTagValues.push(StoreNameTagYOH);
            console.log('>>>>> Store Name Tag Params >>>>>'+StoreNameTagValues);
            
            if((StoreNameTagLN==null || StoreNameTagLN==undefined || StoreNameTagLN=='') && (StoreNameTagTitle != 'Team Member'))
            {
                console.log('>>>>> Store Name Tag Last Name If condition enter >>>>>'+StoreNameTagLN);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Last Name',
                    message:'Please Enter the Last Name',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
                event.preventDefault(); 
            }
            
            else if(StoreNameTagYOH==null || StoreNameTagYOH==undefined || StoreNameTagYOH=='')
            {
                console.log('>>>>> Store Name Tag Last Year of Hire if condition enter >>>>>'+StoreNameTagYOH);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Year of Hire',
                    message:'Please Enter the Year of Hire',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
                event.preventDefault(); 
            }
            
                else if(StoreNameTagLogoList.Length=0 || StoreNameTagLogoList=='')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Logos',
                        message:'Please Select the Logo',
                        duration:' 5000',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                    event.preventDefault(); 
                }
                    else
                    {
                        RequestType.setParams({
                            requestType:'Store Name Tag',
                            Formvalues:StoreNameTagValues,
                            ListStoreNameTagLogo:StoreNameTagLogoList
                        })   
                        RequestType.setCallback( helper, function(response) {
                            console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
                        });
                    }
            
        }
        
        /******************************** Billboard/Dot Service Request Form Values ***********************************/
      /*  if(requestValue=='Billboard Repairs'){
            var BBSignTypeList=[];
            var BBRServiceIssueList=[];
            var BBLightList=[];
            
            var BBRLocation=component.find("BBRLocation").get("v.value");
            var BBSignType=document.getElementById("BBSignType");
            var BBName=component.find("BBName").get("v.value");
            var BBRServiceIssue=document.getElementById("BBRServiceIssue");
            var BBCurReads=component.find("BBCurReads").get("v.value");
            var BBShRead=component.find("BBShRead").get("v.value");
            var BBLight=document.getElementById("BBLight");
            var BBtime=component.find("BBtime").get("v.value");
            var BBNotes=component.find("BBNotes").get("v.value");
            
            for (var i = 0; i < BBSignType.options.length; i++) {
                if(BBSignType.options[i].selected ==true){
                    BBSignTypeList.push(BBSignType.options[i].value);
                }
            }
            
            for (var i = 0; i < BBRServiceIssue.options.length; i++) {
                if(BBRServiceIssue.options[i].selected ==true){
                    BBRServiceIssueList.push(BBRServiceIssue.options[i].value);
                }
            }
            
            for (var i = 0; i < BBLight.options.length; i++) {
                if(BBLight.options[i].selected ==true){
                    BBLightList.push(BBLight.options[i].value);
                }
            }
            
            console.log('>>>>> BBRLocation >>>>>'+BBRLocation);
            console.log('>>>>> BBSignType >>>>>'+BBSignTypeList);
            console.log('>>>>> BBName >>>>>'+BBName);
            console.log('>>>>> BBRServiceIssue >>>>>'+BBRServiceIssueList);
            console.log('>>>>> BBCurReads >>>>>'+BBCurReads);
            console.log('>>>>> BBShRead >>>>>'+BBShRead);
            console.log('>>>>> BBLight >>>>>'+BBLightList);
            console.log('>>>>> BBtime >>>>>'+BBtime);
            console.log('>>>>> BBNotes >>>>>'+BBNotes);
            
            var BillboardRepairValues=[];
            BillboardRepairValues.push(BBRLocation);
            BillboardRepairValues.push(BBName);
            BillboardRepairValues.push(BBCurReads);
            BillboardRepairValues.push(BBShRead);
            BillboardRepairValues.push(BBtime);
            BillboardRepairValues.push(BBNotes);
            console.log('>>>>> Billboard Repair Values >>>>>'+BillboardRepairValues);
            
            console.log('==File Length===',component.find("BBRFileupload").get("v.files"));
            if(component.find("BBRFileupload").get("v.files")!=null){ 
                console.log('==File not null if enter===',component.find("BBRFileupload").get("v.files"));
                if (component.find("BBRFileupload").get("v.files").length > 0 ) {
                    console.log('==File Length greater than 0 if enter===',component.find("BBRFileupload").get("v.files"));
                    console.log('==requestValue==='+requestValue);
                    helper.uploadHelper(component,event,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList);
                } 
            }
            else
            {
                RequestType.setParams({
                    requestType:'Billboard Repairs',
                    Formvalues:BillboardRepairValues,
                    ListBBSignType:BBSignTypeList,
                    ListBBRServiceIssue:BBRServiceIssueList,
                    ListBBLight:BBLightList
                })
                RequestType.setCallback( helper, function(response) {
                    console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
                });
            }
        }*/
        
        /******************************** Custom Order Request Form Values ***********************************/
        
       /* if(requestValue=='Custom Order')
        {
            var COItemsNeededList=[];
            var COItemsNeeded=document.getElementById("COItemsNeeded");
            var COTurnTime=component.find("COTurnTime").get("v.value");
            var COQuantity=component.find("COQuantity").get("v.value");
            var COHeightWidth=component.find("COHeightWidth").get("v.value");
            var COExplainReq=component.find("COExplainReq").get("v.value");
            var COExplainMore=component.find("COExplainMore").get("v.value");
            var COExplainInstall=component.find("COExplainInstall").get("v.value");
            
            for (var i = 0; i < COItemsNeeded.options.length; i++) {
                if(COItemsNeeded.options[i].selected ==true){
                    COItemsNeededList.push(COItemsNeeded.options[i].value);
                }
            }
            
            console.log('>>>>> COItemsNeededList >>>>>'+COItemsNeededList);
            console.log('>>>>> COTurnTime >>>>>'+COTurnTime);
            console.log('>>>>> COQuantity >>>>>'+COQuantity);
            console.log('>>>>> COHeightWidth >>>>>'+COHeightWidth);
            console.log('>>>>> COExplainReq >>>>>'+COExplainReq);
            console.log('>>>>> COExplainMore >>>>>'+COExplainMore);
            console.log('>>>>> COExplainInstall >>>>>'+COExplainInstall);
            
            var CustomOrderValues=[];
            CustomOrderValues.push(COTurnTime);
            CustomOrderValues.push(COQuantity);
            CustomOrderValues.push(COHeightWidth);
            CustomOrderValues.push(COExplainReq);
            CustomOrderValues.push(COExplainMore);
            CustomOrderValues.push(COExplainInstall);
            console.log('>>>>> Custom Order Values >>>>>'+CustomOrderValues);
            
            var COFileUpload=component.find("CustomOrderFileupload").get("v.value");
            console.log('>>>>> Custom Order File Upload >>>>>'+COFileUpload);
            if(COFileUpload==null || COFileUpload==undefined || COFileUpload=='')
            {
                console.log('>>>>> BusinessName if enter >>>>>'+BusinessCard);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Upload photo of installation area',
                    message:'Please Choose file',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.isSpinner", false);
                console.log('>>>>> COFileUpload After if enter >>>>>'+COFileUpload);
                event.preventDefault(); 
            }
            else
            {
                console.log('==File Length===',component.find("CustomOrderFileupload").get("v.files"));
                if(component.find("CustomOrderFileupload").get("v.files")!=null){ 
                    console.log('==File Length1===',component.find("CustomOrderFileupload").get("v.files"));
                    if (component.find("CustomOrderFileupload").get("v.files").length > 0 ) {
                        console.log('==File Length2===',component.find("CustomOrderFileupload").get("v.files"));
                        console.log('==File===');
                        console.log('==requestValue==='+requestValue);
                        helper.uploadHelper(component,event,requestValue,BillboardRepairValues,BBSignTypeList,BBRServiceIssueList,BBLightList,CustomOrderValues,COItemsNeededList);
                    } 
                }
                else
                {
                    RequestType.setParams({
                        requestType:'Custom Order',
                        Formvalues:CustomOrderValues,
                        ListCOItemsNeeded:COItemsNeededList
                    })
                    RequestType.setCallback( helper, function(response) {
                        console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
                                        
                                    }), 3000
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
                    });
                }
            }
        }*/
        
        /******************************** Made To Order Request Form Values ***********************************/
        if(requestValue=='Made To Order'){
            
            var NameSelectedItem=document.getElementById("SelectedItems").options[document.getElementById("SelectedItems").selectedIndex].text;
            var MtoQty=component.find("MtoQty").get("v.value");
            var MtoSpecialDetails=component.find("MtoSpecialDetails").get("v.value");
            
            console.log('>>>>> NameSelectedItem >>>>>'+NameSelectedItem);
            console.log('>>>>> MtoQty >>>>>'+MtoQty);
            console.log('>>>>> MtoSpecialDetails >>>>>'+MtoSpecialDetails);
            
            var MadeToOrderValues=[];
            MadeToOrderValues.push(NameSelectedItem);
            MadeToOrderValues.push(MtoQty);
            MadeToOrderValues.push(MtoSpecialDetails);
            
            console.log('>>>>> Made To Order Values >>>>>'+MadeToOrderValues);
            RequestType.setParams({
                requestType:'Made To Order',
                Formvalues:MadeToOrderValues,
            })
            RequestType.setCallback( helper, function(response) {
                console.log("=====Made to Order Form Response====", JSON.stringify(response.getReturnValue()));
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
            });
        }
        
        
        $A.enqueueAction(RequestType);
        
        /**************************************** Corporate Name Tag Request Form *****************************************************/   
        
        if(CoprequestValue=='Corporate Name Tag'){
            var CopNameTagTitle=component.find("CopNameTagTitle").get("v.value");
            var CopNameTagFN=component.find("CopNameTagFN").get("v.value");
            var CopNameTagLN=component.find("CopNameTagLN").get("v.value");
            var CopNameTagYOH=component.find("CopNameTagYOH").get("v.value");
            var CopNameTagFN=component.find("CopNameTagFN").get("v.value");
            var CopNameTagLogo=document.getElementById("CopNameTagLogo");
            
            var CopNameTagLogoList=[]; 
            for (var i = 0; i < CopNameTagLogo.options.length; i++) {
                if(CopNameTagLogo.options[i].selected ==true){
                    CopNameTagLogoList.push(CopNameTagLogo.options[i].value);
                }
            }
            
            console.log('>>>>> CopNameTagLogoList >>>>>'+CopNameTagLogoList);
            console.log('>>>>> CopNameTagTitle >>>>>'+CopNameTagTitle);
            console.log('>>>>> CopNameTagFN >>>>>'+CopNameTagFN);
            console.log('>>>>> CopNameTagLN >>>>>'+CopNameTagLN);
            console.log('>>>>> CopNameTagYOH >>>>>'+CopNameTagYOH);
            console.log('>>>>> CopNameTagFN >>>>>'+CopNameTagFN);
            
            var CorporateNameTagValues=[];
            CorporateNameTagValues.push(CopNameTagTitle);
            CorporateNameTagValues.push(CopNameTagFN);
            CorporateNameTagValues.push(CopNameTagLN);
            CorporateNameTagValues.push(CopNameTagYOH);
            CorporateNameTagValues.push(CopNameTagFN);
            
            console.log('>>>>> Corporate Name Tag Params >>>>>'+CorporateNameTagValues);
            
            RequestType.setParams({
                requestType:'Corporate Name Tag',
                Formvalues:CorporateNameTagValues,
                ListCopNameTagLogo:CopNameTagLogoList
            })
            RequestType.setCallback( helper, function(response) {
                console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
            });
        }
        
        /**************************************** Corporate Office Nameplate Request Form *****************************************************/   
        
        if(CoprequestValue=='Corporate Office Nameplate'){
            var CopOfficeName=component.find("CopOfficeName").get("v.value");
            var CopOfficeTitle=component.find("CopOfficeTitle").get("v.value");
            var CopOfficeYOH=component.find("CopOfficeYOH").get("v.value");
            var CopOfficeBulid=component.find("CopOfficeBulid").get("v.value");
            var CopOfficeNameType=document.getElementById("CopOfficeNameType");
            
            
            var CopOfficeNameTypeList=[]; 
            for (var i = 0; i < CopOfficeNameType.options.length; i++) {
                if(CopOfficeNameType.options[i].selected ==true){
                    CopOfficeNameTypeList.push(CopOfficeNameType.options[i].value);
                }
            }
            
            console.log('>>>>> CopOfficeNameTypeList >>>>>'+CopOfficeNameTypeList);
            console.log('>>>>> CopOfficeName >>>>>'+CopOfficeName);
            console.log('>>>>> CopOfficeTitle >>>>>'+CopOfficeTitle);
            console.log('>>>>> CopOfficeYOH >>>>>'+CopOfficeYOH);
            console.log('>>>>> CopOfficeBulid >>>>>'+CopOfficeBulid);
            
            var CopOfficeValues=[];
            CopOfficeValues.push(CopOfficeTitle);
            CopOfficeValues.push(CopOfficeName);
            CopOfficeValues.push(CopOfficeYOH);
            CopOfficeValues.push(CopOfficeBulid);
            
            console.log('>>>>> Corporate Office Nameplate Params >>>>>'+CopOfficeValues);
            
            RequestType.setParams({
                requestType:'Corporate Office Nameplate',
                Formvalues:CopOfficeValues,
                ListCopOfficeNameType:CopOfficeNameTypeList
            })
            RequestType.setCallback( helper, function(response) {
                console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
            });
        }
        
        /**************************************** Corporate Business Cards Request Form *****************************************************/   
        
        if(CoprequestValue=='Corporate Business Cards'){
            var CopBCBulid=component.find("CopBCBulid").get("v.value");
            var CopBCAddress=component.find("CopBCAddress").get("v.value");
            var CopBCName=component.find("CopBCName").get("v.value");
            var CopBCTitle=component.find("CopBCTitle").get("v.value");
            var CopBCPhone=component.find("CopBCPhone").get("v.value");
            var CopBCFax=component.find("CopBCFax").get("v.value");
            var CopBCEmail=component.find("CopBCEmail").get("v.value");
            var CopBCMobile=component.find("CopBCMobile").get("v.value");
            var CopBCWeb=component.find("CopBCWeb").get("v.value");
            var CopBCICEChat=component.find("CopBCICEChat").get("v.value");
            
            
            console.log('>>>>> CopOfficeNameTypeList >>>>>'+CopOfficeNameTypeList);
            console.log('>>>>> CopBCBulid >>>>>'+CopBCBulid);
            console.log('>>>>> CopBCAddress >>>>>'+CopBCAddress);
            console.log('>>>>> CopBCName >>>>>'+CopBCName);
            console.log('>>>>> CopBCTitle >>>>>'+CopBCTitle);
            console.log('>>>>> CopBCPhone >>>>>'+CopBCPhone);
            console.log('>>>>> CopBCFax >>>>>'+CopBCFax);
            console.log('>>>>> CopBCEmail >>>>>'+CopBCEmail);
            console.log('>>>>> CopBCMobile >>>>>'+CopBCMobile);
            console.log('>>>>> CopBCWeb >>>>>'+CopBCWeb);
            console.log('>>>>> CopBCICEChat >>>>>'+CopBCICEChat);
            
            var CopBCValues=[];
            CopBCValues.push(CopBCBulid);
            CopBCValues.push(CopBCAddress);
            CopBCValues.push(CopBCName);
            CopBCValues.push(CopBCTitle);
            CopBCValues.push(CopBCEmail);
            CopBCValues.push(CopBCWeb);
            CopBCValues.push(CopBCICEChat);
            
           
            
            //console.log('>>>>> CopBCValues params111 >>>>>'+CopBCPhone.length);
            console.log('>>>>> CopBCValues params >>>>>'+CopBCValues);
            console.log('>>>>> CopBCValues params >>>>>'+CopBCValues.length);
            
            if(CopBCPhone.length == 0)
            {
                CopBCValues.push(CopBCPhone);
            }
            else
            {
                console.log('>>>>> CopBCPhoneValues if enter >>>>>');
                
                if(CopBCPhone.length==10 && !isNaN(CopBCPhone)) 
                {
                    CopBCPhone =   '(' + CopBCPhone.substring(0,3) + ') ' + CopBCPhone.substring(3, 6) + '-' + CopBCPhone.substring(6);
                    CopBCValues.push(CopBCPhone);
                    console.log('>>>>> CopBCPhoneValues length if enter >>>>>');
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Phone',
                        message:'Please Enter 10 digits Number only for Phone Ex: 1234567890',
                        duration:' 5000',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                    console.log('>>>>>  >>>>>'+CopBCPhone);
                    event.preventDefault(); 
                }
            }
            
            if(CopBCFax.length == 0)
            {
                CopBCValues.push(CopBCFax);
            }
            else
            {
                console.log('>>>>> CopBCFax if enter >>>>>');
                
                if(CopBCFax.length==10 && !isNaN(CopBCFax)) 
                {
                    CopBCFax =   '(' + CopBCFax.substring(0,3) + ') ' + CopBCFax.substring(3, 6) + '-' + CopBCFax.substring(6);
                    CopBCValues.push(CopBCFax);
                    console.log('>>>>> CopBCFax length if enter >>>>>');
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Fax',
                        message:'Please Enter 10 digits Number only for Fax Ex: 1234567890',
                        duration:' 5000',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                    console.log('>>>>>  >>>>>'+CopBCFax);
                    event.preventDefault(); 
                }
            }
            
            if(CopBCMobile.length == 0)
            {
                CopBCValues.push(CopBCMobile);
            }
            else
            {
                console.log('>>>>> CopBCMobile if enter >>>>>');
                
                if(CopBCMobile.length==10 && !isNaN(CopBCMobile)) 
                {
                    CopBCMobile =   '(' + CopBCMobile.substring(0,3) + ') ' + CopBCMobile.substring(3, 6) + '-' + CopBCMobile.substring(6);
                    CopBCValues.push(CopBCMobile);
                    console.log('>>>>> CopBCMobile length if enter >>>>>');
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Mobile',
                        message:'Please Enter 10 digits Number only for Mobile Ex: 1234567890',
                        duration:' 5000',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
                    console.log('>>>>>  >>>>>'+CopBCMobile);
                    event.preventDefault(); 
                }
            }
            
            console.log('>>>>> CopBCValues params 22 >>>>>'+CopBCValues);
            console.log('>>>>> CopBCValues params 22 >>>>>'+CopBCValues.length);
            RequestType.setParams({
                requestType:'Corporate Business Cards',
                Formvalues:CopBCValues
            }) 
            RequestType.setCallback(helper, function(response) {
                console.log("=====Response====", JSON.stringify(response.getReturnValue()));
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
            });
        }
    },
     
})