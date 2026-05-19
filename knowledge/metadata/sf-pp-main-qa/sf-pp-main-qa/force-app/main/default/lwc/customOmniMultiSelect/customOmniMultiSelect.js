import { api, track, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';

export default class CustomOmniMultiSelect extends OmniscriptBaseMixin(LightningElement) {

    // @track property to hold the currently selected values in the Dual Listbox.
    // This is crucial for retaining the selection across re-renders.
    @track selectedValues = []; 

    @api inputPropertyMap; // Received from OmniScript 
    // Flag to ensure initial data loading from omniJsonData happens only once.
    _isInitialized = false; 
    
    // ConnectedCallback is generally preferred for initial setup.
    connectedCallback() {
        // If omniJsonData is available and not yet initialized, load the data.
        // This handles cases where the user navigates back to the step.
        if (this.omniJsonData && !this._isInitialized) {
            this.loadInitialDataFromOmniScript();
        }
    }

    // Use renderedCallback for potential updates if OmniScript dynamically changes omniJsonData
    // while the component is still mounted 
    renderedCallback() {
        if (this.omniJsonData && !this._isInitialized) {
            this.loadInitialDataFromOmniScript();
        }
    }

    loadInitialDataFromOmniScript() {
        const componentData = this.omniJsonData[this.inputPropertyMap?.stepName];
        if (componentData && componentData[this.inputPropertyMap?.componentName]) {
            // OmniScript typically stores the array of objects as we transformed it.
            // We need to convert it back to a simple array of values (strings) for dual-listbox.
            this.selectedValues = componentData[this.inputPropertyMap?.componentName].map(item => item.value);
        }
        this._isInitialized = true; // Mark as initialized
    }

    get componentIsValid() {
        // Validation logic : check if selectedValues has any items.
        return this.selectedValues.length > 0 ;
    }
   
    get label() {
        return this.inputPropertyMap?.label || ""; // Safely get label, default to empty string
    }
    
    get options() {
        if (this.inputPropertyMap?.options && this.inputPropertyMap?.options.length > 0) {
            // Transform the options array 
            return this.inputPropertyMap.options.map(op => ({
                label: op.Name,
                value: op.Id
            }));
        }
        return []; // Return empty array if no options
    }

    handleChange(event) {
        // Update the @track property with the new selection from the dual listbox.
        // This immediately updates the UI and retains the data.
        this.selectedValues = event.detail.value; 

        // Transform the array of IDs into an array of objects
        const transformedArray = this.selectedValues.map(item => {
            
            let label = this.options.filter(opt => opt.value === item)[0].label;
            let opt = { value: item, label: label };
            return opt;
         });

        // Construct the value object for OmniScript.
        const CustomLWCValue = {
            [this.inputPropertyMap?.stepName]: {
                [this.inputPropertyMap?.componentName]: transformedArray
            }
        };
        
        // Send the updated value to OmniScript.
        this.omniApplyCallResp(CustomLWCValue);

        // This tells OmniScript to re-evaluate validation.
        this.omniValidate(false); 
    }

    @api checkValidity() {
        // OmniScript will call this method. It should return true/false based on our logic.
        //return this.componentIsValid;
        if(this.isRequired == false){
            return true;
        }else{
            return this.componentIsValid;
        }
    }

    get name(){
        return this.inputPropertyMap?.name;
    }

    get isRequired(){
        return this.inputPropertyMap?.required;
    }
}