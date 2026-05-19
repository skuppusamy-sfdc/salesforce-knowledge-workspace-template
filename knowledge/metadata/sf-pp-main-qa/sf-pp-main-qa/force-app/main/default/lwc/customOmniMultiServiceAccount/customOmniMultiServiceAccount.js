// --- Helper Function for Array Comparison ---
// Compares two arrays of IDs for identical content, ignoring order.
// This function runs in O(N) time complexity, which is highly performant.
function areArraysIdentical(arr1, arr2) {
    if (arr1.length !== arr2.length) {
        return false;
    }
    
    const set1 = new Set(arr1);
    const set2 = new Set(arr2);
    
    // We only need to check one way since the lengths are guaranteed to be equal here.
    for (const item of set1) {
        if (!set2.has(item)) {
            return false;
        }
    }
    return true;
}


import { api, track, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';

export default class CustomOmniMultiServiceAccount extends OmniscriptBaseMixin(LightningElement){

    // Private state for user's current selection. Null means we haven't selected anything yet.
    @track _selectedValues = null; 
    
    // Custom name for the error state to avoid OmniScript proxy conflicts.
    @track _displayErrorState = false; 

    // Flag to track if validation has been manually triggered at least once (for error suppression).
    @track _hasBeenValidated = false; 

    // Stores the selection (array of IDs) when the component first loads for change comparison.
    _originalSelectedValues = null; 
    // Flag to ensure the original selection is only captured once.
    _isInitialLoadComplete = false;

    @api inputPropertyMap; // Configuration received from OmniScript 

    
    // Core Prepopulation Logic: Determines the selected values on render.
    get selectedValues() {
        // 1. If the user has already interacted, use the tracked selection.
        if (this._selectedValues !== null) {
            return this._selectedValues;
        }

        // 2. Initial Load Check (Runs if _selectedValues is null)
        const stepName = this.inputPropertyMap?.stepName;
        const compName = this.inputPropertyMap?.componentName;
        
        // Safely access the prepopulated data path
        const componentData = this.omniJsonData?.[stepName]?.[compName];
        
        let initialValues = [];
        
        if (componentData && Array.isArray(componentData)) {
            // Data found (prepopulated). Return the IDs.
            initialValues = componentData.map(item => item.value);
        }

        // --- Change Tracking Setup (Strict Capture) ---
        // Capture the original values only once when the data is first available.
        if (!this._isInitialLoadComplete && this.omniJsonData) {
            // Use JSON methods for a deep, immutable copy of the array content
            this._originalSelectedValues = JSON.parse(JSON.stringify(initialValues));
            this._isInitialLoadComplete = true;
        }

        return initialValues; 
    }
    
    get componentIsValid() {
        return this.selectedValues.length > 0;
    }
    
    get displayErrorState() {
        return this._displayErrorState;
    }
    
    get label() {
        return this.inputPropertyMap?.label || "Service Accounts"; 
    }
    
    get fieldName() {
        return this.inputPropertyMap?.fieldName || "Service Account Selection";
    }
    
    get helpText() {
        return this.inputPropertyMap?.helpText || null;
    }
    
    get options() {
        if (this.inputPropertyMap?.options && this.inputPropertyMap?.options.length > 0) {
            return this.inputPropertyMap.options.map(op => ({
                label: op.Name,
                value: op.pncId
            }));
        }
        return []; 
    }

    handleChange(event) {
        // 1. Update the private @track property with the new selection.
        this._selectedValues = event.detail.value; 
        
        // 2. Clear visual error state instantly on change
        this._displayErrorState = false; 

        // 3. Transform the array of IDs back into the array of {value, label} objects required by OmniScript
        const currentSelectionIds = this._selectedValues;

        const transformedArray = currentSelectionIds.map(item => {
            const option = this.options.find(opt => opt.value === item);
            return { 
                value: item, 
                label: option ? option.label : item
            };
         });
         
        // --- Change Tracking: Compare current selection vs. original selection using helper ---
        const originalArray = this._originalSelectedValues || [];
        const currentArray = currentSelectionIds;

        const areIdentical = areArraysIdentical(originalArray, currentArray);
        const isChanged = !areIdentical;


        // 4. Send the updated value object to OmniScript.
        const CustomLWCValue = {
            [this.inputPropertyMap?.stepName]: {
                [this.inputPropertyMap?.componentName]: transformedArray,
                // FINAL FLAG: Send isChanged back to OmniScript
                isChanged: isChanged
            }
        };
        
        this.omniApplyCallResp(CustomLWCValue);

        // 5. Tell OmniScript to re-evaluate validation.
        this.omniValidate(false); 
    }

    @api checkValidity() {
        // OmniScript calls this method.
        
        // If not required, always valid.
        if (this.isRequired === false) {
            this._displayErrorState = false;
            return true;
        } 
        
        const isValid = this.componentIsValid;
        
        // On initial load, we return the true validation status but suppress the visual error.
        if (!this._hasBeenValidated) {
            this._hasBeenValidated = true; 
            return isValid; 
        }
        
        // After the first check (i.e., when user hits Next or Save):
        this._displayErrorState = !isValid; 
        
        return isValid;
    }

    get name(){
        return this.inputPropertyMap?.componentName;
    }

    get isRequired(){
        return this.inputPropertyMap?.required;
    }
}