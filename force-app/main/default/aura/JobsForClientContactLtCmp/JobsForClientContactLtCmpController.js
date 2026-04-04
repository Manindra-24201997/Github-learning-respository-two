({
    doInit : function(component, event, helper) {
        
        helper.getStatusOptions(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if(isMobile){
            component.set("v.isMobile",isMobile);
        }
        
    /*    var getJobs=component.get("c.DisplayJobsforClientContact");
        getJobs.setCallback(this,function(Response){
            console.log("-----RESPONSE"+JSON.stringify(Response.getReturnValue()));
            //console.log("----RESPONSE length"+Response.getReturnValue().length);
            //component.set("v.data",Response.getReturnValue());
            if(Response.getState()=="SUCCESS"){
                alert('val === '+Response.getReturnValue()); 
            }
        });
        $A.enqueueAction(getJobs);*/
    },
    StatusChange : function(component, event, helper) {       
        helper.getStatusJobs(component, event, helper); 
    },
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    ShpupdateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var ShpsortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.ShpsortedBy", fieldName);
        component.set("v.ShpsortedDirection", ShpsortDirection);
        helper.ShpsortData(component, fieldName, ShpsortDirection);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var rowId=row.Id;
        switch (action.name) {
            case 'View_Shipment':
                component.set("v.isShpListOpen", true);
                console.log('>>>>>>isShpListOpen>>>>>>>>>>');
                helper.ViewShipments(component, event,rowId);
                break;
        }
    },
    
    handleMobileQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var rowId=event.getSource().get("v.name");
        console.log('---rowId-'+rowId+'---option--'+selectOption);
        if(selectOption=='Shipment'){
            component.set("v.isShpListOpen", true);
            console.log('>>>>>>isShpListOpen>>>>>>>>>>');
            helper.ViewShipments(component, event,rowId);
        }
        
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isShpListOpen", false);
    },
    
    
    
    /* handleLoadMoreRec: function (component, event, helper) {
        console.log('>>>>>>>>>Handle Load More >>>>>>>>>>>>');
        // event.getSource().set("v.isLoading", true);
        var cmo = component.find("pickStatus");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        component.set('v.loadMoreStatus', 'Loading....');
        //console.log('>>>>>>>>>>> Total Number of Rows >>>>>>>'+component.get('v.totalNumberOfRows'));
        
        helper.getMoreRec(component, component.get('v.rowsToLoad'),selectd).then($A.getCallback(function (data) {
            if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = component.get('v.data');
                var newData = currentData.concat(data);
                for (var i = 0; i < newData.length; i++) {
                    var row = newData[i];
                    row.NameLink = '/'+row.Id; 
                    row.Name = row.Name;
                    row.Status__c=row.Status__c;
                    if(row.JS_Client__c!=undefined || row.JS_Client__c!=null){
                        row.clientlink=row.JS_Client__r.Name;
                        row.JS_Client__c = '/'+row.JS_Client__r.Id;
                    }
                    if(row.JS_Client_Contact__c!=undefined || row.JS_Client_Contact__c!=null){
                        row.JS_Client_Contact__c = row.JS_Client_Contact__r.Name;
                    }
                }
                component.set('v.data', newData);
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
            }
            event.getSource().set("v.isLoading", false);
        }));
       
    },*/
})