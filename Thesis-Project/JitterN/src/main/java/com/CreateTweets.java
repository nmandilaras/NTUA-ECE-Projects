package com;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.bson.types.ObjectId;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import com.model.Hashtag;
import com.model.Tweet;
import com.model.User;
import com.mongo.MongoMyClient;

public class CreateTweets {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub

		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		BufferedReader reader = new BufferedReader(new FileReader("src/main/resources/hundrendk.txt"));
        RandomAccessFile raf = new RandomAccessFile("src/main/resources/googleWords.txt", "r");
		String userName, jitText, Shashtag;
		Tweet jit;
		int numOfTweets ,numOfWords, numOfHashtags, limit =(int) raf.length()-5, k=0;
		Random randNumOfTweets = new Random(), randNumOfWords = new Random(), randPos = new Random(), randNumOfHashtags = new Random() ;
		HashMap<String, Hashtag> map = new HashMap<String, Hashtag>(13334);
		System.out.println("Starting...");
		while ((userName = reader.readLine()) != null ){
			if ((++k)%10000 == 0){
				System.out.println("User number: " + k);
				commit(map,mongoOperation);
				map = new HashMap<String, Hashtag>(13334);
				System.gc();
				System.out.println("Done!");
			}
			numOfTweets = randNumOfTweets.nextInt(1000);
			for(int i=0; i<numOfTweets; i++){
				List<String> hashtags = new ArrayList<String>();
				jitText = "";
				Date date = new Date();
				numOfWords = 1 + randNumOfWords.nextInt(16);
				for(int j=0; j<numOfWords; j++){
		            raf.seek(randPos.nextInt(limit)); 
		            raf.readLine(); 
		        	jitText += raf.readLine() + " "; 			
				}
				numOfHashtags = randNumOfHashtags.nextInt(5);
				for(int j=0; j<numOfHashtags; j++){
		            raf.seek(randPos.nextInt(limit)); 
		            raf.readLine(); 
		            Shashtag = raf.readLine();
		        	jitText += "#" + Shashtag + " "; 
		        	hashtags.add(Shashtag);
				}
				jit = new Tweet();
				jit.setUserName(userName);
				jit.setDate(date);
				jit.setText(jitText);
				mongoOperation.insert(jit);
				for(String hashtagName : hashtags){
					Hashtag value = map.get(hashtagName);
					if (value != null){
						value.addJit(jit.getId());
					}else{
						value = new Hashtag();
						value.setText(hashtagName);
						value.addJit(jit.getId());
					}
					map.put(hashtagName, value);
				}
			}
		}
		commit(map,mongoOperation);
		ctx.close();
		System.out.println("Finished");
	}
	
	private static void commit(HashMap<String, Hashtag> map, MongoOperations mongoOperation) {
		Iterator it = map.entrySet().iterator();
		Map.Entry pair;
		String key;
		Hashtag myValue;
		while (it.hasNext()) {
			pair = (Map.Entry)it.next();
			key = (String) pair.getKey();
			myValue = (Hashtag) pair.getValue();
			new Criteria();
			Query query = new Query(Criteria.where("text").is(key));
			Hashtag hashtag = mongoOperation.findOne(query, Hashtag.class);
			if (hashtag == null){
				hashtag = new Hashtag();
				hashtag.setText(key);
				for (ObjectId myId: myValue.getJits())
					hashtag.addJit(myId);
				mongoOperation.insert(hashtag);
			}else{
				for (ObjectId myId: myValue.getJits())
					hashtag.addJit(myId);
				mongoOperation.save(hashtag);
			}
			//map.put(key, null);
		}
		return;
	}
}