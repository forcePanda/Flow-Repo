public without sharing class RecordLocker {
    
    final static String MESSAGE_SUCCESS = 'Record locked successfully.';
    final static String MESSAGE_ERROR = 'Failed to lock the record. Error: ';
    
    @InvocableMethod(label='Lock Record')
    public static ActionOutput[] execute(ActionInput[] inputs) {
        
        String[] recordIds = getRecordIds(inputs);

        Approval.LockResult[] lrList = Approval.lock(recordIds, true);

        ActionOutput[] outputs = new ActionOutput[]{};
        for(Approval.LockResult result : lrList) {
            outputs.add(
                getOutputResult(result)
            );
        }        
        return outputs;
    }

    private static String[] getRecordIds(ActionInput[] inputs) {
        String[] recordIds = new String[]{};
        for (ActionInput input : inputs) {
            recordIds.add(input.recordId);
        }
        return recordIds;
    }

    private static ActionOutput getOutputResult(Approval.LockResult result) {
        ActionOutput output = new ActionOutput();

        output.isSuccess = result.isSuccess();
        output.message = result.isSuccess() ? MESSAGE_SUCCESS : MESSAGE_ERROR; + result.getErrors().toString();
        return output;
    }
    
    /* Input parameters for the LockRecord action */
    public class ActionInput {
        @InvocableVariable(label='Record Id' required=true)
        public String recordId;
    }
    
    /* Output parameters of the LockRecord action */
    public class ActionOutput {
        @InvocableVariable(label='Is Success')
        public Boolean isSuccess;

        @InvocableVariable(label='Message')
        public String message;
    }
}
