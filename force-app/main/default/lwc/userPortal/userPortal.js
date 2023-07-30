import {api, track, LightningElement } from 'lwc';
import getAccountData from '@salesforce/apex/DealerAndNonDealerAccountSearch.getAccountData';


export default class UserPortal extends LightningElement {
    value = '';
    isDealerOrNonDealer = '';
    isDealer = '';
    isInputValid = false ;
    showWarningPopupModal = false;
    @api facilityName;
    @api facilityZipCode;
    @api taxIdNumberType;
    @api einNumber='';
    @api phoneNumber='';
    @api searchKey;
    @api dealerOrNonDealer;
    @api accountList;

    get options() {
        return [
            { label: 'Assurant Client/Dealer Selling Production Products', value: 'Yes' },
            { label: 'Independent Repair Facility/Non-Selling Dealership', value: 'No' },
        ];
    }
    handleFacilityName(event){
        this.facilityName = event.target.value ;
    }
    handleFacilityZipCode(event){
        this.facilityZipCode = event.target.value ;
    }
    handleFacilityPhone(event){
        this.phoneNumber = event.target.value ;
    }
    handleEIN(event){
        this.einNumber = event.target.value ;
    }
    handleChange(event){
       
        if(event.target.value == 'No'){
            this.isDealerOrNonDealer = true;
            this.isDealer = false;
            this.dealerOrNonDealer = 'Non-Dealer';
        }else{
            this.isDealerOrNonDealer = true;
            this.isDealer = true;
            this.dealerOrNonDealer = 'Dealer';
         }

    }
    handleBack(){
        this.isDealerOrNonDealer = false;
        this.isDealer = false;
        
    }
    SearchAccountHandler(){
        console.log("Inside SearchHandler")
        let dealertype =this.dealerOrNonDealer;
        console.log("dealertype");
        let searchKey = this.facilityName + ',' + this.facilityZipCode + ',' + this.phoneNumber + ',' + this.einNumber;
        console.log("searchKey");
        console.log(this.isInputValids());
            console.log(this.facilityName);
            console.log(this.facilityZipCode);
            console.log(this.phoneNumber);
            console.log(this.einNumber);
            console.log(dealertype);
        
        if(this.isInputValids()){

            getAccountData({searchKey: searchKey, dealerOrNonDealer :dealertype})
            .then(result => {
                    this.accountList = result;
                    console.log(result);
                if(result.length>0){
                    this.isInputValid = true;
                }else{
                    this.showWarningPopupModal = true;
                }

            })
            .catch({
               
            });
            console.log(this.isInputValids());
            console.log(this.facilityName);
            console.log(this.facilityZipCode);
            console.log(this.phoneNumber);
            console.log(this.einNumber);
            console.log(dealertype);
        }else{
            console.log(dealertype);
        }

    }

    isInputValids() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
                
            }
        });
        return isValid;
    }
    handleCloseModal(){
        this.showWarningPopupModal = false;
    }
}