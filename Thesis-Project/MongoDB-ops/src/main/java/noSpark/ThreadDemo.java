package noSpark;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

class ThreadDemo extends Thread {
	   
	   private String userName;
	   
	   ThreadDemo( String name) {
	      userName = name;
	      //System.out.println("Creating " +  userName );
	   }
	   
	   public void run() {
	      //System.out.println("Running " +  userName );
	      long lStartTime = System.nanoTime();
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		//String userName = args[0];
		//for(int i=0; i<101; i++){
		    List<Tweet> jits = new ArrayList<Tweet>();
			new Criteria();
			Query query = new Query(Criteria.where("userName").is(userName));
			User user = mongoOperation.findOne(query, User.class);
			List<String> followers = user.getFollowers();
			//System.out.println(userName + "nik");
			//System.out.println(followers.size());
			Query myQuery = new Query(Criteria.where("userName").in(followers));
			myQuery.with(new Sort(Sort.Direction.DESC, "date"));
			jits = tweetsPage(myQuery, 0, mongoOperation);
			for (Tweet myTweet: jits )
				System.out.println(myTweet.getUserName() + ": " + myTweet.getText() + " on " + myTweet.getDate());
		//}
		ctx.close();
		long lEndTime = System.nanoTime();	
		long output = lEndTime - lStartTime;
		System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	      System.out.println("Thread " +  userName + " exiting.");
	   }	
		private static List<Tweet> tweetsPage(Query query, int i, MongoOperations mongoOperation) {

			Pageable pageable = new PageRequest(i,20);
			query.with(pageable);
			return mongoOperation.find(query, Tweet.class);		
		}
	}