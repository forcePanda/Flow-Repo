@IsTest
public class FlowAction_CreateContentVersionTest {

    @TestSetup
    static void createData(){
        insert new Account(
            Name = 'DummyAccount'
        );
    }
    
    @IsTest
    static void createFileTest(){
        String accountId = [SELECT Id FROM Account WHERE Name = 'DummyAccount'].Id;
        FlowAction_CreateContentVersion.FlowInput[] inputs = new FlowAction_CreateContentVersion.FlowInput[]{};
        inputs.add(createFlowInput('DummyNote', 'SNOTE', 'DummyNote\'sText', accountId));
        inputs.add(createFlowInput('DummyPNG', 'PNG', 'RandomText', ''));

        Test.startTest();
        FlowAction_CreateContentVersion.createFile(inputs);
        Test.stopTest();

        System.assertEquals( 
            1, 
            [SELECT Id FROM ContentDocument WHERE FileType = 'SNOTE'].size(),
            'Unexpected count of NOTE type files.'
        );

        System.assertEquals( 
            1, 
            [SELECT Id FROM ContentDocument WHERE FileType = 'PNG'].size(),
            'Unexpected count of PNG type files.'
        );
        
    }

    static FlowAction_CreateContentVersion.FlowInput createFlowInput( String title, String fileExtension, String data, String parentId) {

        FlowAction_CreateContentVersion.FlowInput input = new FlowAction_CreateContentVersion.FlowInput();
        input.title = title;
        input.fileExtension = fileExtension;
        input.data = data;
        if(String.isNotEmpty(parentId)) {
            input.parentId = parentId;
        }

        return input;

    }

}
