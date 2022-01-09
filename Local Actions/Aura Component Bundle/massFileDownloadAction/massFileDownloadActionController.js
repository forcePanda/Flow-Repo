({
    /* When a flow executes this component, it calls the invoke method */
    invoke : function(cmp, event, helper) {
        helper.getFiles(cmp, cmp.get("v.contentDocumentIds"));
    }
})