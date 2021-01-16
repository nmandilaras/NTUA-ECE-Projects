

import java.util.Arrays;

import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.ReadPreference;
import com.mongodb.ServerAddress;

public class MongoMyClient {
	public @Bean
	MongoDbFactory mongoDbFactory() throws Exception {
		MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27017), 
                MongoClientOptions.builder()
                .socketKeepAlive(true)
                //.readPreference(ReadPreference.secondary())
                .build());		
		    //MongoClient mongoClient = new MongoClient( "localhost" , 27017); 
		    SimpleMongoDbFactory simpleMongoDbFactory = new SimpleMongoDbFactory(mongoClient, "jitterN");
		    return simpleMongoDbFactory;
	}
	
	public @Bean
	MongoTemplate mongoTemplate() throws Exception {

		MongoTemplate mongoTemplate = new MongoTemplate(mongoDbFactory());

		return mongoTemplate;

	}
}