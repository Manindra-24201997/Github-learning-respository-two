({
    getloaddata : function(component, event, helper) {
        var options=component.get("c.getStatusList");
        options.setCallback(this,function(Response){
            console.log("-----rESPONSE"+Response.getReturnValue());
            if(Response.getState()=="SUCCESS"){
                component.set("v.statusPicklist",Response.getReturnValue()); 
            }
            else{
                console.log('options error === '+Response.getError());
            }
            
        });
        $A.enqueueAction(options);
        
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
                    {label: 'Order Date', fieldName: 'CreatedDate', sortable: true, type: 'date-local' ,cellAttributes: { class: { fieldName: 'CreatedDate' }, iconName: 'utility:event', iconAlternativeText:'Order Date'} }
                ]);  
            }
        });  
        $A.enqueueAction(getColums);
        
        //To get job records
        var getjobs = component.get("c.getbillboardjobs");
        getjobs.setCallback(this,function (Response){
            if(Response.getState() == "SUCCESS"){
                var rows=Response.getReturnValue();
                console.log('Response rows === '+rows.length);
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.NameLink = '/'+row.Id; 
                    row.Name = row.Name;
                    
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
            else{
                alert('Error === '+Response.getError()[0].message);
            }
        });
        $A.enqueueAction(getjobs); 
        
        
        var action=component.get("c.getClientId");
        action.setCallback(this,function(Response){
           // alert('-----rESPONSE'+Response.getReturnValue());
            component.set('v.clientId',Response.getReturnValue());
        });
         $A.enqueueAction(action);
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
    
    getBBList : function(component, event, helper) {
        
        var BBItems=component.get("c.DisplayBillboardList");
        BBItems.setCallback(this, function(Response){
            console.log('-----Response---'+Response.getState());
            console.log('-----Response---'+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=='SUCCESS'){
                component.set("v.BBItemsList",Response.getReturnValue());
            }
        });
        
        $A.enqueueAction(BBItems);
    },
    
    sortBy: function(component, event, sortFieldName) {
              console.log('sortFieldName === '+sortFieldName+'\n');
  
        var currentDir = component.get("v.arrowDirection");
        console.log('currentDir === '+currentDir);
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.
            component.set("v.sortAsc", true);  
            component.set("v.sortField", sortFieldName);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.sortAsc", false);
            component.set("v.sortField", sortFieldName);
        }
       var statusJobs=component.get("c.DisplayBillboardListForSorting");
        statusJobs.setParams({
            sortdirection:currentDir,sortfield:sortFieldName
        });
        statusJobs.setCallback(this,function(Response){
            console.log("-----rESPONSE"+JSON.stringify(Response.getReturnValue()));
            if(Response.getState()=="SUCCESS"){
                component.set("v.BBItemsList",Response.getReturnValue());
            }
        });
        $A.enqueueAction(statusJobs);
    },
    
})