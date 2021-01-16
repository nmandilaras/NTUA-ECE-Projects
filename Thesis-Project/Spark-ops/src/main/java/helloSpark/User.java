package helloSpark;

import java.util.ArrayList;
import java.sql.Timestamp;
import java.util.List;

import org.bson.types.ObjectId;

public class User {

	private ObjectId id;
	private String realName;
	private String userName;
	private Timestamp lastLoginDate;
	private Timestamp firstLoginDate;
	private int password;
	private String email;
	private List<String> followers; 
	
	public User(){
		this.followers = new ArrayList<String>();
	}
	
	public String getRealName() {
		return realName;
	}
	public void setRealName(String firstName) {
		this.realName = firstName;
	}
	public Timestamp getLastLoginDate() {
		return lastLoginDate;
	}
	public void setLastLoginDate(Timestamp lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getPassword() {
		return password;
	}
	public void setPassword(int password) {
		this.password = password;
	}
	public Timestamp getFirstLoginDate() {
		return firstLoginDate;
	}
	public void setFirstLoginDate(Timestamp firstLoginDate) {
		this.firstLoginDate = firstLoginDate;
	}
	public ObjectId getId() {
		return id;
	}
	public void setId(ObjectId id) {
		this.id = id;
	}
	public String getUserName() {
		return userName;
	}
	public void setUsername(String username) {
		this.userName = username;
	}
	public List<String> getFollowers() {
		return followers;
	}
	public void addFollower(String userName) {
		this.followers.add(userName);
	}
	public void deleteFollower(String userName) {
		this.followers.remove(userName);
	}
	public void print() {
		System.out.println("UserName:" + this.userName);
		System.out.println("RealName:" + this.realName);
		System.out.println("Password:" + this.password);
		System.out.println("Email:" + this.email);
		System.out.println("FloginDate:" + this.firstLoginDate);
		System.out.println("LloginDate:" + this.lastLoginDate);
	}
}