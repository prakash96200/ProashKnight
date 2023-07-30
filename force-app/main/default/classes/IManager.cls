public interface IManager { 
	void beforeInsert(List<sObject> newObjList);
	void beforeUpdate(List<sObject> newObjList, Map<Id,sObject> oldObjMap);
	void beforeDelete(Map<Id,sObject> oldObjMap);
	void afterInsert(List<sObject> newObjList);
	void afterUpdate(List<sObject> newObjList, Map<Id,sObject> oldObjMap);
	void afterDelete(Map<Id,sObject> oldObjMap);
	void afterUndelete(List<sObject> newObjList);
}