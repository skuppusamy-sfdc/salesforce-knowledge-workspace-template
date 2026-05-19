import { LightningElement, api, wire } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import pubsub from 'omnistudio/pubsub';
import { NavigationMixin } from 'lightning/navigation';
import {
    IsConsoleNavigation,
    getFocusedTabInfo,
    closeTab,
    openTab,
    refreshTab
} from 'lightning/platformWorkspaceApi';

export default class FlowFooter extends NavigationMixin(LightningElement) {
    @api showSave = false;
    @api showCancel = false;
    @api recordId;
    @api source;

    @wire(IsConsoleNavigation) isConsoleNavigation;

    handleCancel() {
        if (this.source == 'Flow') {
            if (this.isConsoleNavigation) {
                this.refreshTab();
            } else {
                this.navigateToRecord();
            }
        }
        else{
            pubsub.fire('DisplayProviderNtwrkContract', 'close');
        }
    }

    handleSave() {
        this.dispatchEvent(new FlowNavigationNextEvent());
    }

    navigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }


    async refreshTab() {
        /*const { tabId } = await getFocusedTabInfo();
        await refreshTab(tabId);
        await openTab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            },
            focus: true
        });*/
        window.open('/' + this.recordId, "_top");

        // Give it a short moment to finish opening before closing the old one
        /*setTimeout(async () => {
           await closeTab(tabId);
        }, 300);*/
        
    }
}