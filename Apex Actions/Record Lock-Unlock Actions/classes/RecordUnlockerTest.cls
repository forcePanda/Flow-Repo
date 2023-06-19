@IsTest
public class RecordUnlockerTest {
    
    @IsTest
    static void testExecute() {

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Approval.lock(testAccount.Id);
        
        Test.startTest();
        RecordUnlocker.ActionOutput[] outputs = RecordUnlocker.execute(createInputs(testAccount.Id));
        Test.stopTest();

        Assert.areEqual(true, outputs[0].isSuccess, 'Record unlock should be successful');
    }

    static RecordUnlocker.ActionInput[] createInputs(String recordId) {
        RecordUnlocker.ActionInput[] inputs = new RecordUnlocker.ActionInput[]{};
        RecordUnlocker.ActionInput input = new RecordUnlocker.ActionInput();
        input.recordId = recordId;
        inputs.add(input);
        return inputs;
    }
}
