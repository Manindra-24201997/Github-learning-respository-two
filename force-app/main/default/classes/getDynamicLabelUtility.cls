public with sharing class getDynamicLabelUtility {
    public static String getDescribedObjects( List<String> lstSObjectType ) {
        
        // Globally desribe all the objects 
        Map<String, SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        // Create a JSON string with object field labels and picklist values
        String allObjJSON = '{';
        
        // Iterate over the list of objects and describe each object  
        for( String sObjectType : lstSObjectType ) {
            
            if( allObjJSON != '{' ) 
                allObjJSON += ', ';
            allObjJSON += '"' + sObjectType + '": ';
            DescribeSObjectResult describeResult = globalDescribe.get(sObjectType).getDescribe();
            system.debug('>>>>>Obj Result>>>>>>>'+describeResult);
            Map<String, Schema.SObjectField> desribedFields = describeResult.fields.getMap();
            String objJSON = '{';
            system.debug('>>>>>desribedFields>>>>>>>'+desribedFields.keySet());
            for( String fieldName :  desribedFields.keySet() ) {
                
                // Descirbe the field 
                Schema.SObjectField field = desribedFields.get( fieldName );
                Schema.DescribeFieldResult f = field.getDescribe();	   
                if( objJSON != '{' )
                    objJSON += ', ';    
                // Get the field label and append in the JSON string
                objJSON += '"' + f.getName() + '": ' + '{ "label" : "' + f.getLabel() + '"';
                
                // if it's a picklist field then also add the picklist options
                /*  if( field.getDescribe().getType() == Schema.DisplayType.PICKLIST ){

List <Schema.PicklistEntry> picklistValues = field.getDescribe().getPickListValues();
List<String> pickListOptions = new List<String>();
pickListOptions.add('{ "label": "--None--", "value": null }');

for (Schema.PicklistEntry pe : picklistValues) { 
pickListOptions.add('{ "label": "' + pe.getLabel() + '", "value": "' + pe.getValue() + '" }');
}

System.debug( '>>>> ' + fieldName + '>>>> ' + String.join(pickListOptions, ', ') );
objJSON += ', "picklistOptions": [' + String.join(pickListOptions, ', ') + ']';   
} */
                objJSON += '}';
            }
            objJSON += '}';
            
            allObjJSON += objJSON;
        }
        
        // Close the object in the JSON String
        allObjJSON += '}';
        
        System.debug( ' JSON STRING : ' + allObjJSON );
        
        return allObjJSON;
    }
}