
# Call sub flows using Apex action
A flow action that enables you to call subflows(autolaunched type flows) from flows where Subflow element is not available.


### Input/Output(s) for component
|Parameter	               |Use for Input	   |Use for Output	   |Description 
|-|-|-|-|
✔
| Flow API Name | ✔ |  | API name of the flow. |
| Flow Namespace | ✔ |  | Namespace of the flow. Leave the input blank if the flow does not have a namespace. | 
| JSON of Input Variables | ✔ |  | JSON string of flow input variables and their corresponding values. <br>Ex: If your flow has two input variables; varText(text type) and varNumber(number type), then the JSON should look like this.
{
    "varText" : "Text Input",
    "varNumber" : 3000
}
Store the JSON string in a variable using a Text type variable or a Text Template(with View as Plain Text) and pass that variable in the action input. |

For more details about the component, refer this blog post: <Blogpost link>

Use the following link(s) to install the unmanaged package: 

| Version | Fixes |Package Link	    
| 1.0 |  | https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6F000004161y |
