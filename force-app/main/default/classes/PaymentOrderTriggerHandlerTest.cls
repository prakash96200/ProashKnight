@isTest
private class PaymentOrderTriggerHandlerTest {
    
    
   /* @isTest
    static void test1()
    {
        List<Payment_Order__c> paymentOrders = new List<Payment_Order__c>();
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.BillingCountry = 'Sattur';
        insert acc;
        for(Integer i = 0 ; i<20 ; i++)
        {
            paymentOrders.add(new Payment_Order__c(Payee_Name__c = 'TestPayment' + i, Status__c = 'New', Account__c = acc.Id, Payment_Amount__c = 1000));
            
        }
        
        Test.startTest();
        List<Payment_Order__c> testingPo = paymentOrderTriggerHandler.populateAccountFields(paymentOrders);
        insert testingPo;
        Test.stopTest();
        List<Payment_Order__c> paymentRecords = [Select Name, Country__c FROM Payment_Order__c WHERE Country__c = 'Sattur'];
        System.debug(paymentRecords.size());
        System.assertEquals(20,paymentRecords.size(),'Something went wrong');
    }
    
    @isTest
    public static void test2()
    {
        //when account is not populated, creating a new account if no matching account
        List<Payment_Order__c> paymentOrders1 = new List<Payment_Order__c>();
        for(Integer i = 20; i<40; i++)
        {
            PaymentOrders1.add(new Payment_Order__c(Payee_Name__c = 'TestPayment' + i, State__c = 'Tamilnadu', Country__c = 'India' , Phone_No__c = '123456'));
        }
        insert paymentOrders1;
        Test.startTest();
        PaymentOrderTriggerHandler.createNewAccount(paymentOrders1);
        Test.stopTest();
        
        List<Account> accs = [Select Id, Name From Account WHERE BillingCountry = 'India'];
        System.debug(accs.size());
        System.assertEquals(20, accs.size(),'Something Went Wrong');
    }
    
    
    //When a account matches
    @isTest
    public static void test3()
    {
        List<Payment_Order__c> paymentOrders1 = new List<Payment_Order__c>();
        for(Integer i = 40; i<60; i++)
        {
            paymentOrders1.add(new Payment_Order__c(Payee_Name__c = 'TestPayment' + i, State__c = 'UP', Country__c = 'MP' , Phone_No__c = '007'));
        }
        insert paymentOrders1;
        
        Account acc = new Account(Name = 'Testing3' , BillingState = 'UP' , BillingCountry = 'MP' , Phone = '007');
        insert acc;
        Test.startTest();
        PaymentOrderTriggerHandler.createNewAccount(paymentOrders1);
        Test.stopTest();
        
        List<Account> acc3 = [Select Id,Name FROM Account WHERE Name = 'Testing3'];
        System.debug(acc3.size());
        System.assertEquals(1,acc3.size(),'Something went wrong');
        
    }*/
    
    
    
    

}