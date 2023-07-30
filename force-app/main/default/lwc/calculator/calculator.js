import { LightningElement } from 'lwc';

export default class Calculator extends LightningElement {
    number1;
    number2;
    number3;
    isAnswer = false;
    handleChangeEvent(event){
        const val = event.target.value;
        const name = event.target.name;
        if(name === 'number1'){
            this.number1 = val;
        }else{
            this.number2 = val;
        }
    }
    doSum(){
        const sum = parseInt(this.number1) + parseInt(this.number2);
        this.number3 = sum;
        this.isAnswer = true;
    }
    doSubsc(){
        const subsc = parseInt(this.number1) - parseInt(this.number2);
        this.number3 = subsc;
        this.isAnswer = true;
    }

    doDiv(){
        const divOut = parseInt(this.number1) / parseInt(this.number2);
        this.number3 = divOut;
        this.isAnswer = true;
    }

    doMulti(){
        const multiPli = parseInt(this.number1) * parseInt(this.number2);
        this.number3 = multiPli;
        this.isAnswer = true;
    }
    doReset(){
        this.number1 = '';
        this.number2 = '';
        this.number3 = '';
        this.isAnswer = false;
    }
}