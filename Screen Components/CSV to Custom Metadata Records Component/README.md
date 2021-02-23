# Mass Create/Update Custom Metadata Records via CSV and Flows
A flow screen component that allows you to create/update Custom Metadata records in bulk via a CSV.

### Considerations for Preparing the CSV
- Make sure NOT to put any blank value in the last column of the csv.
- All CSV cells MUST be of Text type, in other words, 'format the cells' as Text type.
- Format for Date and Date time values: YYYY-MM-DD HH:MM:SS.
- Use the API name(s) of the field of the CMDT in the CSV column header.

### Input/Output(s) for component
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
| Content Document Id(CSV file) | ✔ |  | Id of the CSV file that is saved as the ContentDocument |
| Custom Metadata API Name | ✔ |  | API name of the Custom Metadata Type |

For more details about the component, refer this blog post: <Blogpost link>

Use the following link(s) to install the unmanaged package: 

| Version | Fixes |Package Link	    
|-|-|-|
| 1.1 | Base Version | https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000001ZLj7 |