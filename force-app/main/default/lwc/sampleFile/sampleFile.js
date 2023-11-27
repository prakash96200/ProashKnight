import { LightningElement,api} from "lwc";
import getAccount from '@salesforce/apex/AccountListController.fetchAccts'
import NUMBER_FIELD from "@salesforce/schema/Account.number__c";
export default class PickList extends LightningElement {
@api recordId;
account;
connectedCallback(){
    this.fetchAccount();
}

    value = 'inProgress';
    fetchAccount(){
        getAccount({ accId: this.recordId})
        .then(result=>{
            this.account = result;
            this.account.number__c = this.account.number__c;
        })
        }
    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

      

    }