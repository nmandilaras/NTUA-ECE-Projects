package noSpark;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;


public class Main {
	
	private static Query myQuery = null;
	
	public static void main(String[] args) throws IOException {
		
		long lStartTime = System.nanoTime();
	    BufferedReader reader = new BufferedReader(new FileReader("/home/nickiemand16/hundrendk.txt"));
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		String userName = args[0];
        for(int i=0; i<101; i++){
	        userName = reader.readLine(); 
	        List<Tweet> jits = new ArrayList<Tweet>();
			new Criteria();
			Query query = new Query(Criteria.where("userName").is(userName));
			User user = mongoOperation.findOne(query, User.class);
			List<String> followers = user.getFollowers();
			//System.out.println(followers.size());
			allFollowersAllTweetsPage(followers,jits,mongoOperation);
        }
		reader.close();
		ctx.close();
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}
	
	private static void allFollowersAllTweetsPage(List<String> followers, List<Tweet> jits, MongoOperations mongoOperation) {

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
