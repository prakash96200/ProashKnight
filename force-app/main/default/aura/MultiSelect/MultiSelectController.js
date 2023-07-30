({
    showList : function(component, event, helper) {
        component.set("v.show", true);
    },
    
    hideList : function(component, event, helper) {
        component.set("v.show", false);
    },
    
    selectHandler : function(component, event, helper) {
        let id = event.currentTarget.id;
        var selectedOption = component.get("v.options")[id];
        var listvalues = component.get("v.values");
        var pillList = component.get("v.pillValues");
        
            var i = listvalues.indexOf(selectedOption);
            if(i<0)
            {
                listvalues.push(selectedOption);
                console.log(listvalues);
                let newpill = {
                    type: 'icon',
                    label: selectedOption,
                    name: selectedOption,
                    iconName: 'standard:account',
                    alternativeText: 'Account'
               };
               pillList.push(newpill);
               console.log("newpill",newpill);
               console.log("pillList",pillList);
            }
            else{
                listvalues.splice(i,1);
                pillList.splice(i,1);
                console.log("after splice list",listvalues);
                console.log("after splice pillList",pillList);
            }
        component.set("v.values",listvalues);
        component.set("v.pillValues",pillList);
        
        var newEvent = component.getEvent("accountOptions");
        var accvalues = component.get("v.values"); 
        newEvent.setParams({
            accountNames : accvalues
        });
        newEvent.fire();
        
    },
    
    removeItem : function(component, event, helper) {
        var pillIndex = event.getParam("index");
        console.log("pillIndex",pillIndex);
        
        var pillList = component.get("v.pillValues");
        var value = component.get("v.values");
        value.splice(pillIndex,1);
        pillList.splice(pillIndex,1);
        component.set("v.pillValues",pillList);
        component.set("v.values",value);
    },
})