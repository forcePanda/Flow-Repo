@IsTest
public class GetSObjectFieldValueActionTest {
    
    @IsTest
    static void getDynamicSObjectFieldValueTest() {

        Account dummyAcc = new Account(
            Name = 'DummyAccount',
            AnnualRevenue = 100.0,
            NumberOfEmployees = 5
        );
        insert dummyAcc;
        dummyAcc = [SELECT Id,Name, AnnualRevenue, NumberOfEmployees, LastActivityDate, CreatedDate FROM Account WHERE Id = :dummyAcc.Id];
        GetSObjectFieldValueAction.ActionInput[] actionInputs = getFlowActionInputs(
            dummyAcc, 
            'Account',
            new String[]{'Name', 'AnnualRevenue','NumberOfEmployees', 'LastActivityDate', 'CreatedDate' }
        );

        Test.startTest();
        GetSObjectFieldValueAction.ActionOutput[] outputs = GetSObjectFieldValueAction.getDynamicSObjectFieldValue(actionInputs);
        Test.stopTest();

        System.assertEquals(dummyAcc.Name, outputs[0].stringOutput,'Unexpected string output.');

        System.assertEquals(dummyAcc.AnnualRevenue, outputs[1].currencyOutput,'Unexpected currency output.');

        System.assertEquals(dummyAcc.NumberOfEmployees, outputs[2].numberOutput,'Unexpected number output.');

        System.assertEquals(dummyAcc.LastActivityDate, outputs[3].dateOutput,'Unexpected date output.');
        
        System.assertEquals(dummyAcc.CreatedDate, outputs[4].datetimeOutput,'Unexpected datetime output.');
    }

    @IsTest
    static void exceptionTest() {
        
        GetSObjectFieldValueAction.ActionInput[] actionInputs = getFlowActionInputs(
            new Account(),
            'Account', 
            new String[]{'InvalidName'}
        );

        Test.startTest();

        try {
            GetSObjectFieldValueAction.getDynamicSObjectFieldValue(actionInputs);
        } catch (GetSObjectFieldValueAction.CustomException ex) {
            System.assert(
                ex.getMessage().contains('Invalid Field'), 
                'Exception message is expected to contain \'Invalid Field\' phrase.'
            );
        }
        
        Test.stopTest();
    }

    static GetSObjectFieldValueAction.ActionInput[] getFlowActionInputs(
        SObject record,
        String objectApiName,
        String[] fieldApiNames
    ) {
        GetSObjectFieldValueAction.ActionInput[] actionInputs = new GetSObjectFieldValueAction.ActionInput[]{};
        
        for(String fieldName : fieldApiNames) {
            GetSObjectFieldValueAction.ActionInput input = new GetSObjectFieldValueAction.ActionInput();
            input.record = record;
            input.objectApiName = objectApiName;
            input.fieldApiName = fieldName;

            actionInputs.add(input);
        }


        return actionInputs;
    }
}
