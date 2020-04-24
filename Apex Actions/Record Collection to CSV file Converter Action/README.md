# Record Collection to CSV file Converter Apex Action

Use this Apex action to directly convert a list of records to a CSV file.

Stay tuned for the blog for a more descriptive explanation.

## Usage Considerations:
1. This action will only work when all the fields are included in the records.
   So make sure to select 'Automatically store all fields' when using Get records to fetch records.

### Flow Action Inputs:
- Object API Name
- List of records
- Save file with name: This will be the name of the saved CSV file.
- Add time stamp to the file name? : When true, the name of the file will automatically appended by the current date and time.

### Flow Action Output:
- Text type collection of all the uploaded CSV files.

To use this flow Apex action, install this unmanaged package: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000003zHeH