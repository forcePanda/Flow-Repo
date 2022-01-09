@IsTest
private class MassFileDownloaderControllerTest {
    
    @TestSetup
    static void createData() {
        ContentVersion cv = new ContentVersion(
            Title = 'DemoFile',
            VersionData = Blob.valueOf('Random String Data'),
            PathOnClient = 'DemoFile.png'
        );
        insert cv;
    }

    @IsTest
    static void getFilesTest() {
        
        Test.startTest();
        System.assertEquals(
            1, 
            MassFileDownloaderController.getFiles().size(),
            'Expected number of files does not match the expected count.'
        );
        Test.stopTest();
    }

    @IsTest
    static void getFilesByIdsTest() {
        
        Id demoFileId = [SELECT Id FROM ContentDocument WHERE Title = 'DemoFile'].Id;

        Test.startTest();
        System.assertEquals(
            1, 
            MassFileDownloaderController.getFilesByIds(new String[] {demoFileId}).size(),
            'Expected number of files does not match the expected count.'
        );
        Test.stopTest();
    }
}
