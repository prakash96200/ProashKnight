public class AccountListController {

@AuraEnabled
public static List < Account > fetchAccts(String searchText) {
     searchText = searchText + '%';
    system.debug('inside'+searchText);

return [ SELECT Id, Name, Industry, Type FROM Account where name Like:searchText ];

}
 @InvocableMethod
public static void accountChange(List<Account> newAccounts) {
    for(Account newAccount: newAccounts){
        if(newAccount.Phone == null){
            newAccount.Phone = '9159595714';
        }
    }
    update newAccounts;
}
}