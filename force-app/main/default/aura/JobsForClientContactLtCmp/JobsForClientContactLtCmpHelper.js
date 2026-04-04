({
    getStatusOptions : function(component,helper) {
        console.log('>>>>>Doinit>>>>>');
        // var rowActions = helper.getRowActions.bind(this, component);
        var rowActions = [{ label: 'Shipments','iconName': 'standard:shipment', name: 'View_Shipment'}];
        
        console.log('>>>>>rowActions>>>>>'+rowActions);
        var options=component.get("c.getStatusList");
        options.setCallback(this,function(Response){
            console.log("-----rESPONSE"+Response.getReturnValue());
            if(Response.getState()=="SUCCESS"){
                component.set("v.statusPicklist",Response.getReturnValue()); 
            }
            
        });
        var getColums=component.get("c.getLabels");
        var isMobile = /iPhone|iPod|Android/i.test(navigator.userAgent);
        
        getColums.setCallback(this,function(Response){
            console.log("-----rESPONSE"+Response.getReturnValue());
            if(Response.getState()=="SUCCESS"){
                
                component.set("v.columns",[
                    {label:Response.getReturnValue()[2], fieldName: 'Job_Auto_Number__c', sortable: true, cellAttributes: { alignment: 'left' }},
                    {label:Response.getReturnValue()[0],  fieldName: 'NameLink', sortable: true, type: 'url',typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: Response.getReturnValue()[1], fieldName: 'JS_Client__c', sortable: true,  type: 'url',typeAttributes: { label: { fieldName: 'clientlink' },target: '_self', tooltip :{ fieldName: 'clientlink' }} },
                    {label: 'Name', fieldName: 'JS_Client_Contact__c',sortable: true, type: 'text'} ,                      
                    {label: 'Order Date', fieldName: 'CreatedDate', sortable: true, type: 'date-local' ,cellAttributes: { class: { fieldName: 'CreatedDate' }, iconName: 'utility:event', iconAlternativeText:'Order Date'} },
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                ]);  
                    }
                    
                    
                    });
                    
                    var getJobs=component.get("c.DisplayJobsforClientContact");
                    
                    getJobs.setCallback(this,function(Response){
                    
                    console.log("-----RESPONSE"+JSON.stringify(Response.getReturnValue()));
                    console.log("----RESPONSE length"+Response.getReturnValue().length);
                    //component.set("v.data",Response.getReturnValue());
                    if(Response.getState()=="SUCCESS"){
                    var rows=Response.getReturnValue();
                    for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                              row.NameLink = '/'+row.Id; 
                              row.Name = row.Name;
                              //row.AutoNumber = row.Job_Auto_Number__c;
                              // row.Job_Auto_Number__c= '/'+row.Id; 
                              
                              if(row.JS_Client__c!=undefined || row.JS_Client__c!=null){
                    row.clientlink=row.JS_Client__r.Name;
                    row.JS_Client__c = '/'+row.JS_Client__r.Id;
                }
                if(!isMobile){
                    row.Status__c=row.Status__c;
                    if(row.JS_Client_Contact__c!=undefined || row.JS_Client_Contact__c!=null){
                        row.JS_Client_Contact__c = row.JS_Client_Contact__r.Name;
                    }
                }
            }
            component.set("v.data",rows);
        }
                              });
        
        $A.enqueueAction(options);
        $A.enqueueAction(getColums);
        $A.enqueueAction(getJobs);
        
    },
    
    ViewShipments: function(component,helper,rowId) {
        var ShpRec = component.get("c.getShprecords");
        ShpRec.setParams({
            recordId : rowId,
        });
        
        ShpRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if(row.Tracking_Number__c !=undefined){
                        row.tracklink='https://www.ups.com/track?loc=en_US&tracknum='+row.Tracking_Number__c+'&requester=WT/trackdetails';    
                    }
                }
                component.set("v.Shpdata",rows);
            }
            else {
                console.log('>>>>>> TS Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Shipment has '+errors[0].message
                }); 
            }
        });
        
        component.set('v.Shpcolumns', [
            {label: 'Manifest Date', fieldName: 'Shipment_Date__c', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Shipment Sent Date'}},
            {label: 'Status', fieldName: 'Shipment_Status__c', sortable: true, type: 'text'},
            {label: 'Tracking Number', fieldName: 'tracklink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Tracking_Number__c' }, target: '_self'}}
        ]);  
        
        $A.enqueueAction(ShpRec);
    },
    
    
    getStatusJobs : function(component,helper) {
        var isMobile = /iPhone|iPod|Android/i.test(navigator.userAgent);
        var status=component.find("pickStatus").get("v.value");
        console.log('---status---'+status);
        var statusJobs=component.get("c.populateJobList");
        statusJobs.setParams({
            strStatus:status
        });
        statusJobs.setCallback(this,function(Response){
            console.log("-----rESPONSE"+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=="SUCCESS"){
                var rows=Response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.NameLink = '/'+row.Id; 
                    row.Name = row.Name;
                    //row.AutoNumber = row.Job_Auto_Number__c;
                    //row.Job_Auto_Number__c= '/'+row.Id; 
                    row.Status__c=row.Status__c;
                    if(row.JS_Client__c!=undefined || row.JS_Client__c!=null){
                        row.clientlink=row.JS_Client__r.Name;
                        row.JS_Client__c = '/'+row.JS_Client__r.Id;
                    }
                    if(! isMobile){
                        if(row.JS_Client_Contact__c!=undefined || row.JS_Client_Contact__c!=null){
                            row.JS_Client_Contact__c = row.JS_Client_Contact__r.Name;
                        }
                    }
                    
                }
                component.set("v.data",rows);
            }
        });
        $A.enqueueAction(statusJobs);
    },
    /* getMoreRec:  function(component, rows,selectd){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.populateJobList');
            console.log('>>>>>getMoreRec>>>');
            var recordOffset = component.get("v.currentCount");
            console.log('>>>>>recordOffset>>>'+recordOffset);
            var recordLimit = component.get("v.initialRows");
            console.log('>>>>>recordLimit>>>'+recordLimit);
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset,              
                 "Status": selectd
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset);   
                }                
            });
            $A.enqueueAction(action);
        }));
    },*/
    
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='NameLink'){
            data.sort(this.sortBy('Name', reverse))
        }
        else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        component.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    ShpsortData: function (component, fieldName, ShpsortDirection) {
        var data = component.get("v.Shpdata");
        var reverse = ShpsortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='NameLink'){
            data.sort(this.ShpsortBy('Name', reverse))
        }
        else{
            data.sort(this.ShpsortBy(fieldName, reverse))
        }
        component.set("v.Shpdata", data);
    },
    ShpsortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
    
    
})