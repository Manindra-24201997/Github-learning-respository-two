({
    doInit : function(component, event, helper) {
        component.find('Job_status').set('v.value','Active');
        var action=component.get("c.getJobStatus");
        action.setCallback(this, function(Response){            
            if(Response.getState()=='SUCCESS'){              
                component.set("v.JobStatusList",Response.getReturnValue());
            }           
        });
        $A.enqueueAction(action); 
    },
    
    handleSearch : function(component, event, helper) {
        var JobStatusValue=component.find('Job_status').get('v.value');       
        var JobTypeValue=component.find('Job_Type').get('v.value');       
        component.set("v.showSpinner",true);
        helper.getResultsList(component, event, helper,JobStatusValue,JobTypeValue);
    },
    
    downloadCsv : function(component,event,helper){    
        
        var JobTypeValue=component.find('Job_Type').get('v.value');       
        
        var ResultData = component.get("v.ResultsList");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,JobTypeValue);   
        if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'_'+date.getDate()+'_'+date.getFullYear()+' '+hours+'_'+minutes+' '+newformat;
        hiddenElement.download = 'NameTagBusCard '+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    }
})