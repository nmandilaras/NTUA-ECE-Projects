import java.io.*;
import java.net.*;
import java.util.Random;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;

import java.util.Date;

 public class TweetServer{
	 
	 public static void main(String[] args ){
		 
		ConfigurableApplicationContext ctx = new AnnotationConfigApplicationContext(MongoMyClient.class);
		MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
	 try{
		 
        ServerSocket s = new ServerSocket(9999);
        // wait for client connection – as soon as this comes,
         Socket incoming = s.accept ( ); //socket obj. incoming is constructed  
         //BufferedReader in = new BufferedReader (new InputStreamReader(incoming.getInputStream()));
         PrintWriter out = new PrintWriter (incoming.getOutputStream(),true);
         boolean done = false;
         while (!done){
        	Tweet jit = generateTweet();
			out.println(jit.getUserName() + ":" + jit.getText() + ":" + jit.getDate());
			//System.out.println(jit.getUserName() + ":" + jit.getText() + ":" + jit.getDate());
			mongoOperation.insert(jit); //send to db also the writes
			Thread.sleep(200);
        }
        s.close(); 
        incoming.close();
		ctx.close();
       }
      catch (Exception e) { e.printStackTrace(); }
    }
	
	public static Tweet generateTweet() throws IOException{
		Date date = new Date();
		RandomAccessFile reader = new RandomAccessFile("D:/Jitter/jitter/JitterN/src/main/resources/hundrendk.txt", "r");
        RandomAccessFile raf = new RandomAccessFile("D:/Jitter/jitter/JitterN/src/main/resources/googleWords.txt", "r");
		String userName, jitText, Shashtag;
		int numOfWords, numOfHashtags, limit =(int) raf.length()-5, fixedLength = (int)reader.length() - 8;
		Random randNumOfWords = new Random(), randPosUser = new Random(), randPos = new Random(), randNumOfHashtags = new Random();
		reader.seek(randPosUser.nextInt(fixedLength));
		reader.readLine();
		userName = reader.readLine();
		jitText = "";
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
		}
		Tweet jit = new Tweet();
		jit.setUserName(userName);
		jit.setDate(date);
		jit.setText(jitText);
		raf.close();
		reader.close();
		return jit;	
	}		
 }

