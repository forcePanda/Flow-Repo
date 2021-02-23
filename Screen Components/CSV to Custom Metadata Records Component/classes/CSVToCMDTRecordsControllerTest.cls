/**
 * Description: Test class for CSVToCMDTRecordsController class.
 */
@IsTest
public class CSVToCMDTRecordsControllerTest {

    static String cmdtApiName = 'DummyCMDTType__mdt';

    @IsTest
    static void insertCMDTRecordsTest() {

        String contentDocumentId = createFile(
            createCSVBlob(),
            NULL
        );
        
        String deployRequestJobId;
        
        try {
            deployRequestJobId = CSVToCMDTRecordsController.insertCMDTRecords(contentDocumentId, cmdtApiName);
            System.assert(false, 'Test is expected to fail');
        } catch (Exception ex) {
            System.assertEquals(
                NULL, 
                deployRequestJobId,
                'deployRequestJobId variable is expected to be null.'
            );

            System.assertEquals(
                'System.AuraHandledException',
                ex.getTypeName(),
                'Wrong exception type received.'
            );

            System.assert( 
                ex.getMessage().contains('Metadata cannot be deployed from within a test'),
                'Exception message does not contain the expected error.'
            );
        }
        
        String[] csvrows = CSVToCMDTRecordsController.getCSVContentAsRows(
            CSVToCMDTRecordsController.getCSVContent(contentDocumentId)
        );
        
        Metadata.DeployContainer mdContainer = CSVToCMDTRecordsController.createCMDTRecordsList(
            cmdtApiName, 
            csvrows, 
            csvrows.remove(0).split(',')
        );

        List<Metadata.Metadata> contents = mdContainer.getMetadata();
        System.assertEquals(3, contents.size());
        Metadata.CustomMetadata cmdtRecord1 = (Metadata.CustomMetadata) contents.get(0);
        Metadata.CustomMetadata cmdtRecord2 = (Metadata.CustomMetadata) contents.get(1);
        Metadata.CustomMetadata cmdtRecord3 = (Metadata.CustomMetadata) contents.get(2);

        System.assertEquals(
            cmdtApiName + '.' + 'DevName1', 
            cmdtRecord1.fullName, 
            'cmdtRecord1 name does not match.'
        );

        System.assertEquals(
            cmdtApiName + '.' + 'DevName2', 
            cmdtRecord2.fullName, 
            'cmdtRecord2 name does not match.'
        );

        System.assertEquals(
            cmdtApiName + '.' + 'DevName3', 
            cmdtRecord3.fullName, 
            'cmdtRecord3 name does not match.'
        );   
    }

    @IsTest
    static void handleResultTest() {

        Metadata.DeployCallback deploymentCallback = new CSVToCMDTRecordsController();
        
        Metadata.DeployResult result = new Metadata.DeployResult();
        result.status = Metadata.DeployStatus.Succeeded;
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
        
        // Invoke the callback's handleResult method.
        deploymentCallback.handleResult(result, context);
        
        System.assertEquals(
            1, 
            CSVToCMDTRecordsController.eventsToPublish.size(), 
            '# of events to be fired does not match.'
        );

        System.assertEquals(
            'succeeded', 
            CSVToCMDTRecordsController.eventsToPublish[0].Status__c, 
            'Platform event status does not match.'
        );
    }

    @IsTest
    static void metadataDeploymentResultEventPublishExceptionTest() {
        
        Metadata.DeployCallback deploymentCallback = new CSVToCMDTRecordsController();
        
        Metadata.DeployResult result = new Metadata.DeployResult();
        result.errorMessage = generateRandomString(20);
        result.status = Metadata.DeployStatus.Failed;
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
        
        try {
            deploymentCallback.handleResult(result, context);
            System.assert(false,'Method is expected to fail');
        } catch (Exception ex) {
            System.assert(
                ex.getMessage().contains('Value too long'), 
                'Exception does not contain the expected error message.'
            );
        }
    }

    @IsTest
    static void invalidFieldAPINameExceptionTest() {
        
        String contentDocumentId = createFile(
            Blob.valueOf('InvalidAPIFieldName'),
            NULL
        );

        try {
            CSVToCMDTRecordsController.insertCMDTRecords(contentDocumentId, cmdtApiName);
            System.assert(false, 'Test is expected to fail');
        } catch (Exception ex) {

            System.assertEquals(
                'System.AuraHandledException',
                ex.getTypeName(),
                'Wrong exception type received.'
            );

            System.assert(
                ex.getMessage().contains('Invalid Field Error'),
                'Exception does not contain the expected error message.'
            );
        }
        
    }

    static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    static String createFile(Blob fileData, String relatedRecordId) {
        
        ContentVersion cv = new ContentVersion(
            Title = 'CMDTRecordsCSVFile',
            VersionData = fileData,
            PathOnClient = 'CMDTRecordsCSVFile.csv'
        );
        insert cv;

        String contentDocId = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        if(String.isEmpty(relatedRecordId)) {
            return contentDocId;
        }
        
        insert new ContentDocumentLink(
            LinkedEntityId = relatedRecordId,
            ContentDocumentId = contentDocId
        );

        return contentDocId;
    }    

    static Blob createCSVBlob() {
        
        String csvHeader = 'DeveloperName,MasterLabel,BooleanField__c,DateField__c,DateTimeField__c,EmailField__c,TextField__c,NumberField__c,PhoneField__c,PicklistField__c' + '\n';
        String row1 = 'DevName1,Label1,,2020-12-23 00:00:00,2020-12-23 23:45:00,Label1@cmdt.com,Id_1,100.0,Phone1,Value1' + '\n';
        String row2 = 'DevName2,Label2,true,2021-02-06 00:00:00,2021-02-06 00:00:00,Label2@cmdt.com,CSVToCMDTRecordsController,99.99,Phone2,Value2' + '\n';
        String row3 = 'DevName3,Label3,false,2021-03-07 00:00:00,2021-02-06 14:20:00,Label3@cmdt.com,CSVToCMDTRecordsController,1,Phone3,Value3';
        
        return Blob.valueOf(csvHeader + row1 + row2 + row3);
    }
}
