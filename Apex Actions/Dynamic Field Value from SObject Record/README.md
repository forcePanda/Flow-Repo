# Get field value dynamically from an SObject Record.
A flow action that enables you to get a value of a field from SObject record by specifying field name as a variable.


### Input/Output(s) for component
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
| SObject Record | ✔ |  | SObject record, to get the value from. |
| SObject API Name | ✔ |  | API name of the SObject. | 
| Field API Name | ✔ |  | API name of the field.|
| String Output |  | ✔ | Use this output when field value is of string(picklist, phone, email, url etc. included) type. |
| Number Output |  | ✔ | Use this output when field value is of Number(Number, Currency etc.) type. |
| Boolean Output |  | ✔ | Use this output when field value is of Boolean type. |
| Date Output |  | ✔ | Use this output when field value is of Date type. |
| DateTime Output |  | ✔ | Use this output when field value is of DateTime type. |


For more details about the component, refer this blog post: <TODO>

Use the following link(s) to install the unmanaged package: 

| Version | Fixes |Package Link
|-|-|-|	    
| 1.0 |  | https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000001ZLhp |