# Flow Action: Upsert Records
An apex action that enables you to upsert a record in a Flow.


### Input/Output(s) for component
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
|  | ✔ |  |  |
| Record | ✔ |  | Record to upsert |
| Object API Name | ✔ |  | API name of the SObject |
| External Id Field(API name) | ✔ |  | API name of the field marked as External Id. |
| Upsert Success? |  | ✔ | Indicate if Upsert operation was success or not |
| Record ID |  | ✔ | Id of the upserted record |
| Is Record Created? |  | ✔ | Indicate if the record was created |
| Is Record Updated? |  | ✔ | Indicate if the record was updated |
| Error(s) |  | ✔ | Errors that occurred when upsert failed |

### Post Installation Notes
The package contains a field called IsTestDummyExternalField__c on Account object along with custom Label FlowAction_UpsertRecords_ExternalFieldName. These are required for the successful Apex test run during installation.\
However, if you don't want to keep this additional field, you can delete this field and update the 'value' of FlowAction_UpsertRecords_ExternalFieldName label with the API name of any of your field which is marked as External ID field on Account object.\
NOTE: The field should be on Account object because the test class includes upsert an Account record.

### Unmanaged package link(s): 

| Version | Fixes |Package Link*	    
|-|-|-|
| 1.0 | Base version | https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F0000045cOS |

*To install the package in sandbox, replace login.salesforce.com with test.salesforce.com.