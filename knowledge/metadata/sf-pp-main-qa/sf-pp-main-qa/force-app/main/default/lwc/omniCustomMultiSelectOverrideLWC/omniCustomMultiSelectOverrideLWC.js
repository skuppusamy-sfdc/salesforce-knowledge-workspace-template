import OmniscriptMultiselect from "omnistudio/omniscriptMultiselect";
import template from "./omniCustomMultiSelectOverrideLWC.html";

export default class OmniCustomMultiSelectOverrideLWC extends OmniscriptMultiselect {
  _hasRendered = false;
  _propMap = {};
  _defaultOptions = [];

  renderedCallback() {
    console.log('OUTPUT : ',JSON.stringify(this.jsonDef));
    if (!this._hasRendered && this.jsonDef && this.jsonDef.propSetMap) {
      this._propMap = this.jsonDef.propSetMap;
      console.log("this._propMap >> "+JSON.stringify(this._propMap));
      this.applyCallResp(this._propMap.defaultValue);
      this._hasRendered = true;
    }
  }

  get label() {
    if (this.hasValues()) {
      return this._propMap.label;
    }
    return "";
  }

  get helpText() {
    if (this.hasValues()) {
      return this._propMap.helpText;
    }
    return "";
  }

  get options() {
    if (this.hasValues()) {
      let options = [];
      options = this._propMap?.options?.map((op) => {
        let obj = {};
        obj.label = op.value;
        obj.value = op.name;
        return obj;
      });
      return options;
    }
    return [];
  }

  hasValues() {
    return Object.keys(this._propMap).length > 0;
  }

  get name() {
    if (this.jsonDef && this.jsonDef.name) {
      return this.jsonDef.name;
    }
    return "";
  }

  handleChange(e) {
    this.applyCallResp(e.detail.value.join(";"));
  }

  render() {
    return template;
  }

  get values() {
    if (this.hasValues()) {
      //return [this._propMap.defaultValue];
      if (this.elementValue) {
        let tmp = this.elementValue?.indexOf(";")
                ? this.elementValue.split(";")
                : this.elementValue;
        this._defaultOptions.push(...tmp);
      }

      return this._defaultOptions;
    }
    return "";
  }
}