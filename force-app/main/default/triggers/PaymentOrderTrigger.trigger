trigger PaymentOrderTrigger on Payment_Order__c (before insert, after insert) {
if(trigger.isInsert)
{
    if(trigger.isBefore)
    {
        PaymentOrderTriggerHandler.populatePaymentOrderFields(trigger.new);
    }
    if(trigger.isAfter)
    {
        PaymentOrderTriggerHandler.createAccount(trigger.new);
    }
}
}