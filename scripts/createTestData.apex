// Script to create comprehensive test data using CarDataPreparationService
// Execute this script using: sfdx force:apex:execute -f scripts/createTestData.apex

System.debug('Starting comprehensive test data creation...');

try {
    // Create comprehensive test data
    Map<String, List<SObject>> testData = CarDataPreparationService.createComprehensiveTestData();
    
    // Log results
    System.debug('✅ Test data creation completed successfully!');
    System.debug('📊 Summary:');
    System.debug('   - Cars created: ' + testData.get('cars').size());
    System.debug('   - Contacts created: ' + testData.get('contacts').size());
    System.debug('   - Bookings created: ' + testData.get('bookings').size());
    System.debug('   - Reviews created: ' + testData.get('reviews').size());
    System.debug('   - Cases created: ' + testData.get('cases').size());
    
    // Display some sample data
    List<Car__c> cars = (List<Car__c>) testData.get('cars');
    if (!cars.isEmpty()) {
        System.debug('🚗 Sample car: ' + cars[0].Name + ' (' + cars[0].Make__c + ' ' + cars[0].Model__c + ')');
    }
    
    List<Booking__c> bookings = (List<Booking__c>) testData.get('bookings');
    if (!bookings.isEmpty()) {
        System.debug('📅 Sample booking: ' + bookings[0].Customer__c + ' booked car ' + bookings[0].Car__c);
    }
    
    System.debug('🎉 All test data has been created and is ready for testing!');
    
} catch (Exception e) {
    System.debug('❌ Error creating test data: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

