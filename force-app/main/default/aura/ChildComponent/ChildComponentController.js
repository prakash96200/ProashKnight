({
	onUpdate : function(component, event, helper) {
		var componentEvent = component.getEvent("cmpEvent");
        var MessageFrmChild = component.get("v.MsgToDisplay");
        
        MessageFrmChild = $A.util.isEmpty("v.MsgToDisplay")? "N" : MessageFrmChild;
        
        componentEvent.setParams({
            "message" : MessageFrmChild,
            "label" : "Custom Label"
        });
        componentEvent.fire();
	}
})