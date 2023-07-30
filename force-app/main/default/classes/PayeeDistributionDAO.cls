public class PayeeDistributionDAO implements IPayeeDistributionDAO{
   public interface IPayeeDistributionDAO{
    	Payee_Distribution__c insertPayee(Payee_Distribution__c payees);
        List<Payee_Distribution__c> getPayee(List<String> Ids);
        Payee_Distribution__c deletePayee(Payee_Distribution__c payees);
        Payee_Distribution__c editPayeeData(Payee_Distribution__c payees);
        Dealer_Product__c insertClient(Dealer_Product__c clients);
        Account insertNewAccount(string searchKey);
        Payee_Distribution__c insertNewPayeeNumber(Payee_Distribution__c payee, string searchKey);
        List<Payee_Distribution__c> searchPayeeNumber(string searchkey);
        List<Account> searchAccountName(string searchkey);
        Dealer_Product__c updateDealerInAccount(Dealer_Product__c client, List<String> accounts);
        Dealer_Product__c updateDealerInPayee(Dealer_Product__c client, List<String> Ids);
        List<String> getAccounts();
     }
    public Payee_Distribution__c insertPayee(Payee_Distribution__c payees){
        upsert payees;
        return payees;
    }
    
    public List<Payee_Distribution__c> getPayee(List<String> Ids){
      return [Select Payee_Number__c, Account_name__r.Name, Allocation_Percentage__c from Payee_Distribution__c where Id =:Ids]; 
    }
    
    public Payee_Distribution__c deletePayee(Payee_Distribution__c payees){
        delete payees;
        return payees;
    }
    
    public Payee_Distribution__c editPayeeData(Payee_Distribution__c payees){
     	update payees;
        return payees;   
    }
    
    public Dealer_Product__c insertClient(Dealer_Product__c clients){
        insert clients;
        return clients;
    }
    
    public Account insertNewAccount(string searchKey){
        Account account = new Account(Name = searchKey);
        insert account;
        return account;
    }
    
    public Payee_Distribution__c insertNewPayeeNumber(Payee_Distribution__c payee, string searchKey){
       Payee_Distribution__c newPayee = new Payee_Distribution__c(Name = '', Payee_Number__c = Decimal.valueOf(searchkey), Allocation_Percentage__c = payee.Allocation_Percentage__c);
       insert newPayee;
       return newPayee;
    }
    
    public List<Payee_Distribution__c> searchPayeeNumber(string searchkey){
        List<Payee_Distribution__c> payeeList = new List<Payee_Distribution__c>([Select Id, Payee_Number__c from Payee_Distribution__c where Payee_Number__c =:Decimal.valueOf(searchkey)]);
        return payeeList;
    }
    
    public List<Account> searchAccountName(string searchkey){
        List<Account> accountList = new List<Account>([Select Id, name from Account where name LIKE :searchkey]);
        return accountList;
    }
    
    public Dealer_Product__c updateDealerInAccount(Dealer_Product__c client, List<String> accounts){
    	List<Account> accountlist = new List<Account>([Select Id, Name, Exclude_Dealer__c from Account where Name =:accounts]);
        for(Account account : accountlist){
        	account.Exclude_Dealer__c = client.Id;
        }
        update accountlist;
        return client;    
    }
    
    public Dealer_Product__c updateDealerInPayee(Dealer_Product__c client, List<String> Ids){
        List<Payee_Distribution__c> payeelist = new List<Payee_Distribution__c>([Select Id, Name, Exclude_Dealer__c from Payee_Distribution__c where Id =:Ids]);
         for(Payee_Distribution__c payees : payeelist){
        	payees.Exclude_Dealer__c = client.Id;    
        }
        update payeelist;
        return client;
    } 
    
    public List<String> getAccounts(){
        List<Account> accountList = new List<Account>([Select Id, Name from Account]);
        List<String> stringList = new List<String>();
        for(Account accounts : accountList)
        {
            stringList.add(accounts.Name);
        }
        return stringList;
    }
    
}