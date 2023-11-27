({
    doInit : function(component, event, helper) {
		var action =component.get('c.fetchAccts');
        action.setParams({
            "accId": '0015g00001B835JAAR'
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(state);
            if(state='SUCCESS'){
                var data = response.getReturnValue();
                component.set('v.account',data);
                console.log(component.get('v.account'));
            }
        });
       $A.enqueueAction(action); 
	},
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
            "accid": '0015g00001B835JAAR'
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(state);
            if(state='SUCCESS'){
                var data = response.getReturnValue();
                component.set('v.account',response.getReturnValue());
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
	},
    downloadpdf:function(component, event, helper){
    var generatePdfAction=component.get("c.generatePdf");

                    var pdfString = "<div style=\"padding:4px;font-family:Arial Unicode MS;\"> ó, ą, ę, ż, ź, ć, ś, ń,</div>"
                    var pdfName = "prakash pdf7"
                    generatePdfAction.setParams({
                        "webOrderJSON":pdfString
                        ,"DisId":pdfName})

                        generatePdfAction.setCallback(this,function(resp){
                        });
                        $A.enqueueAction(generatePdfAction);
                }
})