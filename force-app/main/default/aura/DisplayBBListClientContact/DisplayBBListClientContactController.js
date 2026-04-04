({
    doInit : function(component, event, helper) {
        helper.getBBList(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('>>>>isMobile>>>>>>>'+isMobile);
        component.set('v.device',isMobile);
        
    },
    handleClick:function(component,event,helper){
        component.set("v.showbillboardform",true);
    }
})