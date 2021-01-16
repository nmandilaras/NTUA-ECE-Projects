package noSpark;

import java.util.ArrayList;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

public class Search {

	private static Query myQuery = null;
	
	public static void main(String[] args) {

		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		long lStartTime = System.nanoTime();		
		String  searchString = args[0];	
		new Criteria();
		Query query = new Query(Criteria.where("text").is(searchString));	
		Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
		List<Tweet> jits = new ArrayList<Tweet>();
		if (hashtag != null){
			List<ObjectId> twId = hashtag.getJits();
			List<ObjectId> tweetId = twId.subList(Math.max(twId.size() - 20, 0), twId.size());
			new Criteria();
			myQuery = new Query(Criteria.where("_id").in(tweetId));
			jits = mongoOperation.find(myQuery, Tweet.class);	
			for (Tweet myTweet: jits )
				System.out.println(myTweet.getUserName() + ": " + myTweet.getText() + " on " + myTweet.getDate());
			
		}
		ctx.close();
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}		
}