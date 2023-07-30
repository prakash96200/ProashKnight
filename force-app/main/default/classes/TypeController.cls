public class TypeController {
    @AuraEnabled
    public static List<Account> getValue(){
        List<Account> acc = [select name, type from account];
        return acc;
    }

}