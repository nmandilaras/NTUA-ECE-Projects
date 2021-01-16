package com;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import org.apache.log4j.Logger;
import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import com.model.Hashtag;
import com.model.Tweet;
import com.mongo.MongoMyClient;

public class HashtagSearch {

	private static final Logger logger = Logger.getLogger(HashtagSearch.class.getName());
	
	public static void main(String[] args) throws IOException {
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		RandomAccessFile raf = new RandomAccessFile("src/main/resources/googleWords.txt", "r");
		String  searchString;
		int limit =(int) raf.length()-5;
		Random  randPos = new Random();
        raf.seek(randPos.nextInt(limit)); //first user is not going to be counted
        raf.readLine();
        searchString = raf.readLine();	
        logger.info("Find hashtag");
		new Criteria();
		Query query = new Query(Criteria.where("text").is(searchString));	
		Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
		logger.info("Done!");
		List<Tweet> jits = new ArrayList<Tweet>();
		if (hashtag != null){
			logger.info("Not Null");
			List<ObjectId> jitsToRemove = new ArrayList<ObjectId>();
			Tweet tweet;
			for (ObjectId jitId : hashtag.getJits()){
				 new Criteria();
				query = new Query(Criteria.where("id").is(jitId));	
				 tweet = mongoOperation.findOne(query, Tweet.class);
				 if (tweet != null)
					 jits.add(tweet);
				 else
					 jitsToRemove.add(jitId);
			}
			logger.info("Finished");
		}
	}
}