@isTest
public class PaymentOrderTest {
@isTest
public static void  matchingExistingAccountTest()
{
    List<Payment_Order__c> paymentOrders = new List<Payment_Order__c>();
        Account testAccount = new Account();
                   testAccount.Name = 'testName';
                   testAccount.Phone = '1234567890';
                   testAccount.BillingState = 'TN';
                   testAccount.BillingPostalCode = '638052';
                   testAccount.BillingCountry = 'India';
                   testAccount.BillingStreet = 'RS street';
                   testAccount.ShippingStreet = 'perundurai';
   insert testAccount;
            paymentOrders.add(new Payment_Order__c(Payee_Name__c = 'TestPayment', State__c = 'TN', Country__c = 'India' , Phone_No__c = '1234567890',Address_Street_1__c='RS street',Address_Street_2__c='perundurai',Zip__c='638052'));
insert paymentOrders;
    test.startTest();
         PaymentOrderTriggerHandler.populatePaymentOrderFields(paymentOrders);
    test.stopTest();
    Payment_Order__c newPaymentOrder = [Select Name from Payment_Order__c Where Account__c = :testAccount.id];
        System.assertEquals(testAccount.Id,newPaymentOrder.Account__c,' Account is not linked to Payment Order');

}
@isTest
public static void populatePaymentOrderFieldsTest()
{
    List<Payment_Order__c> paymentOrders = new List<Payment_Order__c>();
        Account testAccount = new Account();
                   testAccount.Name = 'testName';
                   testAccount.Phone = '9159595714';
                   testAccount.BillingState = 'TN';
                   testAccount.BillingPostalCode = '638052';
                   testAccount.BillingCountry = 'India';
                   testAccount.BillingStreet = 'RS street';
                   testAccount.ShippingStreet = 'perundurai';
   insert testAccount;
      paymentOrders.add(new Payment_Order__c(Payee_Name__c = 'TestPayment',Account__c = testAccount.Id));
                        insert paymentOrders;
    test.startTest();
            PaymentOrderTriggerHandler.populatePaymentOrderFields(paymentOrders);
test.stopTest();
    Payment_Order__c newPaymentOrder = [Select Name from Payment_Order__c Where Account__c = :testAccount.id];
        System.assertEquals(testAccount.Id,newPaymentOrder.Account__c,'the fields did not auto-populate');

}
@isTest
    public static void notMatchingAccount()
    {
         List<Payment_Order__c> paymentOrders = new List<Payment_Order__c>();
        Account testAccount = new Account();
                   testAccount.Name = 'testName';
                   testAccount.Phone = '1234567890';
                   testAccount.BillingState = 'TN';
                   testAccount.BillingPostalCode = '638052';
                   testAccount.BillingCountry = 'India';
                   testAccount.BillingStreet = 'RS street';
                   testAccount.ShippingStreet = 'perundurai';
   insert testAccount;
            paymentOrders.add(new Payment_Order__c(Payee_Name__c = 'TestPayment', Account__c = testAccount.id, State__c = 'TN', Country__c = 'India' , Phone_No__c = '1234567899',Address_Street_1__c='neru street',Address_Street_2__c='perundurai',Zip__c='638052'));
insert paymentOrders;
    test.startTest();
       PaymentOrderTriggerHandler.createAccount(paymentOrders);
    test.stopTest();
 Account newAccount = [Select Name from Account Where Name = 'TestPayment'];
        System.assertEquals('TestPayment',newAccount.Name,'Account is not created for the corresponding paymentOrder');
    }

    @isTest
    public static void creatingNewAccount()
    {
        list<Payment_Order__c> paymentOrderTestList = new List<Payment_Order__c>();
            paymentOrderTestList.add(new Payment_Order__c(Payee_Name__c = 'Aravind', State__c = 'TN', Country__c = 'India' , Phone_No__c = '9942443478',Address_Street_1__c='Thiru street',Address_Street_2__c='Tirchy',Zip__c='600004'));
        insert paymentOrderTestList;
        test.startTest();
                PaymentOrderTriggerHandler.createAccount(paymentOrderTestList);
        test.stopTest();
     Account newAccount = [Select Name from Account Where Name = 'Aravind'];
        System.assertEquals('Aravind',newAccount.Name,'Account is not created for the corresponding paymentOrder');   
    }
}