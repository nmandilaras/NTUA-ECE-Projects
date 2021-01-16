

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
 * Servlet implementation class Vote
 */
public class Vote extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Vote() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out;
		out = response.getWriter();
		
		Connection con = null;
		Statement st = null;
		
		String userId =  (String) request.getParameter("userId");
		String vote =  (String) request.getParameter("vote");
	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting","root","");
			st = con.createStatement();
			if(vote!= null )st.executeUpdate("update voters set voted='"+ vote +"' where name ='"+ userId +"'  ;");
			response.sendRedirect("Voting");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out;
		out = response.getWriter();
		boolean exist = false;
		Connection con = null;
		Statement st = null;
		ResultSet rs = null;
		
		String userId =  (String) request.getParameter("userId");
		if (userId.equals("admin")) {
			response.sendRedirect("AdminPage");
			return;
		}
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting","root","");
			st = con.createStatement();
			rs = st.executeQuery("select voted from voters where name ='"+ userId +"'  ;");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		out.println("<html><head><title>Vote Page</title></head>");
		out.println("<body> <h2>Your Vote</h2><br>");
		out.println("<form action=\"Vote\" method=\"get\">");
		out.println("Name: <input type=\"text\" name=\"userId\" value=\""+ userId+"\"><br><br>");
		try {	
			while(rs.next()){	
				exist = true;
				if (rs.getString("voted") != null) {
					out.println("Your vote: "+rs.getString("voted")+"<br>");
				}
				else {		
					out.println("<input type=\"radio\" name=\"vote\" value=\"yes\"> Yes <br>");
					out.println("<input type=\"radio\" name=\"vote\" value=\"no\"> No <br>");
					out.println("<input type=\"radio\" name=\"vote\" value=\"blank\" checked> Blank<br><br>");
					out.println("<input type=\"submit\" value=\"Vote\"></form>");
				}				
			}
			if(!exist){
				response.sendRedirect("Voting");
				return;			
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		out.println("</body></html>");
		out.close();
	}

}
