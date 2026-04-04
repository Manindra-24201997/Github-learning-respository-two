({
    onInit : function(component, event, helper) {
        var currentPageURL = window.location.href;
        var params = currentPageURL.split('?')[1];
        var paramList = params.split('&');
        var code;
        alert('test123 === '+currentPageURL);
        for(var i in paramList){
            if(paramList[i].includes('code')){
                code = paramList[i].split('=')[1];
                break;
            }
        }
        console.log('code === '+code);
        var action = component.get("c.ConnecttoAssana");
        action.setParams({authcode:code,isRefresh:false});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
            }    
        });
         //org
        var actionorg = component.get("c.orgdetails");
        actionorg.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                if(response.getReturnValue() == '00D8c000004tXwGEAU'){
                window.location.replace('https://manindra2-dev-ed.lightning.force.com/lightning/o/Job__c/list?filterName=Recent'); 
                }
            }    
        });
        $A.enqueueAction(action);
        $A.enqueueAction(actionorg);
    }
})