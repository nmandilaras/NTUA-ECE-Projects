
public class AuxUsr {

	private String userName;
	private int numOfTw;
	private int numOfRepl;
	private int numOfRetw;
	private float score;
	
	public AuxUsr(/*String userName,*/ int tweets, int replies, int retweets, float score) {
		//this.userName = userName;
		this.score = score;
		this.numOfTw = tweets;
		this.numOfRepl = replies;
		this.numOfRetw = retweets;
	}
	
	public AuxUsr(String userName, int tweets, int replies, int retweets, float score) {
		this.userName = userName;
		this.score = score;
		this.numOfTw = tweets;
		this.numOfRepl = replies;
		this.numOfRetw = retweets;
	}
	
	public void setScore(float num){
		this.score += num;
	}
	
	public float getScore(){
		return this.score;
	}
	
	public void setRepl(int repl){
		this.numOfRepl = repl;
	}
	
	public void setRetw(int retw){
		this.numOfRetw = retw;
	}
	
	public AuxUsr repl(int repl){
		this.setRepl(repl);
		this.setScore(0.35F * repl);
		return this;
	}
	
	public AuxUsr retw(int retw){
		this.setRetw(retw);
		this.setScore(0.4F * retw);
		return this;
	}
	
	public int compare( AuxUsr b) {
        // -1 - less than, 1 - greater than, 0 - equal, all inversed for descending
        if (this.getScore() > b.getScore())
        	return -1;
        else if (b.getScore() > this.getScore())
        	return 1;
        else 
        	return 0;
    }
	
	public String print(){
		return/*this.userName + ": " + */this.numOfTw + ": " + this.numOfRepl + ": " + this.numOfRetw + ": " + this.score;
	}		
}
