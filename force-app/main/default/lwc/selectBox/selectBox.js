import { LightningElement,track } from 'lwc';

export default class SelectBox extends LightningElement {
@track select;
@track defaultValue;
@track options;

connectedCallback(){
        let secondOption =[
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
        let trueVal = false;
        let falseVal = true;
        this.options=secondOption;
        this.defaultValue=secondOption[1].value;
    if(trueVal)
    {
        this.select = 'select'
    }
    else if(falseVal)
    {
        this.select = secondOption[1].value;
    }}
    handleChange(event){
        var value= event.target.value;
        if(value !=''){
        this.template.querySelector('[data-id="divblock]').className='slds-form-element';  
        this.template.querySelector('[data-id="divblock2]').className='slds-hidden';  
    
      }
        
        else if(value === '')
        {
            this.template.querySelector('[data-id="divblock]').className='slds-form-element slds-has-error';    
            this.template.querySelector('[data-id="divblock2]').className='slds-form-element__help';    }
        
            
        }

    }