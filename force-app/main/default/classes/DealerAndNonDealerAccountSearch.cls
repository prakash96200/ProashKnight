public class DealerAndNonDealerAccountSearch{
    @AuraEnabled(Cacheable = true)
    public static list<Account> getAccountData(String searchKey, String dealerOrNonDealerRecordTypeId) {
      return AccountDAO.getDealerOrNonDealerAccount(searchKey, dealerOrNonDealerRecordTypeId);     
    }
    @AuraEnabled
    public static List<Account> insertNonDealerAccount(Account nonDealerAccount){
      List<Account> accountList = new List<Account>();
      accountList.add(AccountDAO.insertAccount(nonDealerAccount));
      return accountList;
    }
    @AuraEnabled
    public static Map<String, String> getAccountRecordTypeMap(){
      return RecordTypeDAO.getRecordTypeForAccount();
    }
}