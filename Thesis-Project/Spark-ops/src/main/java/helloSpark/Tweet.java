package helloSpark;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.bson.types.ObjectId;

public class Tweet {

	private String id;
	private String userName;
	private String text;
	private Timestamp date;
	private int[] location;
	//private List<String> hashtags;
	private List<String[]> replies; 
	//private List<String[]> retweets;
	private List<String> retweets;

	
	public Tweet(){
		this.replies = new ArrayList<String[]>();
		this.location = new int[2];
		this.retweets = new ArrayList<String>();
	}	
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String username) {
		this.userName = username;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	public int[] getLocation() {
		return location;
	}
	public void setLocation(int latitude, int longitude ) {
		this.location[0] = latitude;
		this.location[1] = longitude;
	}	
	public List<String[]> getReplies() {
		return replies;
	}
	public void addReply(String userName,String text, Timestamp date ) {
		String[] reply = new String[]{userName,text,date.toString()};
		this.replies.add(reply);
	}
	public List<String> getRetweets() {
		return retweets;
	}
	public void addRetweet(String id) {
		this.retweets.add(id);
	}	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
}
