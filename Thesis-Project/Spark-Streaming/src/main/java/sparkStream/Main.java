package sparkStream;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.Arrays;
import java.util.List;
import org.apache.spark.*;
import org.apache.spark.streaming.Durations;
import org.apache.spark.streaming.api.java.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import scala.Tuple2;

public class Main {

	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		SparkConf conf = new SparkConf()
				.setAppName("sparkStream")
				.setMaster("local[*]");

		JavaStreamingContext ssc = new JavaStreamingContext(conf, Durations.seconds(1));
		JavaReceiverInputDStream<String> lines = ssc.socketTextStream("localhost", 9999);
		
		JavaPairDStream<String ,String> tuples = lines.mapToPair(x -> new Tuple2<>(x.split(":")[0],x));
		tuples.reduceByKey((i1, i2) -> i1 + "\n" + i2);
		//tuples.print();
		tuples.foreachRDD(rdd -> {
			  rdd.foreach(record -> {
			      MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
				  MongoDatabase db = mongoClient.getDatabase("jitterN");
				  MongoCollection<Document> users = db.getCollection("users");
				  Document user = users.find(eq("username", record._1())).first();
				  List<String> followers = user.get("followers", List.class);
				  BufferedWriter writer;
				  String tweet = record._2() + "\n";
				  for(String follower : followers){
						writer = new BufferedWriter(new FileWriter("F:/stream/" + follower + ".txt",true));
						writer.write(tweet);
						writer.close();
				  }
				  mongoClient.close();
				  });
				});
		
		ssc.start();              // Start the computation
		ssc.awaitTermination();   // Wait for the computation to terminate
	}
}
