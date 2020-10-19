public class GetOldRecordFlowAction {

    public class CustomException extends Exception {}

    @InvocableMethod(label='Get Old Record')
    public static FlowOutput[] getOldRecord(FlowInput[] inputs) {

        FlowOutput[] outputs = new FlowOutput[]{};
        for(FlowInput input : inputs) {
            FlowOutput output = new FlowOutput();
            output.oldRecord = AccountTriggerHandler.oldMap.get(input.recordId);
            outputs.add(output);
        }
        return outputs;

    }

    public class FlowInput {
        @InvocableVariable
        public String recordId;
    }

    public class FlowOutput {
        @InvocableVariable
        public SObject oldRecord;
    }
    
}
