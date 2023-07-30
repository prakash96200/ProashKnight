public class AccountTriggerHandler extends TriggerHandler {
    
     private static String handlerNameInternal = null;



   public AccountTriggerHandler() {
        
    }



   public override String getHandlerName() {
        if(handlerNameInternal == null) {
            handlerNameInternal = AccountTriggerHandler.class.getName();
        }
        return handlerNameInternal;
    }
    
    public override String getSObjectType() {
        return 'Account';
    }
    
}