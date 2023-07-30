public class AccountManagerHW implements Imanager {
    public void beforeInsert(List<Account> lstOfNewRecord){
    }
    
    public void beforeUpdate(List<Account> lstOfNewRecord, Map<Id,SObject> mapOfOldRecord){
        for(Account record: lstOfNewRecord){
            record.Name = record.Name +' TriggerHandler';
        }
    }


    
    public void beforeDelete(Map<Id,SObject> mapOfOldRecord){
        
    }
    public void afterInsert(List<Account> lstOfNewRecord){
        List<contact> newContactList = new list<Contact>();  
        List<contact> contactList = [Select id, Name, Email, accountId from contact where accountId IN :lstOfNewRecord];     
        List<Account> accountList = [select id,Name,email__c from Account where Id not in(select accountid from contact) AND id IN:lstOfNewRecord];
        if(contactList.size() > 0)
        {
			for(Account accountRecord : lstOfNewRecord)
            {
             if(accountRecord.email__c != null)
             {
                for(Contact contact : contactList)
                {
                if(accountRecord.id == contact.accountId)
                {
                    contact.Email = accountRecord.email__c;
                    newContactList.add(contact);
                    
                }
                    }
            }
            }}
        if(accountList.size() > 0)
        {
            for(Account account : accountList)
            {
                if(account.email__c != null)
                {
                    Contact newContact =new Contact();
                    newContact.AccountId =account.id;
                    newContact.Email = account.email__c;
                    newContact.LastName = account.Name;
                    newContactList.add(newContact);
                }
            }
        }
        
       
    if(newContactList.size()>0)
    {
        upsert newContactList;
    }
    }
    public void afterUpdate(List<Account> lstOfNewRecord, Map<Id,SObject> mapOfOldRecord){}
    public void afterDelete(Map<Id,SObject> mapOfOldRecord){
       
     
        
    }
    public void afterUndelete(List<Account> lstOfNewRecord){}
}