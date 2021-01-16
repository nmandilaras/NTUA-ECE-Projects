
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.ReadPreference;
import com.mongodb.ServerAddress;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

public class Main{

	public static void main(String[] args) throws IOException {

		System.out.println("Starting..");
		long lStartTime = System.nanoTime();
        MongoClient mongoClient = new MongoClient("spark-jitter-m",27018);
		MongoDatabase db = mongoClient.getDatabase("jitterN");
		MongoCollection<Document> tweets = db.getCollection("tweets");
		float score = 0;
        String userName ;
		int numOfTw = 0, numOfRepl = 0, numOfRetw = 0;
		List<AuxUsr> aux = new ArrayList<AuxUsr>();
		
		/* find score for all users */
		
		HashMap<String,AuxUsr> map = new HashMap<String,AuxUsr>(100000);
    	AggregateIterable<Document> output = tweets.aggregate(Arrays.asList(
		        new Document("$group", new Document("_id", "$userName").append("tw_count",new Document ("$sum",1)))
		        ));

		for (Document dbObject : output){
			numOfTw = dbObject.getInteger("tw_count");
			map.put(dbObject.getString("_id"),new AuxUsr(numOfTw, 0, 0 , 0.25F * numOfTw));
		}
    	output = tweets.aggregate(Arrays.asList(
		        new Document("$unwind", "$replies"),
		        new Document("$group", new Document("_id", "$userName").append("repl_count",new Document ("$sum",1)))
		        ));

		for (Document dbObject : output){
			userName = dbObject.getString("_id");
			numOfRepl = dbObject.getInteger("repl_count");
			map.put(userName, map.get(userName).repl(numOfRepl));
		}
		
    	output = tweets.aggregate(Arrays.asList(
		        new Document("$unwind", "$retweets"),
		        new Document("$group", new Document("_id", "$userName").append("retw_count",new Document ("$sum",1)))
		        )); 	

		for (Document dbObject : output){
			userName = dbObject.getString("_id");
			numOfRetw = dbObject.getInteger("retw_count");
			map.put(userName, map.get(userName).retw(numOfRetw));
		}
		
		map.entrySet().stream()
		   .sorted(Map.Entry.comparingByValue((a,b) -> a.compare(b)))
		   .limit(20)
		   .forEach(e -> System.out.println(e.getKey() + e.getValue().print()));
		
	    long lEndTime = System.nanoTime();	
        long time = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + time / 1000000);		
		mongoClient.close();
	}
}