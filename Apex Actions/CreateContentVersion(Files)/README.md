# Flow Apex Action: Create ContentVersion/Files
Apex action that allows users to create ContentVersion(Files).

### Input/Output(s) for component
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
| File Data | ✔ | | String input that'll be stored as VersionData. For images, the string input should be base64 encoded string. |
| File Extenstion | ✔ | | Type of the file. For notes, it should be 'SNOTE'. |
| File Title | ✔ | | Title of the file. |
| Related Record Id | ✔ | | ID of the record where the file should be added. |
| ContentDocument ID | | ✔ | ContentDocument ID of the created file(ContentVersion). |

For more details about the component, refer this blog post: <Blogpost link>

Use the following link(s) to install the unmanaged package: 

| Version | Fixes |Package Link	    
 1.0 | | https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000004165C |
