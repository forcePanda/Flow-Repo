@isTest
public class CustomFlowExceptionTest {
    @isTest
    static void testThrowCustomFlowExceptionMethod() {
        CustomFlowException.ActionInputs[] inputs = new CustomFlowException.ActionInputs[]{};
        CustomFlowException.ActionInputs input = new CustomFlowException.ActionInputs();
        input.message = 'Error message from Apex test.';
        inputs.add(input);

        Test.startTest();
        try {
            CustomFlowException.throwCustomFlowException(inputs);
        } catch (CustomFlowException ex) {
            System.assert(ex.getMessage() == input.message);
        }
        
        Test.stopTest();
    }
}
