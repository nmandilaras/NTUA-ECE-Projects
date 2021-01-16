

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
 * Servlet implementation class Voting
 */
public class Voting extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Voting() {
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
		
		PrintWriter out;
		out = response.getWriter();
		boolean started=false;
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
		
		out.println("<html><head><title>Current Voting Results</title></head>");
		out.println("<body> <h1>Voting</h1><br>");
		try {
			while(rs.next()){	
				out.println("Poll: <b> "+rs.getString("text")+"</b><br>");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		out.println("<h3>Results so far!</h3>");
		try {
			rs = st.executeQuery("SELECT voted,COUNT(voted) FROM voters GROUP BY voted;");		
			while(rs.next()){
				if( rs.getString("voted")!= null){
				out.println(rs.getString("voted")+": ");
				out.println(rs.getString("COUNT(voted)") + "&nbsp");
				started = true;
				}
			}
			if (!started)  out.println("No results so far!");
		}  catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		out.println("<h3>Vote now!</h3>");
		out.println("<form action=\"Vote\" method=\"post\">");		
		out.println("Fill in your userId: <input type=\"text\" name=\"userId\"></input>");
		out.println("<input type=\"submit\" value=\"Search\"></input></form>");
		out.println("</body></html>");
		out.close();
	}		


}
