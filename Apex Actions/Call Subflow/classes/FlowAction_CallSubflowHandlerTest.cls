@IsTest
public class FlowAction_CallSubflowHandlerTest {
    
    private static final String flowApiName = 'Dummy_Flow';
    private static final Map<String,Object> inputVariablesMap = new Map<String,Object>{
        'varText' => 'Flows are love!'
    };
    private static final String assertionFailMessagePrefix = 'FlowAction_CallSubflowHandlerTest Class Assertion Failed: ';

    @IsTest
    static void callSubflowTest(){

        FlowAction_CallSubflowHandler.FlowInput[] inputs = new FlowAction_CallSubflowHandler.FlowInput[]{};
        FlowAction_CallSubflowHandler.FlowInput input = new FlowAction_CallSubflowHandler.FlowInput();
        input.flowApiName = flowApiName;
        input.inputVariablesJSON = JSON.serialize(inputVariablesMap);
        inputs.add(input);

        Test.startTest();
        FlowAction_CallSubflowHandler.callSubflow(inputs);
        
        System.assertEquals(
            1, 
            Limits.getQueries(), 
            assertionFailMessagePrefix + 'Number of SOQL queries do not match.'
        );
        
        Test.stopTest();
        
    }

}
