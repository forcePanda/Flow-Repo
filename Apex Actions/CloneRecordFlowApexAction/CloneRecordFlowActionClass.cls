public class CloneRecordFlowActionClass {
    
    @InvocableMethod(label='Clone Record')
    public static FlowOutputParameters[] cloneRecord(FlowInputParameters[] input){
        FlowOutputParameters[] result = new FlowOutputParameters[]{};
        
        SObject[] recordsToClone = new SObject[]{};

        for(FlowInputParameters inputParam : input){
            SObject s = inputParam.recordToClone;
            s.put('Id',NULL); //Setting the 'Id' field of the record as NULL
            recordsToClone.add(s);
        }
        insert recordsToClone;

        for(SObject s : recordsToClone){
            FlowOutputParameters obj = new FlowOutputParameters();
            obj.clonedRecordId = (string)s.get('Id'); //Copying the inserted sObject record Id to return as an flow output
            result.add(obj);
        }
        return result;
    }
    
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        @InvocableVariable(label='Record to Clone' required = true )
        public sObject recordToClone;
    }
    
    /* Output parameters of the Apex action */
    public class FlowOutputParameters{
        @InvocableVariable(label='Cloned Record ID')
        public string clonedRecordId;
    }

}