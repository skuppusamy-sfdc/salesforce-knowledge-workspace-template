({
	doInit: function(component, event, helper) {
		let opId = component.get('v.recordId'), opUriInterval = window.location.href;
		const action = component.get('c.getSettings');
		console.log(opUriInterval);
		action.setCallback(this, response => {
			if (response.getState() === 'SUCCESS') {
				component.set('v.settings', response.getReturnValue());
			} else {
				const toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'Cannot obtain TruSales App settings. ' + response.getError()[0].message,
					type: 'error'
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);

		helper.getSuitable(component, event, helper, true);

		const OpStatusAction = component.get('c.getOpportunityStatusApex');
		OpStatusAction.setParams({
			id: opId
		});
		OpStatusAction.setCallback(this, response => {
			if (response.getState() === 'SUCCESS') {
				component.set('v.opportunityStatus', response.getReturnValue()[0]);
				let interval = setInterval($A.getCallback(() => {
					const getChangeOpportunityStatus = component.get('c.getOpportunityStatusApex');

					if (!getChangeOpportunityStatus) {
						return;
					}

					getChangeOpportunityStatus.setParams({
						id: opId
					});
					getChangeOpportunityStatus.setCallback(this, response => {
						if (response.getState() === 'SUCCESS' && component.get('v.opportunityStatus') !== response.getReturnValue()[0] && response.getReturnValue()[1] !== 'false') {
							component.set('v.opportunityStatus', response.getReturnValue()[0]);
							helper.getSuitable(component, event, helper);
						}
					});
					$A.enqueueAction(getChangeOpportunityStatus);
					if (opUriInterval !== window.location.href) {
						clearInterval(interval);
					}
				}), 1500);
			}
		});
		$A.enqueueAction(OpStatusAction);

		const orgId = component.get('c.getOrgId');
		orgId.setCallback(this, response => {
			if (response.getState() === 'SUCCESS')
			{
				console.log('59 ORGID');
				console.log(orgId);
				component.set('v.orgId', response.getReturnValue());
				console.log('62 ORGID');
				console.log(component.get('v.orgId'));
			}
			else
				{
				const toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'Cannot get OrganizationId. ' + response.getError()[0].message,
					type: 'error'
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(orgId);


	},

	forceRefreshViewHandler: function(component, event, helper) {
		helper.getSuitable(component, event, helper);
	},

	openRequestFeedbackHandler: function(component, event, helper) {
		component.set('v.opportunityId', event.getParam('opportunityId'));
		if (component.get('v.settings').TruVoiceIntegration__c) {
			component.set('v.showModalReqFeedback', true);
			helper.setOpportunityName(component, event.getParam('opportunityId'));
		}
		if ((event.getParam('opportunityId') === component.get('v.recordId')) && !component.get('v.settings').TruVoiceIntegration__c) {
			helper.openRequestFeedback(component, event, helper);
		}
	},

	hideModal: function(component, event, helper) {
		component.set('v.showModal', false);
	},
	hideModalNew: function(component, event, helper) {
		component.set('v.showModalReqFeedback', false);
		component.set('v.showModalNew', false);
	},
	iframeLoadHandler: function(component, event, helper) {
		component.set('v.showModalSpinner', false);
	}
});