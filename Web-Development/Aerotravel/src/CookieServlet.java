// Setting and Retrieving Cookies
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class CookieServlet extends HttpServlet {

   public void doPost( HttpServletRequest request,                  // reaction to the reception of POST
                       HttpServletResponse response )   throws ServletException, IOException
   {
	  PrintStream out = new PrintStream(System.out, true, "UTF-8");
      PrintWriter output;
      String fname = request.getParameter( "firstName" );   // choice made will be sent back to client
      Cookie fn = new Cookie( "firstName",  fname );  
      String lname = request.getParameter( "lastName" );   // choice made will be sent back to client
      Cookie ln = new Cookie( "lastName",  lname ); 
      String email = request.getParameter( "emailAddress" );   // choice made will be sent back to client
      Cookie em = new Cookie( "emailAddress",  email ); 
      String pass = request.getParameter( "password" );   // choice made will be sent back to client
      Cookie ps = new Cookie( "password",  pass ); 	  // to be stored there as a cookie
      fn.setMaxAge( 500 );  // seconds until cookie removed
      response.addCookie( fn );  // must preceede getWriter
      ln.setMaxAge( 500 );  // seconds until cookie removed
      response.addCookie( ln );
      em.setMaxAge( 500 );  // seconds until cookie removed
      response.addCookie(em );
      ps.setMaxAge( 500 );  // seconds until cookie removed
      response.addCookie( ps );	  
      response.setContentType( "text/html" );
      output = response.getWriter();  
     
       // send HTML page to client
      output.println( "<HTML><HEAD><TITLE>" );
      output.println( "Hello there!" );
      output.println( "</TITLE>");
	  output.println( "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"> ");
	  output.println( "<meta http-equiv=\"Content-Language\" content=\"el\">");
	  output.println( "<link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\"/>");
	  output.println( "</HEAD><BODY>" );
	  output.println("<p><br><br>Hello Mr. "+ fn.getValue() + " "+ ln.getValue()+".<br><br>Please click the button below to continue with your order.<br><br><br>");
      output.println(" <a href=\"formA.html\"><button type=\"button\">Continue</button></a>");
	  //onclick continue with your order
      output.println( "</BODY></HTML>" );
      output.close ();    // close stream 
   }
   
   public void doGet( HttpServletRequest request,        // reaction to the reception of GET
                      HttpServletResponse response )
                      throws ServletException, IOException
   {
      PrintWriter output;
      Cookie cookies[];
      
      cookies = request.getCookies(); // get client's cookies

      response.setContentType( "text/html" ); 
      output = response.getWriter();

      output.println( "<HTML><HEAD><TITLE>" );
      output.println( "Hello there!" );
      output.println( "</TITLE>");
	  output.println( "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"> ");
	  output.println( "<meta http-equiv=\"Content-Language\" content=\"el\">");
	  output.println( "<link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\"/>");	  
	  output.println( "</HEAD><BODY>" );
	 
      if ( cookies != null ) {                                               // many cookies !! 
       // send HTML page to client

	  output.println("<p><br><br>Nice to see you again Mr. "+ cookies[0].getValue() + " "+ cookies[1].getValue()+".<br><br>Please click the button below to proceed .<br><br><br>");
      output.println(" <a href=\"formA.html\"><button type=\"button\">Proceed to Order</button></a>");
	  //onclick continue with your order
      }
      else {
		 output.println( " <meta http-equiv=\"refresh\" content=\"4;index.html\" />");
         output.println( "<H1>Sorry, no recommendation possible !</H1>" );
         output.println( "You are not registered in our database or " );
         output.println( "the cookies have expired." );
		 output.println( "<br><br><h3>Redirecting you in 3...</h3>" );
      }

      output.println( "</BODY></HTML>" );
      output.close();    // close stream
   }
}
