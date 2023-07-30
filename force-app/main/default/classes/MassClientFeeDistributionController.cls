public class MassClientFeeDistributionController {

    public static PayeeDistributionDAO.IPayeeDistributionDAO payeeDistributionDAOInstance = new PayeeDistributionDAO();
    
	@AuraEnabled
    public static List<String> getAccounts(){
        List<String> stringList = payeeDistributionDAOInstance.getAccounts();
        return stringList;
    }
    
    @AuraEnabled      
    public static List<String> getPickListValues(string objectname, string fieldname){    
        List<String> pickListValuesList = new List<String>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String,Schema.SObjectField> field_map = gd.get(objectname).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(fieldname).getDescribe().getPickListValues();              
        for (Schema.PicklistEntry pv : picklistValues) {
            pickListValuesList.add(pv.getValue());
        }
        return pickListValuesList;
    }

    @AuraEnabled
    public static Dealer_Product__c insertClient(Dealer_Product__c client ){
        Dealer_Product__c clients = payeeDistributionDAOInstance.insertClient(client);
          return clients;
    }
    
    @AuraEnabled
    public static Dealer_Product__c updateDealerInAccount(Dealer_Product__c client, List<String> accounts){
        Dealer_Product__c newClient = payeeDistributionDAOInstance.updateDealerInAccount(client,accounts);
    	 return newClient;
    }
    
    @AuraEnabled
    public static Dealer_Product__c updateDealerInPayee(Dealer_Product__c client, List<String> Ids){
         Dealer_Product__c newClient = payeeDistributionDAOInstance.updateDealerInPayee(client,Ids);
         return client;
    }
    
    @AuraEnabled
    public static Payee_Distribution__c insertPayee(Payee_Distribution__c payee){
        Payee_Distribution__c payees = payeeDistributionDAOInstance.insertPayee(payee);
        return payees;
    }
    
    @AuraEnabled
    public static List<Payee_Distribution__c> getPayee(List<String> payeeIds){
        System.debug(payeeIds);
        List<Payee_Distribution__c> payeeList = payeeDistributionDAOInstance.getPayee(payeeIds);
        System.debug(payeeList);
        return payeeList;
    }
    
    @AuraEnabled
    public static List<Payee_Distribution__c> searchPayeeNumber(string searchkey){ 
       List<Payee_Distribution__c> payeeList = payeeDistributionDAOInstance.searchPayeeNumber(searchkey);
        return payeeList;
    }
    
    @AuraEnabled
    public static List<Account> searchAccountName(string searchkey){
        List<Account> accountList = payeeDistributionDAOInstance.searchAccountName(searchkey);
        return accountList;
      }
     
    @AuraEnabled
    public static Payee_Distribution__c insertNewAccount(Payee_Distribution__c payee, string searchkey){
        
           Account account = payeeDistributionDAOInstance.insertNewAccount(searchkey);
           payee.Account_name__c = account.Id;
           return payee;   
    }
    
     @AuraEnabled
    public static Payee_Distribution__c insertNewPayeeNumber(Payee_Distribution__c payee, string searchkey){
           Payee_Distribution__c newPayee = payeeDistributionDAOInstance.insertNewPayeeNumber(payee,searchkey);
           return newPayee;   
    }
    
    @AuraEnabled
    public static void deletePayeeData(Payee_Distribution__c payee){
        Payee_Distribution__c newPayee = payeeDistributionDAOInstance.deletePayee(payee);
    }
    
    @AuraEnabled
    public static Payee_Distribution__c editPayeeData(Payee_Distribution__c payee){
         Payee_Distribution__c newPayee = payeeDistributionDAOInstance.editPayeeData(payee);
         return newPayee;
    }
}