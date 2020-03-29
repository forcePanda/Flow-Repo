/* Class definition for throwing custom exceptions via Apex actions in Flows */
public class CustomFlowException extends Exception {
    
    @InvocableMethod(label='Throw Custom Exception')
    public static void throwCustomFlowException(ActionInputs[] inputs){
        throw createCustomException(inputs[0].message);
    }
    
    public class ActionInputs{
        @InvocableVariable
        public string message;
    }

    static CustomFlowException createCustomException(String message) {
        CustomFlowException ex = new CustomFlowException(message);
        ex.setMessage(message);
        return ex;
    }
    
}