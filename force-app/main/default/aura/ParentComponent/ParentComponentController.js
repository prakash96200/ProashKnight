({
	handleComponentEvent : function(component, event, helper) {
		var Message = event.getparam("message");
        var label = event.getParam("label");
        
        component.set("v.MsgFrmParent",Message);
        component.set("v.label",label);
        
        var count = parseInt(component.get("v.EventCount")+1);
        component.set("v.EventCount",count);
        
	}
})