

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.google.gson.Gson;
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
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Home
 */
public class Home extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Home() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    public class Triplet<T, U, V> {

        private final T first;
        private final U second;
        private final V third;

        public Triplet(T first, U second, V third) {
            this.first = first;
            this.second = second;
            this.third = third;
        }

        public T getFirst() { return first; }
        public U getSecond() { return second; }
        public V getThird() { return third; }
        public void print() {
        	System.out.println(first + " says: " + second + " at: " + third.toString());
        }
    }
    
    protected ArrayList<Triplet<String,String,Date>> fetchJits(String userName, int z, ArrayList<Triplet<String,String,Date>> list){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Calendar cal = Calendar.getInstance(); // because date constructor is deprecated
		cal.set(Calendar.YEAR, 2017);
		cal.set(Calendar.MONTH, Calendar.AUGUST);
		cal.set(Calendar.DAY_OF_MONTH, 15);
		Date startDate = cal.getTime();
		Date today = new Date();
		Date higherBound = today;
		if (z!=1)
			 higherBound= new Date(today.getYear(), today.getMonth(), today.getDate() - 3*(z-1), today.getHours(), 0, 0);
		Date lowerBound = new Date(today.getYear(), today.getMonth(), today.getDate() - 3*z, today.getHours(), 0, 0);	
		if (higherBound.before(startDate) ) return null;
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		MongoDatabase db = mongoClient.getDatabase("Jitter");
		MongoCollection<Document> followers = db.getCollection(userName);
		MongoCursor<Document> cursor = followers.find().iterator();
		try {
		    while (cursor.hasNext()) {
		    	Document doc = cursor.next();
		    	String usr = doc.getString("userName");
				MongoCollection<Document> Jits = db.getCollection(usr+"Jits");
				//MongoCursor<Document> cursor1 = Jits.find(and(gte("timeStamp",dateFormat.format(lastWeekStart)),lte("timeStamp",dateFormat.format(today)))).sort(new BasicDBObject("_id",-1)).iterator();
				MongoCursor<Document> cursor1 = Jits.find(and(gte("timeStamp",dateFormat.format(lowerBound)),lte("timeStamp",dateFormat.format(higherBound)))).iterator();
			    while (cursor1.hasNext()) {
			    	Document jit = cursor1.next();
			    	list.add(new Triplet(usr,jit.getString("Jit"),dateFormat.parse(jit.getString("timeStamp"))));
			    	//System.out.println(dateFormat.parse(jit.getString("timeStamp")));
			    }		
		    }
		    Collections.sort(list, new Comparator<Triplet<String,String,Date>>() {
		        @Override
		        public int compare(Triplet<String,String,Date> a, Triplet<String,String,Date> b) {
		            // -1 - less than, 1 - greater than, 0 - equal, all inversed for descending
		            if (a.getThird().after(b.getThird()))
		            	return -1;
		            else
		            	return 1;
		        }
		    });
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
		    cursor.close();
		}
		mongoClient.close();
		return list;
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(  "Username" ) == null) {
        	System.out.println(1);
        	String json = "{\"error\":\"ACCESS RESTRICTED\"}";
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        	response.getWriter().write(json);
        	return;
        }
        String userName = (String)session.getAttribute(  "Username" );
        session.setAttribute( "scroll", 1);
		PrintWriter out;
		out = response.getWriter();
		SimpleDateFormat TimeFormat = new SimpleDateFormat("HH:mm dd/MM");
		ArrayList<Triplet<String,String,Date>> list = new ArrayList<>();
		list = fetchJits(userName,1,list);
		out.println("<!DOCTYPE html><html><head><title>Home page</title><link type='text/css' rel='Stylesheet' href='general.css' /><script src='ajax.js'></script> </head>");
		out.println("<body>");
		out.println("<table class='heading' width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td width='1' style='background-image:url(gradient.png); background-repeat: repeat-x'><a href='Home'><img src='JitterlogoF.png' border='0' alt='Jitterlogo' height='50' width='50' /></a></td><td width='100%' style='background-image:url(gradient.png); background-repeat: repeat-x; text-align:left'><h1 align='left'>&nbsp Jitter </h1></td></tr></table>");
		out.print("<br><br><br><div align='center'>");
		out.print("<a class='profil' href='Profil?usr=" +  userName + "'> <h4>" + userName + "</h4></a>");
		out.print("<form  action='Search' method='post'><input id='myInput' name='search' type='text'><input class='searchB' type='submit' value=''></form>");
		out.println("<div class='container' ><br><textarea id='jit' class='form-textarea' onchange='' name='' maxlength='140' cols='50' rows='3' ></textarea><br>");
		out.println("<button onclick='loadXMLDoc()'>Jit</button></div>");
		out.print("<form  action='Search' method='get'><button class='logB' type='submit'>Log out</button></form>");
		out.print("<div class='form-all'>");
		out.print("<br><ul id='unList' class='form-section'>");
		for(Triplet<String,String,Date> s: list){
			out.print("<li class='form-line'>");
			out.print("<label class='form-label-left' >");
			String usr = s.getFirst();
	    	out.print("<a href='Profil?usr=" + usr + "'>" + usr +"</a>");
	    	out.print("</label>");
	    	out.print("<label class='form-label '>");
	        out.print(s.getSecond());
	        out.print("</label>");
	        out.print("<label class='form-label-right'>");
	        out.print(TimeFormat.format(s.getThird()));
	        out.print("</label>");
	        out.print("</li>");
		}
		out.println("</ul>");
		out.print("</div>");
		out.println("</div></body></html>");
		out.close();	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        HttpSession session = request.getSession(false);
		String userName = (String)session.getAttribute(  "Username" );
		String jit =  request.getParameter( "jit" );
		String loadMore =  request.getParameter( "loadMore" );
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
		if(jit != null){
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			Date date = new Date();
			MongoDatabase db = mongoClient.getDatabase("Jitter");
			MongoCollection<Document> jits = db.getCollection(userName+"Jits");
			Document jitEntry = new Document("Jit",jit).append("timeStamp",dateFormat.format(date));
			jits.insertOne(jitEntry);
		}else if(loadMore != null ){
			int z = (Integer)session.getAttribute(  "scroll" );
			ArrayList<Triplet<String,String,Date>> list = new ArrayList<>();
			while(list !=null && list.size() == 0) list = fetchJits(userName,++z,list); 
			session.setAttribute( "scroll", z);
			response.setContentType("application/json");
			new Gson().toJson(list, response.getWriter());
		}
		mongoClient.close();	
	}
}
