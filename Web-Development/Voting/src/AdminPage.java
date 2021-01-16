

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

/**
 * Servlet implementation class AdminPage
 */
public class AdminPage extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminPage() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out;
		out = response.getWriter();
		Connection con = null;
		Statement st = null;
		ResultSet rs = null;		
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting","root","");
			st = con.createStatement();
			rs = st.executeQuery("select text from polls where id = 1 ;");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
				
		out.println("<html><head><title>Administration Page</title></head>");
		out.println("<body> <h1>Administration Page</h1><br>");
		out.println("<form action=\"AdminPage\" method=\"post\">");
		try {
			while(rs.next())
				out.println("<textarea name=\"question\" cols=\"50\" rows=\"2\"> " + rs.getString("text") + " </textarea><br><br>");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		out.println("<input type=\"submit\" value=\"Change Referendum\"></form>");
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String question =  (String) request.getParameter("question");
		
		Connection con = null;
		Statement st = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting","root","");
			st = con.createStatement();
			st.executeUpdate("update voters set voted=NULL;");
			st.executeUpdate("update polls set text='" + question + "' where id =1;");
			response.sendRedirect("Voting");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}			
	}

}
