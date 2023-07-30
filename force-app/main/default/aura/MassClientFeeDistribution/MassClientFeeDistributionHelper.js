({
    fetchProductCodePicklist : function(component, event, helper) {
        var action = component.get("c.getPickListValues");
        action.setParams({
            'objectname' : component.get("v.objectname"),
            'fieldname' : component.get("v.productcode")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.productList", response);
            }
        });
        $A.enqueueAction(action);	
    },
    fetchFeeCodePicklist : function(component, event, helper) {
        var action = component.get("c.getPickListValues");
        action.setParams({
            'objectname' : component.get("v.objectname"),
            'fieldname' : component.get("v.feetype")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue()
               component.set("v.feeList", response);
            }
        });
        $A.enqueueAction(action);	
    },
    insertClientHandler : function(component,client){
        let action = component.get("c.insertClient");
        action.setParams({
            "client" : client
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log("response Insert",response);
                var theClient = component.get("v.clients");
                theClient.push(response);
                component.set("v.clients",theClient);
                let client = JSON.parse(JSON.stringify(response));
                var accounts = component.get("v.accountNames");
                console.log("accounts",accounts);
                this.updateClientHandler(component,client,accounts);
                var ids = component.get("v.ids");
                console.log("payeeIds",ids);
                this.updatePayee(component,client,ids);
                component.set("v.newClient",{ 'sobjectType': 'Dealer_Product__c', 
                                             'Classification_Code__c': '',
                                             'Fee_amount_for_ended_allocations__c':'',
                                             'Fee_amount_for_created_allocations__c': '',
                                             'Product_code__c':'',
                                             'Fee_type__c': '',
                                             'End_date_for_open_allocation__c':'',
                                             'Start_date_for_new_allocation__c': '',
                                             'End_date_for_new_allocation__c':''});
                console.log("client",component.get("v.newClient"));
                component.set("v.showTable",false);
            }
        });
        $A.enqueueAction(action);
    },
    updateClientHandler : function(component, client,accounts) {
        var action = component.get("c.updateDealerInAccount");
        action.setParams({
            'client' : client,
            'accounts' : accounts
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                //console.log("response account update",response);
                component.set("v.newClient",response);
            }
        });
        $A.enqueueAction(action);
    }, 
    updatePayee : function(component, client,ids) {
        var action = component.get("c.updateDealerInPayee");
        action.setParams({
            'client' : client,
            'Ids' : ids
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log("response payee update",response);
                component.set("v.newClient",response);
            }
        });
        $A.enqueueAction(action);
    }, 
    accountNameHandler : function(component, searchKey, helper) {
        var action = component.get("c.searchAccountName");
        action.setParams({
            'searchkey' : searchKey
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var responses = response.getReturnValue()[0];
                console.log(responses);
                if(responses != null)
                {
                    component.set("v.newPayee.Account_name__c", response.getReturnValue()[0].Id);
                }
            }
        });
        $A.enqueueAction(action);
    },
    payeeNumberHandler : function(component, searchKey, helper) {
        var action = component.get("c.searchPayeeNumber");
        action.setParams({
            'searchkey' : searchKey
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var responses = response.getReturnValue()[0];
                if(responses != null)
                {
                    component.set("v.newPayee.Payee_Number__c", response.getReturnValue()[0].Payee_Number__c);
                    component.set("v.newPayee.Id", response.getReturnValue()[0].Id);
                 }
            }
        });
        $A.enqueueAction(action);
    },
    insertPayeeHandler : function(component,payee){
        let action = component.get("c.insertPayee");
        action.setParams({
            "payee" : payee
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log("insertPayee",response);
                var payees = component.get("v.payees");
                payees.push(response);
                component.set("v.payees",payees);
                component.set("v.newPayee",{ 'sobjectType':'Payee_Distribution__c',
                                            'Id':'',
                                            'Payee_Number__c':'',
                                            'Account_name__c':'',
                                            'Allocation_Percentage__c':''});
                var payee = JSON.parse(JSON.stringify(response));
                var id = payee["Id"];
                var ids = component.get("v.ids");
                ids.push(id);
                component.set("v.ids",ids);
                this.getPayeeHandler(component, event);
            }
        });
       
        $A.enqueueAction(action);
    } ,
    
    getPayeeHandler : function(component, event){
        let Ids = component.get("v.ids");
        console.log("Ids table:",Ids);
    	let action = component.get("c.getPayee");
        action.setParams({
            'payeeIds' : Ids
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var responses = response.getReturnValue();
                console.log("table:",responses);
                component.set("v.data", responses);
     
                  var percentage = 0;
                  let grandtotal = 0;
                for(var i = 0; i < responses.length; i++){
                    percentage = responses[i].Allocation_Percentage__c;
                    grandtotal = grandtotal + percentage;
                    component.set("v.grandTotal",grandtotal);
                   }
                var total = component.get("v.grandTotal");
                if(total>100){
                    component.set("v.showError",true);
                }
                var theData = component.get("v.data");
                console.log("size",theData.length);
                if(theData.length === 0)
                {
                    component.set("v.grandTotal",0);
                }
             }
        }); 
         $A.enqueueAction(action);
    },
    
    insertAccountHandler : function(component, payee, searchWord) {
        var action = component.get("c.insertNewAccount");
        action.setParams({
            'searchkey' : searchWord,
            'payee' : payee
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var responses = response.getReturnValue();
                console.log("newaccountresponse", responses);
                 component.set("v.newPayee",responses);
                  let newpayee = JSON.parse(JSON.stringify(responses));
                  delete newpayee["Id"];
                  newpayee["Payee_Number__c"] = '23';
                  console.log("newpayee",newpayee);
                  this.insertPayeeHandler(component,newpayee); 
            }
        });
        $A.enqueueAction(action);
    },
    
    insertPayeeNumHandler : function(component, payee, searchWord) {
    	var action = component.get("c.insertNewPayeeNumber");
        action.setParams({
            'searchkey' : searchWord,
            'payee' : payee
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var responses = response.getReturnValue();
                console.log("newpayeeresponse", responses);
                component.set("v.newPayee.Payee_Number__c",response.getReturnValue().Payee_Number__c);
                var payees = component.get("v.payees");
                payees.push(response);
                component.set("v.payees",payees);
                component.set("v.newPayee",{ 'sobjectType':'Payee_Distribution__c',
                                            'Id':'',
                                            'Payee_Number__c':'',
                                            'Account_name__c':'',
                                            'Allocation_Percentage__c':''});
                var payee = JSON.parse(JSON.stringify(responses));
                var id = payee["Id"];
                var ids = component.get("v.ids");
                ids.push(id);
                console.log("ids:",ids);
                component.set("v.ids",ids);
                this.getPayeeHandler(component, event);
            }
        });
        $A.enqueueAction(action); 
    },
   
})