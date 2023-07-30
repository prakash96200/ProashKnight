({
    onClickCheckBox : function(component, event, helper) {
        var checkBoxV = component.find("checkBoxId").get("v.checked");
        component.set("v.CheckboxValue", checkBoxV);
        var cb = component.get("v.CheckboxValue");
        var billingStreet =component.get("v.RegForm.BillingStreet");
        var billingCity =component.get("v.RegForm.BillingCity");
        var reg1 = component.get("v.RegForm1")
        
        console.log(billingStreet);
        
        if(cb==true) {
           component.set("v.RegForm1.ShippingStreet",billingStreet);
           component.set("v.RegForm1.ShippingCity",billingCity);
            
        }
        else{
            component.set("v.RegForm1.ShippingStreet","");
            component.set("v.RegForm1.ShippingCity","");
            component.set("v.RegForm1.ShippingState","");
            component.set("v.RegForm1.ShippingCountry","");
        }
        
    }
})