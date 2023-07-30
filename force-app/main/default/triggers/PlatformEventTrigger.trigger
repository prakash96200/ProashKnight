trigger PlatformEventTrigger on user_creation_event__e (after insert) {
	List<Account> newAccountList = new List<Account>();
    for(user_creation_event__e event: trigger.new){
        if(event.isActive__c == true){
            Account acc = new Account();
            acc.Name = event.username__c;
            newAccountList.add(acc);
        }
    }
    insert newAccountList;
}