public with sharing class DisplayJobsforClientContact {

  Public List<Job__c> JobList {get;set;}
  Public Client_Contact__c  clientContact{get;set;}
  Public User lstUser{get;set;}
  public String strStatus{get;set;}
  Public string clientname{get;set;}
    integer count;
    integer countstr;
    public List<selectOption> getStatusList() 
    {
        List<selectOption> optionList = new List<selectOption>();
        Schema.DescribeFieldResult field = Job__c.Status__c.getDescribe();
         optionList.add(new selectOption('All Jobs', 'All Jobs')); 
        for (Schema.PicklistEntry a : field.getPicklistValues()) 
        {  
            optionList.add(new selectOption(a.getLabel(), a.getLabel()));  
        }
        
        return optionList;  
    }
    // End of Global variables
  
   
     public  DisplayJobsforClientContact(){
      strStatus= 'Active';
      lstUser = [select firstname ,Username,Id, Profile.Name  from user where id=:userinfo.getuserid()];
      clientcontact=[Select id,Email__c , name,Client__c,UserName__c, Client__r.Name ,Client__r.Billing_City__c , Client__r.Billing_Postal_Code__c,Client__r.Billing_Street__c , Client__r.Billing_State__c,Client__r.Client_Fax__c , Client__r.Phone__c   from Client_Contact__c where UserName__c =:lstUser.Username];
      
      clientname=clientcontact.Client__r.Name;
      
      system.debug('***clientname***'+clientname);
      
      if(clientname.contains('Store')){
      
            JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
      }
      
      
      if(clientname.contains('District')){
      
            JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
      }
      
      
      
      if(clientname.contains('Division')){
      
            JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }
      
      else{
         JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :'Active' And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }
      
     system.debug('***JobList Constructor***'+JobList);
     
     
      system.debug('***Client***'+clientcontact.Client__r.Name);
      system.debug('***Client Contact***'+clientcontact.name);
    
      
       }
       
       
    public void populateJobList()
      {
     
         count = [select count() from Job__c where JS_Client__c =:clientcontact.Client__c];
         if(strStatus != 'All Jobs')
         {
          countstr = [select count() from Job__c  where JS_Client__c =:clientcontact.Client__c ];
          }
          else
          {
            countstr = [select count() from Job__c where JS_Client__c =:clientcontact.Client__c and Status__c = :strStatus ];
          }
        
       
          if(strStatus == 'All Jobs')
          {
          
              if(count>1000)
              {
              
              if(clientname.contains('Store')){
      
                  JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                 }
      
      
               if(clientname.contains('District')){
      
                   JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                }
      
      
      
             if(clientname.contains('Division')){
      
                JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

             }
             
             else{
         JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }
             
             
         }else
              {
              
              
              if(clientname.contains('Store')){
      
                  JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                 }
      
      
               if(clientname.contains('District')){
      
                   JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                }
      
      
      
             if(clientname.contains('Division')){
      
                JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) And  CreatedBy.Profile.Name ='SP Client Contact'  ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

             }
             else{
         JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }
             
             
              }
          }
          else
          {
              if(countstr >1000 )
              {
              
               if(clientname.contains('Store')){
      
                  JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                 }
      
      
               if(clientname.contains('District')){
      
                   JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                }
      
      
      
             if(clientname.contains('Division')){
      
                JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

             }
              
           else{
         JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }   
              
             
             
             
              }else
              {
                
                
                if(clientname.contains('Store')){
      
                  JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                 }
      
      
               if(clientname.contains('District')){
      
                   JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c) and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      
                }
      
      
      
             if(clientname.contains('Division')){
      
                JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where (JS_Client__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__c  =:clientcontact.Client__c OR JS_Client__r.Hierarchy__r.Hierarchy__c  =:clientcontact.Client__c)  and Status__c = :strStatus And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

             }
             
             else{
         JobList=[Select id ,name ,JS_Client_Contact__c,JS_Client_Contact__r.name,JS_Client__r.name,JS_Client__c,Campaign__c,Specification_Template__c,Media_Types__c,Schedule_Template__c from Job__c where   JS_Client__c  =:clientcontact.Client__c and Status__c = :strStatus  And  CreatedBy.Profile.Name ='SP Client Contact' ORDER BY JOB_Auto_NUmber__c DESC LIMIT 1000];

      }
             
             
              }
          }
      
    }   
        
        
        
        


}