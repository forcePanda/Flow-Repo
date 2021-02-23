/**
 * Description: Controller class for FSC_CSVToCMDTRecords component.
 */
public class CSVToCMDTRecordsController implements Metadata.DeployCallback {
   
    final static Integer MAX_PAYLOAD_LENGTH = 130000; //Deduced from length of Payload__c field of MetadataDeploymentResult__e event. 1072 characters are for buffer.

    static Map<String,SObjectField> cmdtFieldsMap;
    static Map<String,Schema.DisplayType> fieldToFieldTypeMap;

    @TestVisible
    static MetadataDeploymentResult__e[] eventsToPublish = new MetadataDeploymentResult__e[]{};
    
    @AuraEnabled
    public static String insertCMDTRecords(String contentDocumentId, String cmdtApiName) {

        cmdtFieldsMap = getSObjectFieldMap(cmdtApiName);

        String csvContent = getCSVContent(contentDocumentId);
        
        String[] csvRows = getCSVContentAsRows(csvContent);
        String[] fieldsList = getCSVColumnHeadersAsFields(csvRows[0]);

        csvRows.remove(0); //Remove the header row containing field names

        fieldToFieldTypeMap = getFieldToFieldTypeMap(cmdtFieldsMap, fieldsList);

        try {
            Id jobId = Metadata.Operations.enqueueDeployment(
                createCMDTRecordsList(cmdtApiName, csvRows, fieldsList), 
                new CSVToCMDTRecordsController()
            );            
            return jobId;
        } catch (Exception ex) {
            throw createAuraHandledException(ex.getMessage());
        }
    }

    public static Metadata.DeployContainer createCMDTRecordsList(String cmdtApiName, String[] csvRows, String[] fieldsList) {

        Metadata.DeployContainer deploymentContainer = new Metadata.DeployContainer();
        for(String row : csvRows) {

            Map<String,String> fieldToValueMap = new Map<String,String>();
            
            String[] fieldInputValues = row.split(',');
            
            for (Integer i = 0; i < fieldsList.size(); i++) {
                fieldToValueMap.put(fieldsList[i],fieldInputValues[i]);
            }
            deploymentContainer.addMetadata(createCMDTRecord(cmdtApiName, fieldToValueMap));
        }

        return deploymentContainer;
    }

    public static Metadata.CustomMetadata createCMDTRecord(String cmdtApiName, Map<String,String> fieldToValueMap ) {
        
        Metadata.CustomMetadata cmdtRecord = new Metadata.CustomMetadata();
        cmdtRecord.fullName = cmdtApiName + '.' + fieldToValueMap.get('DeveloperName');
        cmdtRecord.label = fieldToValueMap.get('MasterLabel');

        fieldToValueMap.remove('MasterLabel');
        fieldToValueMap.remove('DeveloperName');

        for (String field : fieldToValueMap.keySet()) {
            Metadata.CustomMetadataValue cmdtValue = new Metadata.CustomMetadataValue();
            cmdtValue.Field = field;
            cmdtValue.Value = getConvertedFieldValue(
                fieldToFieldTypeMap.get(field),
                fieldToValueMap.get(field)
            ); 
            cmdtRecord.values.add(cmdtValue);
        }
        return cmdtRecord;
    }

    /**
     * Interface method to handle the callback from the Metadata deployment
     */
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        
        this.publishMetadataDeploymentResultEvent(result);
    }

    public void publishMetadataDeploymentResultEvent(Metadata.DeployResult result) {
        
        MetadataDeploymentResult__e deployResultEvent = new MetadataDeploymentResult__e(
            JobId__c = result.id,
            Status__c = String.valueOf(result.status).toLowerCase(),
            Payload__c = getEventPayload(JSON.serialize(result)),
            DummyField__c = result.errorMessage
        );
        eventsToPublish.add(deployResultEvent);

        List<Database.SaveResult> results = EventBus.publish(eventsToPublish);

        Database.SaveResult sr = results[0];
        if(!sr.isSuccess()) {
            String error = 'Error firing MetadataDeploymentResult__e event.\n' + JSON.serialize(sr.getErrors());
            System.debug(error);
            throw createCustomException(error);
        }

    }

    static String getEventPayload(String stringifiedPayload) {
        if(stringifiedPayload.length() > MAX_PAYLOAD_LENGTH) {
            stringifiedPayload = stringifiedPayload.substring(0,MAX_PAYLOAD_LENGTH);
            stringifiedPayload += '\n' + '... Event payload too large. Please use the Workbench and Metadata API the query the whole result.';
        }
        return stringifiedPayload;  
    }

    static Object getConvertedFieldValue(Schema.DisplayType fieldType, String fieldValue) {

        switch on fieldType {//Setting Field value based on the field data type
            when BOOLEAN {
                return String.isEmpty(fieldValue) ? false : Boolean.valueOf(fieldValue);
            }
            when DOUBLE {
                return String.isEmpty(fieldValue) ? null : Double.valueOf(fieldValue);
            }
            when DATE {
                return String.isEmpty(fieldValue) ? null : Date.valueOf(fieldValue);
            }
            when DATETIME {
                return String.isEmpty(fieldValue) ? null : Datetime.valueOf(fieldValue);
            }
            when else { 
                return fieldValue;
            }
        }
    }

    @TestVisible
    static String[] getCSVContentAsRows(String csvContent) {
        return csvContent.split('\n');
    }

    @TestVisible
    static String[] getCSVColumnHeadersAsFields(String csvHeader) {
        return csvHeader.split(',');
    }

    static Map<String,SObjectField> getSObjectFieldMap(String objectApiName) {
        SObjectType sObjType = ((SObject)Type.forName(objectApiName).newInstance()).getSObjectType();
        return sObjType.getDescribe().fields.getMap();
    }

    static Map<String,Schema.DisplayType> getFieldToFieldTypeMap(Map<String,SObjectField> fieldMap, String[] fieldsList) {
        Map<String,Schema.DisplayType> fieldToFieldTypeMap = new map<String,Schema.DisplayType>();
        for (String field : fieldsList) {
            fieldToFieldTypeMap.put(field, getFieldType(fieldMap, field));
        }
        return fieldToFieldTypeMap;
    }

    static Schema.DisplayType getFieldType(Map<String, SObjectField> fieldMap, String fieldApiName) {
        if(fieldMap.get(fieldApiName) == null) {
            throw createAuraHandledException('Invalid Field Error: '+fieldApiName + '. Please double check the API name of the field.');
        }
        return fieldMap.get(fieldApiName).getDescribe().getType();
    }

    @TestVisible
    static String getCSVContent(String contentDocumentId) {

        Blob csvFileData = [
            SELECT 
            VersionData 
            FROM ContentVersion 
            WHERE ContentDocumentId = :contentDocumentId 
              AND IsLatest = true
        ].VersionData;

        return blobToString(csvFileData, 'ISO-8859-1').replaceAll('(\r\n|\r)','\n');
    }
    
    /* Converting the CSV file input(BLOB format) to a String */
    static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    static AuraHandledException createAuraHandledException(String error) {

        AuraHandledException ex = new AuraHandledException(error);
        ex.setMessage(error);
        return ex;
    }

    static CustomException createCustomException(String error) {

        CustomException ex = new CustomException(error);
        ex.setMessage(error);
        return ex;
    }

    public class CustomException extends Exception {}
}