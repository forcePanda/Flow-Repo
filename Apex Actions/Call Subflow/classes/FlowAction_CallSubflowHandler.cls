public class FlowAction_CallSubflowHandler {
    
    @InvocableMethod(label = 'Call Subflow')
    public static void callSubflow(FlowInput[] inputs) {
        for(FlowInput input : inputs) {
            Map<String,Object> inputVariablesMap = (Map<String,Object>)JSON.deserializeUntyped(input.inputVariablesJSON);
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
        @InvocableVariable(label='JSON of Input Variables')
        public String inputVariablesJSON;

        @InvocableVariable(label='Flow API name' description='Make sure the flow is active.')
        public String flowApiName;

        @InvocableVariable(label='Flow Namespace' description='Leave blank if the flow does not have a namespace.')
        public String flowNamespace;
    }

}