({

    getFiles : function(cmp, contentDocumentIds) {
        var helper = this;
        var action = cmp.get("c.getFilesByIds");
        action.setParams({ contentDocumentIds : contentDocumentIds });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.downloadFiles(cmp, response.getReturnValue());
            }
            else {
                this.handleBadServerResponse(cmp, response);
            }
        });
        $A.enqueueAction(action);
    },

    downloadFiles : function(cmp, files) {

        if(files.length === 0) {
            console.error('No files found.');
            return;
        }

        let downloadString = this.getDownloadString(files);

        window.open( cmp.get("v.basePath") + downloadString, '_blank');
    },

    getDownloadString : function(files) {
        let downloadString = '';
        files.forEach(function(item) {
            downloadString += '/' + item.LatestPublishedVersionId
        });
        return downloadString;
    },

    handleBadServerResponse: function (cmp, response) {

        var state = response.getState();
        var message = "Unknown error!";

        if (state === "ERROR") {
            var errors = response.getError();
            if (errors && Array.isArray(errors) && errors.length > 0) {
                message = errors[0].message;
            }
        } else {
            message += " Response state: " + state;
        }
        console.error(message);
    }
})