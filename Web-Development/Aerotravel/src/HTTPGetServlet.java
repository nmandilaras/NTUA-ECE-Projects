import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.Random;

public class HTTPGetServlet extends HttpServlet {
	
       public void doGet (HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException
       {
            PrintWriter output;
             response.setContentType ("text/html") ;
             output = response.getWriter() ; 
             StringBuffer buf = new StringBuffer()  ;
             buf.append( "<HTML><HEAD><TITLE>\n") ; // write here line-by-line the html for the desired page
             buf.append( "A simple servlet example\n") ; 
             buf.append( "</TITLE></HEAD><BODY>\n") ; 
             buf.append( "<H1>Welcome to servlets !</H1>\n") ; 
             buf.append( "</BODY></HTML>") ;              // end of desired page
             output.println (buf.toString()) ;
             output.close (); // PrintWriter stream closed->buffer is flashed to client !!!
         }
	
	public void doPost( HttpServletRequest request,HttpServletResponse response ) throws ServletException, IOException
	{
		int cost=39 + (int)(Math.random() * ((180 - 39) + 1));
		PrintWriter output;
		String from=request.getParameter("from");
		String to=request.getParameter("to");
		int passengers=Integer.parseInt(request.getParameter("passengers"));
		String depart=request.getParameter("departure");

		response.setContentType( "text/html" );
		output = response.getWriter();
		output.println( "<HTML><HEAD><TITLE>" );
		output.println( "Confirmation Page" );
		output.println( "</TITLE>" );
	    output.println( "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"> ");
	    output.println( "<meta http-equiv=\"Content-Language\" content=\"el\">");		
	    output.println( "<link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\"/>");
	    output.println( "</HEAD><BODY>" );		
		output.println( "<P>You have chosen  tickets<br> From: "+from+"<br> To: "+to+"<br> For: "+Integer.toString(passengers)+" passenger(s) <br> Departure date: "+depart+".</p>");
		output.println("<p>The total cost of your tickets is :"+ Integer.toString(cost)+" Euro");
		output.println( "<P>" );
		output.println("<p>Please confirm or decline your current booking options</p>");
		output.println("<a href=\"allset.html\"><button type=\"button\">Accept tickets</button></a>");
		output.println("<a href=\"formA.html\"><button type=\"button\">Decline Tickets</button></a>");
		output.println( "</body></html>" );
		output.close (); // close stream
		}
}
		
		
		
		
		
		
		
		
		
		
		
		