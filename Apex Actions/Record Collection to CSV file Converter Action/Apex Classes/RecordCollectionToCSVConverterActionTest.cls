@isTest
public with sharing class RecordCollectionToCSVConverterActionTest {
    
    @testSetup
    static void createData(){

        Account[] lstAccounts = new Account[]{
            new Account(Name = 'CSV Acc1', AnnualRevenue = NULL, AccountNumber = '', NumberOfEmployees = NULL, Rating = 'Hot'),
            new Account(Name = 'CSV Acc2', AnnualRevenue = 1000, AccountNumber = '911', NumberOfEmployees = 0, Rating = 'Warm'),
            new Account(Name = 'CSV Acc3', AnnualRevenue = 911007, AccountNumber = '007',NumberOfEmployees = 10,Rating = 'Cold')
        };

        insert lstAccounts;
        
    }

    @isTest
    static void testRecordCollectionToCSVConverterMethod(){
        
        RecordCollectionToCSVConverterAction.FlowActionInput[] lstInputs = createFlowInputsList();
        
        Test.startTest();
        RecordCollectionToCSVConverterAction.recordCollectionToCSVConverter(lstInputs);
        Test.stopTest();

        ContentVersion uploadedCSV = [SELECT Id,Title,FileExtension FROM ContentVersion];

        System.assert(uploadedCSV != NULL, 'No file found');
        System.assert(uploadedCSV.Title == lstInputs[0].strFileTitle, 'File not found: '+lstInputs[0].strFileTitle);
        System.assert(uploadedCSV.FileExtension == 'csv', 'Uploaded file not of CSV type');
        
    }

    @isTest
    static void TestGetFieldApiNameToLabelMapException(){

        RecordCollectionToCSVConverterAction.FlowActionInput[] lstInputs = createFlowInputsList();
        lstInputs[0].strObjectApiName='InvalidObject';
        Test.startTest();
        try {
            RecordCollectionToCSVConverterAction.recordCollectionToCSVConverter(lstInputs);
        } catch (Exception e) {
            System.assert(
                e.getMessage() == 'Error: Invalid Object API name.', 
                'Exception message mismatch!'
            );
        }
        Test.stopTest();
        
    }

    static RecordCollectionToCSVConverterAction.FlowActionInput[] createFlowInputsList(){
        
        RecordCollectionToCSVConverterAction.FlowActionInput[] flowInputs = new RecordCollectionToCSVConverterAction.FlowActionInput[]{};
        RecordCollectionToCSVConverterAction.FlowActionInput input = new RecordCollectionToCSVConverterAction.FlowActionInput();
        input.strObjectApiName = 'Account';
        input.lstRecords = Database.query(getQuery(input.strObjectApiName));
        input.strFileTitle = 'Accounts List';
        input.boolAddTimeStamp = false;
        flowInputs.add(input);

        return flowInputs;
    }

    static String getQuery(String strObjectApiName) {
        String strQuery = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(strObjectApiName).getDescribe().fields.getMap();

        for(String fieldApiName : objectFields.keySet()) {
            strQuery += ' ' + fieldApiName + ', ';
        }
        strQuery = strQuery.subString(0,strQuery.trim().Length()-1); // Removing the last comma

        strQuery += ' FROM ' + strObjectApiName;
        
        return strQuery;
    }

}
