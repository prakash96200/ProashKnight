import { LightningElement,api } from 'lwc';
import insertNonDealerAccount from '@salesforce/apex/DealerAndNonDealerAccountSearch.insertNonDealerAccount';
export default class NewNonDealerAccountCreationComponent extends LightningElement {
    facilityName;
    facilityStreetAddressOne;
    facilityStreetAddressTwo = null;
    facilityCity;
    facilityState;
    facilityCountry = 'USA';
    facilityPostalCode; 
    facilityEmail;
    facilityPhone;
    facilityFax;
    EIN;
    EntityType;
    @api accountList;
    @api isDealerOrNonDealerRecordType;
    @api nonDealerAccount = { 'sobjectType': 'Account'};
    formatPhoneNumber(event){
        var phoneNumber = event.target.value;
        var s = (""+phoneNumber).replace(/\D/g, '');
        var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
        var formattedPhone = (!m) ? phoneNumber :   "(" + m[1]+ ") " + m[2] + "-" + m[3];
        if(event.target.label === 'Facility Phone'){
            this.facilityPhone=formattedPhone;
        }else if(event.target.label === 'Fax'){
            this.facilityFax = formattedPhone;
        }
    }
    handleRecordChange(event){
        if(event.target.label == 'Facility Name'){
            this.facilityName = event.target.value;
        }
        if(event.target.label == 'Street Address'){
            this.facilityStreetAddressOne = event.target.value;
        }
        if(event.target.label == 'Address Line 2'){
            this.facilityStreetAddressTwo = event.target.value;
        }
        if(event.target.label == 'City'){
            this.facilityCity = event.target.value;
        }
        if(event.target.label == 'State/Provience'){
            this.facilityState = event.target.value;
        }
        if(event.target.label == 'Postal Code'){
            this.facilityPostalCode = event.target.value;
        }
        if(event.target.label == 'Company Email Address'){
            this.facilityEmail = event.target.value;
        }
        if(event.target.label == 'Facility Phone'){
            this.facilityPhone = event.target.value;
        }
        if(event.target.label == 'Fax'){
            this.facilityFax = event.target.value;
        }
        if(event.target.label == 'Employee Identification Number'){
            this.EIN = event.target.value;
        }
    }
    get entityOption(){
            return [
                { label: 'Entity One', value: 'Entity One' },
                { label: 'Entity Two', value: 'Entity Two' },
                { label: 'Entity Three', value: 'Entity Three' },
            ];
    }
    get stateOption() {
        return [
            { label: 'State One', value: 'State One' },
            { label: 'State Two', value: 'State Two' },
        ];
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
passAccountList(){
    console.log('passAccountList');
    const accountListEvent = new CustomEvent('pass',{detail: {
        accountList : this.accountList
    }});
    console.log('passAccount');
    this.dispatchEvent(accountListEvent);
}
backToEZPass(){
    console.log('backToEZPass');
    console.log(this.isDealerOrNonDealerRecordType);
    this.dispatchEvent(new CustomEvent('back'));
}
createNonDealerAccountHandler(){
    if(this.isInputValids()){
        this.nonDealerAccount.Name = this.facilityName;
        this.nonDealerAccount.BillingStreet = this.facilityStreetAddressOne + this.facilityStreetAddressTwo;
        this.nonDealerAccount.BillingState  = this.facilityState;
        this.nonDealerAccount.BillingCity = this.facilityCity;
        this.nonDealerAccount.BillingCountry = this.facilityCountry;
        this.nonDealerAccount.Zip_Code__c =this.facilityPostalCode;
        this.nonDealerAccount.Company_Email_Address__c = this.facilityEmail;
        this.nonDealerAccount.Phone_Number__c = this.facilityPhone;
        this.nonDealerAccount.EIN__c = this.EIN;
        this.nonDealerAccount.Fax = this.facilityFax;
        this.nonDealerAccount.RecordTypeId = this.isDealerOrNonDealerRecordType;
        console.log(this.nonDealerAccount);
        insertNonDealerAccount({
            nonDealerAccount:this.nonDealerAccount
        })
        .then(result=>{
            console.log(result);
            if(result.length>0){
                this.accountList = result;
                this.passAccountList();
            }
        })
        .catch({

        })      
    }
}
}