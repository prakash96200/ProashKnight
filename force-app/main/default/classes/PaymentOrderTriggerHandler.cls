public class PaymentOrderTriggerHandler {
public static list<Payment_Order__c> populatePaymentOrderFields(list<Payment_Order__c> paymentOrderRecords)
{
    String AccountId = null;
    list<Account> allExistingAccount = AccountAndPaymentOrderDAO.getAllAccountDetails();

    list<Payment_Order__c> paymentOrderList = new list<Payment_Order__c>();

    for(Payment_Order__c paymentOrder:paymentOrderRecords)
    {
       if(paymentOrder.Account__c!=null && paymentOrder.Address_Street_1__c == null && paymentOrder.Address_Street_2__c == null && paymentOrder.Country__c == null && paymentOrder.Phone_No__c == null && paymentOrder.Zip__c == null && paymentOrder.State__c == null)
       {
            AccountId = paymentOrder.Account__c;
       }
        else if(paymentOrder.Account__c == null)
        {
            for(Account newAccount : allExistingAccount)
            {
         if(paymentOrder.Address_Street_1__c == newAccount.BillingStreet && paymentOrder.Address_Street_2__c == newAccount.ShippingStreet && paymentOrder.Country__c == newAccount.BillingCountry && paymentOrder.Phone_No__c == newAccount.Phone && paymentOrder.Zip__c == newAccount.BillingPostalCode && paymentOrder.State__c == newAccount.BillingState)
         {
             paymentOrder.Account__c = newAccount.Id;
             paymentOrderList.add(paymentOrder);
         }
             }}
        if(AccountId != null)
        {
 Account existingAccount = AccountAndPaymentOrderDAO.getAccountDetails(AccountId);
                paymentOrder.Address_Street_1__c = existingAccount.BillingStreet;
                paymentOrder.Address_Street_2__c = existingAccount.ShippingStreet;
                paymentOrder.Country__c  = existingAccount.BillingCountry;
                paymentOrder.Phone_No__c = existingAccount.Phone;
                paymentOrder.Zip__c = existingAccount.BillingPostalCode;
                paymentOrder.State__c = existingAccount.BillingState;
                paymentOrderList.add(paymentOrder);
        }
    }
    return paymentOrderList;
}  
public static list<Payment_Order__c> createAccount(list<Payment_Order__c> paymentOrderRecords)
{
    list<Payment_Order__c> paymentOrderList = new list<Payment_Order__c>();
    for(Payment_Order__c paymentOrder : paymentOrderRecords)
    {
    if(paymentOrder.Account__c==null)
    {
        paymentOrderList = createAndLinkAccount(paymentOrder);   
     }
       else if(paymentOrder.Account__c!=null)
        {
        Account checkingAccount = AccountAndPaymentOrderDAO.getAccountDetails(paymentOrder.Account__c) ;
   
       if(paymentOrder.Address_Street_1__c != checkingAccount.BillingStreet && paymentOrder.Address_Street_2__c != checkingAccount.ShippingStreet && paymentOrder.Country__c != checkingAccount.BillingCountry && paymentOrder.Phone_No__c != checkingAccount.Phone && paymentOrder.Zip__c != checkingAccount.BillingPostalCode && paymentOrder.State__c != checkingAccount.BillingState)
        {
                    paymentOrderList = createAndLinkAccount(paymentOrder);   
        }}
    }
    AccountAndPaymentOrderDAO.setPaymentOrderRecordDetails(paymentOrderList);
return paymentOrderList;
}  
    public static list<Payment_Order__c> createAndLinkAccount(Payment_Order__c paymentOrder)
    {                  
                   List<Account> accountList = new list<Account>();
                   Account creatingAccount = new Account();
                   creatingAccount.Name = paymentOrder.Payee_Name__c;
                   creatingAccount.Phone = paymentOrder.Phone_No__c;
                   creatingAccount.BillingState = paymentOrder.State__c;
                   creatingAccount.BillingPostalCode = paymentOrder.Zip__c;
                   creatingAccount.BillingCountry = paymentOrder.Country__c;
                   creatingAccount.BillingStreet = paymentOrder.Address_Street_1__c;
                   creatingAccount.ShippingStreet = paymentOrder.Address_Street_2__c;
                   accountList.add(creatingAccount);
                   AccountAndPaymentOrderDAO.setAccountDetails(accountList);
            list<Payment_Order__c> paymentOrderList = new List<Payment_Order__c>();
                    list<Account> existingAccount = AccountAndPaymentOrderDAO.getAllAccountDetails();
              for(Account newAccount : existingAccount)
                 {
             if(paymentOrder.Address_Street_1__c == newAccount.BillingStreet && paymentOrder.Address_Street_2__c == newAccount.ShippingStreet && paymentOrder.Country__c == newAccount.BillingCountry && paymentOrder.Phone_No__c == newAccount.Phone && paymentOrder.Zip__c == newAccount.BillingPostalCode && paymentOrder.State__c == newAccount.BillingState)
                {
                    Payment_Order__c linkingPaymentOrder=[select id from Payment_Order__c where Name = :paymentOrder.Name];
                    Account linkingAccount =[select Id from Account where Name = :paymentOrder.Payee_Name__c];
                    linkingPaymentOrder.Account__c = linkingAccount.id;
                    paymentOrderList.add(linkingPaymentOrder);
                    
               }
             }
return paymentOrderList;
    }
    }