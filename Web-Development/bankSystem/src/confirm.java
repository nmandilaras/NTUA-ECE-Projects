

import static com.mongodb.client.model.Filters.eq;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

/**
 * Servlet implementation class confirm
 */
public class confirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public confirm() {
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
		out = response.getWriter();
		String commit = "";
		commit =  request.getParameter( "commit" );
		out.println("<html><head><title>Transcactions</title><script src='ajax.js'></script> </head>");
		out.println("<body> <div align=\"center\"><h1>Transcactions</h1><br>");	
		out.println("<table border=0>");
		out.println("<th><td>Source</td><td>Target</td><td>Amount</td></th>");
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("bank");
		MongoCollection<Document> temp = db.getCollection("temp");
		MongoCollection<Document> conf = db.getCollection("confirmed");
		if(commit!=null){
			MongoCursor<Document> cursor0 = temp.find().iterator();
		    while (cursor0.hasNext()) {
		    	Document doc = cursor0.next();
		    	conf.insertOne(doc);
		    	temp.deleteOne(doc);
		    }
		}
		MongoCursor<Document> cursor = conf.find().iterator();
		try {
		    while (cursor.hasNext()) {
		    	Document doc = cursor.next();
		    	out.println("<tr><th></th>");
		    	out.println("<td>" + doc.getString("source")+"</td>");
		        out.println("<td>" + doc.getString("target") + "</td>");
		        out.println("<td>" + Double.toString(doc.getDouble("amount")) + "</td>");
		        out.println("</tr>");
		    }
		} finally {
		    cursor.close();
		}
		out.println("</table>");
		out.println("<h2>Unconfirmed Transcactions</h2>");
		out.println("<table border=0>");
		out.println("<th><td>Source</td><td>Target</td><td>Amount</td></th>");
		MongoCursor<Document> res = temp.find().iterator();
		try {
		    while (res.hasNext()) {
		    	Document doc = res.next();
		    	out.println("<tr><th></th>");
		    	out.println("<td>" + doc.getString("source")+"</td>");
		        out.println("<td>" + doc.getString("target") + "</td>");
		        out.println("<td>" + Double.toString(doc.getDouble("amount")) + "</td>");
		        out.println("</tr>");
		        out.println("<tr><td colspan='4' align='center'><button onclick='loadXMLDoc()'>Submit</button></td></tr>");
		    }
		} finally {
		    cursor.close();
		}		
		out.println("</table></div></body></html>");
		out.close();		
	}

}
