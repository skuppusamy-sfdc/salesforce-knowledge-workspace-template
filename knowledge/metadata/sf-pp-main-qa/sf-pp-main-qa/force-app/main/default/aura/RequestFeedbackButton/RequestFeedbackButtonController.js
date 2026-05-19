({
    doInit: function(component, event, helper) {
        console.log('3 doInit');
        const action = component.get('c.getUserInfo');
        action.setCallback(this, (response) => {
            if (response.getState() === 'SUCCESS' && response.getReturnValue() === true) {
                console.log('8 doInit: ' +  response.getReturnValue());
                $A.enqueueAction(component.get('c.userValid'));
            }
        });

        $A.enqueueAction(action);
    },
    userValid: function(component, event, helper){
        helper.getSettings(component, event, helper).then($A.getCallback(() => {
            helper.checkOpportunitySuitable(component, event, helper);
        }));
    },

    forceRefreshViewHandler: function(component, event, helper) {
        console.log(' 21 forceRefreshViewHandlerButton');
        const action = component.get('c.getUserInfo');
        action.setCallback(this, (response) => {
            if (response.getState() === 'SUCCESS' && response.getReturnValue() === true) {
                console.log('forceRefreshViewHandlerButton');
                helper.checkOpportunitySuitable(component, event, helper);
            }
        });

        $A.enqueueAction(action);

    },

    openFeedbackRequest: function(component, event, helper) {
        console.log('openFeedbackRequest');
		const clickEvent = $A.get('e.c:OpenRequestFeedbackEvent');
		clickEvent.setParam('opportunityId', component.get('v.recordId'));

		clickEvent.fire();
    },

});