public class queueableClass implements Queueable{
    PRIVATE string userId;
    public queueableClass(String user){
        this.userId = user;
    }
    
    public void execute (QueueableContext context){
       List<Account> accountList = [SELECT Id, Name FROM Account where createdById =:userId];
       system.debug('accountList'+accountList);
    }
}