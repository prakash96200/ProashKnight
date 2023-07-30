public class QueueableTaskCreator implements Queueable {
    private String recId;
    Public QueueableTaskCreator(string recId)
    {
        this.recId = recId;
    }
    public void execute(QueueableContext context)
    {
        Task tsk =new Task();
        tsk.WhatId= recId;
        tsk.Subject='Created from Queueable Apex';
        insert tsk;
    }
    

}