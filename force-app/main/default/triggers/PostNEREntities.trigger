trigger PostNEREntities on Call_Log__c ( after insert ) {

    //Define variables
    List<Call_Log__c> newLog = Trigger.new;

    //Call routine to post found Entity values
    EinsteinLanguage.PostNERResults( trigger.new[0].id, trigger.new[0].Notes__c, .7D );

    //Call routine to post Intent Entity values
    EinsteinLanguage.PostIntentResults( trigger.new[0].id, trigger.new[0].Notes__c, .7D );

}