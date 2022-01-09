public with sharing class MassFileDownloaderController {
    
    @AuraEnabled(cacheable=true)
    public static ContentDocument[] getFiles() {
        return [
            SELECT
            Id, Title, FileExtension, LatestPublishedVersionId
            FROM ContentDocument
        ];
    }

    @AuraEnabled(cacheable=true)
    public static ContentDocument[] getFilesByIds(String[] contentDocumentIds) {
        return [
            SELECT
            Id, Title, FileExtension, LatestPublishedVersionId
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];
    }
}
