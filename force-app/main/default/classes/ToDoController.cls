public class ToDoController {
   @AuraEnabled(Cacheable = true)
   public static List<TO_DO__C> getToDoList(){
      list<TO_DO__C> extToDoList = [select id, name,priority__c, Due_Date__c,Status__c from TO_DO__C];
    return extToDoList;
   }
   @AuraEnabled
   public static List<TO_DO__C> inserToDoList(List<TO_DO__C> newToDo){
    insert newToDo;
    return newToDo;
   }
   @AuraEnabled
   public static List<TO_DO__C> updateOrDelete(List<Id> extToDoIds, Boolean isDelete){
      List<TO_DO__C> extToDo = new List<TO_DO__C>();
      for(id todoId : extToDoIds){
         TO_DO__c updateOrDeleteToDo = new TO_DO__c();
         updateOrDeleteToDo.id= todoId;
         updateOrDeleteToDo.Status__c = 'Finished';
         extToDo.add(updateOrDeleteToDo);
      }
      if(isDelete == true){
         delete extToDo;
      }else{
         update extToDo;
      }
      return [select id, name,priority__c, Due_Date__c,Status__c from TO_DO__C];
   }
}