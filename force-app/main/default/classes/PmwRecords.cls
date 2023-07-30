public with sharing class PmwRecords {
    @AuraEnabled
    public static Boolean savePmwRecords (Pmw__c pmwRecord)
    {
        list<Pmw__c> pmwList = [select id,Manufacturer_Name__c,Start_Date__c from Pmw__c where Manufacturer_Name__c like:pmwRecord.Manufacturer_Name__c order by CreatedDate desc limit 1];
  
               
        list<Pmw__c> newPmwList = new list<Pmw__c>();
        list<Pmw__c> oldPmwList = new list<Pmw__c>();
        Boolean Duplicate;
        if(pmwList.size() > 0)
        {
        for(Pmw__c pmw : pmwList)
        {
            if(pmw.Manufacturer_Name__c == pmwRecord.Manufacturer_Name__c)
            {
                if(pmwRecord.Start_Date__c !=null)
                {
                pmw.Expiry_Date__c = pmwRecord.Start_Date__c.addDays(-1);
                oldPmwList.add(pmw);
 			newPmwList.add(pmwRecord);
                }
                else if(pmwRecord.start_Date__c == null)
                {
						Duplicate =True;
                }
            }
            
        }
        }
        else if(pmwList.size() == 0)
        {
        newPmwList.add(pmwRecord);
            Duplicate =False;
        }
        
        if(oldPmwList.size() > 0)
        {
        update oldPmwList;
        }
        
        if(newPmwList.size() > 0)
        {
            insert newPmwList;
        }
       return Duplicate;
    }
}