/**
 * Description: Test class for FlowAction_UpsertRecords class.
 */
@IsTest
private class FlowAction_UpsertRecordsTest {

    private static final String EXTERNAL_FIELD = System.Label.FlowAction_UpsertRecords_ExternalFieldName;

    @IsTest
    static void initUpsertTest_Success() {
        
        Account acc = new Account(
            Name = 'TestAccount'
        );
        acc.put(EXTERNAL_FIELD, '007');

        Test.startTest();
        FlowAction_UpsertRecords.ActionOutput[] outputs = FlowAction_UpsertRecords.initUpsert(getActionInputs(acc,'Account'));
        Test.stopTest();

        System.assertEquals(
            true, 
            outputs[0].isSuccess,
            'Upsert operation is expected to succeed.'
        );

        System.assertEquals(
            true, 
            outputs[0].isCreated,
            'Record is expected to be inserted and not updated.'
        );
    }

    private static FlowAction_UpsertRecords.ActionInput[] getActionInputs(SObject record, String objectApiName) {

        FlowAction_UpsertRecords.ActionInput input = new FlowAction_UpsertRecords.ActionInput();
        input.record = record;
        input.objectApiName = objectApiName;
        input.externalIdField = EXTERNAL_FIELD;

        return new FlowAction_UpsertRecords.ActionInput[]{input};
    }
}
