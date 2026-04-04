({
    doinit : function(component, event, helper) {
        helper.getloaddata(component, event, helper);
        helper.getBBList(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('>>>>isMobile>>>>>>>'+isMobile);
        component.set('v.device',isMobile);
    },
    
    handleClick:function(component, event, helper) { 
        component.set('v.showbillboardform',true);
        var BBname = event.target.title;
        //alert("BBname:::" +BBname);
        var bblist = component.get("v.BBItemsList");
        //alert(bblist[indexvar].BBWrap.Id);        
        // component.set("v.billboardrcdid",bblist[indexvar].BBWrap.Id);
        component.set("v.billboardrcdid",BBname);  
    },
    
    StatusChange : function(component, event, helper) {       
        helper.getStatusJobs(component, event, helper); 
    },
    
    updateColumnSorting : function(component, event, helper) {
        var ColumnName = event.target.title;
        // alert('ColumnName === '+ColumnName);
        if(ColumnName == 'Details'){
            helper.sortBy(component,helper, 'Billboard_Type__c');
        }
        else{
            helper.sortBy(component,helper, ColumnName);
        }
    }
})