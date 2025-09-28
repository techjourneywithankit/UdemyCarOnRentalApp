public with sharing class LogCleanupBatchSchedule implements Schedulable{
     
    public void execute(SchedulableContext sc){
        Database.executeBatch(new LogCleanupBatch(),200);
    }
}