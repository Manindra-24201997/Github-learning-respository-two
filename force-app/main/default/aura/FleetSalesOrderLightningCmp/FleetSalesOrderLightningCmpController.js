({
    doInit : function(component, event, helper) {
        helper.getClientContacts(component, event, helper);
         var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Loading", true); 
    },
    
    hideSpinner : function(component,event,helper){
        component.set("v.Loading", false);
    },
    
    backToStoreFront :function(component, event, helper) {    
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },    
    ShowMaterialItemList : function(component, event, helper) {
        var  clientContacts=component.get("v.clientContacts");        
        var selectClient=0;
        var clientContactSelectList=[];
        for(var i=0;i<clientContacts.length;i++){
            if(clientContacts[i].varCSelect==true){
                selectClient=selectClient+1;
                clientContactSelectList.push(clientContacts[i].varClientCon);
            }
        }
        if(selectClient>0){
            component.set('v.ShowClientList',false); 
            component.set('v.ShowMaterialItemList',true);
            component.set("v.clientContactSelected",clientContactSelectList);          
            var mInputString=component.get("v.enteredInputSearch");            
            if(mInputString==null || mInputString=='undefined'){
                component.find('MaterialNameString').set('v.value','')
            }
            else{
                component.find('MaterialNameString').set('v.value',mInputString);
            }         
        }
        else{
            console.log('list empty');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please select atleast one Client Contact."
            });
            toastEvent.fire();
        }  
    },
    backToClient : function(component, event, helper) {
        component.set('v.ShowMaterialItemList',false);
        component.set('v.ShowClientList',true);        
    },
    onMiInput : function(component, event, helper) {      
        var mTypeInput=component.find('MaterialNameString').get('v.value'); 
        if(mTypeInput!=null && mTypeInput !='undefined'){
            component.set("v.enteredInputSearch",mTypeInput);
        }
        helper.getShowItems(component, event, helper,mTypeInput);       
    },
    goToCobineList : function(component, event, helper){
        var selectedClientList=component.get("v.clientContactSelected");
        var MaterialItems=component.get("v.MaterialItemsList");
        var selectedMaterialItems=[];
        console.log('-selectedClientList---'+JSON.stringify(selectedClientList));
        console.log('-MaterialItems---'+JSON.stringify(MaterialItems));
        var count=0;
        for(var i=0;i<MaterialItems.length;i++){
            if(MaterialItems[i].varMISelect==true){
                count=count+1;
                selectedMaterialItems.push(MaterialItems[i]);
            }
        }
        if(count>0){
            helper.getCombineList(component, event, helper,selectedClientList,selectedMaterialItems);
            component.set('v.ShowMaterialItemList',false);
            component.set('v.ShowClientList',false);        
            component.set('v.ShowCombineList',true);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please select atleast one Material Item."
            });
            toastEvent.fire();
        }
    },
    checkQuantity : function(component, event, helper){
        var inputvalue=event.getSource().get("v.value"); 
        console.log('--inputvalue---'+inputvalue);
        var divQtyid=event.getSource().get("v.name");           
        var divDataValue=document.getElementById(divQtyid).getAttribute("data-value");      
        var divDataRec=document.getElementById(divQtyid).getAttribute("data-record");      
        var mxQtyId=divDataRec+'maxQty'+divDataValue;
        var mxQtyValue=document.getElementById(mxQtyId).innerText;
        var erMsgId=divDataRec+'erMsg'+divDataValue;
        var emptyMsgId=divDataRec+'emptyMsg'+divDataValue;
        if(inputvalue=='' || inputvalue=='0'){          
            event.getSource().set('v.value',1);
            $A.util.removeClass(document.getElementById(divQtyid),'addRed');
            document.getElementById(erMsgId).setAttribute('style','display:none'); 
        }
        else if(Number(mxQtyValue)<Number(inputvalue)){
            $A.util.addClass(document.getElementById(divQtyid), 'addRed');
            document.getElementById(erMsgId).setAttribute('style','display:;color:red;white-space:pre-wrap;');
        }     
            else{           
                $A.util.removeClass(document.getElementById(divQtyid),'addRed');
                document.getElementById(erMsgId).setAttribute('style','display:none');              
            }
        
    },   
    
    backToMaterial : function(component, event, helper){
        component.set('v.ShowMaterialItemList',true);             
        component.set('v.ShowCombineList',false);
        var inputString=component.get("v.enteredInputSearch");
        component.find("MaterialNameString").set("v.value",inputString);
    },
    submitOrder : function(component, event, helper){
        component.set("v.isSpinner", true);
        var MaterialItems=component.get("v.MaterialItemsList");
        var combineStoreWrapper=component.get("v.combineStoreWrapper");
        var selectedMaterialItems=[];
        console.log('-combineStoreWrapper---'+JSON.stringify(combineStoreWrapper));
        
        for(var i=0;i<MaterialItems.length;i++){
            if(MaterialItems[i].varMISelect==true){
                selectedMaterialItems.push(MaterialItems[i].varMI);
            }
        }
        var emailField = component.find("txtEmail");       
        var emailFieldValue; 
        var emailcount=0;
        var Billcount=0;
        
        
        for(var i=0;i<emailField.length;i++){
            emailFieldValue=emailField[i].get("v.value");
            console.log('emailFieldValue'+emailFieldValue);
            if($A.util.isEmpty(emailFieldValue)){
                component.set("v.isSpinner", false);
                $A.util.addClass(emailField[i], 'slds-has-error');
                emailcount=emailcount+1;
               // emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);   
            }
        }
        var BillingInstruField = component.find("BillingiaInsru");
        var BillingInstruFieldValue;
        for(var i=0;i<BillingInstruField.length;i++){
            BillingInstruFieldValue=BillingInstruField[i].get("v.value");
            console.log('BillingInstruFieldValue'+BillingInstruFieldValue);
            if($A.util.isEmpty(BillingInstruFieldValue) || BillingInstruFieldValue=='None'){
                component.set("v.isSpinner", false);
                $A.util.addClass(BillingInstruField[i], 'slds-has-error');
                Billcount=Billcount+1;
                // emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);   
            }else{
                 $A.util.removeClass(BillingInstruField[i], 'slds-has-error');
            }
            
        }   
        if(Billcount>0 && emailcount>0){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                        "title": "Review the all errors!!!",
                        "type":"error",
                        "message": "Email and BillingInstructions are required fields."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
        }else if(Billcount>0){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                        "title": "Review the all errors!!!",
                        "type":"error",
                        "message": "BillingInstructions is required field."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
        }  else if(emailcount>0){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                        "title": "Review the all errors!!!",
                        "type":"error",
                        "message": "Email is required field."
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner", false);
        }else{
        helper.saveOrder(component, event, helper,combineStoreWrapper,selectedMaterialItems);
    }
    }
})