({
	fetchAccounts : function(component, event, helper) {
        console.log('inside');        
        component.set('v.mycolumns', [
        {label: 'Account Name', fieldName: 'linkName', type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
        
        {label: 'Industry', fieldName: 'Industry', type: 'text'},
        {label: 'Type', fieldName: 'Type', type: 'Text'}
        ]);
        var action =component.get('c.fetchAccts');
        action.setParams({
            "searchText":component.get('v.searchText')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(state);
            if(state='SUCCESS'){
                var data = response.getReturnValue();
                data.forEach(function(record){
				record.linkName = '/'+record.Id;   
            	});
                if(data.length>0 && !(component.get('v.searchText') === null || component.get('v.searchText').match(/^ *$/) !== null)){
                    component.set('v.acctList',data); 
                    component.set('v.showTable',true);
                }
                else{
					component.set('v.showTable',false);
                }
            console.log(component.get('v.acctList'));
            }
        });
       $A.enqueueAction(action); 
	}
})