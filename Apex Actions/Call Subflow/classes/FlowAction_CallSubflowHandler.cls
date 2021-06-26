public class FlowAction_CallSubflowHandler {
    
    @InvocableMethod(label = 'Call Subflow')
    public static void callSubflow(FlowInput[] inputs) {
        for(FlowInput input : inputs) {
            Map<String, Object> inputVariablesMap = new Map<String, Object>();
            if(!String.isEmpty(input.inputVariablesRecordVar)) {
                inputVariablesMap.put(input.inputVariablesRecordVar, input.inputVariablesRecord);
            }
            if(!String.isEmpty(input.inputVariablesStringVar)) {
                inputVariablesMap.put(input.inputVariablesStringVar, input.inputVariablesString);
            }
            if(!String.isEmpty(input.inputVariablesNumberVar)) {
                inputVariablesMap.put(input.inputVariablesNumberVar, input.inputVariablesNumber);
            }
            if(!String.isEmpty(input.inputVariablesJSON)) {
                inputVariablesMap.putAll((Map<String,Object>)JSON.deserializeUntyped(input.inputVariablesJSON));
            }
            startFlow(
                input.flowApiName,
                input.flowNamespace,
                inputVariablesMap
            );
        }
    }

    static void startFlow(String flowApiName, String namespace, Map<String,Object> inputVariablesMap) {
        Flow.Interview subflow;
        if(String.isEmpty(namespace)) {
            subflow = Flow.Interview.createInterview(flowApiName, inputVariablesMap);
        } else {
            subflow = Flow.Interview.createInterview(namespace, flowApiName, inputVariablesMap);
        }
        subflow.start();
    }

    public class FlowInput {
        @InvocableVariable(label='Flow API name' description='Make sure the flow is active.')
        public String flowApiName;


        @InvocableVariable(label='Record variable to pass to Flow' description='Use this input for passing a single record (optional, but be sure to set the variable name below if used)')
        public sObject inputVariablesRecord;
        @InvocableVariable(label='Name of record variable' description='The variable name from the flow to use with this Record')
        public String inputVariablesRecordVar;

        @InvocableVariable(label='String to pass to Flow' description='optional, but be sure to set the variable name below if used')
        public String inputVariablesString;
        @InvocableVariable(label='Name of string variable' description='The variable name from the flow to use with this string')
        public String inputVariablesStringVar;

        @InvocableVariable(label='Number to pass to Flow' description='optional, but be sure to set the variable name below if used')
        public Decimal inputVariablesNumber;
        @InvocableVariable(label='Name of number variable' description='The variable name from the flow to use with this number')
        public String inputVariablesNumberVar;

        @InvocableVariable(label='JSON of Input Variables' description='Use this input for more complex inputs (optional)')
        public String inputVariablesJSON;

        @InvocableVariable(label='Flow Namespace' description='Leave blank if the flow does not have a namespace.')
        public String flowNamespace;
    }

}