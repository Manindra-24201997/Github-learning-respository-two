public with sharing class StoreFrontTabPage {

  // Global Variables
    public String tabInFocus{get;set;}
    String intTabFocus;
    // End of Global variables 
    
    // Start Constructor 
    public StoreFrontTabPage () 
    {
        intTabFocus = System.currentPageReference().GetParameters().get('intFocus');
        
        if(intTabFocus=='1')
        {
            tabInFocus = 'Jobs';
        }
        if(intTabFocus=='2')
        {
            tabInFocus = 'Billboards';
        }
        if(intTabFocus=='3')
        {
            tabInFocus = 'MaterialItems';
        }
        
        
    }
    // End of Contstructor 
}