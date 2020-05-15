//Author:	Timothy Miles
//Date:		5/5/2020
//Purpose:	This class manages the Einstein Language processes
//			found in the Einstein Playground
//Notes:    Must include @future(callout=true) to allow for async processing in trigger
public class EinsteinLanguage {

    //Define contants
    static final String csNER_MODEL = 'NER7';
    static final String csINTENT_MODEL = 'ZPAGFKQ7FT3DYX2DQSPYKJZ53U';

    //Function to post the results from Einstein Language Named Entity Recognition (NER)
    //to a related object.  It uses the NER7 model from the Playground.
    //sParentID                 = ID for the parent record.  Used as the linked ID
    //                            in the Entity object
    //sNotes                    = String value being tested by NER
    //dMinAllowableProbability  = Minimum threshold for entities being posted.
	@future(callout=true)
    public static void PostNERResults( String sParentID, String sNotes, Decimal dMinAllowableProbability ) {

        //Define variables
        List<einsteinplay.Einstein_Probability> entities = EinsteinPredictNER( sNotes, 5 );

        //Cycle through each record
        for ( Integer i = 0; i < entities.size(); i++ ) {

            //Test whether the probability is great enough to post
            if ( entities[i].probability >= dMinAllowableProbability ) {

                //Add a new entity
                Entity__c entity = new Entity__c();

                //Set the value
                entity.Call_Log__c = sParentID;
                entity.Type__c = entities[i].label;
                entity.Probability__c = (entities[i].probability * 100);
                entity.Entity__c = entities[i].token;

                //Insert the records
                insert entity;

            }

        }

    }

    //Function to post the results from Einstein Language Intent to a related object.
    //It uses the NER7 model from the Playground.
    //sParentID                 = ID for the parent record.  Used as the linked ID
    //                            in the Entity object
    //sNotes                    = String value being tested by NER
    //dMinAllowableProbability  = Minimum threshold for entities being posted.
	@future(callout=true)
    public static void PostIntentResults( String sParentID, String sNotes, Decimal dMinAllowableProbability ) {

        //Define variables
        List<einsteinplay.Einstein_Probability> entities = EinsteinPredictINTENT( sNotes, 5 );

        //Cycle through each record
        for ( Integer i = 0; i < entities.size(); i++ ) {

            //Test whether the probability is great enough to post
            if ( entities[i].probability >= dMinAllowableProbability ) {

                //Add a new entity
                Entity__c entity = new Entity__c();

                //Set the value
                entity.Call_Log__c = sParentID;
                entity.Type__c = 'Intent';
                entity.Probability__c = (entities[i].probability * 100);
                entity.Entity__c = entities[i].label;

                //Insert the records
                insert entity;

            }

        }

    }

    //Function to execute the NER Prediction Service
    private static List<einsteinplay.Einstein_Probability> EinsteinPredictNER( string sText, integer iMaxResults ) {

        //Define variables
        einsteinplay.Einstein_PredictionService service = new einsteinplay.Einstein_PredictionService(einsteinplay.Einstein_PredictionService.Types.NER);
        einsteinplay.Einstein_PredictionResult prediction = service.predictNER( csNER_MODEL, sText, iMaxResults, '');
		List<einsteinplay.Einstein_Probability> results = prediction.probabilities;

        //Test whether anything returned and post to the log
        if (!results.isEmpty()) {

            //Set variables
        	System.debug( results );
			System.debug( results.size() );

        }

        //Return the results
        return results;
    }

    //Function to execute the Intent Prediction Service
    private static List<einsteinplay.Einstein_Probability> EinsteinPredictIntent( string sText, integer iMaxResults ) {

        //Define variables
        einsteinplay.Einstein_PredictionService service = new einsteinplay.Einstein_PredictionService(einsteinplay.Einstein_PredictionService.Types.Intent);
        einsteinplay.Einstein_PredictionResult prediction = service.predictIntent( csINTENT_MODEL, sText, iMaxResults, '');
		List<einsteinplay.Einstein_Probability> results = prediction.probabilities;

        //Test whether anything returned and post to the log
        if (!results.isEmpty()) {

            //Set variables
        	System.debug( results );
			System.debug( results.size() );

        }

        //Return the results
        return results;
    }

}