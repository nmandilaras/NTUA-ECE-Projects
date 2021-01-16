package helloSpark;

import com.mongodb.spark.MongoSpark;
import com.mongodb.spark.config.ReadConfig;

import scala.Tuple2;
import static org.apache.spark.sql.functions.col;

import org.apache.spark.SparkContext;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.api.java.function.MapFunction;
import org.apache.spark.broadcast.Broadcast;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.storage.StorageLevel;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class Main {
	
	public static void main (String[] args) throws InterruptedException, IOException{
		
	    SparkSession spark = SparkSession.builder()
	    	      //.master("spark://spark-jitter-m:7077")
	    		  //.master("yarn")
	    	      .appName("helloSpark")
	    	      //.config("spark.submit.deployMode", "cluster")
	    	      //.config("spark.executor.cores", "2")
	    	      //.config("spark.executor.memory", "2560m")
	    	      //.config("spark.mongodb.input.uri", "mongodb://spark-jitter-m:27017,spark-jitter-w-0:27017,spark-jitter-w-1:27017,spark-jitter-w-2:27017/jitterN.tweets?replicaSet=rs0&readPreference=secondary")
	    	      .config("spark.mongodb.input.uri", "mongodb://spark-jitter-w-0:27018,spark-jitter-w-1:27018,spark-jitter-w-2:27018/jitterN.tweets?readPreference=nearest")	    	      
	    	      //.config("spark.mongodb.input.partitioner","MongoSamplePartitioner")
	    	      //.config("spark.mongodb.input.partitionerOptions.partitionKey","userName")	  
	    	      //.config("spark.mongodb.input.partitionerOptions.partitionSizeMB","1185")
	    	      //.config("spark.mongodb.input.partitionerOptions.samplesPerPartition","5")
	    	      //.config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
	    	      //.config("spark.locality.wait","200ms")
	    	      .config("spark.mongodb.input.localThreshold","100")
	    	      .config("spark.mongodb.input.partitioner","MongoShardedPartitioner")
	    	      .config("spark.mongodb.input.partitionerOptions.shardkey","userName")	    	      
	    	      .getOrCreate(); 
	   
	   
	    System.setProperty("spark.mongodb.keep_alive_ms", "6000000"); // 100 min
	    SparkContext conf = spark.sparkContext();
	    JavaSparkContext ctx = new JavaSparkContext(conf);

	    /* Complex query */
	    
	    Dataset<Row> nTweets = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "tweets"), Tweet.class).select("userName","replies","retweets").persist(StorageLevel.MEMORY_ONLY());	    
	    Dataset<Row> tw = nTweets.select("userName").groupBy("userName").agg(org.apache.spark.sql.functions.count("userName").as("numOfTweets"));
	    Dataset<Row> repl = nTweets.select("userName","replies").withColumn("replies",org.apache.spark.sql.functions.explode(col("replies"))).groupBy("userName").agg(org.apache.spark.sql.functions.count("replies").as("numOfReplies"));
	    Dataset<Row> retw = nTweets.select("userName","retweets").withColumn("retweets",org.apache.spark.sql.functions.explode(col("retweets"))).groupBy("userName").agg(org.apache.spark.sql.functions.count("retweets").as("numOfRetweets"));
	    Dataset<Row> ft = repl.join(retw,"userName").join(tw, "userName");
	    ft.withColumn("score",(ft.col("numOfTweets").multiply(0.25F)).plus(ft.col("numOfReplies").multiply(0.35F)).plus(ft.col("numOfReTweets").multiply(0.4F))).sort(col("score").desc()).show();
		   
	    /* */
	    
	    /* Find timeline for one user  */
	    
	    String userName = args[0];
	    Dataset<User> users = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "users"), User.class);
	    Dataset<Tweet> tweets = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "tweets"), Tweet.class);
	    String[] array = users.filter(col("userName").$eq$eq$eq(userName)).select("followers").first().getList(0).stream().toArray(String[]::new);
	    //Broadcast<String[]> Var = ctx.broadcast(array); //refer as Var.value
	    // broadcast the list to all nodes to see if we can decrease Task Deserialization Time (no change, that is happening already )
	    
	    //Dataset<String> foll =  users.filter(col("username").$eq$eq$eq("cxoop1994")).select("followers").withColumn("followers",org.apache.spark.sql.functions.explode(col("followers")).as("userName")).as(Encoders.STRING());
	    //tweets.join(foll, "userName").sort(col("date").desc()).show(false);
	    tweets.filter(col("userName").isin(array)).select("userName","text","date").sort(col("date").desc()).show(false);
	   
	    /*  */
	    
	   /* Cache tweets and calculate 100 timelines */
	     
	    BufferedReader reader = new BufferedReader(new FileReader("/home/nickiemand16/hundrendk.txt"));
        String userName;
	    Dataset<User> users = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "users"), User.class).persist(StorageLevel.MEMORY_ONLY());
        Dataset<Row> tweets = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "tweets"), Tweet.class).select("userName","text","date").persist(StorageLevel.MEMORY_ONLY());
        for(int i=0; i<101; i++){
            userName = reader.readLine();
            String[] array = users.filter(col("userName").$eq$eq$eq(userName)).select("followers").first().getList(0).stream().toArray(String[]::new);
    	    tweets.filter(col("userName").isin(array)).sort(col("date").desc()).show(false);
    	    //List<String> arr = (List<String>) tweets.filter(col("userName").isin(list.stream().toArray(String[]::new))).sort(col("date").desc()).select("userName","text","date").limit(20).collect();
    	    //save as file
        }
        reader.close();
        /* */
	    
	    /* Cache tweets with collect 
	    Dataset<Row> users = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "users"), User.class).select("followers").limit(101);//.persist(StorageLevel.MEMORY_ONLY());
        Dataset<Row> tweets = MongoSpark.load(spark, ReadConfig.create(spark).withOption("collection", "tweets"), Tweet.class).select("userName","text","date").persist(StorageLevel.MEMORY_ONLY());
        List<Row> nick  = users.collectAsList();
        for(Row row:nick){
    	     tweets.filter(col("userName").isin(row.getList(0).stream().toArray(String[]::new))).sort(col("date").desc()).show(false);
        }
         */
        
	    ctx.close();
	}
}
