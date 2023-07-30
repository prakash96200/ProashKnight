({
	doInit : function(component, event, helper) {
		helper.fetchOpportunities(null,component)
	},
    
    fetchOppo : function(component, event, helper){
        var searchKey =component.find("searchField").get("v.value");
        helper.fetchOpportunities(searchKey,component)
    }
})