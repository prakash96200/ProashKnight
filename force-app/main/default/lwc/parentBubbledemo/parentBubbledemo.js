import { LightningElement } from 'lwc';

export default class ParentBubbledemo extends LightningElement {

    handleChildEvent1(){
        console.log("Event Fired from handleChildEvent1")
    }
    
    handleChildEvent2(){
        console.log("Event Fired from handleChildEvent2")
    }

    onclick1(){
        console.log("Event Fired from onclick1")
    }
    onclick2(){
        console.log("Event Fired from onclick2")
    }
    onclick3(){
        console.log("Event Fired from onclick3")
    }
    onclick4(){
        console.log("Event Fired from onclick4")
    }
}