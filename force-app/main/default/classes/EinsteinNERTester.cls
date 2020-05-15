public class EinsteinNERTester {

    //Define constants
    static final Double cdMINIMUM_PROBABILITY = .7D;
    static final String csNER_MODEL = 'NER7';

    //Function to post the results to a related object
//	@InvocableMethod(label='Insert NER Entities' description='Insert NER Entities found in Call Log Notes.')
    public static List<Entity__c> InsertNEREntities( List<Call_Log__c> callLogs ) {

        //Define variables for me.
        String sCallLogID = callLogs[0].Id;
        List<einsteinplay.Einstein_Probability> probabilities = Predict( callLogs[0].Notes__c );

        //Cycle through each record
        for ( Integer i = 0; i < probabilities.size(); i++ ) {

            //Add a new entity
            Entity__c entity = new Entity__c();

            //Set the value
            entity.Call_Log__c = sCallLogID;
            entity.Type__c = probabilities[i].label;
            entity.Probability__c = (probabilities[i].probability * 100);
            entity.Entity__c = probabilities[i].token;

	        //Insert the records
			Database.SaveResult result = Database.insert(entity);

        }

        //Return the results
        List<Entity__c> returnEntities = [SELECT Call_Log__c, Type__c, Probability__c, Entity__c FROM Entity__c WHERE Call_Log__c =: sCallLogID];
        return returnEntities;
    }


	//Function to post the results to a related object
	@future
    public static void PostResults( String sCallLogID, String sText, Double minProbabilityScore ) {

        //Define variables
        List<einsteinplay.Einstein_Probability> probabilities = Predict( sText );

        //Cycle through each record
        for ( Integer i = 0; i < probabilities.size(); i++ ) {

            //Add a new entity
            Entity__c entity = new Entity__c();

            //Set the value
            entity.Call_Log__c = sCallLogID;
            entity.Type__c = probabilities[i].label;
            entity.Probability__c = (probabilities[i].probability * 100);
            entity.Entity__c = probabilities[i].token;

	        //Insert the records
			insert entity;
        }

    }

    //Function to execute the NER Prediction Service
    private static List<einsteinplay.Einstein_Probability> Predict( string sText ) {

        //Define variables
        einsteinplay.Einstein_PredictionService service = new einsteinplay.Einstein_PredictionService(einsteinplay.Einstein_PredictionService.Types.NER);
        einsteinplay.Einstein_PredictionResult prediction = service.predictNER( csNER_MODEL, sText, 5, '');
		List<einsteinplay.Einstein_Probability> results = prediction.probabilities;

        //Test whether anything returned
        if (!results.isEmpty()) {

            //Set variables
        	System.debug( results );
			System.debug( results.size() );

        }

        //Return the results
        return results;
    }
}