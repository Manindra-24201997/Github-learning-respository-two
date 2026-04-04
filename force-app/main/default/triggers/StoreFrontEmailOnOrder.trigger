trigger StoreFrontEmailOnOrder on Production_Estimate__c (after insert) {
    
    set<Id> PEstJobIds=new set<Id>();
    for(Production_Estimate__c t:Trigger.new){
        if(t.FromStoreFront__c==true){
            PEstJobIds.add(t.Job__c);
        }
    }
    system.debug('-PEstJobIds--'+PEstJobIds);
    if(trigger.isAfter && trigger.isInsert){
        if(PEstJobIds.size()>0){           
        
        map<string,list<Production_Estimate__c>> jobsWithPEstsMap=new   map<string,list<Production_Estimate__c>>();
        list<string> JobNames=new list<string>();
        list<Job__c> jobsList=[select id,name,Job_Auto_Number__c,Createddate,JS_Client__r.name,JS_Client_Contact__r.Name, (select id,Name,Quantity__c,Total_Cost__c,Amount__c,Vendor__r.Name,GL_Code__r.Name from Production_Estimates__r where PE_Template__c=null ) from Job__c where id in:PEstJobIds];
        System.debug('-jobsList---query---result---'+jobsList); 
        list<String> jobNumbersForSubject=new list<String>();
        map<string,string> jobNameWithClientName=new map<string,string>();
        for(Job__c a:jobsList){
            JobNames.add(a.name);
            jobNumbersForSubject.add(a.Job_Auto_Number__c);           
            jobNameWithClientName.put(a.Name,a.JS_Client__r.Name);
            if(jobsWithPEstsMap.containsKey(a.name)){
                jobsWithPEstsMap.get(a.name).add(a.Production_Estimates__r);  
            }
            else{
                jobsWithPEstsMap.put(a.name,a.Production_Estimates__r);
            }
        }
        system.debug('---jobsWithPEstsMap----'+jobsWithPEstsMap);
        system.debug('---jobNumbersForSubject----'+jobNumbersForSubject);
        string subjectNumbers=string.join(jobNumbersForSubject,',');
        system.debug('---subjectNumbers----'+subjectNumbers);
        String userName = UserInfo.getUserName();
        system.debug('-userName--'+userName);
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        system.debug('-userEmail--'+userEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owEmail = [select Id from OrgWideEmailAddress limit 1];        
        if ( owEmail.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owEmail.get(0).Id);
        }
        mail.setToAddresses(new String[] {userEmail});
        mail.setSubject('Order-'+subjectNumbers+'-Received');
        String messageBody='<html><body style="position:relative;width:21cm;height:100%;margin:0 auto;color:#001028;background:#FFFFFF;font-family: Arial, sans-serif;font-size: 12px;font-family: Arial;"><p style="color:green;font-size:20px;">Thank you for placing a StoreFront order.</p><p style="font-size:15px;">This is validation that your order has been received and will begin processing. Please allow 3-5 business days to receive. Thank you.</p><header style="padding:10px 0;margin-bottom:30px;"><b><h1 style="text-align: left;background: #F5F5F5;border-top: 1px solid #000000;border-bottom: 1px solid #000000;font-size: 2em;line-height: 1.4em;margin: 0 0 20px 0;">Order Details</h1></b>';
        string GLName; 
        for(integer i=0;i<JobNames.size();i++){
            list<Production_Estimate__c> PEsts=new list<Production_Estimate__c>();
            PEsts.addAll(jobsWithPEstsMap.get(JobNames[i]));
            system.debug('--PEsts---'+PEsts);
            DateTime dateCreated = jobsList[i].Createddate;
            String dateString =  dateCreated.format('MM/dd/yyyy') ; 
            messageBody +='<div id="project" style="font-size: 15px;float: left;width: 50%;"><table style="background: none;width: 100%;border-collapse: collapse;border-spacing: 0;margin-bottom: 20px;font-size: 15px;"><tbody><tr><td style="width: 56px;text-align: left;padding: 5px;vertical-align:top;">Order Name:</td><td style="text-align: left;padding: 5px;">'+JobNames[i]+'</td></tr> <tr><td style="width: 87px;text-align: left;padding: 5px;vertical-align:top;">Store:</td><td style="text-align: left;padding: 5px;">'+jobNameWithClientName.get(JobNames[i])+'</td></tr></tbody></table></div><div id="project" style="font-size: 15px;float: left;width:50%;"><table style="background: none;width: 100%;border-collapse: collapse;border-spacing: 0;margin-bottom: 20px;font-size: 15px;"><tbody><tr><td style="width: 43px;text-align: left;padding: 5px;vertical-align:top;width:100px;">Store Contact:</td><td style="text-align: left;padding: 5px;">'+jobsList[i].JS_Client_Contact__r.Name+'</td></tr><tr><td style="text-align: left;padding: 5px;vertical-align:top;">Date :</td><td style="text-align:left;padding:5px;">'+dateString+'</td></tr></tbody></table></div></header><main>';
            //messageBody += '<br/><b>'+JobNames[i]+'</b><br/><b>'+jobNameWithClientName.get(JobNames[i])+'</b><br/><b>'+jobsList[i].JS_Client_Contact__r.Name+'</b><br/><b>'+dateString+'</b><br/>';
            //<br/><table style="border: 1px solid black;border-collapse:collapse;"><thead><tr><th style="border: 1px solid #ddd;padding:8px;" scope="col">Name</th><th style="border: 1px solid #ddd;padding:8px;" scope="col">GL Description</th><th style="border: 1px solid #ddd;padding:8px;" scope="col">Quantity</th></tr></thead>';
            messageBody += '<br/><table style="font-size: 15px;width: 100%;border-collapse: collapse;border-spacing: 0;margin-bottom: 20px;"><thead style=""><tr style="background: #f5f5f5;border-top: 1px solid black;border-bottom: 1px solid black;"><th class="service" style="border-bottom: 1px solid #000000;white-space: nowrap;font-weight: bold;padding: 5px 5px;text-align: left;">Name</th><th style="border-bottom: 1px solid #000000;white-space: nowrap;font-weight: bold;padding: 5px 0px;text-align: left;">GL Description</th><th></th><th style="border-bottom: 1px solid #000000;white-space: nowrap;font-weight: bold;padding: 5px 0px;text-align: left;">Quantity</th></tr></thead>';
            for(integer k=0;k<PEsts.size();k++){
                if(PEsts[k].GL_Code__r.Name==null || PEsts[k].GL_Code__r.Name=='undefined'){
                    GLName='-';
                } 
                else{
                    GLName=PEsts[k].GL_Code__r.Name;
                }
               Integer quantity=(Integer)PEsts[k].Quantity__c;
                messageBody +='<tbody><tr><td class="service"><p style="margin: 0;padding-left:4px;">'+PEsts[k].Name+'</p></td><td class="unit" style=" ">'+GLName+'</td><td></td><td class="qty" style="">'+quantity+'</td></tr></tbody>';
               // messageBody += '<tbody><tr><td style="border: 1px solid #ddd;padding:8px;">'+PEsts[k].Name+'</td><td style="border: 1px solid #ddd;padding:8px;">'+GLName+'</td><td style="border: 1px solid #ddd;padding:8px;">'+PEsts[k].Quantity__c+'</tr></tbody>';
            }
            messageBody +='</table><a href="'+System.Label.DomainUrl+jobsList[i].id+'"'+'>Click here to see the order</a><br/><hr>';
            system.debug('----messageBody----'+messageBody);
        } 
        messageBody +='</body></html>';
        mail.setHtmlBody(messageBody); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    }
}