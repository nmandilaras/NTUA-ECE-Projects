package com;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import org.apache.log4j.Logger;
import org.bson.Document;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import static com.mongodb.client.model.Filters.eq;
import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;
import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

public class SortFollowers {

	private static final Logger logger = Logger.getLogger(Auxilary.class.getName());
	
	public static void main(String[] args) throws IOException {
		
		//ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		//MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");	
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("jitterN");
		MongoCollection<Document> users = db.getCollection("users");
		MongoCursor<Document> cursor = users.find().iterator();
		//Document doc = users.find(eq("username", "bandos_csgo")).first();
        logger.info("Starting...");
	    while (cursor.hasNext()) {
	    	Document doc = cursor.next();
	    	List<String> followers = doc.get("followers",List.class);
	    	List<String> junks = new ArrayList<String>();
	        Iterator<String> iterator = followers.iterator();
	        Iterator<String> iterator2 = followers.iterator();
	        iterator2.next();
	        String next;
	        // while loop
	        while (iterator.hasNext()) {
	        	String cur = iterator.next();
	        	if (iterator2.hasNext())  next =iterator2.next(); else break;
	        	if ( cur.equals(next)) junks.add(cur);
	        }
	    	for (String junk:junks) followers.remove(junk);

			/*Collections.sort(followers, new Comparator<String>() {
			    @Override
			    public int compare(String s1, String s2) {
			        return s1.compareTo(s2);
			    }
			});*/
			BasicDBObject newDocument = new BasicDBObject();
			newDocument.append("$set", new BasicDBObject().append("followers", followers));
			BasicDBObject searchQuery = new BasicDBObject().append("username", doc.get("username"));
			users.updateOne(searchQuery, newDocument);		
	   }
	   mongoClient.close();
		//List <User> users = mongoOperation.findAll(User.class);
		/*for (User user: users){
			List<String> followers = user.getFollowers();

			user.setFollowers(followers);
			mongoOperation.save(user);
		}
		for(String follower: followers){
			System.out.println(follower);
		}*/
        logger.info("Finished...");
	}

}
