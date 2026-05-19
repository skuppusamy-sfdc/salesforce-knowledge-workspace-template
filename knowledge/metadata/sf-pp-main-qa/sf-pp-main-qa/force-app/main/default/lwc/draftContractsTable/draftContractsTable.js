import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveSelectedContracts from '@salesforce/apex/SaveContractSelectionAction.saveSelectedContracts';

export default class DraftContractsTable extends LightningElement {
    data = [];
    selectedRows = [];
    isLoading = true;
    totalRecords = 0;
    emptyMessage = 'No draft contracts to display.';
    _value;
    _accountId;
    _contractId;
    isSaving = false;
    isSaved = false;
    showDebug = false; // Set to false to hide debug panel
    submitMessage = '';
    submitSuccess = null; // true | false | null

    @api
    get value() {
        return this._value;
    }
    set value(newValue) {
        console.log('[draftContractsTable] value set:', newValue ? JSON.stringify(newValue).substring(0, 200) + '...' : 'null/undefined');
        this._value = newValue;
        if (newValue) {
            this.processValue(newValue);
        } else {
            this.handleNoData();
        }
    }

    get hasData() {
        return this.data && this.data.length > 0;
    }

    get selectedCount() {
        return this.selectedRows ? this.selectedRows.length : 0;
    }

    get dataWithSelection() {
        const selectedSet = new Set(this.selectedRows || []);
        return (this.data || []).map((item) => ({
            ...item,
            isSelected: selectedSet.has(item.id),
        }));
    }

    connectedCallback() {
        // Don't set isLoading = true here - it can run after value setter and overwrite processValue's isLoading = false
        setTimeout(() => {
            if (this.isLoading && (!this.data || this.data.length === 0)) {
                this.isLoading = false;
                if (!this._value) {
                    this.emptyMessage = 'No data received. Run Get Contracts To Send action first.';
                }
            }
        }, 3000);
    }

    processValue(val) {
        console.log('[draftContractsTable] processValue called, val keys:', val ? Object.keys(val) : 'null');
        try {
            this._accountId = val.accountId || null;
            this._contractId = val.contractId || null;
            console.log('[draftContractsTable] accountId:', this._accountId, 'contractId:', this._contractId);

            let records = [];
            if (Array.isArray(val)) {
                records = val;
                if (val.length > 0) {
                    const first = val[0];
                    this._accountId = first.accountId || this._accountId;
                    this._contractId = first.clientContractId || first.contractId || this._contractId;
                }
            } else if (val.draftContracts && Array.isArray(val.draftContracts)) {
                records = val.draftContracts;
            } else if (val.draftContractsList && Array.isArray(val.draftContractsList)) {
                records = val.draftContractsList;
            } else {
                const keys = Object.keys(val);
                for (const key of keys) {
                    if (Array.isArray(val[key]) && val[key].length > 0) {
                        const first = val[key][0];
                        if (first && (first.contractId || first.contractNumber || first.clinicianName)) {
                            records = val[key];
                            break;
                        }
                    }
                }
            }

            console.log('[draftContractsTable] records extracted:', records.length, records.length > 0 ? records[0] : '');
            if (records.length > 0) {
                this.isSaved = false; // Reset when new data loads
                this.data = records.map((r, i) => ({
                    id: r.contractId || r.id || `row-${i}`,
                    contractNumber: r.contractNumber || 'N/A',
                    startDate: r.startDate || 'N/A',
                    clinicianName: r.clinicianName || 'N/A',
                }));
                this.totalRecords = this.data.length;
                this.selectedRows = this.data.map((d) => d.id);
                this.dispatchValueChange();
            } else {
                this.handleNoData();
            }
        } catch (error) {
            console.error('Error processing draft contracts:', error);
            this.emptyMessage = 'Something went wrong while loading. Please try again.';
            this.handleNoData();
        } finally {
            this.isLoading = false;
        }
    }

    handleNoData() {
        this.data = [];
        this.selectedRows = [];
        this.totalRecords = 0;
        this.isLoading = false;
        this.isSaved = false;
        if (this._value && typeof this._value === 'object' && this._value.message) {
            this.emptyMessage = this._value.message;
        } else {
            this.emptyMessage = 'No draft contracts found.';
        }
    }

    handleCheckboxChange(event) {
        const id = event.target.dataset.id;
        const checked = event.target.checked;
        let newSelected = [...(this.selectedRows || [])];
        if (checked) {
            if (!newSelected.includes(id)) newSelected.push(id);
        } else {
            newSelected = newSelected.filter((s) => s !== id);
        }
        this.selectedRows = newSelected;
        this.isSaved = false; // Re-enable Save when selection changes
        console.log('[draftContractsTable] checkbox changed, selectedCount:', this.selectedRows.length, 'ids:', this.selectedRows);
        this.dispatchValueChange();
    }

    dispatchValueChange() {
        const selectedRecords = this.data.filter((d) => this.selectedRows.includes(d.id));
        this.dispatchEvent(
            new CustomEvent('valuechange', {
                detail: {
                    selectedContractIds: this.selectedRows,
                    selectedRecords,
                    totalRecords: this.totalRecords,
                    selectedCount: this.selectedRows.length,
                },
            })
        );
    }

    @api
    getSelectedContractIds() {
        return this.selectedRows || [];
    }

    @api
    getSelectedRecords() {
        if (!this.data || this.selectedRows.length === 0) {
            return [];
        }
        return this.data.filter((d) => this.selectedRows.includes(d.id));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant: variant || 'info' }));
    }

    async handleSubmit() {
        console.log('[draftContractsTable] handleSubmit, accountId:', this._accountId, 'contractId:', this._contractId, 'selectedIds:', this.getSelectedContractIds());
        this.submitMessage = '';
        this.submitSuccess = null;

        if (!this._accountId || !this._contractId) {
            const msg = 'Please select a service account and contract first. Run Get Contracts To Send to load contracts.';
            this.submitMessage = msg;
            this.submitSuccess = false;
            this.showToast('Error', msg, 'error');
            this.dispatchEvent(new CustomEvent('valuechange', { detail: { submitError: msg } }));
            return;
        }
        const ids = this.getSelectedContractIds();
        if (!ids || ids.length === 0) {
            const msg = 'Please select at least one contract.';
            this.submitMessage = msg;
            this.submitSuccess = false;
            this.showToast('Error', msg, 'error');
            this.dispatchEvent(new CustomEvent('valuechange', { detail: { submitError: msg } }));
            return;
        }
        this.isSaving = true;
        try {
            const result = await saveSelectedContracts({
                accountId: this._accountId,
                contractId: this._contractId,
                selectedContractIds: ids,
            });
            console.log('[draftContractsTable] saveSelectedContracts result:', result);
            this.submitMessage = result.message || 'Saved successfully.';
            this.submitSuccess = result.success;
            if (result.success) {
                this.isSaved = true;
                this.showToast('Success', result.message, 'success');
            } else {
                this.showToast('Error', result.message, 'error');
            }
            this.dispatchEvent(
                new CustomEvent('valuechange', {
                    detail: { submitSuccess: result.success, submitMessage: result.message },
                })
            );
        } catch (error) {
            const errMsg = error.body?.message || error.message;
            console.error('[draftContractsTable] saveSelectedContracts error:', error);
            this.submitMessage = 'Something went wrong. Please try again.';
            this.submitSuccess = false;
            this.showToast('Error', errMsg, 'error');
            this.dispatchEvent(
                new CustomEvent('valuechange', {
                    detail: { submitSuccess: false, submitMessage: 'Something went wrong. Please try again.' },
                })
            );
        } finally {
            this.isSaving = false;
            console.log('[draftContractsTable] handleSubmit complete');
        }
    }

    get isSaveDisabled() {
        return this.isSaving || this.isSaved;
    }

    get submitMessageClass() {
        if (this.submitSuccess === true) return 'slds-theme_success';
        if (this.submitSuccess === false) return 'slds-theme_error';
        return '';
    }

    get debugInfo() {
        return JSON.stringify({
            accountId: this._accountId,
            contractId: this._contractId,
            totalRecords: this.totalRecords,
            selectedCount: this.selectedRows?.length || 0,
            selectedIds: this.selectedRows,
            hasData: this.hasData,
            isLoading: this.isLoading,
        }, null, 2);
    }
}