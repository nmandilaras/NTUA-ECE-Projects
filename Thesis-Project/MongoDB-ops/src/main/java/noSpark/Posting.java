package noSpark;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

public class Posting {

	public static void main(String[] args) {
		
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
		long lStartTime = System.nanoTime();
		String userName = args[0], jitText = args[1];
		Date date = new Date();
		Tweet jit = new Tweet();
		jit.setUserName(userName);
		jit.setDate(date);
		jit.setText(jitText);
		mongoOperation.insert(jit);

		Pattern MY_PATTERN = Pattern.compile("#(\\w+)");
		Matcher mat = MY_PATTERN.matcher(jitText);
		List<String> hashtags = new ArrayList<String>();
		while (mat.find()) 
		  hashtags.add(mat.group(1));
		for(String hashtagName : hashtags){
			new Criteria();
			Query query = new Query(Criteria.where("text").is(hashtagName));
			Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
			if (hashtag == null){
				hashtag = new Hashtag();
				hashtag.setText(hashtagName);
				hashtag.addJit(jit.getId());
				mongoOperation.insert(hashtag);
			}else{
				hashtag.addJit(jit.getId());
				mongoOperation.save(hashtag);
			}
		}		
		ctx.close();
	    long lEndTime = System.nanoTime();	
        long output = lEndTime - lStartTime;
        System.out.println("Elapsed time in milliseconds: " + output / 1000000);
	}
}