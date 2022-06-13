@IsTest
private class INClauseFilterActionTest {

    @TestSetup
    static void createData() {
        insert new Account[]{
            new Account(Name = 'A', Rating = 'A', Site = 'US', Sic = '111'),
            new Account(Name = 'B', Rating = 'B', Site = 'US', Sic = '111'),
            new Account(Name = 'C', Rating = 'C', Site = 'US', Sic = '000'),
            new Account(Name = 'D', Rating = 'D', Site = 'DE', Sic = '999'),
            new Account(Name = 'E', Rating = 'E', Site = 'DE', Sic = '000')
        };
    }

    @IsTest
    static void filterRecordsTest() {

        INClauseFilterAction.ActionInput[] inputList = new INClauseFilterAction.ActionInput[]{};
        INClauseFilterAction.ActionOutput[] outputList = new INClauseFilterAction.ActionOutput[]{};

        /* Preparing Flow Action input list */
        INClauseFilterAction.ActionInput input1 = new INClauseFilterAction.ActionInput();
        input1.objectApiName = 'Account';
        input1.fieldsToQuery = 'Id,Name,Rating';
        input1.filterField = 'Rating';
        input1.filterValues = new String[]{'A','B','C'};
        input1.additionalFilters = 'Site = US; Sic = 111';
        
        INClauseFilterAction.ActionInput input2 = new INClauseFilterAction.ActionInput();
        input2.objectApiName = 'Account';
        input2.fieldsToQuery = 'Id,Name,Rating';
        input2.filterField = 'Rating';
        input2.filterValues = new String[]{'B','C'};
        input2.additionalFilters = 'Site=US; Sic =000';
        
        INClauseFilterAction.ActionInput input3 = new INClauseFilterAction.ActionInput();
        input3.objectApiName = 'Account';
        input3.fieldsToQuery = 'Id,Name,Rating';
        input3.filterField = 'Rating';
        input3.filterValues = new String[]{'D','E'};
        input3.additionalFilters = 'Site=US; Sic=000';
        
        inputList.add(input1);
        inputList.add(input2);
        inputList.add(input3);
        
        Test.startTest();
            outputList = INClauseFilterAction.filterRecords(inputList);
        Test.stopTest();

        System.assert(outputList[0].records.size() == 2);
        System.assert(outputList[1].records.size() == 1);
        System.assert(outputList[2].records.size() == 0);
    }

    @IsTest
    static void filterRecordsTest_WithoutAdditionalFilters() {

        INClauseFilterAction.ActionInput[] inputList = new INClauseFilterAction.ActionInput[]{};
        INClauseFilterAction.ActionOutput[] outputList = new INClauseFilterAction.ActionOutput[]{};

        /* Preparing Flow Action input list */
        INClauseFilterAction.ActionInput input1 = new INClauseFilterAction.ActionInput();
        input1.objectApiName = 'Account';
        input1.fieldsToQuery = 'Id,Name,Rating';
        input1.filterField = 'Rating';
        input1.filterValues = new String[]{'A','B','C'};

        inputList.add(input1);
        
        Test.startTest();
            outputList = INClauseFilterAction.filterRecords(inputList);
        Test.stopTest();

        System.assert(outputList[0].records.size() == 3);
    }
}