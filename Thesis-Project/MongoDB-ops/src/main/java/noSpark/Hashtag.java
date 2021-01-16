package noSpark;

import java.util.ArrayList;
import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "hashtags")
public class Hashtag {

	@Id
	private ObjectId id;
	private String text;
	private List<ObjectId> jits;
	
	public Hashtag(){
		this.jits = new ArrayList<ObjectId>();
	}
	
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}	
	public List<ObjectId> getJits() {
		return jits;
	}
	public void addJit(ObjectId id) {
		this.jits.add(id);
	}
	public void removeJit(ObjectId id) {
		this.jits.remove(id);
	}
}
