({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue()
                component.set("v.options", response);
            }
        });
        $A.enqueueAction(action);	
	}
})