public class AccountAndPaymentOrderDAO {
    
    Public static Account getAccountDetails(Id accountId)
    {
        
        Return [Select Name, ShippingStreet, BillingStreet, BillingCountry, Phone, BillingPostalCode, BillingState From Account WHERE Id = :accountId];
    }
    
    Public static List<Account> getAllAccountDetails()
    {
        
        Return [Select Name, Id, ShippingStreet, BillingStreet, BillingCountry, Phone, BillingPostalCode, BillingState From Account];
        
    }    
    public static void setAccountDetails(List<Account> accountDetails)
    {
             upsert accountDetails;     
    }
    public static void setPaymentOrderRecordDetails(list<Payment_Order__c> paymentOrderDetails)
{
    upsert paymentOrderDetails;
}
    

    
}