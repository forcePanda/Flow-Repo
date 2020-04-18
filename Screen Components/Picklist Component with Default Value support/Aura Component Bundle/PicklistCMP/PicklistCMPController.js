({
    init : function(component, event, helper) {
        
        component.set("v.showSpinner",true); //show Spinner
        
        var action=component.get("c.getPicklistValues");
        action.setParams({
            objectApiName	: component.get("v.objectApiName"),
            fieldApiName	: component.get("v.fieldApiName"),
            defaultValue	: component.get("v.defaultValue")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
                //console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.picklistValues",response.getReturnValue());
                
                //Check if default value is set
                var defaultValue = component.get("v.defaultValue");
                if(defaultValue)
                    component.set("v.selectedValue",defaultValue);
                else
                    component.set("v.selectedValue",response.getReturnValue()[0].value);
                
                component.set("v.showSpinner",false); //hide Spinner
            }
            else{
                component.set("v.showSpinner",false); //hide Spinner
                alert('Error occured! Check console log.');
                console.log('State: '+state);
                if(state==="ERROR")
                    console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleChange: function (component, event) {
        component.set("v.selectedValue",event.getParam("value"));
    }
    
})