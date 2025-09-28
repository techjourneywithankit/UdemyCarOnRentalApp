public with sharing class carImageController {
   
    @AuraEnabled 
    public static void createFile(
        String documentId,
        String recordId,
        Boolean isPrimaryImage
    ){
        //get the latest content version from the content document. 

        List<ContentVersion> contentVersion = [
            SELECT Id,ContentDocumentId from ContentVersion 
            where IsLatest = true and ContentDocumentId = :documentId
            order by CreatedDate desc limit 1
        ];
        if(contentVersion.isEmpty()){
           throw new AuraHandledException('Content version not found for content document id ' + isPrimaryImage);
        }

        //insert record in carImage
        Car_Image__c carImage = new Car_Image__c(
            Car__c = recordId,
            Image_Url__c =  '/sfc/servlet.shepherd/version/download/' + contentVersion[0].Id
        );
        if(isPrimaryImage){
            carImage.Primary_Image__c = true;
        }
        try {
            insert carImage;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
             Log logger = Log.get();
            logger.publish(ex.getMessage());
        }
    }

      @AuraEnabled(cacheable=true)
  public static List<Car_Image__c> getCarImages(Id productId) {
    try {
      return [
        SELECT id, Car__r.Name, Image_Url__c, Primary_Image__c
        FROM Car_Image__c
        WHERE Car__c = :productId
        WITH USER_MODE
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}