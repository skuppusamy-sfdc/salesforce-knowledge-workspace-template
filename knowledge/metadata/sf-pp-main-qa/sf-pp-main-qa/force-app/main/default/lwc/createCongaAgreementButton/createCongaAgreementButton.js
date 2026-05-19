import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createAgreements from '@salesforce/apex/CreateCongaAgreementService.createAgreements';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class CreateCongaAgreementButton extends NavigationMixin(LightningElement) {
    @api recordId;
    isLoading = true;

    connectedCallback() {
        // Use Promise.resolve() to ensure recordId is populated
        Promise.resolve().then(() => {
            // Call the Apex method imperatively and chain the promises
            createAgreements({ contractId: this.recordId })
                .then(newAgreementId => {
                    // On success, show a success toast message
                    this.showToast('Success', 'Agreements created successfully.', 'success');

                    // Navigate to the newly created Agreement record using the returned ID
                    if (newAgreementId) {
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: newAgreementId,
                                objectApiName: 'Apttus__APTS_Agreement__c',
                                actionName: 'view'
                            }
                        });
                    }
                })
                .catch(error => {
                    // On error, log and show a user-friendly error toast message
                    console.error('Error creating agreements:', JSON.stringify(error, null, 2));

                    let errorMessage = 'An unknown error occurred.';
                    if (error.body && error.body.message) {
                        errorMessage = error.body.message;
                    } else if (error.message) {
                        errorMessage = error.message;
                    }
                    this.showToast('Error', errorMessage, 'error');
                })
                .finally(() => {
                    //Stop the loading spinner
                    this.isLoading = false;
                });
        });
    }

    // Helper method to dispatch a toast message
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}