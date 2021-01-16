

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;

/**
 * Servlet implementation class Search
 */
public class Search extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Search() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        request.getSession().invalidate();
        response.sendRedirect("http://localhost:8080/Jitter/");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        HttpSession session = request.getSession(false);
        String userName = (String)session.getAttribute(  "Username" );
		PrintWriter out;
		out = response.getWriter();
		out.println("<!DOCTYPE html><head><title>Search Results</title><link type='text/css' rel='Stylesheet' href='general.css' /></head>");
		out.println("<body>");
		out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td width='1' style='background-image:url(gradient.png); background-repeat: repeat-x'><a href='Home'><img src='JitterlogoF.png' border='0' alt='Jitterlogo' height='50' width='50' /></a></td><td width='100%' style='background-image:url(gradient.png); background-repeat: repeat-x; text-align:left'><h1 align='left'>&nbsp Jitter </h1></td></tr></table>");
		out.print("<a class='profil' href='Profil?usr=" +  userName + "'> <h4>" + userName + "</h4></a>");
		out.print("<form  action='Search' method='post'><input id='myInput' name='search' type='text'><input class='searchB' type='submit' value=''></form>");
		out.println("<div style='margin-left:10px;'><h2>Results</h2><br>");	
		out.println("<table border=0>");
		out.println("<td>Persons</td>");
		String search=request.getParameter("search");
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("Jitter");
		MongoCollection<Document> users = db.getCollection("users");
		MongoCursor<Document> cursor = users.find(Filters.regex("userName", search)).iterator();
		try {
		    while (cursor.hasNext()) {
		    	Document doc = cursor.next();
		    	out.println("<tr>");
		    	out.println("<td><a href='Profil?usr=" + doc.getString("userName")+"'>"+ doc.getString("userName") +"</a></td>");
		    	//out.println("<td>" <button>Follow</button> "</td>");
		        out.println("</tr>");
		    }
		} finally {
		    cursor.close();
		}	
		out.println("</table></div></body></html>");
		out.close();
		mongoClient.close();
	}

}
