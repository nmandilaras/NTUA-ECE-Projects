

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class addRate
 */
public class addRate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addRate() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out;
		HttpSession session = request.getSession(false);	
		String username = (String)session.getAttribute("Username");
		String movieid =  (String) request.getParameter("movieid");
		String rate =  (String) request.getParameter("rate");
		String userid = null;
		Connection con = null;
		Statement st = null;
		ResultSet rs = null;
		out = response.getWriter();
		out.println("<html><head><title>Rates</title></head>");
		out.println("<body> <h1>Rates</h1><br>");
		out.println("Hello " + username + "!<br><br>" );
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/movies","root","");
			st = con.createStatement();
			rs = st.executeQuery("select id from users where username='" + username +"';");		
			while(rs.next()){
				userid = rs.getString("id");
			}
			st = con.createStatement();
			st.executeUpdate("insert into rates(movieID,usernameID,rate) values("+ movieid +","+ userid +","+ Integer.parseInt(rate) + " );");
			response.sendRedirect("showMovies");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		out.println("</body></html>");
		out.close();
	}

}
