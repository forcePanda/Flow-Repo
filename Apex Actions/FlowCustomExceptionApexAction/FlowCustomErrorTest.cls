@IsTest
public class FlowCustomErrorTest {

    @isTest
    static void testFlowCustomError() {
        FlowCustomError.Inputs[] inputs = new FlowCustomError.Inputs[]{};
        FlowCustomError.Inputs input = new FlowCustomError.Inputs();
        input.message = 'Error message from Apex test.';
        inputs.add(input);

        Test.startTest();
        try {
            FlowCustomError.throwCustomFlowException(inputs);
        } catch (FlowCustomError.CustomException ex) {
            System.assert(ex.getMessage() == input.message);
        }
        
        Test.stopTest();
    }
    
}
