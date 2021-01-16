

import java.io.IOException;
import java.io.PrintWriter;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.BasicDBObject;

import org.bson.Document;

import com.mongodb.client.MongoCursor;

import static com.mongodb.client.model.Filters.*;

import com.mongodb.client.model.Projections;
import com.mongodb.client.result.DeleteResult;

import static com.mongodb.client.model.Updates.*;

import com.mongodb.client.result.UpdateResult;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class credentials
 */
public class credentials extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public credentials() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out;
		
		String userName =  request.getParameter( "userName" );
		String password =  request.getParameter( "password" );		
		String info =  request.getParameter( "info" );
		HttpSession session = request.getSession(true);
		System.out.println(info);
		out = response.getWriter();
		try {
	        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
			MongoDatabase db = mongoClient.getDatabase("bank");
			MongoCollection<Document> coll = db.getCollection("users");
			if(info.equals("log")){
				Document myDoc = coll.find(eq("first_name", userName)).first();
				if(myDoc==null)
					out.print("userName");
				else if (myDoc.getInteger("password")!=password.hashCode())
					out.print("password");
				else if(myDoc.getString("admin")!=null){
					session.setAttribute( "Username", userName);
					session.setAttribute( "isAdmin", true);
					out.print("admin");
				}
				else{
					session.setAttribute( "Username", userName);
					out.print("ok");
				}
			}
			else if(info.equals("sign")){
				Document myDoc = coll.find(eq("first_name", userName)).first();
				if(myDoc!=null)
					out.print("userName");
				else{
					MongoCollection<Document> users = db.getCollection("users");
					int hash = password.hashCode();
					Document doc = new Document("first_name",userName).append("password", hash);
					users.insertOne(doc);	
					session.setAttribute( "Username", userName);
					out.print("ok");
				}	
			}

			out.close();
			mongoClient.close();
			}catch(Exception e){
		         System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		  }	
	}

}
