@IsTest
private class RecordLockerTest {

    @IsTest
    static void testLockRecord() {

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Test.startTest();
        RecordLocker.ActionOutput[] outputs = RecordLocker.execute(createInputs(testAccount.Id));
        Test.stopTest();

        // Verify the result
        Assert.areEqual(
            true,
            outputs[0].isSuccess,
            'Record is expected to be locked successfully.'
        );
    }

    static RecordLocker.ActionInput[] createInputs(String recordId) {
        RecordLocker.ActionInput[] inputs = new RecordLocker.ActionInput[]{};
        RecordLocker.ActionInput input = new RecordLocker.ActionInput();
        input.recordId = recordId;
        inputs.add(input);
        return inputs;
    }
}
