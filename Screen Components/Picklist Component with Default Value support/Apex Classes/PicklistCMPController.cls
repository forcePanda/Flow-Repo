public class PicklistCMPController {
    
    public class AuraResponse{
        @AuraEnabled public string label; //Picklist Label
        @AuraEnabled public string value; //Picklist Value
    }
    
    @AuraEnabled(cacheable=true)
    public static AuraResponse[] getPicklistValues(string objectApiName, string fieldApiName, string defaultValue){
        
        //Check if Object API name, Controlling Field name and Dependent field name is invalid
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);
        if ( objType == NULL)
            throw new AuraHandledException('Error: Invalid Object API name.');
        
		Schema.sObjectField picklistField= objType.getDescribe().fields.getMap().get(fieldApiName);
		if( picklistField == NULL)
            throw new AuraHandledException('Error: Invalid Field API name.');
        
        AuraResponse[] picklistValuesList= new AuraResponse[]{};
        List<Schema.PicklistEntry> picklistEntries = ((SObject)Type.forName(objectApiName).newInstance()).getSObjectType().getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();
        boolean isDefaultValueValid = false;
        
        for( Schema.PicklistEntry pickVal : picklistEntries){
            if(string.isNotEmpty(defaultValue) && (pickVal.label == defaultValue || pickVal.value==defaultValue))
                isDefaultValueValid = true;
            AuraResponse picklist = new AuraResponse();
            picklist.label = pickVal.getLabel(); picklist.value = pickVal.getValue();
            pickListValuesList.add(picklist);
        }
        
        if( string.isNotEmpty(defaultValue) && !isDefaultValueValid)
            throw new AuraHandledException('Error: Invalid default value.');
        
        return pickListValuesList;
        
    }
}