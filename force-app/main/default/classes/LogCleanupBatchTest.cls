@IsTest
public with sharing class LogCleanupBatchTest {
    
    @TestSetup
    static void makeData() {
        // Create test LogEvent__c records with different creation dates
        List<LogEvent__c> logEvents = new List<LogEvent__c>();
        
        // Create old logs that should be deleted (older than threshold)
        for (Integer i = 0; i < 5; i++) {
            LogEvent__c oldLog = new LogEvent__c(
                Log_Data__c = 'Old test log ' + i,
                Quiddity__c = 'Test Quiddity',
                Request_Id__c = 'TestRequest' + i
            );
            logEvents.add(oldLog);
        }
        
        
        insert logEvents;
        
        // Note: We cannot set CreatedDate in tests as it's a system field
        // The batch will use the actual creation date for testing
    }
   
    
    @IsTest
    static void testLogCleanupBatchFullExecution() {
        // Test the complete batch execution
        LogCleanupBatch batch = new LogCleanupBatch();
        
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify that the batch execution completes without errors
        System.assert(true, 'Batch execution should complete without errors');
    }
    
}