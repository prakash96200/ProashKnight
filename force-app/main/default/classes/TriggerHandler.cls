public abstract class TriggerHandler {

    // static map of handlerName, times run() was invoked
    private static Map<String, LoopCount> loopCountMap; // count the loop
    private static Set<String> bypassedHandlers; // used to skip the trigger
    public Map<String, IManager> managerMap; // all the instance for class
    public Set<String> applicableClasses; //class that are applicable

    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;

    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;

    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }

    // constructor
    public TriggerHandler() {
        this.setTriggerContext();
        this.fillInheritanceObjectMap();
    }

    /***************************************
     * public instance methods
     ***************************************/

    // main method that will be called during execution
    public void run() {
        if(!validateRun()) return;

        addToLoopCount();

        // dispatch to the correct handler method
        if(this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if(this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if(this.context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if(this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if(this.context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if(this.context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if(this.context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }

    }

    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();

        if(!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    /***************************************
     * public static methods
     ***************************************/

    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }
    
    /***************************************
     * private instance methods
     ***************************************/

    private Map<String, List<sObject>> newInheritanceMap = new Map<String, List<sObject>>();
    private Map<String, Map<Id,sObject>> oldInheritanceMap = new Map<String, Map<Id, sObject>>(); // map<ClassName, map<Id, Sobject>>

    @TestVisible
    private void getInheritanceObjectMap(String objectName, String callType, List<sObject> newObjs, Map<Id, sObject> oldObjs, Boolean isDeleteContext) {
        newInheritanceMap = new Map<String, List<sObject>>();
        oldInheritanceMap = new Map<String, Map<Id, sObject>>();

        if(isDeleteContext) {
            mapInheritanceSetting(objectName, callType, oldObjs.values(), true);
        } else {
            mapInheritanceSetting(objectName, callType, newObjs, false);
        }

        if(newObjs != null && oldObjs != null) {
            for(String applicableClass : newInheritanceMap.keySet()) {
                List<sObject> tempList = new List<sObject>();

                for(sObject sObj : newInheritanceMap.get(applicableClass)) {
                    tempList.add(oldObjs.get(sObj.Id));
                }

                Map<Id, sObject> tempMap = new Map<Id, sObject>(tempList); 
                oldInheritanceMap.put(applicableClass, tempMap);
            }
        }
    }

    private static Map<String, List<Inheritance_Setting__mdt>> settingsMap = new Map<String, List<Inheritance_Setting__mdt>>();
    
    @TestVisible
    private void mapInheritanceSetting(String objectName, String callType, List<sObject> sObjs, Boolean isDeleteContext) {
        List<Inheritance_Setting__mdt> settings = new List<Inheritance_Setting__mdt>();
        String settingsRecKey = objectName + '-' + callType; //Account-TriggerHandler

        if(!settingsMap.containsKey(settingsRecKey)) {
            settings = [SELECT DeveloperName, Object__c, Type__c, Record_Type_1__c, Record_Type_2__c,
                    Record_Type_3__c, Skip_Trigger__c
                    FROM Inheritance_Setting__mdt
                    WHERE Object__c = :objectName
                        AND Type__c = :callType];
            settingsMap.put(settingsRecKey, settings);
        } else {
            settings = settingsMap.get(settingsRecKey);
        }
        
        Map<Id, RecordType> recTypeMap = RecordTypeDAO.getAllRecordTypes().get(objectName); // get all object record types
        Map<String, String> recordTypeNameToClass = buildRT2NameMap(settings, objectName); // get the record type name which is available
        Map<String, Boolean> skipTriggerClassMap = buildSkipTriggerClassMap(settings); //get user id(Dataloader)

        for(sObject sObj : sObjs) {

            String applicableClass = null;
            String recordTypeDevName = 'Master';

            if(recTypeMap != null && sObj.get('RecordTypeId') != null) {
                recordTypeDevName = recTypeMap.get((Id) sObj.get('RecordTypeId')).DeveloperName;
                applicableClass = recordTypeNameToClass.get(recordTypeDevName);
            } else {
                applicableClass = recordTypeNameToClass.get(recordTypeDevName);
            }

            if(settings.size() == 1 && applicableClass == null) {
                String expectedApplicableClass = settings[0].DeveloperName;

                throw new TriggerHandlerException('There is only 1 configured Manager Class (' + expectedApplicableClass + ') for this Object (' + objectName + ') but current record\'s Record Type (' + recordTypeDevName + ') is not listed there. Either add Record Type to existing Manager Class or configure a new Manager Class to handle this Record Type. You can configure a new Manager Class with an empty implementation if required.');
            }

            if(applicableClass != null
                && (skipTriggerClassMap.get(applicableClass) == null
                    || skipTriggerClassMap.get(applicableClass) == false)) {

                List<sObject> newsObjList = new List<sObject>();
                Map<Id, sObject> oldsObjMap = new Map<Id, sObject>();

                if(isDeleteContext) {
                    if(oldInheritanceMap.containsKey(applicableClass)) {
                        oldsObjMap = oldInheritanceMap.get(applicableClass);
                    }
                    oldsObjMap.put(sObj.Id, sObj);
                    oldInheritanceMap.put(applicableClass, oldsObjMap);
                } else {
                    if(newInheritanceMap.containsKey(applicableClass)) {
                        newsObjList = newInheritanceMap.get(applicableClass);
                    }
                    newsObjList.add(sObj);
                    newInheritanceMap.put(applicableClass, newsObjList);
                }
            }
        }
    }

    @TestVisible
    private static Map<String, Boolean> buildSkipTriggerClassMap(List<Inheritance_Setting__mdt> settings) {
        Map<String, Boolean> skipTriggerClassMap = new Map<String, Boolean>();
        Skip_User_Config__c skipUserConfig = Skip_User_Config__c.getValues('SkipTriggerUserId'); // custom setting 

        if(skipUserConfig != null && skipUserConfig.User_Id__c != null 
           && UserInfo.getUserId().startsWith(skipUserConfig.User_Id__c)) {
            for(Inheritance_Setting__mdt inheritanceSetting : settings) {
                if(inheritanceSetting.Skip_Trigger__c == true) {
                    skipTriggerClassMap.put(inheritanceSetting.DeveloperName, true);
                }
            }
        }

        return skipTriggerClassMap;
    }

    @TestVisible
    private static Map<String, String> buildRT2NameMap(List<Inheritance_Setting__mdt> settings, String objectName) {
        Map<String, String> tempMap = new Map<String, String>();

        for(Inheritance_Setting__mdt inhSet : settings) {
            if(inhSet.Record_Type_1__c != null) {
                if(tempMap.containsKey(inhSet.Record_Type_1__c)) {
                    throw new TriggerHandlerException('There is more than 1 configured Manager Class for this Object (' + objectName + ') and Record Type (' + inhSet.Record_Type_1__c + ').');
                }
                tempMap.put(inhSet.Record_Type_1__c, inhSet.DeveloperName);
            }
            if(inhSet.Record_Type_2__c != null) {
                if(tempMap.containsKey(inhSet.Record_Type_2__c)) {
                    throw new TriggerHandlerException('There is more than 1 configured Manager Class for this Object (' + objectName + ') and Record Type (' + inhSet.Record_Type_2__c + ').');
                }
                tempMap.put(inhSet.Record_Type_2__c, inhSet.DeveloperName);
            }
            if(inhSet.Record_Type_3__c != null) {
                if(tempMap.containsKey(inhSet.Record_Type_3__c)) {
                    throw new TriggerHandlerException('There is more than 1 configured Manager Class for this Object (' + objectName + ') and Record Type (' + inhSet.Record_Type_3__c + ').');
                }
                tempMap.put(inhSet.Record_Type_3__c, inhSet.DeveloperName);
            }
                      
        }

        return tempMap;
    }

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        if(!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }

        if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
        (ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
        (ctx != null && ctx == 'before update')) {
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
        (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
        (ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
        (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
        (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
        (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }
    
    @TestVisible
    private void fillInheritanceObjectMap() {
        if(Trigger.isExecuting) {
            if(Trigger.isDelete) {
                this.getInheritanceObjectMap(getSObjectType(), 'TriggerHandler', Trigger.new, Trigger.oldMap, true);
            } else {
                this.getInheritanceObjectMap(getSObjectType(), 'TriggerHandler', Trigger.new, Trigger.oldMap, false);
            }
        }
        
        managerMap = new Map<String, IManager>();
        applicableClasses = new Set<String>();
        applicableClasses.addAll(newInheritanceMap.keySet());
        applicableClasses.addAll(oldInheritanceMap.keySet());

        for(String applicableClass : applicableClasses) {
            IManager tm = (IManager) Type.forName(applicableClass).newInstance();
            managerMap.put(applicableClass, tm);
        }
    }

    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();

        if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if(exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        if(!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        
        return true;
    }

    @TestVisible
    protected abstract String getHandlerName();

    @TestVisible
    protected abstract String getSObjectType();

    /***************************************
     * context methods
     ***************************************/

    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).beforeInsert(newInheritanceMap.get(applicableClass));
        }
    }

    @TestVisible
    protected virtual void beforeUpdate() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).beforeUpdate(newInheritanceMap.get(applicableClass), oldInheritanceMap.get(applicableClass));            
        }
    }

    @TestVisible
    protected virtual void beforeDelete() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).beforeDelete(oldInheritanceMap.get(applicableClass));
        }
    }

    @TestVisible
    protected virtual void afterInsert() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).afterInsert(newInheritanceMap.get(applicableClass));
        }
    }

    @TestVisible
    protected virtual void afterUpdate() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).afterUpdate(newInheritanceMap.get(applicableClass), oldInheritanceMap.get(applicableClass));
        }
    }

    @TestVisible
    protected virtual void afterDelete() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).afterDelete(oldInheritanceMap.get(applicableClass));
        }
    }

    @TestVisible
    protected virtual void afterUndelete() {
        for(String applicableClass : applicableClasses) {
            managerMap.get(applicableClass).afterUndelete(newInheritanceMap.get(applicableClass));
        }
    }

    /***************************************
     * inner classes
     ***************************************/

    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(integer max) {
            this.max = max;
            this.count = 0;
        }

        public Boolean increment() {
            this.count++;

            return this.exceeded();
        }

        public Boolean exceeded() {
            if(this.max < 0) return false;
            if(this.count > this.max) {
                return true;
            }

            return false;
        }

        public Integer getMax() {
            return this.max;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setMax(Integer max) {
            this.max = max;
        }
    }

    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }

    // exception class
    @TestVisible
    private class TriggerHandlerException extends Exception { }
}