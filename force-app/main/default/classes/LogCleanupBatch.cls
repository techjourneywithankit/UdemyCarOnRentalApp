public with sharing class LogCleanupBatch implements Database.Batchable<sObject>, Database.stateful {
    
    private Integer daysToKeep;
    private Integer recordsProcessed = 0;
    private Integer recordsDeletedSuccessfully = 0;
    private Integer recordsDeleteionFailed = 0;
    private String notificationEmail;

    public LogCleanupBatch(){
        loadConfiguration();
    }

    private void loadConfiguration(){
        //get the Log Clean up Notification	
        System_Thresholds__mdt logCleanUpMdt = System_Thresholds__mdt.getInstance('Log_Clean_up_Notification');
        notificationEmail = logCleanUpMdt.Value__c;

        System_Thresholds__mdt daysToKeepMdt = System_Thresholds__mdt.getInstance('Days_To_Keep_Logs');
        daysToKeep = Integer.valueOf(daysToKeepMdt.Value__c);

    }

    public Database.queryLocator start(Database.BatchableContext bc){
        Date cutOffDate = Date.today().addDays(-daysToKeep);
        String query = 'Select Id from LogEvent__c where createdDate < :cutOffDate';
        return database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc,List<LogEvent__c> scope){
        if(scope == null || scope.isEmpty()){
            return;
        }

        recordsProcessed = recordsProcessed + scope.size();
        //all good records will be deleted and bad records will be skipped
        List<Database.DeleteResult> results = Database.delete(scope,false);
        Log logger = Log.get();
        for(Database.DeleteResult result : results){
            if(result.isSuccess()){
                recordsDeletedSuccessfully = recordsDeletedSuccessfully + 1;
            }else{
                //List<Database.error> errorList = result.getErrors();
                recordsDeleteionFailed = recordsDeleteionFailed + 1;
                logger.add('Record Deletion Failed ' +    String.join(result.getErrors(), ', ')  );
            }
        }
        logger.publish();
    }

    public void finish(Database.BatchableContext bc){
        String subject = 'LogCleanupBatch Complete - ' + datetime.now().format('MM dd, yyyy');
        String body = 'Log Cleanup Batch Job Completed\n\n' +
                      'Records processed : ' + recordsProcessed + '\n' +
                      'Record Deleted Successfully :' + recordsDeletedSuccessfully + '\n' +
                      'Record Deletion Failed : ' + recordsDeleteionFailed + '\n' +
                      'This is an automated recport from the Car on Rental System';
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {notificationEmail}; 
        // Assign the addresses for the To to the mail object.
        mail.setToAddresses(toAddresses);

        // Specify the name used as the display name.
        mail.setSenderDisplayName('Car On Rental');

        mail.setSubject(subject);

        mail.setPlainTextBody(body);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


}