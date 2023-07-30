public class NewBatchable implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'SELECT id, name from Account';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Account> records){
        for(Account newAccount : records){
            newAccount.Name = newAccount.Name.replace('engineer',''); 
        }
        update records;
    }
    public void finish(Database.BatchableContext bc){
       AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()]; 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toaddresses = new String[]{UserInfo.getUserEmail()};
        mail.setSubject('batch');
        mail.setHtmlBody('new records updated by '+job);
        Messaging.sendEmail(new List<Messaging.Email>{mail});
    }
}