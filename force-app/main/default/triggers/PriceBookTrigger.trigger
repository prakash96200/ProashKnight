trigger PriceBookTrigger on PricebookEntry (after insert) {
for(PricebookEntry priceBookEntry: trigger.newMap.values()){
    priceBookEntry.priceBookCheckBox__c =true;
}
update trigger.newMap.values();
}