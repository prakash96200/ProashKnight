({
	fetchOpportunities : function(searchKey,component) {
        component.set("!v.columnsToDisplay",[
    { label: 'Opportunity Name', fieldName: 'Name' },
    { label: 'close Date', fieldName: 'closeDate', type: 'date' },
    { label: 'Amount', fieldName: 'amount', type: 'currency' },
    
]);
            
            var action = component.get("c.fetchingOppurtunities");
            
          action.setparams
		
	}
})