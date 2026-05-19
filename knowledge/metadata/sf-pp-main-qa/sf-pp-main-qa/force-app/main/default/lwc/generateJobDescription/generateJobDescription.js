import { LightningElement, api, track } from 'lwc';
import generateJobDescription from '@salesforce/apex/GenerateJobDescriptionController.generateJobDescription';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';

export default class GenerateJobDescription extends LightningElement {
    @track isLoading = true;
    @track result;

    _recordId;

    @api set recordId(value) {
        this._recordId = value;
        console.log('recordId----' + this.recordId);
        this.processApex();
    }
    get recordId() {
        return this._recordId;
    }

    processApex() {
        generateJobDescription({ recordId: this.recordId })
            .then((data) => {
                this.result = data;
                console.log('data----' + data);
                try {
                    this.closeQuickAction();
                } catch (error) {
                    console.log('errorr--' + error);
                }

            })
            .catch((error) => {
                console.error('Error:', error);
                this.result = 'Error occurred while processing.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}