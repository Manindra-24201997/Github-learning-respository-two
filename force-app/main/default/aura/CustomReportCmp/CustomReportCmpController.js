({
    doInit : function(component, event, helper) {
        var action = component.get("c.ProfileInformation");
        action.setCallback(this, function(response) {
            console.log('====response======'+response.getReturnValue());
            var proState = response.getState();
            if (proState === "SUCCESS") {
                component.set("v.ProfileInfo",response.getReturnValue());  
            }
            
        });
    },
	BBMaintenanceReport : function(component, event, helper) {
		window.open('/one/one.app#/alohaRedirect/apex/BBMaintReport','_target'); 
        
       /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/apex/BBMaintReport"
        });
        urlEvent.fire();*/
        
	},
    BBBinderReport : function(component, event, helper) {
		window.open('/one/one.app#/alohaRedirect/apex/BBBinderLC_Embed_VfPage','_self'); 		
        
       /* var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BB_Binder_Report_LC",
        });
        evt.fire();*/
	},
    LovesCampaignStatus : function(component, event, helper) {
		window.open('/one/one.app#/alohaRedirect/apex/LovesCampaignStatusReport','_target'); 
	},
    TrainingDept : function(component, event, helper) {
       window.open('/one/one.app#/alohaRedirect/apex/TrainingCampaignStatusReport','_target');  
    },
    
    NameTagReport : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:NameTag_BusinessCard_Report_LC",
        });
        evt.fire();
    
    },
    MIImport : function(component, event, helper) {
		window.open('/one/one.app#/alohaRedirect/apex/MaterialInventoryItemImportLightning','_target'); 
	},
    NewStoreOutdoorReport : function(component, event, helper) {
		window.open('/one/one.app#/alohaRedirect/apex/NewStoreOutdoorReport','_target'); 
	}
})