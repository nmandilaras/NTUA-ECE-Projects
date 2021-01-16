package com;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;

import com.model.User;
import com.mongo.MongoMyClient;

public class CreateUsers {

	public static void main(String[] args) throws IOException, FileNotFoundException {
		// TODO Auto-generated method stub
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");		
		BufferedReader reader = new BufferedReader(new FileReader("src/main/resources/hundrendk.txt"));
        RandomAccessFile raf = new RandomAccessFile("src/main/resources/hundrendk.txt", "r");
		String userName, realName, password, email, temp,temp2;
		Random randPos = new Random(), randNumOfFollowers = new Random(); 
		int numOfFollowers, lengthOfLastLine = 8, fixedLength = (int)raf.length() - lengthOfLastLine; // length reduced by the length of last line in bytes
		User userNew;
		List<User> users = new ArrayList<User>();
		int j=0;
		System.out.println("Starting...");
		while ((userName = reader.readLine()) != null ){
			if ((++j)%1000 == 0){
				System.out.println("Commiting...number: " + j);
				mongoOperation.insertAll(users);
				users = new ArrayList<User>();
				System.out.println("Done!");
			}
			userNew = new User();
			Date date = new Date();
			temp = generateWord();
			temp2 = generateWord();
			password = temp;
			realName =  temp + " " + temp2 ;
			email = temp + "@" + temp2 + ".com";
			userNew.setUserName(userName);
			userNew.setRealName(realName);
			userNew.setPassword(password.hashCode());
			userNew.setEmail(email);
			userNew.setFirstLoginDate(date);
			userNew.setLastLoginDate(date);
			userNew.addFollower(userName);
	        numOfFollowers = randNumOfFollowers.nextInt(10000);
	        for (int i=0; i< numOfFollowers; i++){	
	            raf.seek(randPos.nextInt(fixedLength)); //first user is not going to be counted
	            raf.readLine(); //first read is dummy 
	        	userNew.addFollower(raf.readLine());  //gia oikonomia follow 10 mazi
	        }			
			users.add(userNew);
	        //mongoOperation.insert(userNew);
		}
		mongoOperation.insertAll(users);
		reader.close();
		raf.close();
		ctx.close();
		System.out.println("Finished");
	}

	private static String generateWord() {
		
	    Random random = new Random();
	    int length = 4  +  random.nextInt(5); 
	    StringBuilder word = new StringBuilder(length);
	    for (int i = 0; i < length; i++) {
	        word.append((char)('a' + random.nextInt(26)));
	    }
	    return word.toString();		
	}
	
	private static int generateInt() {
	
	    Random random = new Random();
	    int number = random.nextInt(100);
	    return number;		
	}	
	
/*	private static String passRandom() {

		String password = generateWord() + generateInt() ;
		return password;
	}
	
	private static String emailRandom() {

		String email = generateWord() + "@" + generateWord() + ".com";
		return email;
	}

	private static String realNameRandom() {
	
		String realName = generateWord() + " " + generateWord();
		return realName;
	}
	*/
}
