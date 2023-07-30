({
	onClick : function(component, event, helper) {
		var message = component.find("messageToShow").get("!v.value");
        component.set("messageToPrint",message);
        component.set("showMessage",True)
	}
})