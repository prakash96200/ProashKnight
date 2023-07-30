public class RecordTypeDAO {
    @AuraEnabled
    public static Map<String, String> getRecordTypeForAccount(){
         Map<String, String> accountRecordTypeMap = new Map<String, String>();
       List<RecordType> accountRecordTypeList = new List<RecordType>();
       accountRecordTypeList = [Select Id, DeveloperName from RecordType where SobjectType ='account'];
        for(RecordType accountRecordType : accountRecordTypeList){
            accountRecordTypeMap.put(accountRecordType.DeveloperName, accountRecordType.Id);
        }
        Return accountRecordTypeMap;
    }
}