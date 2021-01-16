package noSpark;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

public class Profil {

	public static void main(String[] args) {
		
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		long lStartTime = System.nanoTime();
		String userName = args[0], usr = args[1]; 
		boolean follow;
		String followText;
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		if (!usr.equals(userName)){
			User user = mongoOperation.findOne(query, User.class);
			if(user != null){
				List<String> followers = user.getFollowers();
				if (followers!=null && followers.contains(usr)){
					follow = true;
					followText = "Unfollow";
				}
				else{
					follow = false;
					followText = "Follow";
				}
			}
		}
		else{
			;
		}
		query = new Query(Criteria.where("userName").is(usr));
		List<Tweet> jits = mongoOperation.find(query, Tweet.class);
		Collections.sort(jits, (a,b) -> a.compare(b));
		ctx.close();
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}
}