import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigateToOffboradingOSWrapper extends NavigationMixin(LightningElement){
    @api recordId;

    connectedCallback() {
        if (!this.recordId) {
            console.error('Missing recordId!');
            return;
        }

        const omniscriptUrl = window.location.origin + `/lightning/page/omnistudio/omniscript?omniscript__type=Clinician&omniscript__subType=OffboardingOS&omniscript__language=English&omniscript__theme=lightning&omniscript__tabIcon=custom:custom18&omniscript__tabLabel=Clinician_OffboardingOS&c__ContextId=${this.recordId}`;

        // Using window.location.href to avoid NavigationMixin issues
        window.location.href = omniscriptUrl;
    }
}