public without sharing class RecordUnlocker {
    
    final static String MESSAGE_SUCCESS = 'Record unlocked successfully.';
    final static String MESSAGE_ERROR = 'Failed to unlock the record. Error: ';
    
    @InvocableMethod(label='Unlock Record')
    public static ActionOutput[] execute(ActionInput[] inputs) {
        
        String[] recordIds = getRecordIds(inputs);

        Approval.UnlockResult[] urList = Approval.unlock(recordIds);

        ActionOutput[] outputs = new ActionOutput[]{};
        for (Approval.UnlockResult result : urList) {
            outputs.add(getOutputResult(result));
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

    private static ActionOutput getOutputResult(Approval.UnlockResult result) {
        ActionOutput output = new ActionOutput();

        output.isSuccess = result.isSuccess();
        output.message = result.isSuccess() ? MESSAGE_SUCCESS : MESSAGE_ERROR + result.getErrors().toString();
        
        return output;
    }
    
    public class ActionInput {
        @InvocableVariable(label='Record Id' required=true)
        public String recordId;
    }
    
    public class ActionOutput {
        @InvocableVariable(label='Is Success')
        public Boolean isSuccess;

        @InvocableVariable(label='Message')
        public String message;
    }
}
