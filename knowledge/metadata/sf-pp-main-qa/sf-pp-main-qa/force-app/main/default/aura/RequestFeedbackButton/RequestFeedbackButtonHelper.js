({
    checkOpportunitySuitable: function(component, event, helper) {

        const action = component.get('c.isSuitableOpportunity');

        action.setParams({
            opportunityId: component.get('v.recordId')
        });

        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {
                component.set('v.isSuitableOpportunity', response.getReturnValue());

                if (response.getReturnValue()) {
                    helper.getSubmittedContacts(component, event, helper);
                }
            } else {
                const toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Cannot check the Opportunity suitability ' + response.getError()[0].message,
                    type: 'error'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },


    getSubmittedContacts: function(component, event, helper) {
        const xhr = new XMLHttpRequest();

        xhr.open('POST', component.get('v.settings').API_Endpoint__c + '/sfa/sample/submitted-contacts', true);

        xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
        xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
        xhr.setRequestHeader('Content-type', 'application/json');

        xhr.onreadystatechange = $A.getCallback(() => {
            if (xhr.readyState === 4) {
                if (xhr.status === 200 || xhr.status === 201) {
                    const response = xhr.responseText;

                    if (JSON.parse(response).length === 0) {
                        component.set('v.needFeedback', true);
                    }
                } else {
                    console.error('Error while retrieving submitted contacts');
                }
            }
        });
        xhr.send(JSON.stringify({
            sfa__opportunity_ids: [
                `${component.get('v.recordId')}`
            ]
        }));
    },

    getSettings: function(component, event, helper) {
        return new Promise(resolve => {
            const action = component.get('c.getSettings');

            action.setCallback(this, (response) => {
                if (response.getState() === 'SUCCESS') {
                    component.set('v.settings', response.getReturnValue());
                    console.log(response.getReturnValue());
                    console.log('67 getSettings');
                    console.log(component.get('v.settings'));
                    resolve();
                }
            });

            $A.enqueueAction(action);
        });
    },

});