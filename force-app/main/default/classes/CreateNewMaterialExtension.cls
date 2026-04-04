public with sharing class CreateNewMaterialExtension {


     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    public string MIprefix {set;get;}

    private final Material_Item__c MI;
    Public string Recordtypeid,Strid,GLDName,GLCName,CBTemp,PETemp;
    Public string RecordtypeName{get;set;}
    
    
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
     public String getCBTemp() { return CBTemp; }
    public void setCBTemp(String s) {  this.CBTemp= s; }
    
     public String getPETemp() { return PETemp; }
    public void setPETemp(String s) {  this.PETemp= s; }
    

    public CreateNewMaterialExtension(ApexPages.StandardController controller) {
    
        this.MI=(Material_Item__c)controller.getRecord();
        MIprefix = Material_Item__c.SobjectType.getDescribe().getKeyPrefix();
    
        Recordtypeid=ApexPages.CurrentPage().getParameters().get('RecordType');
        Recordtype rt=[SELECT ID, name FROM RecordType WHERE id =:Recordtypeid ];
        RecordtypeName=rt.Name;
    
    }
    
    // This method is used to retrieve all GLDepartments into dropdown list
    public List<selectOption> getGLDepartments() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c order by Name]) 
          {  
               optionList.add(new selectOption(gld.Id, gld.Name));  
          }
          return optionList;  
     }   
     // End of method getGLDepartments
    
    // This method is used to retrieve all GLCodes into dropdown list
    public List<selectOption> getGLCodes() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Code__c users : [SELECT Id,GL_Id__c,Name FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name]) 
          {  
               optionList.add(new selectOption(users.Id, users.GL_Id__c +' '+users.Name));  
          }
          return optionList;  
     }
     // End of method getGLCodes
     
     
      // This method is used to retrieve all CB Templates into dropdown list
    public List<selectOption> getCBTempName() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Specification_Template__c SpecsTemp: [SELECT Id,Name FROM Specification_Template__c  ORDER BY Name]) 
          {  
               optionList.add(new selectOption(SpecsTemp.Id, SpecsTemp.Name));  
          }
          return optionList;  
     }
     // End of method getCBTempName
     
     
        // This method is used to retrieve all PE Templates into dropdown list
    public List<selectOption> getPETempName() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Production_Estimate_Template__c PETemp: [SELECT Id,Name FROM Production_Estimate_Template__c  ORDER BY Name]) 
          {  
               optionList.add(new selectOption(PETemp.Id, PETemp.Name));  
          }
          return optionList;  
     }
     // End of method getPETempName
     
    
         // Save Method
        public PageReference saveme(){ 
                 
                 try
                    {  
                    
                        MI.GL_Department__c = GLDName;
                        MI.GL_Code__c = GLCName;
                        MI.Creative_Brief_Template__c=CBTemp;
                        MI.Production_Estimate_Template__c =PETemp;
                        insert MI;
                        Strid=MI.id;
                        
                    }catch(DMLException e)
                    {
                       ApexPages.addMessages(e);
                        return null;
                    }
                    
                 PageReference pageRef;   
                 if(isLtng)
                 {
                    pageRef = new Pagereference('/apex/MaterialLineDetailPageLightning?id='+strid);
                 }
                
                else
                 {
                   pageRef = new Pagereference('/apex/MaterialLineDetailPage?id='+strid);
                 } 
                    
                    
                    
                    
                 // PageReference pageRef = new PageReference('/apex/MaterialLineDetailPage?id='+Strid);//('/apex/MaterialLineDetailpage?id='+Strid);
                  pageRef.setRedirect(true);
                  return pageRef;
                  
                  
               }
            // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
        {       
            PageReference p =  new Pagereference('/'+MIprefix+'/o');
            p.setRedirect(true);
            return p;   
            
            
          //  return null;
          }
        // Cancel Method        
    
    
    

}