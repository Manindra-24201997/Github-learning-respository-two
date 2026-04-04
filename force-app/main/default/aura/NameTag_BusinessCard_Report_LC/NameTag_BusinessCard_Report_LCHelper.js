({
    getResultsList : function(component, event, helper,JobStatusValue,JobTypeValue) {
        
        var action=component.get("c.getResultsList");
        action.setParams({
            "JobStatusString" : JobStatusValue,
            "SringScheduleTypes" : JobTypeValue
        });
        action.setCallback(this, function(Response){			           
            if(Response.getState()=='SUCCESS'){  
                console.log(Response.getReturnValue().length);
                component.set("v.ResultsList",Response.getReturnValue());               
                var JobTypeValue=component.find('Job_Type').get('v.value');               
                component.set("v.JobTypeSelect",JobTypeValue);
                component.set("v.showSpinner",false);
                
            }           
        });
        $A.enqueueAction(action); 
    },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords,JobTypeValue){
        // declare variables
        var csvStringResult, counter, keys,FlyerBannerKeys,columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        if(JobTypeValue=='Name Tag'){
            keys = ['Store Name','Title','Name','Year Of Hire','Logo' ];
        }
        else if(JobTypeValue=='Corporate Office Nameplate'){
            keys = ['Name','Title','Year Of Hire','Building','Nameplate Type'];
        }
            else if(JobTypeValue=='Corporate Business Card'){
                keys = ['Department','Name','Title','Company','Address','Phone','Fax','Email','Mobile','Logo','Website','ICE Chat'];
            }else if(JobTypeValue=='CMN'){
                FlyerBannerKeys =['','','Flyer','','','','','Banner','','','',''];
                keys = ['Store','Name','Name of Event','Date','Time','Event Details','Special Details','Name of Event','Date','Time','Event Details','Special Details'];
            }
                else{
                    keys = ['Name','Title','Address','City','State','Zip','Phone','Fax','Email','Logo','Website'];
                }  
        
        csvStringResult = '';
        if(JobTypeValue=='CMN'){
            csvStringResult += FlyerBannerKeys.join(columnDivider);
            csvStringResult += lineDivider;
        }        
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            // console.log( 'record i------'+JSON.stringify(objectRecords[i].job.JS_Client__r.Client_Code__c));
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                if(JobTypeValue=='Name Tag'){
                    if(skey=='Store Name'){
                        if(objectRecords[i].job.JS_Client__r!=null){
                            csvStringResult += '"'+ objectRecords[i].job.JS_Client__r.Client_Code__c+'"'; 
                        }
                    }
                    else if(skey=='Title'){
                        if(objectRecords[i].jobspecsTitle!=null){
                            csvStringResult += '"'+ objectRecords[i].jobspecsTitle.Description__c+'"'; 
                        }
                    }
                        else if(skey=='Name'){
                            if(objectRecords[i].jobspecsName!=null){
                                if(objectRecords[i].jobspecsStore!=null){
                                    csvStringResult +=  '"'+objectRecords[i].jobspecsName.Description__c+" "+objectRecords[i].jobspecsStore.Description__c+'"';
                                }
                                else{
                                    csvStringResult += '"'+ objectRecords[i].jobspecsName.Description__c+'"'; 
                                }
                            }
                        }
                            else if(skey=='Year Of Hire'){
                                if(objectRecords[i].jobspecsYearofhire!=null){
                                    csvStringResult += '"'+ objectRecords[i].jobspecsYearofhire.Description__c+'"'; 
                                }
                            }
                                else if(skey=='Logo'){
                                    if(objectRecords[i].jobspecsLogo2!=null &&  objectRecords[i].jobspecsLogo2.Description__c!=null){
                                        csvStringResult += '"'+ objectRecords[i].jobspecsLogo2.Description__c+'"';
                                    }
                                    else{
                                        if(objectRecords[i].jobspecsLogo!=null){
                                            csvStringResult += '"'+ objectRecords[i].jobspecsLogo.Description__c+'"';
                                        }
                                    }
                                    
                                }
                                    else{
                                        csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                                    }
                }
                else if(JobTypeValue=='Corporate Office Nameplate'){                   
                    if(skey=='Name'){
                        if(objectRecords[i].jobspecsName!=null){
                            csvStringResult += '"'+ objectRecords[i].jobspecsName.Description__c+'"';
                        }
                    }else if(skey=='Title'){
                        if(objectRecords[i].jobspecsTitle!=null){
                            csvStringResult += '"'+ objectRecords[i].jobspecsTitle.Description__c+'"';
                        }
                    }
                        else if(skey=='Year Of Hire'){
                            if(objectRecords[i].jobspecsYearofhire!=null){
                                csvStringResult += '"'+ objectRecords[i].jobspecsYearofhire.Description__c+'"';
                            }
                        }
                            else if(skey=='Building'){
                                if(objectRecords[i].jobspecsBuilding!=null){
                                    csvStringResult += '"'+ objectRecords[i].jobspecsBuilding.Description__c+'"';
                                }
                            }
                                else if(skey=='Nameplate Type'){
                                    if(objectRecords[i].jobspecsNameplateType!=null){
                                        csvStringResult += '"'+ objectRecords[i].jobspecsNameplateType+'"';
                                    }
                                }
                                    else{
                                        csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                                    }
                }
                    else if(JobTypeValue=='Corporate Business Card'){    
                        if(skey=='Department'){
                            if(objectRecords[i].jobspecsDept!=null){
                                csvStringResult += '"'+ objectRecords[i].jobspecsDept.Description__c+'"';
                            }
                        }else if(skey=='Name'){
                            if(objectRecords[i].jobspecsName!=null){
                                csvStringResult += '"'+ objectRecords[i].jobspecsName.Description__c+'"';
                            }
                        }
                            else if(skey=='Title'){
                                if(objectRecords[i].jobspecsTitle!=null){
                                    csvStringResult += '"'+ objectRecords[i].jobspecsTitle.Description__c+'"';
                                }
                            }
                                else if(skey=='Company'){
                                    if(objectRecords[i].jobspecsCompany!=null){
                                        csvStringResult += '"'+ objectRecords[i].jobspecsCompany+'"';
                                    }
                                }
                                    else if(skey=='Address'){
                                        if(objectRecords[i].jobspecsAddress!=null){
                                            csvStringResult += '"'+ objectRecords[i].jobspecsAddress+'"';
                                        }
                                    }
                                        else if(skey=='Phone'){
                                            if(objectRecords[i].jobspecsPhone!=null){
                                                csvStringResult += '"'+ objectRecords[i].jobspecsPhone.Description__c+'"';
                                            }
                                        }
                                            else if(skey=='Fax'){
                                                if(objectRecords[i].jobspecsFax!=null){
                                                    csvStringResult += '"'+ objectRecords[i].jobspecsFax.Description__c+'"';
                                                }
                                            }
                                                else if(skey=='Email'){
                                                    if(objectRecords[i].jobspecsEmail!=null){
                                                        csvStringResult += '"'+ objectRecords[i].jobspecsEmail.Description__c+'"';
                                                    }
                                                }
                                                    else if(skey=='Mobile'){
                                                        if(objectRecords[i].jobspecsMobile!=null){
                                                            csvStringResult += '"'+ objectRecords[i].jobspecsMobile.Description__c+'"';
                                                        }
                                                    }
                                                        else if(skey=='Logo'){
                                                            if(objectRecords[i].jobspecsLogo1!=null){
                                                                csvStringResult += '"'+ objectRecords[i].jobspecsLogo1+'"';
                                                            }                                                          
                                                        }
                                                            else if(skey=='Website'){
                                                                if(objectRecords[i].jobspecsWebsite!=null){
                                                                    csvStringResult += '"'+ objectRecords[i].jobspecsWebsite+'"';
                                                                }
                                                            }
                                                                else if(skey=='ICE Chat'){
                                                                    if(objectRecords[i].jobspecsLogo!=null){
                                                                        csvStringResult += '"'+ objectRecords[i].jobspecsLogo.Description__c+'"';
                                                                    }
                                                                }
                                                                    else{
                                                                        csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                                                                    }
                        
                    }
                        else if(JobTypeValue=='CMN'){                       
                            if(skey=='Store' && objectRecords[i].ClientCode!=null){
                                csvStringResult += '"'+ objectRecords[i].ClientCode+'"';
                            }
                            else if(skey=='Name' && objectRecords[i].Clientname!=null){
                                csvStringResult += '"'+ objectRecords[i].Clientname+'"';
                            }
                                else if(skey=='Name of Event' && objectRecords[i].CMNFlyerNameofEvent!=null){
                                    csvStringResult += '"'+ objectRecords[i].CMNFlyerNameofEvent.Description__c+'"';
                                }
                                    else if(skey=='Date' && objectRecords[i].CMNFlyerDate!=null){
                                        csvStringResult += '"'+ objectRecords[i].CMNFlyerDate.Description__c+'"';
                                    }
                                        else if(skey=='Time' && objectRecords[i].CMNFlyerTime!=null){
                                            csvStringResult += '"'+ objectRecords[i].CMNFlyerTime.Description__c+'"';
                                        }
                                            else if(skey=='Event Details' && objectRecords[i].CMNFlyerEventDetails!=null){
                                                csvStringResult += '"'+ objectRecords[i].CMNFlyerEventDetails.Description__c+'"';
                                            }
                                                else if(skey=='Special Details' && objectRecords[i].CMNFlyerSpecialDetails!=null){
                                                    csvStringResult += '"'+ objectRecords[i].CMNFlyerSpecialDetails.Description__c+'"';
                                                }
                                                    else if(skey=='Name of Event' && objectRecords[i].CMNBannerNameofEvent!=null){
                                                        csvStringResult += '"'+ objectRecords[i].CMNBannerNameofEvent.Description__c+'"';
                                                    }
                                                        else if(skey=='Date' && objectRecords[i].CMNBannerDate!=null){
                                                            csvStringResult += '"'+ objectRecords[i].CMNBannerDate.Description__c+'"';
                                                        }
                                                            else if(skey=='Time' && objectRecords[i].CMNBannerTime!=null){
                                                                csvStringResult += '"'+ objectRecords[i].CMNBannerTime.Description__c+'"';
                                                            }
                                                                else if(skey=='Event Details' && objectRecords[i].CMNBannerEventDetails!=null){
                                                                    csvStringResult += '"'+ objectRecords[i].CMNBannerEventDetails.Description__c+'"';
                                                                }
                                                                    else if(skey=='Special Details' && objectRecords[i].CMNBannerSpecialDetails!=null){
                                                                        csvStringResult += '"'+ objectRecords[i].CMNBannerSpecialDetails.Description__c+'"';
                                                                    }
                                                                        else{
                                                                            csvStringResult += '"'+''+'"'; 
                                                                        } 
                        }
                            else{   
                                if(skey=='Name'){
                                    if(objectRecords[i].jobspecsName!=null){
                                        csvStringResult += '"'+ objectRecords[i].jobspecsName.Description__c+'"';
                                    }
                                }
                                else if(skey=='Title'){
                                    if(objectRecords[i].jobspecsTitle!=null){
                                        csvStringResult += '"'+ objectRecords[i].jobspecsTitle.Description__c+'"';
                                    }
                                }
                                    else if(skey=='Address'){
                                        if(objectRecords[i].jobspecsAddress!=null){
                                            csvStringResult += '"'+ objectRecords[i].jobspecsAddress.Description__c+'"';
                                        }
                                    }
                                        else if(skey=='City'){
                                            if(objectRecords[i].jobspecsCity!=null){
                                                csvStringResult += '"'+ objectRecords[i].jobspecsCity.Description__c+'"';
                                            }
                                        }
                                            else if(skey=='State'){
                                                if(objectRecords[i].jobspecsState!=null){
                                                    csvStringResult += '"'+ objectRecords[i].jobspecsState.Description__c+'"';
                                                }
                                            }
                                                else if(skey=='Zip'){
                                                    if(objectRecords[i].jobspecsZip!=null){
                                                        csvStringResult += '"'+ objectRecords[i].jobspecsZip.Description__c+'"';
                                                    }
                                                }
                                                    else if(skey=='Phone'){
                                                        if(objectRecords[i].jobspecsPhone!=null){
                                                            csvStringResult += '"'+ objectRecords[i].jobspecsPhone.Description__c+'"';
                                                        }
                                                    }
                                                        else if(skey=='Fax'){
                                                            if(objectRecords[i].jobspecsFax!=null){
                                                                csvStringResult += '"'+ objectRecords[i].jobspecsFax.Description__c+'"';
                                                            }
                                                        }
                                                            else if(skey=='Email'){
                                                                if(objectRecords[i].jobspecsEmail!=null){
                                                                    csvStringResult += '"'+ objectRecords[i].jobspecsEmail.Description__c+'"';
                                                                }
                                                            }
                                                                else if(skey=='Logo'){
                                                                    if(objectRecords[i].jobspecsLogo!=null){
                                                                        csvStringResult += '"'+ objectRecords[i].jobspecsLogo.Description__c+'"';
                                                                    }
                                                                }
                                                                    else if(skey=='Website'){
                                                                        if(objectRecords[i].jobspecsWebsite!=null){
                                                                            csvStringResult += '"'+ objectRecords[i].jobspecsWebsite.Description__c+'"';
                                                                        }
                                                                    }
                                                                        else{
                                                                            csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                                                                        }
                            }
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    }
    
    
})