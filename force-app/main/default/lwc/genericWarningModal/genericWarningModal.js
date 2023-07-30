import {api} from 'lwc';
import LightningModal from 'lightning/modal';
export default class GenericWarningModal extends LightningModal {
@api content;
handleConfirm() {
    this.close();   
}
}