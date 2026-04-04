({
    doInit : function(component, event, helper) {
        helper.ClientAddress(component,event,helper);
        var isMobile = /iPad|iPhone|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);        
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    FlyerBackForm:function(component, event, helper) {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:StoreFrontNewView"
        });
        navigateEvent.fire();
    },
    
    FlyerNextMethod:function(component, event, helper) {
        var CMNFlyName=component.find("CMNFlyName").get("v.value");
        var CMNFlyDate=component.find("CMNFlyDate").get("v.value");
        var CMNFlyTime=component.find("CMNFlyTime").get("v.value");
        var CMNFlyEvent=component.find("CMNFlyEvent").get("v.value");
        var CMNFlySpecial=component.find("CMNFlySpecial").get("v.value");
        
        if(CMNFlyName==null || CMNFlyName==undefined || CMNFlyName=='')
        {
            console.log('>>>>> CMNFlyName if enter >>>>>'+CMNFlyName);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Name',
                message:'Please Enter the Name',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNFlyName After if enter >>>>>'+CMNFlyName);
            event.preventDefault(); 
        }
        else if(CMNFlyDate==null || CMNFlyDate==undefined || CMNFlyDate=='')
        {
            console.log('>>>>> CMNFlyDate if enter >>>>>'+CMNFlyDate);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Date',
                message:'Please Enter the Date',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNFlyDate After if enter >>>>>'+CMNFlyDate);
            event.preventDefault(); 
        }
            else if(CMNFlyTime==null || CMNFlyTime==undefined || CMNFlyTime=='')
            {
                console.log('>>>>> CMNFlyTime if enter >>>>>'+CMNFlyTime);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Time',
                    message:'Please Enter the Time',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                console.log('>>>>> CMNFlyTime After if enter >>>>>'+CMNFlyTime);
                event.preventDefault(); 
            }
                else
                {
                    component.set('v.CMNFlyer',false);
                    component.set('v.CMNBanner',true);
                    component.set('v.CMNFinalApprove',false);
                }
        
    },
    BannerBackForm:function(component, event, helper) {
        component.set('v.CMNFlyer',true);
        component.set('v.CMNBanner',false);
        component.set('v.CMNFinalApprove',false);
    },
    
    BannerNextMethod:function(component, event, helper) {
        var CMNBNName=component.find("CMNBNName").get("v.value");
        var CMNBNDate=component.find("CMNBNDate").get("v.value");
        var CMNBNTime=component.find("CMNBNTime").get("v.value");
        
        if(CMNBNName==null || CMNBNName==undefined || CMNBNName=='')
        {
            console.log('>>>>> CMNBNName if enter >>>>>'+CMNBNName);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Name',
                message:'Please Enter the Name',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNBNName After if enter >>>>>'+CMNBNName);
            event.preventDefault(); 
        }
        else if(CMNBNDate==null || CMNBNDate==undefined || CMNBNDate=='')
        {
            console.log('>>>>> CMNBNDate if enter >>>>>'+CMNBNDate);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Date',
                message:'Please Enter the Date',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNBNDate After if enter >>>>>'+CMNBNDate);
            event.preventDefault(); 
        }
            else if(CMNBNTime==null || CMNBNTime==undefined || CMNBNTime=='')
            {
                console.log('>>>>> CMNBNTime if enter >>>>>'+CMNBNTime);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Time',
                    message:'Please Enter the Time',
                    duration:' 5000',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                console.log('>>>>> CMNBNTime After if enter >>>>>'+CMNBNTime);
                event.preventDefault(); 
            }
                else
                {
                    component.set('v.CMNFlyer',false);
                    component.set('v.CMNBanner',false);
                    component.set('v.CMNFinalApprove',true);
                }
        
    },
    
    FinalBackForm:function(component, event, helper) {
        component.set('v.CMNFlyer',false);
        component.set('v.CMNBanner',true);
        component.set('v.CMNFinalApprove',false);
    },
    
    SaveMethod:function(component, event, helper) {
        console.log('>>>>> Save >>>>>');
        component.set("v.isSpinner", true);
        var CMNFlyName=component.get("v.CMNFlyerNameofEvent");
        var CMNFlyDate=component.get("v.CMNFlyerDate");
        var CMNFlyTime=component.get("v.CMNFlyerTime");
        var CMNFlyEvent=component.get("v.CMNFlyerEventDetails");
        var CMNFlySpecial=component.get("v.CMNFlyerSpecialDetails");
        
        console.log('>>>>> CMNFlyName >>>>>'+CMNFlyName);
        
        var CMNBNName=component.get("v.CMNBannerNameofEvent");
        var CMNBNDate=component.get("v.CMNBannerDate");
        var CMNBNTime=component.get("v.CMNBannerTime");
        var CMNBNEvent=component.get("v.CMNBannerEventDetails");
        var CMNBNSpecial=component.get("v.CMNBannerSpecialDetails");
        
        var CMNFlyApprove=component.find("CMNFlyApprove").get("v.checked");
        var CMNBanApprove=component.find("CMNBanApprove").get("v.checked");
        console.log('>>>>> CMNBanApprove >>>>>'+CMNBanApprove);
        console.log('>>>>> CMNFlyApprove >>>>>'+CMNFlyApprove);
        
        if(CMNFlyApprove==null || CMNFlyApprove==undefined || CMNFlyApprove=='' || CMNFlyApprove==false)
        {
            console.log('>>>>> CMNFlyApprove if enter >>>>>'+CMNFlyApprove);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'CMN Flyer',
                message:'Please approve the CMN Flyer Template',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNFlyApprove After if enter >>>>>'+CMNFlyApprove);
            component.set("v.isSpinner", false);
            event.preventDefault(); 
        }
        
        else if(CMNBanApprove==null || CMNBanApprove==undefined || CMNBanApprove=='' || CMNBanApprove==false)
        {
            console.log('>>>>> CMNBanApprove if enter >>>>>'+CMNBanApprove);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'CMN Banner',
                message:'Please approve the CMN Banner Template',
                duration:' 5000',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            console.log('>>>>> CMNBanApprove After if enter >>>>>'+CMNBanApprove);
            component.set("v.isSpinner", false);
            event.preventDefault(); 
        }
            else
            {
                var CMNListValues=[];
                CMNListValues.push(CMNFlyName);
                CMNListValues.push(CMNFlyDate);
                CMNListValues.push(CMNFlyTime);
                CMNListValues.push(CMNFlyEvent);
                CMNListValues.push(CMNFlySpecial);
                CMNListValues.push(CMNBNName);
                CMNListValues.push(CMNBNDate);
                CMNListValues.push(CMNBNTime);
                CMNListValues.push(CMNBNEvent);
                CMNListValues.push(CMNBNSpecial);
                
                console.log('>>>>> CMNListValues >>>>>'+CMNListValues);
                
                var CMNReqType = component.get("c.SaveRequestForm");
                console.log('>>>>> Method Call >>>>>');
                CMNReqType.setParams({
                    requestType:'CMN Form',
                    Formvalues:CMNListValues,
                })
                
                CMNReqType.setCallback(this, function(response) {
                    console.log("=====CMN Response====", JSON.stringify(response.getReturnValue()));
                    var CMNresult = response.getReturnValue();
                    if (response.getState() === "SUCCESS") {
                        if(CMNresult=="true"){
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
                                "message":CMNresult
                            });
                            ToastMsg.fire();
                        }
                    }
                });
                
                $A.enqueueAction(CMNReqType);
            }
        
    },
})