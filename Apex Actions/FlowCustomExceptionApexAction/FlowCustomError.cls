/* Class definition for throwing custom exceptions via Apex actions in Flows */
public class FlowCustomError {
    
    public class CustomException extends Exception {}
    
    @InvocableMethod(label='Throw Custom Flow Exception')
    public static void throwCustomFlowException(Inputs[] input){
        throw createCustomException(input[0].message);
    }
    
    public class Inputs{
        @InvocableVariable(label='Error message')
        public string message;
    }  

    static CustomException createCustomException(String message) {
        CustomException ex = new CustomException(message);
        ex.setMessage(message);
        return ex;
    }
}