import { LightningElement, api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import NAME from '@salesforce/schema/Account.Name'
import ACCOUNT_NUMBER from '@salesforce/schema/Account.AccountNumber'
import TYPE from '@salesforce/schema/Account.Type'

export default class RecordForm extends LightningElement {
@api recordId;
get hasRecordId(){
    if(this.recordId == ''){
        return false;
    }
    else{
        return true;
    }
}
objectName = ACCOUNT_OBJECT;
fields=[NAME, ACCOUNT_NUMBER, TYPE] ;
}