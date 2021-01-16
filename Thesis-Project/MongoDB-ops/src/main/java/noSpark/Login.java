package noSpark;

import java.util.Date;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

public class Login {

	public static void main(String[] args) {
		
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		long lStartTime = System.nanoTime();
		String userName = args[0], password = args[1];
		Date date = new Date();
		new Criteria();
		Query query = new Query(Criteria.where("userName").is(userName));
		User user = mongoOperation.findOne(query, User.class);
		if(user != null){
			if (user.getPassword() == password.hashCode()) //hack
				System.out.println("Wrong password");
			else{
				user.setLastLoginDate(date);
				mongoOperation.save(user);
				System.out.println("Log in succesful");
			}
		}else{
			System.out.println("UserName doesn't exist");
		}
		ctx.close();	
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}

}
