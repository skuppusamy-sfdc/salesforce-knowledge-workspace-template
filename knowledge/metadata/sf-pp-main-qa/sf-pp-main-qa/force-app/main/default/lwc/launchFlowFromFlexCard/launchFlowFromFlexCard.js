import { LightningElement, api, track } from 'lwc';
import pubsub from 'omnistudio/pubsub';

export default class LaunchFlowFromFlexCard extends LightningElement {
    _recordId;
    @track flowStarted = false;
    @track inputVariables = [];

    @api flowApiName;

    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        this.inputVariables = [
            {
                name: 'recordId',
                type: 'String',
                value: value
            }
        ];
        this.flowStarted = true;
    }

    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            pubsub.fire('DisplayProviderNtwrkContract', 'close' );
        }
    }
}