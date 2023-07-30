({
    checkboxFunction : function(component, event, helper) {
        
        var physicalAddress=component.get("v.physicalAddress");
        
        var mailingAddress = component.get("v.mailingAddress");
        var isChecked = component.get("v.isChecked");
        if(isChecked){
            mailingAddress.Address__c = physicalAddress.Address__c;
            mailingAddress.Address_Line_2__c = physicalAddress.Address_Line_2__c;
        }
        else{
            mailingAddress.Address__c = " ";
            mailingAddress.Address_Line_2__c =" ";
        }
        component.set("v.mailingAddress",mailingAddress);
        
    },
    
    handleChange : function(component, event, helper){
        
        let mailingAddress = component.get("v.mailingAddress");
        let physicalAddress = component.get("v.physicalAddress")
        let isChecked = component.find("checkBoxId");
        if((!$A.util.isUndefinedOrNull(isChecked) && isChecked.get("v.checked")) && (mailingAddress.Address__c != physicalAddress.Address__c ||  mailingAddress.Address_Line_2__c != physicalAddress.Address_Line_2__c )){
            
            component.set("v.isChecked",false);
        }
        else if(mailingAddress.Address__c != physicalAddress.Address__c &&  mailingAddress.Address_Line_2__c != physicalAddress.Address_Line_2__c){
            component.set("v.isChecked",true);
            
        }
        
    }
})