import { LightningElement,api } from 'lwc';
import getAccountData from '@salesforce/apex/DealerAndNonDealerAccountSearch.getAccountData';
import getRecordTypeForAccount from '@salesforce/apex/DealerAndNonDealerAccountSearch.getAccountRecordTypeMap';
import warningModal from 'c/genericWarningModal';
export default class EzPassPortal extends LightningElement {
    isDealer = false;
    isDealerOrNonDealer = false;
    facilityName = null;
    facilityPhoneNumber = null;
    facilityZipCode = null;
    einNumber = null;
    isNoNonDealerFound = false;
    radioButtonValue;
    accountRecordType;
    isDealerOrNonDealerRecordType;
    @api accountList;
    searchKey;
    connectedCallback(){
        getRecordTypeForAccount()
        .then(result => {
            if(result != null){
            this.accountRecordType = new Map(Object.entries(result));
            }
       
        })
        .catch({
        });
   }
    
    get options() {
        return [
            { label: 'Assurant Client/Dealer Selling Production Products', value: 'Dealer' },
            { label: 'Independent Repair Facility/Non-Selling Dealership', value: 'Non_Dealer' },
        ];
    }
    handleFacilityName(event){
        this.facilityName = event.target.value ;
    }
    handleFacilityZipCode(event){
        this.facilityZipCode = event.target.value ;
    }
    handleFacilityPhone(event){
        this.facilityPhoneNumber = event.target.value ;
    }
    handleEIN(event){
        this.einNumber = event.target.value ;
    }
    handleChange(event){
        var accountRecordTpeMap = this.accountRecordType;
        if(event.target.value == 'Non_Dealer'){
        this.isDealerOrNonDealer = true;
        this.isDealer = false;
        this.facilityName = null;
        this.facilityPhoneNumber = null;
        this.facilityZipCode = null;
        this.einNumber = null;
        this.isDealerOrNonDealerRecordType = accountRecordTpeMap.get('Non_Dealer');
        console.log(this.isDealerOrNonDealerRecordType);
        }else{
            this.isDealerOrNonDealer = true;
            this.isDealer = true;
            this.isDealerOrNonDealerRecordType = accountRecordTpeMap.get('Dealer');
            console.log(this.isDealerOrNonDealerRecordType);
            this.facilityName = null;
            this.facilityPhoneNumber = null;
            this.facilityZipCode = null;
            this.einNumber = null;
        }
    }

    isInputValid() {
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

    formatPhoneNumber(event){
        var phoneNumber = event.target.value;
        var s = (""+phoneNumber).replace(/\D/g, '');
        var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
        var formattedPhone = (!m) ? phoneNumber :   "(" + m[1]+ ") " + m[2] + "-" + m[3];
        this.facilityPhoneNumber=formattedPhone;
    }
    handlePassAccountListEvent(event){
        console.log('handlePassAccountListEvent');
        console.log(event.detail.accountList);
        this.accountList = event.detail.accountList;
        console.log('ACCOUNT LIST'+this.accountList);

        this.isNoNonDealerFound = false;
    }
    handleBackEvent(){
        console.log('handleBackEvent');
        this.radioButtonValue = '';
        this.isNoNonDealerFound = false;
        this.isDealerOrNonDealer = false;
        this.isDealer =false;

    }
    SearchAccountHandler(){
        console.log(this.facilityName);
        console.log(this.facilityZipCode);
        console.log(this.facilityPhoneNumber == null);
        console.log(this.einNumber == null);        
        console.log(this.isInputValid())
       if(this.isInputValid()){
        var searchKey = this.facilityName+','+this.facilityZipCode+','+this.facilityPhoneNumber+','+this.einNumber;
        var searchKeyData = searchKey.split(',');
        console.log(searchKeyData);
        console.log(searchKeyData[0]);
        console.log(searchKeyData[1]);
        console.log(searchKeyData[2]);
        console.log(searchKeyData[3]);
            getAccountData({              
                searchKey: searchKey,
                dealerOrNonDealerRecordTypeId:this.isDealerOrNonDealerRecordType
                                })
            .then(result => {
                    if(result.length>0){
                        this.accountList = result;
                    }
                    else if(this.isDealerOrNonDealerRecordType == this.accountRecordType.get('Non_Dealer') ){
                        this.isNoNonDealerFound = true;
                    }
                    else{
                        this.showModal();
                    }
            })
            .catch( {
                
            });
        }
    }
    async showModal(){
        await warningModal.open({
            size: 'small',
            content: 'No Dealer Records found for given value',
        });
    }

}