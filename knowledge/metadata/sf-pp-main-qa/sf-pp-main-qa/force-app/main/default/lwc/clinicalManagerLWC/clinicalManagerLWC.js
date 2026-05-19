import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import processSelectedRecords from '@salesforce/apex/ClinicalManagerController.processSelectedRecords';

const columns = [
    { label: '#', fieldName: 'rowNumber', type: 'text', cellAttributes: { alignment: 'center' }, initialWidth: 60 },
    { label: 'Clinician Name', fieldName: 'clinicianName' },
    { label: 'Facility Title', fieldName: 'facilityTitle' },
    { label: 'Overrate', fieldName: 'overrate' },
];

export default class ClinicalManagerLWC extends LightningElement {
    page = 1; // initialize 1st page
    items = []; // contains all the records
    data = []; // data displayed in the table
    columns; // holds column info
    startingRecord = 1; // start record position per page
    endingRecord = 0; // end record position per page
    pageSize = 5; // records per page
    totalRecords = 0; // total record count received from all retrieved records
    totalPages = 0; // total number of pages needed to display all records
    selectedRows = []; // persistent selected rows
    isLoading = false;
    isPaginating = false; // Flag to prevent selection events during pagination
    _datatableRef = null; // Cached datatable reference for performance
    @track isSubmitting = false; // Track submission state (with explicit reactivity for Agentforce)
    isSubmitted = false; // Keep submit disabled after success until user changes selection (draftContractsTable pattern)
    submissionResult = null; // Store submission results for Agentforce
    _submitClickCount = 0; // Additional protection against multiple clicks
    _isAgentforceContext = true; // Flag to detect Agentforce environment
    _preventRerender = false; // Flag to prevent re-rendering during submission
    _isInitialLoad = true; // Flag to track initial data load vs. event updates
    // API property to receive data from Custom Lightning Type in Agentforce

    _value;

    @api
    get value() {
        return this._value;
    }
    set value(newValue) {
        // AGGRESSIVE PROTECTION: Block ALL value updates during submission in Agentforce
        if (this._preventRerender || this.isSubmitting) {
            console.log('🚫 BLOCKING value update to prevent re-render during submission');
            return;
        }

        // Only process if the value has actually changed
        if (this._value !== newValue) {
            this._value = newValue;
            // Only process Agentforce data during initial load, not during event updates
            if (newValue && this._isInitialLoad) {
                this.processAgentforceData();
            }
        }
    }

    // Override connectedCallback to detect Agentforce context
    connectedCallback() {
        console.log('🔧 LWC connected in Agentforce context');
        this._isAgentforceContext = true;
    }

    // Override renderedCallback to prevent re-rendering during submission
    renderedCallback() {
        if (this._preventRerender) {
            console.log('🚫 Re-render blocked during submission');
            return;
        }
    }

    // Process data from Agentforce Custom Lightning Type
    processAgentforceData() {
        // Block processing during submission to prevent re-rendering
        if (this._preventRerender || this.isSubmitting) {
            console.log('🚫 Blocking processAgentforceData during submission');
            return;
        }

        if (this.value) {
            // Only set loading if we don't already have data
            if (!this.items || this.items.length === 0) {
                this.isLoading = true;
            }
            let records = [];

            try {
                // Handle different possible data structures from Custom Lightning Type
                if (this.value.clinicalDataList && this.value.clinicalDataList.clinicalRecords) {
                    records = this.value.clinicalDataList.clinicalRecords;
                    this.totalRecords = this.value.clinicalDataList.totalRecords || records.length;
                } else if (this.value.clinicalRecords) {
                    records = this.value.clinicalRecords;
                    this.totalRecords = this.value.totalRecords || records.length;
                } else if (Array.isArray(this.value)) {
                    records = this.value;
                    this.totalRecords = records.length;
                } else {
                    // Check if the value contains nested data
                    const keys = Object.keys(this.value);

                    // Try to find any array property that might contain records
                    for (const key of keys) {
                        if (Array.isArray(this.value[key]) && this.value[key].length > 0) {
                            // Check if the array contains record-like objects
                            const firstItem = this.value[key][0];
                            if (firstItem && (firstItem.id || firstItem.clinicianName)) {
                                records = this.value[key];
                                break;
                            }
                        }
                    }
                }

                if (records.length > 0) {
                    this.isSubmitted = false; // Reset when new data loads (draftContractsTable pattern)
                    this.processRecords(records);
                } else {
                    this.handleNoDataAvailable();
                }
            } catch (error) {
                console.error('❌ Error in processAgentforceData:', error);
                this.isLoading = false;
                this.showToast('Error processing data: ' + error.message, 'error', 'Error');
            }

        } else {
            // In Agentforce, show no data message
            this.handleNoDataAvailable();
        }
    }

    // Get cached datatable reference for performance
    getDatatable() {
        if (!this._datatableRef) {
            this._datatableRef = this.template.querySelector('[data-id="datatable"]');
        }
        return this._datatableRef;
    }

    // Clear datatable cache (called when component re-renders)
    clearDatatableCache() {
        this._datatableRef = null;
    }

    // Show appropriate message when no data is available
    handleNoDataAvailable() {
        this.isLoading = false;
        this.isSubmitted = false;
        this.showToast('No data available. Please ensure data is properly configured.', 'info', 'Info');
    }


    // Process records received from Agentforce
    processRecords(records) {
        try {
            if (!records || !Array.isArray(records) || records.length === 0) {
                this.isLoading = false;
                this.showToast('No records found to display', 'info', 'Info');
                return;
            }
            // Optimized single-pass data processing
            const processedItems = [];
            for (let i = 0; i < records.length; i++) {
                const item = records[i];
                if (item) {
                    processedItems.push({
                        id: item.id || `temp-id-${i}`,
                        rowNumber: i + 1,
                        clinicianName: item.clinicianName || 'N/A',
                        facilityTitle: item.facilityTitle || 'N/A',
                        overrate: item.overrate || 'N/A'
                    });
                }
            }
            this.items = processedItems;

            // Use the actual number of records returned for client-side pagination
            this.totalRecords = this.items.length;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

            // Display first page and setup
            this.displayRecordPerPage(1);
            this.columns = columns;
            this.isLoading = false; // Critical: Always stop loading

            // Auto-select all records ONLY on initial load, not when user has made selections
            if (this._isInitialLoad) {
                this.autoSelectAllRecords();
                this._isInitialLoad = false; // Mark initial load as complete
            }

        } catch (error) {
            console.error('❌ Error in processRecords:', error);
            this.isLoading = false; // Critical: Always stop loading on error
            this.showToast('Error processing data: ' + error.message, 'error', 'Error');
        }
    }

    // Component initialization for Agentforce
    connectedCallback() {
        this.isLoading = true;
        this.columns = columns;

        // Safety timeout to prevent infinite loading (reduced from 5s to 3s for faster UX)
        setTimeout(() => {
            if (this.isLoading) {
                this.isLoading = false;
                if (!this.items || this.items.length === 0) {
                    this.showToast('No data received. Please check your configuration.', 'warning', 'Warning');
                }
            }
        }, 3000); // Reduced timeout for faster feedback
    }

    // Handle post-render initialization
    renderedCallback() {
        // Clear datatable cache to ensure fresh DOM reference
        this.clearDatatableCache();

        // If we have a value but no processed items, try processing again (only if initial load)
        if (this.value && (!this.items || this.items.length === 0) && this.isLoading && this._isInitialLoad) {
            this.processAgentforceData();
        }
    }

    // Optimized auto-select all records
    autoSelectAllRecords() {
        if (this.items && this.items.length > 0) {
            // Pre-allocate array for better performance
            const selectedIds = new Array(this.items.length);
            let validCount = 0;

            for (let i = 0; i < this.items.length; i++) {
                if (this.items[i].id) {
                    selectedIds[validCount++] = this.items[i].id;
                }
            }

            this.selectedRows = selectedIds.slice(0, validCount);
            this.applySelectionToDataTable();
        }
    }

    // Apply selection to datatable with optimized performance
    applySelectionToDataTable() {
        // Use requestAnimationFrame for better performance than setTimeout
        requestAnimationFrame(() => {
            try {
                const datatable = this.getDatatable();
                if (datatable && datatable.selectedRows !== undefined) {
                    datatable.selectedRows = [...this.selectedRows];
                }
            } catch (error) {
                // Fallback: try once more on next frame
                requestAnimationFrame(() => {
                    try {
                        const datatable = this.getDatatable();
                        if (datatable && datatable.selectedRows !== undefined) {
                            datatable.selectedRows = [...this.selectedRows];
                        }
                    } catch (e) {
                        // Silent fallback
                    }
                });
            }
        });
    }

    // Previous button handler
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.handlePagination(this.page);
        }
    }

    // Next button handler
    nextHandler() {
        if ((this.page < this.totalPages) && this.page !== this.totalPages) {
            this.page = this.page + 1;
            this.handlePagination(this.page);
        }
    }

    // Enhanced pagination handler with selection preservation
    handlePagination(targetPage) {
        // Set pagination flag to prevent selection events
        this.isPaginating = true;

        // Store current selections
        const savedSelections = [...this.selectedRows];

        // Display the new page
        this.displayRecordPerPage(targetPage);

        // Restore and apply selections (use requestAnimationFrame for better performance)
        requestAnimationFrame(() => {
            this.selectedRows = savedSelections;
            this.applySelectionsAfterPagination();
        });
    }

    // Optimized selection application after pagination
    applySelectionsAfterPagination() {
        requestAnimationFrame(() => {
            try {
                const datatable = this.getDatatable();
                if (datatable) {
                    // Force clear first, then apply selections
                    datatable.selectedRows = [];

                    requestAnimationFrame(() => {
                        datatable.selectedRows = [...this.selectedRows];
                        this.isPaginating = false;
                    });
                } else {
                    this.isPaginating = false;
                }
            } catch (error) {
                this.isPaginating = false;
            }
        });
    }

    // Optimized header checkbox prevention
    preventHeaderCheckboxAutoCheck() {
        const currentSelections = [...this.selectedRows];

        requestAnimationFrame(() => {
            try {
                const datatable = this.getDatatable();
                if (datatable) {
                    datatable.selectedRows = [];

                    requestAnimationFrame(() => {
                        datatable.selectedRows = [...currentSelections];
                        this.forceUncheckHeaderCheckbox(datatable);
                    });
                }
            } catch (error) {
                // Silent error handling
            }
        });
    }

    // Force uncheck header checkbox as a last resort
    forceUncheckHeaderCheckbox(datatable) {
        try {
            // Try multiple selectors to find and uncheck the header checkbox
            const selectors = [
                'thead input[type="checkbox"]',
                'lightning-primitive-datatable-header-checkbox input',
                '.slds-th__action input[type="checkbox"]',
                'th input[type="checkbox"]'
            ];

            for (const selector of selectors) {
                const headerCheckbox = datatable.shadowRoot?.querySelector(selector);
                if (headerCheckbox && headerCheckbox.checked) {
                    headerCheckbox.checked = false;
                    headerCheckbox.indeterminate = false;
                    headerCheckbox.dispatchEvent(new Event('change', { bubbles: true }));
                    return true;
                }
            }
            return false;
        } catch (error) {
            return false;
        }
    }

    // Display records page by page (Enhanced for Agentforce)
    displayRecordPerPage(page) {

        // Calculate pagination boundaries
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecords)
            ? this.totalRecords : this.endingRecord;

        // Get the data slice for current page
        this.data = this.items.slice(this.startingRecord, this.endingRecord);

        // Increment by 1 to display the startingRecord count (for UI display)
        this.startingRecord = this.startingRecord + 1;

        // Only apply selections if not called during pagination (pagination handles this separately)
        if (!this.isPaginating) {
            this.applySelectionToDataTable();
        }
    }

    // Optimized row selection handler
    handleRowSelection(event) {
        // Ignore selection events during pagination
        if (this.isPaginating) {
            return;
        }

        // Re-enable Submit when user changes selection (draftContractsTable pattern)
        this.isSubmitted = false;

        try {
            const selectedRows = event.detail?.selectedRows || [];
            const currentPageData = this.data || [];

            // Build lookup maps for O(1) access
            const currentPageIds = new Set();
            const selectedOnPageIds = new Set();

            // Single pass to build page ID set
            for (let i = 0; i < currentPageData.length; i++) {
                if (currentPageData[i]?.id) {
                    currentPageIds.add(currentPageData[i].id);
                }
            }

            // Single pass to build selected IDs set
            for (let i = 0; i < selectedRows.length; i++) {
                if (selectedRows[i]?.id) {
                    selectedOnPageIds.add(selectedRows[i].id);
                }
            }

            const currentPageSize = currentPageIds.size;
            const selectedOnCurrentPage = selectedOnPageIds.size;

            // Header checkbox logic (simplified)
            if (selectedOnCurrentPage === 0 && this.selectedRows.length > currentPageSize) {
                // Deselect all
                this.selectedRows = [];
            } else if (selectedOnCurrentPage === currentPageSize && this.selectedRows.length === 0) {
                // Select all
                this.selectedRows = this.items.filter(item => item.id).map(item => item.id);
            } else {
                // Individual selection - optimize with pre-allocated array
                const newSelectedRows = [];

                // Remove current page items from selection
                for (let i = 0; i < this.selectedRows.length; i++) {
                    if (!currentPageIds.has(this.selectedRows[i])) {
                        newSelectedRows.push(this.selectedRows[i]);
                    }
                }

                // Add newly selected items from current page
                for (const id of selectedOnPageIds) {
                    newSelectedRows.push(id);
                }

                this.selectedRows = newSelectedRows;

                // Prevent header checkbox visual issue
                if (selectedOnCurrentPage === currentPageSize && this.selectedRows.length < this.totalRecords) {
                    this.preventHeaderCheckboxAutoCheck();
                }
            }

        } catch (error) {
            // Silent error handling for selection issues
            console.error('Error in handleRowSelection:', error);
        }
    }

    // Computed properties for pagination buttons
    get isPreviousDisabled() {
        return this.page <= 1;
    }

    get isNextDisabled() {
        return this.page >= this.totalPages;
    }

    // Method to dispatch value change events to notify Agentforce (aligned with Agentforce pattern)
    dispatchValueChangeToAgentforce(eventType, eventData = {}) {
        // Create event data without modifying component's value property to preserve user selections
        const eventDetail = {
            ...this.value,
            eventType: eventType,
            timestamp: new Date().toISOString(),
            ...eventData
        };

        // Dispatch the valuechange event to notify Agentforce (following Agentforce pattern)
        this.dispatchEvent(new CustomEvent('valuechange', { detail: eventDetail }));

        console.log('Dispatching valuechange event:', eventType);
    }

    // Agentforce-compatible submit handler with event notifications
    async handleSubmitToAgentforce() {
        try {
            console.log('🔘 Submit button clicked, current state:', {
                isSubmitting: this.isSubmitting,
                clickCount: this._submitClickCount,
                preventRerender: this._preventRerender
            });

            // TRIPLE PROTECTION: Multiple layers to prevent double-clicks
            this._submitClickCount++;

            // Protection 1: Check if already submitting
            if (this.isSubmitting) {
                console.log('❌ Button already clicked, ignoring subsequent clicks');
                return;
            }

            // Protection 2: Check click count
            if (this._submitClickCount > 1) {
                console.log('❌ Multiple clicks detected, ignoring');
                return;
            }

            // AGGRESSIVE PROTECTION: Block ALL re-rendering during submission
            this._preventRerender = true;
            this.isSubmitting = true;
            console.log('🔒 Button disabled and re-render blocked:', {
                isSubmitting: this.isSubmitting,
                preventRerender: this._preventRerender
            });

            // Force immediate DOM update to disable button visually
            await new Promise(resolve => setTimeout(resolve, 50));

            // Validate selection AFTER disabling button
            if (!this.selectedRows || this.selectedRows.length === 0) {
                this.showToast('Please select at least one record to submit', 'warning', 'No Selection');
                // Re-enable button if validation fails
                this.isSubmitting = false;
                this._preventRerender = false;
                this._submitClickCount = 0; // Reset click counter
                return;
            }

            // Prepare submission data for Agentforce
            const submissionData = this.prepareSubmissionData();

            // Dispatch event BEFORE Apex call to notify Agentforce submission started
            this.dispatchValueChangeToAgentforce('SUBMISSION_STARTED', {
                selectedIds: submissionData.selectedIds,
                recordCount: submissionData.selectedIds.length,
                status: 'PROCESSING'
            });

            const accountId = this.getAccountId();
console.log('_value'+JSON.stringify(this._value));
            // Call Apex method
            const result = await processSelectedRecords({
                actionType: 'SUBMIT_SELECTION',
                selectedRecordIds: submissionData.selectedIds,
                accountId: accountId,
                lContractId: this._value?.contractId,
                submissionDataJson: JSON.stringify(submissionData.selectionMetadata)
            });

            if (result && result.success) {
                this.isSubmitted = true; // Disable submit until user changes selection (draftContractsTable pattern)
                // SUCCESS - Store results in component for Agentforce to access
                this.submissionResult = {
                    success: true,
                    selectedRecords: submissionData.selectedRecords,
                    selectedIds: submissionData.selectedIds,
                    totalSelected: submissionData.selectedIds.length,
                    submissionTime: new Date().toISOString(),
                    message: result.message || `Successfully processed ${submissionData.selectedIds.length} records`,
                    apexResponse: result
                };

                // Dispatch success event AFTER Apex call to trigger next Agentforce action
                this.dispatchValueChangeToAgentforce('SUBMISSION_COMPLETE', {
                    selectedIds: submissionData.selectedIds,
                    recordCount: submissionData.selectedIds.length,
                    status: 'SUCCESS',
                    triggerNextAction: true,
                    nextAction: 'Get Contract File Links',
                    executeAction: 'Get Contract File Links',
                    contractIds: submissionData.selectedIds,
                    apexResponse: result,
                    message: result.message,
                    submissionResult: this.submissionResult
                });

                this.showToast(
                    `✅ ${submissionData.selectedIds.length} records processed successfully!`,
                    'success',
                    'Submission Complete'
                );

                console.log('Submission successful');

            } else {
                // ERROR from Apex
                const errorMessage = result ? result.message : 'Unknown error occurred';

                this.submissionResult = {
                    success: false,
                    error: errorMessage,
                    submissionTime: new Date().toISOString(),
                    apexResponse: result
                };

                // Dispatch error event to notify Agentforce
                this.dispatchValueChangeToAgentforce('SUBMISSION_ERROR', {
                    status: 'ERROR',
                    error: errorMessage,
                    apexResponse: result,
                    submissionResult: this.submissionResult
                });

                this.showToast('❌ Submission failed: ' + errorMessage, 'error', 'Error');
                console.error('Apex call failed:', errorMessage);
            }

        } catch (error) {
            console.error('Error in submission:', error.message);

            this.submissionResult = {
                success: false,
                error: error.message,
                submissionTime: new Date().toISOString()
            };

            // Dispatch error event to notify Agentforce
            this.dispatchValueChangeToAgentforce('SUBMISSION_ERROR', {
                status: 'ERROR',
                error: error.message,
                errorDetails: {
                    message: error.message,
                    stack: error.stack,
                    name: error.name
                }
            });

            this.showToast('Submission failed: ' + error.message, 'error', 'Error');
        } finally {
            console.log('🔓 Finally block: Re-enabling button and resetting state');

            // Reset ALL submission state and protection flags
            this.isSubmitting = false;
            this._preventRerender = false;
            this._submitClickCount = 0;

            console.log('✅ Button state reset:', {
                isSubmitting: this.isSubmitting,
                preventRerender: this._preventRerender,
                clickCount: this._submitClickCount
            });

            // Dispatch final status event to notify Agentforce processing is complete
            this.dispatchValueChangeToAgentforce('SUBMISSION_FINISHED', {
                isSubmitting: false,
                finalStatus: this.submissionResult ? (this.submissionResult.success ? 'SUCCESS' : 'ERROR') : 'UNKNOWN'
            });
        }
    }

    // Prepare data for Agentforce submission
    prepareSubmissionData() {
        const selectedRecords = this.items.filter(item =>
            this.selectedRows.includes(item.id)
        );

        return {
            selectedIds: [...this.selectedRows],
            selectedRecords: selectedRecords.map(record => ({
                id: record.id,
                clinicianName: record.clinicianName,
                facilityTitle: record.facilityTitle,
                overrate: record.overrate,
                rowNumber: record.rowNumber
            })),
            totalSelected: this.selectedRows.length,
            totalRecords: this.totalRecords,
            selectionMetadata: {
                pageSize: this.pageSize,
                currentPage: this.page,
                totalPages: this.totalPages,
                timestamp: new Date().toISOString(),
                userAction: 'SUBMIT_SELECTION'
            }
        };
    }

    get isSubmitDisabled() {
        return this.isSubmitting || this.isSubmitted;
    }

    // Get submission results (for Agentforce to access)
    @api
    getSubmissionResults() {
        return this.submissionResult;
    }

    // Get selected records data (for Agentforce to access)
    @api
    getSelectedRecordsData() {
        if (!this.selectedRows || this.selectedRows.length === 0) {
            return {
                success: false,
                message: 'No records selected',
                selectedRecords: []
            };
        }

        const selectedRecords = this.items.filter(item =>
            this.selectedRows.includes(item.id)
        );

        return {
            success: true,
            message: `${selectedRecords.length} records selected`,
            selectedRecords: selectedRecords,
            selectedIds: [...this.selectedRows],
            metadata: {
                totalRecords: this.totalRecords,
                selectionPercentage: Math.round((this.selectedRows.length / this.totalRecords) * 100),
                timestamp: new Date().toISOString()
            }
        };
    }

    // Helper method to extract account ID from current data context
    getAccountId() {
        // Try to extract account ID from the current value/context
        if (this._value) {
            // Look for account ID in various possible locations
            if (this._value.accId) return this._value.accId;
            if (this._value.accountId) return this._value.accountId;
            if (this._value.clinicalDataList && this._value.clinicalDataList.accountId) {
                return this._value.clinicalDataList.accountId;
            }

            // If we have records, try to derive from them (though this may not be reliable)
            if (this._value.clinicalRecords && this._value.clinicalRecords.length > 0) {
                const firstRecord = this._value.clinicalRecords[0];
                if (firstRecord.accountId) return firstRecord.accountId;
            }
        }

        // Fallback - this should be set by Agentforce when component is loaded
        console.warn('⚠️ Account ID not found in context. Make sure Agentforce passes accountId.');
        return null;
    }

    // Show toast message
    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}