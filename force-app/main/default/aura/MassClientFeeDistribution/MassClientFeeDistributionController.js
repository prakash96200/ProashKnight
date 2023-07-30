({
    doInit: function(component, event, helper){
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.todayDate", today);
        
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue()
                component.set("v.accounts", response);
            }
        });
        $A.enqueueAction(action);	
        
        helper.fetchProductCodePicklist(component);
        helper.fetchFeeCodePicklist(component);  
        
    },
    
    showPopup: function(component, event, helper) {
        component.set("v.show", true);
    },
    
    hidePopup : function(component, event, helper) {
        component.set("v.show", false);
    },
    
    eventHandler : function(component, event, helper){
        var names = event.getParam('accountNames');
        console.log("accountnames",names);
        component.set("v.accountNames",names);
    },
    
    savePopup : function(component, event, helper){
           let validForm = [].concat(component.find("searchId")).reduce(function (validValue, inputData) {
            inputData.showHelpMessageIfInvalid();
            return validValue && inputData.get("v.validity").valid;
        }, true);
        
        if(validForm){
            let payee = component.get("v.newPayee");
            console.log("payee",payee);
            let id = component.get("v.newPayee.Id");
            console.log("id",id);
            let accountId = component.get("v.newPayee.Account_name__c");
            console.log("accID",accountId);
            let payeenum = component.get("v.newPayee.Payee_Number__c");
            console.log("payeenum",payeenum);
            let newpayee = JSON.parse(JSON.stringify(component.get("v.newPayee")));
        if(accountId != '' || payeenum != ''){
            delete newpayee["Id"];
            helper.insertPayeeHandler(component,newpayee);
        }
        else if(accountId === '' || payeenum === ''){
            var searchWord = component.find('searchId').get('v.value');
            var reg = new RegExp('^\\d+$');
            if(!reg.test(searchWord)==true){
             	helper.insertAccountHandler(component,payee, searchWord);   
            }else{
             	helper.insertPayeeNumHandler(component,payee,searchWord);   
            }
        }
        
        component.set("v.show", false);
        component.set("v.showTable", true);
        component.set("v.disable", false);
        } 
    },
    submitHandler : function(component, event, helper){
        
            var client = component.get("v.newClient");
            helper.insertClientHandler(component,client);   
    },
    searchHandler : function(component, event, helper){
        var searchKey = component.find('searchId').get('v.value');  
        console.log("searchkey",searchKey);
        var reg = new RegExp('^\\d+$');
        if(reg.test(searchKey)==true){  
            helper.payeeNumberHandler(component, searchKey, helper);
        }
        else{
            helper.accountNameHandler(component, searchKey, helper);
        }
    },
    
    editData : function(component, event, helper){
        var index = event.currentTarget.id;
        component.set("v.showEdit",true);
        var option = component.get("v.data")[index];
        console.log(option);
        component.set("v.dataOption",option);
    },
    
    saveEditPopup : function(component, event, helper){
        var data = component.get("v.dataOption");
        console.log("dataOption:",data);
        var action = component.get("c.editPayeeData");
        action.setParams({
            'payee' : data
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.data",response);
                component.set("v.newPayee",response);
                console.log("edit response:",response);
                helper.getPayeeHandler(component, event);
                }
        });
        $A.enqueueAction(action);
        component.set("v.showEdit", false);
    },
    
    hideEditPopup : function(component, event, helper) {
        component.set("v.showEdit", false);
    },
    
    deleteData : function(component, event, helper){
        var index = event.currentTarget.id;
        var option = component.get("v.data")[index];
        var action = component.get("c.deletePayeeData");
        action.setParams({
            'payee' : option
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                var dataList = component.get("v.data");
                dataList.splice(index,1);
                component.set("v.data",dataList);
                component.set("v.newPayee",response);
                console.log("delete response:",response);
                helper.getPayeeHandler(component,event);
            }
        });
        $A.enqueueAction(action);
    }
})