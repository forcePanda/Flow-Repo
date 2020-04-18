@isTest
public class PicklistCMPControllerTest {
    
    testmethod static void testGetPicklistValues(){
        
        /* Testing Exceptions */
        //1. Invalid Object name 
        try{
            PicklistCMPController.getPicklistValues('InvalidObject', NULL, NULL);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        //2. Invalid Field Name
        try{
            PicklistCMPController.getPicklistValues('Opportunity', 'NULL', NULL);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        //3. Invalid default field value
        try{
            PicklistCMPController.getPicklistValues('Opportunity', 'StageName', '--Invalid--');
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        Test.startTest();
        	PicklistCMPController.getPicklistValues('Case', 'Status', 'Closed');
        Test.stopTest();
    }

}