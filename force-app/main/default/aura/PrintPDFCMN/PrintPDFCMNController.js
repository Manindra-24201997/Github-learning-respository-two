({
    WorkOrderPageRedirect : function(component, event, helper) {
        var jobid=component.get("v.recordId");
        $A.get("e.force:closeQuickAction").fire(); 
        setTimeout(function(){
            var JobName=component.get("v.simpleRecord.Name");
            console.log('>>>>>>>>> Job Name >>>>>>>>>'+JSON.stringify(JobName));
            if(JobName.includes("CMN Form"))
            {
                console.log('>>>>>>>>> True >>>>>>>>>>>>>');
                window.open('/one/one.app#/alohaRedirect/apex/WorkOrderNew?id='+jobid,'_self'); 
            }
            else{
                console.log('>>>>>>>>>>> False >>>>>>>>>>>>>>>>>>');
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "type": "info",
                    "message": "we cannot generate the PDF form for this job."
                });  
                ToastMsg.fire();
            }
            
            
        },200);
        
        
        
    },
})