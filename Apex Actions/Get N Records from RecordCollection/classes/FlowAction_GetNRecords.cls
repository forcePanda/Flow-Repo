/**
 * Description: Flow apex action to get first N records from a collection of records.
 */
public inherited sharing class FlowAction_GetNRecords {
    
    public class CustomException extends Exception {}
    
    @InvocableMethod(label='Get the first N records from a collection')
    public static ActionOutput[] getNRecordsFromCollection(ActionInput[] inputs) {

        ActionOutput[] outputs = new ActionOutput[]{};
        for(ActionInput input : inputs) {
            ActionOutput output = new ActionOutput();
            output.splicedRecordCollection = getSplicedCollection(
                input.recordsList,
                input.numberOfRecords
            );
            outputs.add(output);
        }

        return outputs;
    }

    private static SObject[] getSplicedCollection(SObject[] recordsList, Integer numberOfRecords) {
        
        SObject[] splicedRecordCollection = new SObject[]{};
        for(Integer i=0; i < Math.min(numberOfRecords, recordsList.size()); i++) {
            splicedRecordCollection.add(recordsList[i]);
        }
        return splicedRecordCollection;
    }
    
    /* Input parameters for the Apex action */
    public class ActionInput {

        @InvocableVariable(label='Number of Records' required=true)
        public Integer numberOfRecords;

        @InvocableVariable(label='Input Records Collection' required=true)
        public SObject[] recordsList;
    }
    
    /* Output parameters of the Apex action */
    public class ActionOutput {
        
        @InvocableVariable(label='Output Records Collection')
        public SObject[] splicedRecordCollection;
    }
}
