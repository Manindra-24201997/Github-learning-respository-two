({
    fetchCompeJobs : function(component, event, helper) {
        component.set("v.showSpinner", true); 
		 component.set('v.AccColumn',[
            {label:'Name', fieldName:'Name', type:'text'},
            {label:'Job#', fieldName:'Job_Auto_Number__c', type:'text'},
            {label:'Completion Date', fieldName:'Completion_Date__c', type:'date'}
        ]);
        var action=component.get("c.fetchCompJobs");
        action.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if (state === "SUCCESS") {
                var rows=response.getReturnValue();
                component.set("v.JobList", response.getReturnValue());
               // component.set("v.currentCount", component.get("v.initialRows"));
                component.set("v.totalNumberOfRows",rows.length);
                component.set("v.showSpinner", false); 
            }
        });
        $A.enqueueAction(action);
	},
    
    getFiltersVal :function(component, event, helper){
        component.set("v.showSpinner", true); 
        var filtervals = [];
        var frec=component.get("c.getFiltersData");
        frec.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var freclist=response.getReturnValue();
                console.log('freclist === '+freclist.ownernames);
                component.set("v.CampaignList",freclist.objectvalues[0]);
                component.set("v.MediaTypeList",freclist.objectvalues[1]);
                component.set("v.ScheduleTempList",freclist.objectvalues[2]);
                component.set("v.ClientList",freclist.objectvalues[3]);
                component.set("v.UserList",freclist.ownernames);
                component.set("v.showSpinner", false); 
                
            } 
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                component.set("v.showSpinner", false); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        
        $A.enqueueAction(frec);
    },
    
    filerJobRefecth : function(component, event, helper){
        var CampainStringList=[];
        var MTypeStringList=[];
        var STempStringList=[];
        var ClientStringList=[];
         var OwnerStringList=[];
        var camp=document.getElementById("CampAuraId");
        var MT=document.getElementById("MTAuraId");
        var ST=document.getElementById("STAuraId");
        var C=document.getElementById("ClientAuraId");
        var U = document.getElementById("OwnerAuraId");
        
        console.log('>>>>>>>>>filerJobRefecth camp>>>>>>>>>>>>'+camp);
        
        for (var i = 0; i < camp.options.length; i++) {
            if(camp.options[i].selected ==true){
                CampainStringList.push(camp.options[i].value);
            }
        }
        
        for (var i = 0; i < MT.options.length; i++) {
            if(MT.options[i].selected ==true){
                MTypeStringList.push(MT.options[i].value);
            }
        }
        
        for (var i = 0; i < ST.options.length; i++) {
            if(ST.options[i].selected ==true){
                STempStringList.push(ST.options[i].value);
            }
        }
        
        for (var i = 0; i < C.options.length; i++) {
            if(C.options[i].selected ==true){
                ClientStringList.push(C.options[i].value);
            }
        }
        for (var i = 0; i < U.options.length; i++) {
            if(U.options[i].selected ==true){
                OwnerStringList.push(U.options[i].value);
            }
        }
        
        
        console.log('======CampainStringList=='+CampainStringList);
        console.log('======MTypeStringList=='+MTypeStringList);
        console.log('======STempStringList=='+STempStringList);
        console.log('======ClientStringList=='+ClientStringList);
        console.log('======UserStringList=='+OwnerStringList);
        
        if(CampainStringList.length>0 || MTypeStringList.length>0 || STempStringList.length>0 || ClientStringList.length>0 || OwnerStringList.length>0){
            //component.set("v.enableInfiniteLoading",false);
            console.log('===Filtere with Off INfine Load====');
            helper.runFilterJobs(component, event, helper,CampainStringList,MTypeStringList,STempStringList,ClientStringList,OwnerStringList);          
        }
        else{
            
            //component.set("v.enableInfiniteLoading",true); 
            component.set("v.JobList",[]);
            helper.fetchCompeJobs(component, event, helper);
           // console.log('===Filtere with Off INfine Load==ON==');
           // helper.FetchMassUpdateJobRecords(component, event, helper, 0);
            //helper.getTotalActiveJobRecords(component, event, helper);
        }
        
        
    },
    
    runFilterJobs : function(component, event, helper,CampainStringList,MTypeStringList,STempStringList,ClientStringList,OwnerStringList) {
        component.set("v.showSpinner", true); 
        var FJobAction= component.get("c.FilterChangesJobs");
        FJobAction.setParams({
            strCampaignName:CampainStringList,
            strmediatype:MTypeStringList,
            strscheduletemp:STempStringList,
            strClientName:ClientStringList,
            strOwnerName : OwnerStringList
        });
        FJobAction.setCallback(this, function(response){ 
            
            console.log('======Run filters job response==='+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('====Run filters rows Length===='+rows.length);
                console.log('====Run filters rows===='+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                }
                component.set("v.JobList",rows);
                component.set("v.totalNumberOfRows",rows.length);
                component.set("v.showSpinner", false); 
            } 
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                component.set("v.showSpinner", false); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });  
        $A.enqueueAction(FJobAction);
    },
    
     resetFiltersHelper : function(component, event, helper){
        component.set("v.CampaignList",null);
        component.set("v.MediaTypeList",null);
        component.set("v.ScheduleTempList",null);
        component.set("v.ClientList",null);
         component.set("v.UserList",null);
        component.set("v.data",[]);
        component.set("v.enableInfiniteLoading",true);
        component.set("v.selectedRowsCount",0);
        component.set("v.Selected_Jobs",[]);
         helper.getFiltersVal(component, event, helper);
        helper.fetchCompeJobs(component, event, helper);
    },

    
})