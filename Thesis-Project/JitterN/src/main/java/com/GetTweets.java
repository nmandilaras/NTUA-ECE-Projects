package com;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Random;

import org.apache.log4j.Logger;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;

public class GetTweets {

	private static final Logger logger = Logger.getLogger(GetTweets.class.getName());
	private static Query myQuery = null;
	
	public static void main(String[] args) throws IOException {
        RandomAccessFile raf = new RandomAccessFile("src/main/resources/hundrendk.txt", "r");
        int fixedLength = (int)raf.length() - 8;
        String userName;
        Random randPos = new Random();
        List<Tweet> jits = new ArrayList<Tweet>();
        raf.seek(randPos.nextInt(fixedLength)); //first user is not going to be counted
        raf.readLine();
        userName = raf.readLine();
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		new Criteria();
		Query query = new Query(Criteria.where("username").is("meme0019"));
		logger.info("Find a User.");
		User user = mongoOperation.findOne(query, User.class);
		logger.info("Done.");
		List<String> followers = user.getFollowers();
		//allTweetsOneUser(userName,jits,mongoOperation);
		//allFollowersOneTweet(followers,jits,mongoOperation);
		//allFollowersAllTweets(followers,jits,mongoOperation);
 		//allFollowersAllTweetsUpdate(followers,jits,mongoOperation);
		allFollowersAllTweetsPage(followers,jits,mongoOperation);
	    logger.info("Done.");
	}

	private static void allFollowersOneTweet(List<String> followers, List<Tweet> jits, MongoOperations mongoOperation) {
		// TODO Auto-generated method stub
		Query query;
		Tweet jit;
		logger.info("Number of followers: " + followers.size());
		logger.info("Get one jit for every follower.");
		for(String follower: followers){
			query = new Query(Criteria.where("userName").is(follower));	
			jit = mongoOperation.findOne(query, Tweet.class);
			if (jit != null) jits.add(jit);
		}	
	}
	
	private static void allFollowersAllTweetsUpdate(List<String> followers, List<Tweet> jits, MongoOperations mongoOperation) {
		// TODO Auto-generated method stub
		Query query = new Query(Criteria.where("userName").in(followers));
		logger.info("Get all jits for every follower.");
		jits.addAll(mongoOperation.find(query, Tweet.class));	
	}

	private static void allFollowersAllTweets(List<String> followers, List<Tweet> jits, MongoOperations mongoOperation) {
		// TODO Auto-generated method stub
		Query query;
		logger.info("Number of followers: " + followers.size());
		logger.info("Get all jits for every follower.");
		for(String follower: followers){
			query = new Query(Criteria.where("userName").is(follower));	
			jits.addAll(mongoOperation.find(query, Tweet.class));	
		}	
	}
	private static void allTweetsOneUser(String userName, List<Tweet> jits, MongoOperations mongoOperation) { // for profile
		// TODO Auto-generated method stub
		Query query = new Query(Criteria.where("userName").is(userName));
		logger.info("Get all jits.");		
		jits = mongoOperation.find(query, Tweet.class);
		logger.info("Number of jits: " + jits.size());
	}	
	
	private static void allFollowersAllTweetsPage(List<String> followers, List<Tweet> jits, MongoOperations mongoOperation) {
		// TODO Auto-generated method stub
		logger.info("Get all jits for every follower with paging");
		myQuery = new Query(Criteria.where("userName").in(followers));
		myQuery.with(new Sort(Sort.Direction.DESC, "date"));
		jits = tweetsPage(myQuery, 0, mongoOperation);
		for (Tweet myTweet: jits )
			System.out.println(myTweet.getUserName() + ": " + myTweet.getText() + " on " + myTweet.getDate());
	}
	
	private static List<Tweet> tweetsPage(Query query, int i, MongoOperations mongoOperation) {

		Pageable pageable = new PageRequest(i,20);
		query.with(pageable);
		return mongoOperation.find(query, Tweet.class);		
	}	
}
