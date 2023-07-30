public class MockDAO {
	public class PayeeDistributionMockDAO implements PayeeDistributionDAO.IPayeeDistributionDAO{
        
        public Payee_Distribution__c payee = new Payee_Distribution__c();
        public List<Payee_Distribution__c> payeeListToReturn = new List<Payee_Distribution__c>();
        public Dealer_Product__c client = new Dealer_Product__c();
        public Account accountToReturn = new Account();
        public List<Account> accountListToReturn = new List<Account>();
        public List<String> stringListToReturn = new List<String>();
        
        public Payee_Distribution__c insertPayee(Payee_Distribution__c payees){
            return payee;
        }
        
        public List<Payee_Distribution__c> getPayee(List<String> Ids){
            return payeeListToReturn;
        }
        
        public Payee_Distribution__c deletePayee(Payee_Distribution__c payees){
            return payee;
        }
        
        public Payee_Distribution__c editPayeeData(Payee_Distribution__c payees){
            return payee;
        }
        
        public Dealer_Product__c insertClient(Dealer_Product__c clients){
            return client;
        }
        
        public Account insertNewAccount(string searchKey){
        	return accountToReturn;   
        }
        
        public Payee_Distribution__c insertNewPayeeNumber(Payee_Distribution__c payees, string searchKey){
        	return payee;
        }
        
        public List<Payee_Distribution__c> searchPayeeNumber(string searchkey){
            return payeeListToReturn;
        }
        
        public List<Account> searchAccountName(string searchkey){
            return accountListToReturn;
        }
        
        public Dealer_Product__c updateDealerInAccount(Dealer_Product__c client, List<String> accounts){
            return client;
        }
        
        public Dealer_Product__c updateDealerInPayee(Dealer_Product__c client, List<String> Ids){
            return client;
        }
        
        public List<String> getAccounts(){
            return stringListToReturn;
        }
    }
}