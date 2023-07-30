trigger ContactTrigger on Contact (after insert, after update, after undelete, after delete) {
    Set<Id> accountIdSet = new Set<Id>();
    Map<id,Integer> accountIdMap = new Map<id,Integer>();
    Set<Contact> contactSet = new Set<Contact>();
    /*if(Trigger.isAfter){
if(Trigger.New != null){
contactSet.addAll(Trigger.New); 
}
if(Trigger.old != null){
contactSet.addAll(Trigger.Old);
}
for(Contact newContact : contactSet){
accountIdSet.add(newContact.AccountId);
}
}*/
    if(trigger.isafter && trigger.isDelete){
        if(trigger.old != null){
            for(Contact newContact : trigger.old){
                if(!accountIdMap.containsKey(newContact.accountId)){
                    accountIdMap.put(newContact.accountId,1);
                }
                else{
                    accountIdMap.put(newContact.accountId, accountIdMap.get(newContact.accountId)+1);
                }
            }
        }
    }
    List<Account> accountList = [Select id, No_of_contacts__c,Contact_Deleted_Date__c,no_of_contacts_deleted_today__c,(Select id from Contacts) from Account where ID IN:accountIdMap.keySet()];
    for(Account accountToUpdate : accountList){
        if(accountToUpdate.Contact_Deleted_Date__c != Date.today()){
           accountToUpdate.no_of_contacts_deleted_today__c = accountIdMap.get(accountToUpdate.id);
            accountToUpdate.Contact_Deleted_Date__c = Date.today();
        }
        else{
            accountToUpdate.no_of_contacts_deleted_today__c += accountIdMap.get(accountToUpdate.id);
        }
    }
    update accountList ;
}