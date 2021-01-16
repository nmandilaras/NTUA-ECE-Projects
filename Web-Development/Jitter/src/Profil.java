

import static com.mongodb.client.model.Filters.eq;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.bson.Document;

import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

/**
 * Servlet implementation class Profil
 */
public class Profil extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Profil() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("Jitter");
		HttpSession session = request.getSession(false);
		String userName = (String)session.getAttribute(  "Username" );
		String usr = request.getParameter("usr");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat TimeFormat = new SimpleDateFormat("HH:mm dd/MM");
		MongoCollection<Document> followers = db.getCollection(userName);
		PrintWriter out;
		out = response.getWriter();
		out.print("<!DOCTYPE html><html><head><title>Profile page</title><link type='text/css' rel='Stylesheet' href='general.css' /><script src='profilAjax.js'></script></head>");
		out.print("<body>");
		out.print("<table class='heading' width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td width='1' style='background-image:url(gradient.png); background-repeat: repeat-x'><a href='Home'><img src='JitterlogoF.png' border='0' alt='Jitterlogo' height='50' width='50' /></a></td><td width='100%' style='background-image:url(gradient.png); background-repeat: repeat-x; text-align:left'><h1 align='left'>&nbsp Jitter </h1></td></tr></table>");
		out.print("<a class='profil' href='Profil?usr=" +  userName + "'> <h4>" + userName + "</h4></a>");
		out.print("<form  action='Search' method='post'><input id='myInput' name='search' type='text'><input class='searchB' type='submit' value=''></form>");
		out.print("<br><br><br><br><div align='center'>");
		out.print("<p><span id='usr'>"+ usr +"</span>");
		Document myDoc = followers.find(eq("userName", usr)).first();
		if (!usr.equals(userName)){
			if(myDoc==null)
				out.print(" &nbsp <button onclick='loadXMLDoc(\"follow\")'>Follow</button></p>");
			else 
				out.print(" &nbsp <button onclick='loadXMLDoc(\"unfollow\")'>Unfollow</button></p>");
		}
		MongoCollection<Document> Jits = db.getCollection(usr+"Jits");
		MongoCursor<Document> cursor0 = Jits.find().sort(new BasicDBObject("_id",-1)).iterator();
		out.print("<div class='form-all'>");
		out.print("<br><ul class='form-section'>");
		try {
		    while (cursor0.hasNext()) {
		    	Document doc = cursor0.next();
				out.print("<li class='form-line'>");
				out.print("<label class='form-label-left' >");
		    	out.print("<a href='Profil?usr=" + usr + "'>" + usr +"</a>");
		    	out.print("</label>");
		    	out.print("<label class='form-label '>");
		        out.print(doc.getString("Jit"));
		        out.print("</label>");
		        out.print("<label class='form-label-right'>");
		        out.print(TimeFormat.format(dateFormat.parse(doc.getString("timeStamp"))));
		        out.print("</label>");
		        out.print("</li>");
		    }
			out.println("</ul>");
			out.print("</div>");
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
		    cursor0.close();
		}
		out.print("</div></body></html>");
		out.close();	
		mongoClient.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub.
        HttpSession session = request.getSession(false);
		String userName = (String)session.getAttribute(  "Username" );
		String usr =  request.getParameter( "usr" );
		String fol = request.getParameter("fol");
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("Jitter");
		MongoCollection<Document> followers = db.getCollection(userName);
		Document follower = new Document("userName",usr);
		if (fol.equals("follow"))
			followers.insertOne(follower);
		else
			followers.deleteOne(follower);
		mongoClient.close();
	}

}
