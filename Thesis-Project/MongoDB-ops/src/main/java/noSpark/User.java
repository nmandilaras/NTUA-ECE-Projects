package noSpark;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

@Document(collection = "users")
public class User {

	@Id
	private ObjectId id;
	private String realName;
	private String userName;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date lastLoginDate;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date firstLoginDate;
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
	public Date getLastLoginDate() {
		return lastLoginDate;
	}
	public void setLastLoginDate(Date lastLoginDate) {
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
	public Date getFirstLoginDate() {
		return firstLoginDate;
	}
	public void setFirstLoginDate(Date firstLoginDate) {
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
	public void setUserName(String username) {
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