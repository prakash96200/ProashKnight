public class AccountDAO implements IAccountDAO{
    public interface IAccountDAO{
        Account insertAccount(Account Account);
        List<Account> getDealerOrNonDealerAccount(String searchKey, String dealerOrNonDealerRecordTypeId);
    }
    public static Account insertAccount(Account Account){
        insert Account;
        return Account;
    }
    
    public static List<Account> getDealerOrNonDealerAccount(String searchKey, String dealerOrNonDealerRecordTypeId){
        String[] searchKeyData = searchKey.split(',');
        String facilityName = searchKeyData[0];
        String facilityZip = searchKeyData[1] ;
        String facilityPhone = searchKeyData[2];
        String einNumber = searchKeyData[3];

        String query ='SELECT  Id, Name, BillingAddress, Zip_Code__c From Account WHERE RecordTypeId =:dealerOrNonDealerRecordTypeId AND Zip_Code__c =:facilityZip ';
        
        if (facilityName != 'null' && facilityName !=''){
             facilityName = facilityName + '%';
            query = query + 'AND Name Like:facilityName ';
         }
         if(facilityPhone != 'null' && facilityPhone !=''){
            query = query + 'AND Phone_Number__c =:facilityPhone ';
         }

         if(einNumber != 'null' && einNumber !=''){
            query = query + 'AND EIN__c =:einNumber';
         }         
        list<Account> accLst = Database.query(query) ;
        return accLst; 
    }
}