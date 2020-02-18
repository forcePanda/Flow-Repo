@Istest
public with sharing class CloneRecordFlowActionClassTest {
    
    @TestSetup
    static void createData(){
        Account a1 = new Account(Name = 'Test Acc 1');
        Account a2 = new Account(Name = 'Test Acc 2');

        insert new Account[]{a1,a2};
    }

    testmethod static void testCloneRecordMethod(){
        
        CloneRecordFlowActionClass.FlowInputParameters[] inputParams = new CloneRecordFlowActionClass.FlowInputParameters[]{};
        for(Account a : [Select Id,Name from Account]){
            
            CloneRecordFlowActionClass.FlowInputParameters input = new CloneRecordFlowActionClass.FlowInputParameters();
            input.recordToClone = a;
            inputParams.add(input);
            
        }

        CloneRecordFlowActionClass.FlowOutputParameters[] response = new CloneRecordFlowActionClass.FlowOutputParameters[]{};

        Test.startTest();
            response = CloneRecordFlowActionClass.cloneRecord(inputParams);
        Test.stopTest();

        System.assert(response.size() == 2);

        Integer totalAccounts = [Select COUNT() FROM Account];

        System.assert(totalAccounts == 4);

    }
    
}
