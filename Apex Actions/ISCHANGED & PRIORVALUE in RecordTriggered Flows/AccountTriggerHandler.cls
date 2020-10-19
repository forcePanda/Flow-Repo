public class AccountTriggerHandler {
    
    public static Map<Id,SObject> oldMap;

    public AccountTriggerHandler() {
        if(
            Trigger.isExecuting && 
            (Trigger.isUpdate || Trigger.isDelete)
        ) {
            initOldMap(Trigger.oldMap);
        }
    }

    public static Map<Id,SObject> getOldMap() {
        return oldMap;
    }

    static void initOldMap(Map<Id,SObject> oldRecordMap) {
        if(oldMap != NULL) {
            return;
        }
        oldMap = oldRecordMap;
    }




}
