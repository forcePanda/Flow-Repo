/**
 * Description: Invocable action to upsert records.
 */
public inherited sharing class FlowAction_UpsertRecords {
    
    public class CustomException extends Exception {}
    
    @InvocableMethod(label='Upsert Record')
    public static ActionOutput[] initUpsert(ActionInput[] inputs) {


        SObject[] recordsList = new SObject[]{};
        for(ActionInput input : inputs) {
            recordsList.add(input.record);
        }

        Map<String,Database.UpsertResult> externalKeyToUpsertResultMap = upsertRecords(
            recordsList, 
            inputs[0].objectApiName, 
            inputs[0].externalIdField
        );

        return getActionOutputs(inputs, externalKeyToUpsertResultMap);
    }

    private static Map<String,Database.UpsertResult> upsertRecords(SObject[] recordsList, String objectApiName, String externalIdField) {

        Database.UpsertResult[] results = Database.upsert(
            recordsList, 
            getSObjectField(objectApiName, externalIdField)
        );

        Map<Id,SObject> recordsMap = new Map<Id,SObject>(recordsList);

        Map<String,Database.UpsertResult> externalKeyToUpsertResultMap = new Map<String,Database.UpsertResult>();
        for(Database.UpsertResult result : results) {
            externalKeyToUpsertResultMap.put((String)recordsMap.get(result.getId()).get(externalIdField), result);
        }
        return externalKeyToUpsertResultMap;
    }

    private static ActionOutput[] getActionOutputs(ActionInput[] inputs, Map<String,Database.UpsertResult> externalKeyToUpsertResultMap) {
        ActionOutput[] outputs = new ActionOutput[]{};
        for(ActionInput input : inputs) {
            
            Database.UpsertResult result = externalKeyToUpsertResultMap.get((String)input.record.get(input.externalIdField));

            ActionOutput output = new ActionOutput();
            output.recordId = result.getId();
            output.isSuccess = result.isSuccess();
            output.isCreated = result.isCreated();
            output.isUpdated = !result.isCreated();

            outputs.add(output);
        }
        return outputs;
    }

    private static Schema.SObjectField getSObjectField(String objectApiName, String fieldName) {
        return ((SObject)Type.forName('Schema',objectApiName).newInstance())
            .getSObjectType()
            .getDescribe(SObjectDescribeOptions.DEFERRED)
            .fields
            .getMap()
            .get(fieldName);
    }
    
    /* Input parameters for the Apex action */
    public class ActionInput {

        @InvocableVariable(label='Record' required=true)
        public SObject record;

        @InvocableVariable(label='Object API Name' required=true)
        public String objectApiName;

        @InvocableVariable(label='External Id Field(API name)' required=true)
        public String externalIdField;
    }
    
    /* Output parameters of the Apex action */
    public class ActionOutput {

        @InvocableVariable(label='Upsert Success?')
        public Boolean isSuccess;

        @InvocableVariable(label='Error(s)')
        public String errors;
        
        @InvocableVariable(label='Is Record Updated?')
        public Boolean isUpdated;

        @InvocableVariable(label='Is Record Created?')
        public Boolean isCreated;

        @InvocableVariable(label='Record ID')
        public String recordId;
    }
}
