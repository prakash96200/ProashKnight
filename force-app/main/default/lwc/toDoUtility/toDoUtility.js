import { LightningElement , track} from 'lwc';
import getToDoList from '@salesforce/apex/ToDoController.getToDoList';
import toInsertToDoList from '@salesforce/apex/ToDoController.inserToDoList';
import toUpdateOrDeleteTodDoList from '@salesforce/apex/ToDoController.updateOrDelete';
export default class ToDoUtility extends LightningElement {
    toDO =  { 'sobjectType': 'TO_DO__c'}
    @track toDoList;
    insertToDoList;
    @track updateOrDeleteToDoIdList =[];
    @track isChecked = false;
    @track isMassSelect = false;
    @track isDelete;
    connectedCallback(){
        getToDoList()
        .then(result => {
            if(result != null){
            this.toDoList = result;
            }
            console.log(result);
            console.log(this.toDoList[0].Name);
            console.log(this.toDoList[0].id);
            console.log(this.toDoList[0].Priority__c);
            
       
        })
        .catch({
        });
   }
    get PriorityPicklistOptions(){
        return [
            { label: 'low', value: 'low' },
            { label: 'medium', value: 'medium' },
            { label: 'high', value: 'high' },
        ];
    }
    handleChange(event){
        if(event.target.checked ==true  && ( this.updateOrDeleteToDoIdList.length == 0 || !this.updateOrDeleteToDoIdList.includes(event.target.value))){
            this.updateOrDeleteToDoIdList.push(event.target.value);
            if(this.updateOrDeleteToDoIdList.length >1){
                this.isMassSelect = true;
            }
        }else if(event.target.checked ==false && this.updateOrDeleteToDoIdList.includes(event.target.value)){
            console.log(this.updateOrDeleteToDoIdList.indexOf(event.target.value));
            this.updateOrDeleteToDoIdList.splice(this.updateOrDeleteToDoIdList.indexOf(event.target.value),1);
            if(!this.updateOrDeleteToDoIdList.length<=1){
                this.isMassSelect = false;
            }
        }
    }

    onDeleteHandler(){
        this.isDelete = true;
        this.updateOrDeleteHandler();
    }
    onFinishHandler(){
        this.isDelete = false;
        this.updateOrDeleteHandler();
    }
    onSaveHandler(){
        this.toDO.Name = this.template.querySelector('.TODOName').value;
        this.toDO.Due_Date__c = this.template.querySelector('.TODODate').value;
        this.toDO.Priority__c = this.template.querySelector('.TODOPriority').value;
        this.insertToDoList=[];
        this.insertToDoList.push(this.toDO);
        toInsertToDoList({
            newToDo: this.insertToDoList
        })
        .then(result=>{
            console.log(result);
            if(result.length>0){
                this.toDoList = [...result, ...this.toDoList];
                console.log(this.toDoList);
            }
            this.toDoList = [...this.toDoList];
        })
        .catch(error=>{
            console.log(error);
        })    
    }
    onSinglFinishOrDelete(event){
        this.updateOrDeleteToDoIdList = [];
        this.updateOrDeleteToDoIdList.push(event.target.value);
        if(event.target.label == 'Finish'){
            this.isDelete = false;
        }else{
            this.isDelete = true;
        }
        this.updateOrDeleteHandler();
    }  

    updateOrDeleteHandler(){
        toUpdateOrDeleteTodDoList({
            extToDoIds: this.updateOrDeleteToDoIdList,
            isDelete : this.isDelete
        })
        .then(result=>{
            console.log(result);
            this.isMassSelect = false;
            this.updateOrDeleteToDoIdList =[];
            if(result.length>0){
                this.toDoList = [...result];
                console.log(this.toDoList);
            }else{
                this.toDoList = [];
            }
            console.log(this.toDoList);
        })
        .catch(error=>{
            console.log(error);
        })
    }

}