({
    afterScriptsLoadedinHomePage :function(component, event, helper) {
        helper.fetchCalenderEvents(component, event, helper);
    },
    doInit: function(component, event, helper) {
        helper.fetchFieldLabels(component,event,helper);
        //alert('init');
        var taskview='MyTaskDues';
        helper.MyTaskrecordsfetch(component,event,helper,taskview);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Task_Done':
                helper.TaskDone(component, event, helper);
                break;
                
            case 'Timesheet_Entry':
                component.set("v.LogTaskId",row.jobTaskrole.JobSuite__Job_Task__r.Id);
                component.set("v.isTaskLogTime",true); 
                component.find("LogTimeId").refreshTaskData();
                break;
        }
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    handleTasksView :function (component, event, helper) {
        helper.fetchCalenderEvents(component, event, helper);
    },
    
    handleTasksViewSel:function (component, event, helper) {
        console.log('>>>>>>>>>handleTasksViewSel>>>>>>>>>>>');
        var taskview=component.find("TaskVId").get("v.value");
        console.log('>>>>>>>>>taskview>>>>>>>>>>>'+taskview);
        helper.MyTaskrecordsfetch(component, event, helper,taskview);
    },
    
     CalenderView : function (component, event, helper) {
       // window.open('/one/one.app#/alohaRedirect/apex/JobSuite__TaskCalendarNewHome','_blank'); 
       console.log('========Button Name============'+event.getSource().get("v.label"));
         if(component.get("v.isListview")){
              component.set("v.isListview",false);
              event.getSource().set("v.label","My Do List");
         }
         else{
             helper.MyTaskrecordsfetch(component,event,helper);
               component.set("v.isListview",true); 
                event.getSource().set("v.label","My Calender");
         }
        
    },
    
    handleTskQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectTskId=event.getSource().get("v.name");
        console.log('---selectTskId-'+selectTskId+'---selectOption--'+selectOption);
        
        switch (selectOption) {
                
			case 'TaskDone':
                helper.TaskDone(component, event, helper, selectTskId);
                break;
                
            case 'Log_Time':
                component.set("v.LogTaskId",selectTskId);
                component.set("v.isTaskLogTime",true); 
                component.find("LogTimeId").refreshTaskData();
                break;
            
        }
    }
   
  
    
    
})