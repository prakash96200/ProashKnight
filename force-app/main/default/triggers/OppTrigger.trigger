trigger OppTrigger on Opportunity (after insert, after update, after delete, after undelete) {
set<id> accIds  = new set<id>();
    if(trigger.isAfter){
        if(trigger.isDelete){
            for(Opportunity opp : trigger.oldmap.values()){
                accIds.add(opp.AccountId);
            }
        }
        else{
            for(Opportunity opp : trigger.newmap.values()){
                if(trigger.isInsert || (!trigger.oldmap.values().isEmpty() && trigger.oldmap.keySet().contains(opp.id))){
                    if(trigger.isInsert || (trigger.oldmap.get(opp.id).AccountId == opp.AccountId)){
                        accIds.add(opp.AccountId);
                    }
                    else{
                        accIds.add(opp.AccountId);
                        accIds.add(trigger.oldmap.get(opp.id).AccountId);
                    }
                }
            }
        }
    }
    Map<id,Account> accountToUpdateMap = new map<id,Account>();
    list<AggregateResult> aggres = [select AccountId, Sum(Amount) sumOfAmount from Opportunity where AccountId in: accIds Group by AccountId];
    for(AggregateResult agg : aggres){
        Account acc = new Account();
        acc.id = (id)agg.get('AccountId');
        acc.total_Ammount_opp__c = (decimal)agg.get('sumOfAmount');
        accountToUpdateMap.put(acc.id, acc);
    }
    for(Id accId : accIds){
        if(accountToUpdateMap.get(accId) == null){
            Account acc = new Account();
            acc.id = accId;
            acc.total_Ammount_opp__c = 0;
            accountToUpdateMap.put(acc.id, acc);
        }
    }
    update accountToUpdateMap.values();
}