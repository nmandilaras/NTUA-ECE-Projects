package noSpark;

import java.util.Arrays;

import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.ReadPreference;
import com.mongodb.ServerAddress;

public class MongoMyClient {
	public @Bean
	MongoDbFactory mongoDbFactory() throws Exception {
		MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27018),
				//Arrays.asList(new ServerAddress("spark-jitter-m", 27017),new ServerAddress("spark-jitter-w-0", 27017),new ServerAddress("spark-jitter-w-1", 27017),new ServerAddress("spark-jitter-w-2", 27017)),
                MongoClientOptions.builder()
                .socketKeepAlive(true)
                //.readPreference(ReadPreference.secondary())
                .build());		
		    SimpleMongoDbFactory simpleMongoDbFactory = new SimpleMongoDbFactory(mongoClient, "jitterN");
		    return simpleMongoDbFactory;
	}
	
	public @Bean
	MongoTemplate mongoTemplate() throws Exception {

		MongoTemplate mongoTemplate = new MongoTemplate(mongoDbFactory());

		return mongoTemplate;

	}
}