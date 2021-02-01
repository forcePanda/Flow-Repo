public class GetSObjectFieldValueAction {

    public class CustomException extends Exception {}
    
    @InvocableMethod(label='Dynamically Retrieve Record\'s field value')
    public static ActionOutput[] getDynamicSObjectFieldValue(ActionInput[] inputs) {

        SObjectType sObjType = ((SObject)Type.forName(inputs[0].objectApiName).newInstance()).getSObjectType();
        Map<String,SObjectField> sObjectFieldMap = sObjType.getDescribe().fields.getMap();

        ActionOutput[] outputs = new ActionOutput[]{};
        for(ActionInput input : inputs) {

            Schema.DisplayType fieldType = getFieldType(sObjectFieldMap, input.fieldApiName);

            ActionOutput output = getFieldValue(fieldType, input.record, input.fieldApiName);
            outputs.add(output);
        }

        return outputs;
    }
    
    static ActionOutput getFieldValue(Schema.DisplayType fieldType, SObject record, String fieldApiName){
        
        ActionOutput output = new ActionOutput();
        Object fieldValue = record.get(fieldApiName);

        if(fieldValue == NULL) {
            return output;
        }

        if(
            fieldType == Schema.DisplayType.EMAIL ||
            fieldType == Schema.DisplayType.MULTIPICKLIST ||
            fieldType == Schema.DisplayType.PHONE ||
            fieldType == Schema.DisplayType.PICKLIST ||
            fieldType == Schema.DisplayType.STRING ||
            fieldType == Schema.DisplayType.TEXTAREA ||
            fieldType == Schema.DisplayType.URL
        ) {
            output.stringOutput = (String) fieldValue;
            return output;
        }

        switch on fieldType {//Setting Field value based on the field data type
            when BOOLEAN {
                output.booleanOutput = (Boolean) fieldValue;
            }
            when CURRENCY {
                output.currencyOutput =(Decimal) fieldValue;
            }
            when INTEGER {
                output.numberOutput = (Integer) fieldValue;
            }
            when DATE {
                output.dateOutput = (Date) fieldValue;
            }
            when DATETIME {
                output.datetimeOutput = (DateTime) fieldValue;
            }
        }
        return output;
    }

    @TestVisible
    static Schema.DisplayType getFieldType(Map<String, SObjectField> fieldMap, String fieldApiName) {
        if(fieldMap.get(fieldApiName) == null) {
            throw new CustomException('Invalid Field Error: '+fieldApiName + '. Please double check the API name of the field.');
        }
        return fieldMap.get(fieldApiName).getDescribe().getType();
    }

    /* Input parameters for the Apex action */
    public class ActionInput {

        @InvocableVariable(label='SObject Record' required=true )
        public SObject record;

        @InvocableVariable(label='SObject API Name' required=true )
        public String objectApiName;
        
        @InvocableVariable(label='Field API Name' required=true )
        public String fieldApiName;
    }
    
    /* Output parameters of the Apex action */
    public class ActionOutput {
        
        @InvocableVariable(label='String Output')
        public String stringOutput;
        
        @InvocableVariable(label='Number Output')
        public Decimal numberOutput;

        @InvocableVariable(label='Boolean Output')
        public Boolean booleanOutput;

        @InvocableVariable(label='Date Output')
        public Date dateOutput;
        
        @InvocableVariable(label='DateTime Output')
        public DateTime datetimeOutput;
        
        @InvocableVariable(label='Currency Output')
        public Decimal currencyOutput;
    }
}
