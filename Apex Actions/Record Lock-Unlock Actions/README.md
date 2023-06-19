
# Record Lock-Unlock Actions
This utility comes with 2 actions; Lock Record and Unlock Record, which you can use it in the flows to lock/unlock records.

### Input/Output(s) for actions
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
| Record ID | ✔ |  | Id of the record to lock/unlock. |
| Is Success |  | ✔ | A boolean output to indicate whether the record lock/unlock was successful.| 
| Message |  | ✔ | String type output containing a message indicating if the record was successfully locked/unlocked.|


For more details about the component, refer this blog post: https://forcepanda.wordpress.com/2023/06/20/lock-and-unlock-records-in-salesforce-using-flows/

Use the following link(s) to install the unmanaged package: 

| Version | Fixes |Package Link*
|-|-|-|	    
| 1.0 |  | https://login.salesforce.com/packaging/installPackage.apexp?p0=0Ho6F000000KzFvSAK |


*To install the package in sandbox, replace login.salesforce.com with test.salesforce.com.

### Post Installation Step

Go to Setup –> Process Automation Settings –> Enable “Enable record locking and unlocking in Apex” checkbox.
