({
	openRequestFeedback: function (component, event, helper) {
		console.log('openRequestFeedback');

		const callback = $A.getCallback(() => {
			let endpoint = component.get('v.settings').API_Endpoint__c;
			if (component.get('v.settings').API_Endpoint__c === 'https://api.primary-intel.com')
				endpoint = 'https://trusales.primary-intel.com';
			else endpoint = 'https://trusales-sandbox.primary-intel.com';
			let ownerId = component.get('v.ownerId');
			if (component.get('v.delegated') || !component.get('v.settings').TruVoiceIntegration__c) {
				const endpointsToGetFeedbackURL = {
					//newWindow: endpoint + '/request-feedback/' + component.get('v.recordId'),
					newWindow: endpoint + '/request-feedback/organizations/' + component.get('v.orgId') +'/opportunities/' + component.get('v.recordId'),
					//dialog: endpoint + '/apex/' + component.get('v.recordId')
					dialog: endpoint + '/request-feedback/apex/organizations/' + component.get('v.orgId') +'/opportunities/'+ component.get('v.recordId')
				};

				const openInNewWindow = component.get('v.settings').Open_In_New_Window__c;

				component.set('v.feedbackURL', openInNewWindow ? endpointsToGetFeedbackURL.newWindow : endpointsToGetFeedbackURL.dialog);
				console.log(component.get('v.feedbackURL'));

				if (openInNewWindow) {
					window.open(component.get('v.feedbackURL'));
				} else {
					component.set('v.showModalSpinner', true);
					component.set('v.showModal', true);
				}
			}
		});

		if (component.get('v.settings').TruVoiceIntegration__c) {
			helper.checkUserLastSync(component, event, helper).then(callback).catch($A.getCallback(errorMessage => {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error',
					type: 'error',
					message: errorMessage
				});
				toastEvent.fire();
			}));
		} else {
			callback();
		}
	},
	getEmail: function (component, event, helper) {
		return new Promise((resolve, reject) => {
			var action = component.get('c.getEmail');
			action.setParams({id: component.get('v.ownerId')});

			action.setCallback(this, response => {
				if (response.getState() === 'SUCCESS') {
					resolve(response.getReturnValue());
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(action);
		});
	},

	getSuitable: function (component, event, helper, isFirstLoad) {
		const action = component.get('c.isSuitableOpportunity');
		action.setParams({
			opportunityId: component.get('v.recordId')
		});

		action.setCallback(this, response => {
			if (response.getState() === 'SUCCESS') {
				console.log('resp = ' + response.getReturnValue());
				console.log('isFirstLoad = ' + isFirstLoad);
				console.log('isSuitable = ' + component.get('v.isSuitable'));

				if (response.getReturnValue() === true && !component.get('v.isSuitable') && !isFirstLoad) {
					console.log('openRequestFeedback Start');
					helper.openRequestFeedback(component, event, helper);
				}
				component.set('v.isSuitable', response.getReturnValue());
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

	setOpportunityName: function (component, id) {
		var action = component.get('c.getOpportunityName');
		action.setParam('id', id);
		action.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {
				component.set('v.opportunityName', response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	getOwnerId: function (component, event, helper) {
		return new Promise((resolve, reject) => {
			const action = component.get('c.getOwnerId');

			action.setParams({
				opportunityId: component.get('v.recordId')
			});

			action.setCallback(this, function (response) {
				if (response.getState() === 'SUCCESS') {
					resolve(response.getReturnValue());
					component.set('v.ownerId', response.getReturnValue());
					//
					helper.getEmail(component, event, helper).then($A.getCallback(email => {
						let apiEndpoit = component.get('v.settings').API_Endpoint__c;
						const xhr = new XMLHttpRequest();
						xhr.open('GET', apiEndpoit + '/sfa/users/' + email + '/email-delegate', true);
						xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
						xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
						xhr.onreadystatechange = $A.getCallback(() => {
							if (xhr.readyState === 4) {
								if (xhr.status === 200) {
									let authorized = JSON.parse(xhr.response).authorized;
									console.log('authotrized:' + authorized);
									component.set('v.delegated', authorized);
									if (!authorized) {
										component.set('v.showModalNew', true);
										helper.sendConfirmation(component, event, helper).then().catch($A.getCallback(errorMessage => {
											let toastEvent = $A.get('e.force:showToast');
											toastEvent.setParams({
												title: 'Error',
												type: 'error',
												message: 'Something gone wrong...' + errorMessage
											});
											toastEvent.fire();
										}));
									}
								}
							}
						});
						xhr.send();

					})).catch($A.getCallback(errorMessage => {
						let toastEvent = $A.get('e.force:showToast');
						toastEvent.setParams({
							title: 'Error',
							type: 'error',
							message: errorMessage
						});
						toastEvent.fire();
					}));
				} else {
					reject(response.getError()[0].message);
				}
			});
			$A.enqueueAction(action);
		});
	},
	sendConfirmation: function (component, event, helper) {
		return new Promise($A.getCallback((resolve, reject) => {
			//
			helper.getEmail(component, event, helper).then($A.getCallback(email => {
				console.log('Sending confirmation to ' + email);
				let apiEndpoit = component.get('v.settings').API_Endpoint__c;
				const xhr = new XMLHttpRequest();
				xhr.open('PUT', apiEndpoit + '/sfa/users/' + email + '/email-delegate', true);
				xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
				xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
				xhr.onreadystatechange = $A.getCallback(() => {
					if (xhr.readyState === 4) {
						if (xhr.status === 200) {
							console.log('success!');
							resolve();

						} else {
							console.log(xhr.status);
							reject(xhr.status);
						}
					}
				});
				xhr.send();

			})).catch($A.getCallback(errorMessage => {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error',
					type: 'error',
					message: errorMessage
				});
				toastEvent.fire();
			}));

		}));
	},

	syncClosedOpportunities: function (component, event, helper, lastSyncDate, ownerId) {
		return new Promise($A.getCallback((resolve, reject) => {
			helper.getProducts(component, event, helper).then($A.getCallback(products => {
				const action = component.get('c.getJSONStringForOpportunitiesSync');
				console.log(ownerId);

				action.setParams({
					lastSyncDateString: lastSyncDate,
					ownerId: ownerId,
					truVoiceProducts: products
				});

				action.setCallback(this, function (response) {
					console.log(response.getState());
					if (response.getState() === 'SUCCESS') {
						const responseText = response.getReturnValue().replace(/_underscore_/g, '__');
						let apiEndpoit = component.get('v.settings').API_Endpoint__c;
						const programId = '58af4da0b310d92314627232';
						const xhr = new XMLHttpRequest();

						xhr.open('POST', apiEndpoit + '/sfa/clients/' + component.get('v.settings').TruVoice_Client_ID__c + '/initiative/' + programId + '/sales-history', true);
						xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
						xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
						xhr.setRequestHeader('Content-Type', 'application/json');

						xhr.onreadystatechange = $A.getCallback(() => {

							if (xhr.readyState === 4) {
								console.log(xhr.status);
								console.log(JSON.parse(xhr.responseText));

								if ((xhr.status === 201) || (xhr.status === 200)) {
									resolve();
								} else {
									reject();
								}
							}
						});

						xhr.send(responseText);
					} else {
						reject(response.getError()[0].message);
					}
				});
				$A.enqueueAction(action);
			}));
		}));
	},

	getProducts: function (component, event, helper) {
		return new Promise($A.getCallback((resolve, reject) => {
			const programId = '58af4da0b310d92314627232';
			let apiEndpoit = component.get('v.settings').API_Endpoint__c;
			console.log('getProducts');
			const xhr = new XMLHttpRequest();
			xhr.open('GET', apiEndpoit + '/sfa/clients/' + component.get('v.settings').TruVoice_Client_ID__c + '/initiatives/' + programId + '/products', true);
			xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
			xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);

			xhr.onreadystatechange = $A.getCallback(() => {
				if (xhr.readyState === 4) {
					if (xhr.status === 200) {
						const products = {};

						Array.from(JSON.parse(xhr.responseText)).map(item => {
							products[item.id] = item.name;
						});
						resolve(products);
					} else {
						reject();
					}
				}
			});
			xhr.send();
		}));
	},

	checkUserLastSync: function (component, event, helper) {
		return new Promise((resolve, reject) => {
			helper.getOwnerId(component, event, helper).then($A.getCallback(ownerId => {
				const xhr = new XMLHttpRequest();
				//TODO CHANGE THIS URL TO COMMENTED
				// xhr.open('GET', component.get('v.settings').API_Endpoint__c + '/sfa/clients/' + component.get('v.settings').TruVoice_Client_ID__c + '/sales-history/' + ownerId);
				xhr.open('GET', 'https://api-hf.primary-intel.com/sfa/clients/' + component.get('v.settings').TruVoice_Client_ID__c + '/sales-history');
				xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
				xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);

				xhr.onreadystatechange = $A.getCallback(() => {
					if (xhr.readyState === 4) {

						helper.syncClosedOpportunities(component, event, helper, JSON.parse(xhr.responseText).last_sync.substring(0, 10), ownerId)
							.then($A.getCallback(() => {
								resolve();
							}))
							.catch($A.getCallback(() => {
								reject();
							}));
					}
				});
				xhr.send();
			})).catch($A.getCallback(errorMessage => {
				let toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error',
					type: 'error',
					message: errorMessage
				});
				toastEvent.fire();
			}));
		});
	}
});