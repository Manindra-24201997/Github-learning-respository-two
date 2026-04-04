({
    
    myAction : function(component, event, helper) {
        var actionorg = component.get("c.orgdetails");
        actionorg.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('org info === '+response.getReturnValue());
                component.set("v.orginfo",response.getReturnValue());
            }    
        });
        $A.enqueueAction(actionorg);
    },
    
    
    redirectToApp:function(cmp,event,helper){
        //window.location.replace('https://app.asana.com/-/oauth_authorize?client_id=1202714330484313&redirect_uri=https://login.salesforce.com/c/connectionProcessingApp.app&response_type=code&state=thisIsARandomString&scope=default');
        var istest = cmp.get("v.orginfo");
        if(istest){ 
            window.open('https://app.asana.com/-/oauth_authorize?client_id=1202714330484313&redirect_uri=https://test.salesforce.com/c/connectionProcessingApp.app&response_type=code&state=thisIsARandomString&scope=default');
        }
        else{
            window.open('https://app.asana.com/-/oauth_authorize?client_id=1202714330484313&redirect_uri=https://login.salesforce.com/c/connectionProcessingApp.app&response_type=code&state=thisIsARandomString&scope=default');
        }
    },
    
    getCustomFields:function(cmp,event,helper){
        var action =cmp.get('c.getCustomFieldData');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log();
                try {
                    console.log('custom fields === '+response.getReturnValue());
                    cmp.set("v.customfieldList",JSON.parse(response.getReturnValue()));
                    console.log('Success');                    
                }
                catch (e) {
                    console.log(e);
                }
            }    
        });
        $A.enqueueAction(action);
    }
})