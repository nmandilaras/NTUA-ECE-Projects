package noSpark;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

public class SearchUser {

	public static void main(String[] args) {
		
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		long lStartTime = System.nanoTime();		
		String  searchString = args[0];	
		Pattern pattern = Pattern.compile("^" + searchString);
		new Criteria();
		Query query = new Query(Criteria.where("userName").regex(pattern));	
		List<User> users = mongoOperation.find(query, User.class);
		for(User user:users){
			user.print();
		}
		ctx.close();
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}
}