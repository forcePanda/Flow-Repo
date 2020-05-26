# CSV file to Collection of records Converter Apex Action

Use this Apex action in screen flows to directly convert a CSV file into a collection of records. For some more details, you can follow up with this post: https://forcepanda.wordpress.com/2020/05/05/convert-csv-file-into-record-collection-in-flows/

## Usage Considerations:
1. Make sure to use Field API names in your CSV file header, instead of field labels.
2. Make sure not to put any NULL values in the last column of CSV.

### Flow Action Inputs:
- Object API Name
- ContentDocumentId (Id of the CSV file) 

### Flow Action Output:
- SObject Collection

To use this flow Apex action, install this unmanaged package: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000003zHPY
