package com.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

@Document(collection = "tweets")
public class Tweet {

	@Id
	private ObjectId id;
	private String userName;
	private String text;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date date;
	private int[] location;
	//private List<String> hashtags;
	private List<String[]> replies; 
	//private List<String[]> retweets;
	private List<ObjectId> retweets;
	private ObjectId rt;
	
	public Tweet(){
		this.replies = new ArrayList<String[]>();
		this.location = new int[2];
		this.retweets = new ArrayList<ObjectId>();
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
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
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
	public void addReply(String userName,String text, Date date ) {
		String[] reply = new String[]{userName,text,date.toString()};
		this.replies.add(reply);
	}
	public List<ObjectId> getRetweets() {
		return retweets;
	}
	public void addRetweet(ObjectId id) {
		this.retweets.add(id);
	}
	public ObjectId getRt() {
		return rt;
	}
	public void setRt(ObjectId rt) {
		this.rt = rt;
	}	
	public ObjectId getId() {
		return id;
	}
	public void setId(ObjectId id) {
		this.id = id;
	}	
}
