# CSV file to Collection of records Converter

Use this Apex action in screen flows to directly convert a CSV file into a collection of records.

Usage Considerations:
1. Make sure to use Field API names in your CSV file header, instead of field labels.
2. Make sure not to put any NULL values in the last column of CSV.

Flow Action Inputs:
- Object API Name
- ContentDocumentId

Flow Action Output:
- SObject Collection

To use this flow Apex action, install this unmanaged package: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000003zHPY