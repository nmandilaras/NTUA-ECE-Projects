package com;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.log4j.Logger;
import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;

import com.model.Hashtag;
import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;
import com.mongodb.BasicDBList;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import org.springframework.data.mongodb.repository.MongoRepository;

public class Auxilary {

	private static final Logger logger = Logger.getLogger(Auxilary.class.getName());
	
	public static void main(String[] args) throws IOException {
		
       // RandomAccessFile raf = new RandomAccessFile("src/main/resources/ten.txt", "r");
	//	BufferedReader reader = new BufferedReader(new FileReader("src/main/resources/ten.txt"));
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		BufferedReader reader = new BufferedReader(new FileReader("src/main/resources/hundrendk.txt"));
        logger.info("Starting...");
        String userName ;
        int j=0;
        Random randRetw = new Random(), randRepl = new Random();
		List<Tweet> tweets = new ArrayList<Tweet>();
		while ((userName = reader.readLine()) != null ){
			if ((++j)%1000 == 0){
				System.out.println("Commiting...number: " + j);
				for(Tweet tweet : tweets) mongoOperation.save(tweet);
				tweets = new ArrayList<Tweet>();
				System.out.println("Done!");
			}			
			Query query = new Query(Criteria.where("userName").is(userName));
			List<Tweet> jits = mongoOperation.find(query, Tweet.class);
			for(Tweet jit: jits){
				if (randRetw.nextInt(10) == 0) addRetweets(jit, tweets, mongoOperation);
				if (randRepl.nextInt(5) == 0 ) addReplies(jit, tweets, mongoOperation);
	        }
		}
		for(Tweet tweet : tweets) mongoOperation.save(tweet);
		ctx.close();
        /*Random days = new Random();
        String userName;
        int j=0, size, interval;
        double hours = 365*24.0;
        Date today = new Date();
        Date lastToday = new Date(today.getYear() -1 , today.getMonth() - 1, today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());	    
		while ((userName = reader.readLine()) != null ){
			Query query = new Query(Criteria.where("userName").is(userName));
			List<Tweet> jits = mongoOperation.find(query, Tweet.class);
			today = lastToday;
	        if ((++j)%5000 == 0) logger.info("Already in " + j);
			size = jits.size();
			interval = (int) (hours / size);
	        for(Tweet jit: jits){
		        Date fixDay = new Date(today.getYear(), today.getMonth(), today.getDate(), today.getHours() + interval, today.getMinutes() + days.nextInt(30), today.getSeconds() + days.nextInt(30));	
				jit.setDate(fixDay);
				today = fixDay;
				mongoOperation.save(jit);
			}
			//break;
		}*/
		//System.out.println(fixDay.toString());
		reader.close();
        logger.info("Finished...");
		/* List<Hashtag> hashtags;
		hashtags = mongoOperation.find(new Query(), Hashtag.class);
		for(Hashtag hashtag: hashtags){
			hashtag.setText(hashtag.getText().trim());
			mongoOperation.save(hashtag);
		}
        DBCollection collection = mongoOperation.getCollection("hashtags");
        DBCursor cursor = collection.find();  
        while(cursor.hasNext()){
            DBObject obj = cursor.next();
            String text =  (String) obj.get("text");
            obj.put("text", text.trim());
            collection.save(obj);
            
        }
		*/
		/*String userName;
        int numOfFollowers;
        Random randPos = new Random(), randNumOfFollowers = new Random(); 
		int lenghOfLastLine = 13, fixedLength = (int)raf.length() - lenghOfLastLine;
		while ((userName = reader.readLine()) != null ){
	        numOfFollowers = randNumOfFollowers.nextInt(10000);
	        for (int i=0; i< numOfFollowers; i++){	
	            raf.seek(randPos.nextInt(fixedLength)); //first user is not going to be counted, length reduced by the length of last line in bytes
	            raf.readLine(); //first read is dummy 
	        	System.out.println(raf.readLine()); 
	        }
		}
		        int i=0;
        while( i < 101001) {
            i++;
            writer.write(reader.readLine());
            writer.newLine();
        }
		*/
	} 
	
	public static void addReplies(Tweet jit, List<Tweet> tweets, MongoOperations mongoOperation) throws IOException{
        String userName="nickie";
        Random randNumOfReplies = new Random();
        int maxRepl = randNumOfReplies.nextInt(5);
        String text = "test answer small text";
        Date date = new Date();
        for (int i=0; i<maxRepl; i++){
	        jit.addReply(userName, text, date);
        }
        tweets.add(jit);
	}
	
	public static void addRetweets(Tweet jit, List<Tweet> tweets, MongoOperations mongoOperation) throws IOException{
        Random randNumOfReplies = new Random();
        ObjectId id = jit.getId();
        int maxRepl = randNumOfReplies.nextInt(5);
        for (int i=0; i<maxRepl; i++){
	        jit.addRetweet(id);
        }
		tweets.add(jit);
	}	
}
