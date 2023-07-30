public class FutureTaskCreator {
    @future
    public Static void CreateTask(String recId)
    {
        Task tsk = new Task();
        tsk.Subject='Created from future method';
        tsk.WhatId=recId;
        insert tsk;
    }

}