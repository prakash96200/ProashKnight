import { LightningElement } from 'lwc';

export default class ChildBubbledemo extends LightningElement {

    fireEvent(){
        this.dispatchEvent(new CustomEvent('bubbledemo',{
            bubbles: true
        }))
    }
}