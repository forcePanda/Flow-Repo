({
    subscribe : function(cmp) {

        const empApi = cmp.find('empApi');
        const channel = cmp.get('v.eventName');
        const replayId = -1;

        // Subscribe to an event
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {

            // Process event (this is called each time we receive an event)
            this.handleEventReception(cmp, eventReceived);
        }))
        .then(subscription => {

            console.log('Subscribed to channel ' + subscription.channel);
            cmp.set('v.subscription', subscription);

            this.initCSVImport(cmp);
        });

        empApi.onError($A.getCallback(error => {
            // Error can be any type of error (subscribe, unsubscribe...)
            var err = 'EMP API error: ' + JSON.stringify(error);
            console.error(err);
            this.showToast(err, 'error');
        }));
    },

    initCSVImport : function(cmp) {

        var action=cmp.get('c.insertCMDTRecords');
        action.setParams({
            contentDocumentId   : cmp.get('v.contentDocumentId'), 
            cmdtApiName         : cmp.get('v.cmdtApiName')
        });

        action.setCallback(this,function(response) {
            
            cmp.set('v.status', 'reading_csv');
            
            var state = response.getState();

            if(state === 'SUCCESS') {

                cmp.set('v.jobId', response.getReturnValue());
                cmp.set('v.status', 'deployment_in_progress');
            }
            else {

                cmp.set('v.status', 'failed');
                this.handleBadServerResponse(cmp, response);
            }
        });
        $A.enqueueAction(action);
    },

    handleEventReception : function(cmp, eventReceived) {

        this.unsubscribe(cmp);

        eventReceived.data.payload.Payload__c = JSON.parse(eventReceived.data.payload.Payload__c);
        cmp.set('v.eventPayload', JSON.stringify(eventReceived, null, 5));

        this.updateJobStatus(cmp, eventReceived.data.payload.Status__c);
    },

    updateJobStatus : function(cmp, jobStatus) {
        switch (jobStatus) {
            case 'succeeded':
                cmp.set('v.status', 'success');
                break;        
            default:
                cmp.set('v.status', jobStatus);
                break;
        }
    },

    // Invokes the unsubscribe method on the empApi component
    unsubscribe : function(cmp) {
        
        const empApi = cmp.find('empApi');
        const subscription = cmp.get('v.subscription');

        // Unsubscribe from event
        empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
            
            console.log('Unsubscribed from channel '+ unsubscribed.subscription);
            cmp.set('v.subscription', null);
        }));
    },

    handleBadServerResponse : function(cmp, response) {

        this.unsubscribe(cmp);

        var state = response.getState();
        var err = 'Unknown error!';

        console.log('State: '+ state);
        console.log('Response: '+ JSON.stringify(response));
        if(state ==='ERROR') {
            var errors = response.getError();
            console.log('Error(s): '+ JSON.stringify(errors));
            if(errors && Array.isArray(errors) && errors.length > 0) {
                err = errors[0].message;
            }
        }
        err += 'Check console log for more info.'
        this.showToast(err, 'error');
    },

    showToast : function(message, type ) {
        var toastEvent = $A.get('e.force:showToast');
        if(!toastEvent) {
            alert('Message type: ' + type + '\n Message: ' + message);
        }
        toastEvent.setParams({
            'type': type,
            'message': message
        });
        toastEvent.fire();
    }
})
