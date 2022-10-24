import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class DependentPicklistWithRecordType extends LightningElement {

    @api controllingField;
    @api controllingFieldRequired;
    @api dependentField;
    @api dependentFieldRequired;
    @api userDefaultRecordTypeId;
    @api objectApiName='Account';
    @api disableRecordTypeSelection;
    @api hideRecordTypeInput;
    @api controllingFieldValue;
    @api dependentFieldValue;
    @api recordTypeId;

    objectInfo;
    showPicklists = true;

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    handleObjectInfoWire({error, data}) {

        if(error) {
            this.handleError(error);
            return;
        }

        if(!data) {
            return;
        }

        this.objectInfo = data;
        this.initRecordTypeId();
    }

    initRecordTypeId() {

        if(!this.objectInfo) {
            return;
        }

        this.recordTypeId = this.userDefaultRecordTypeId 
            ? Object.keys(this.objectInfo.recordTypeInfos).find(rtId => rtId === this.userDefaultRecordTypeId )
            : this.defaultRecordTypeId;
    }

    handleRTChange(event) {
        this.showPicklists = false;
        this.recordTypeId = event.detail.value;
        setTimeout(() => {this.showPicklists = true});
    }
    
    handleControllingPicklistChange(event) {
        this.controllingFieldValue = event.detail.value;
    }

    handleDependentPicklistChange(event) {
        this.dependentFieldValue = event.detail.value;
    }

    handleError(err) {
        console.error(err);
    }

    get recordTypesList() {
        if(!this.objectInfo) {
            return;
        }

        const rtInfoList = this.objectInfo.recordTypeInfos;
        let rtList = [];
        Object.keys(this.objectInfo.recordTypeInfos).forEach(rt => {
            let rtInfo = rtInfoList[rt];
            rtInfo.master || !rtInfo.available || rtList.push(this.getRecordTypeOption(rtInfo));
        });

        return rtList;
    }

    getRecordTypeOption(rtInfo) {
        return { 
            label : rtInfo.name, 
            value: rtInfo.recordTypeId 
        };
    }

    get defaultRecordTypeId() {
        return this.objectInfo?.defaultRecordTypeId;
    }

    get showRecordTypeInput() {
        return this.recordTypeId && !this.hideRecordTypeInput;
    }
    @api
    validate() {
    	//If the component is invalid, return the isValid parameter as false and return an error message.
        console.log("validating" + ": ", "entering validate: required=" + this.controllingFieldRequired + " value=" + this.controllingFieldValue);
        let errorMessage = "You must make a selection in this field to continue";

        if ( (this.controllingFieldRequired && !this.controllingFieldValue) || (this.dependentFieldRequired && !this.dependentFieldValue) ) {
            return {
                isValid: false,
                errorMessage: errorMessage
            };
        }
        return { isValid: true };
        
    } 

}
