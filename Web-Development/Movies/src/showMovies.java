

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
 * Servlet implementation class showMovies
 */
public class showMovies extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public showMovies() {
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
		HttpSession session = request.getSession(false);	
		String username = (String)session.getAttribute("Username");
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
			rs = st.executeQuery("select m.title,avg(r.rate) from movies m inner join rates r on m.id = r.movieID  group by m.title;");
			while(rs.next()){
				out.println("Movie: "+rs.getString("title")+"<br>");
				//out.println("Name: "+rs.getString("name")+"<br>");
				if (rs.getString("avg(r.rate)") != null) {
					out.println("Rate: "+rs.getString("avg(r.rate)")+"<br>");
					out.println("<br>");
				}
				else {
					out.println("Grade:  ");
					out.println("<a href=\"Addser?name=" + rs.getString("name")+ "\">Add Grade</a><br><br>");
				}

			}
			out.println("<form action=\"rate.jsp\" method=\"post\">");
			out.println("<input type=\"submit\" value=\"Rate a movie\"></input></form>");
			out.println("</body></html>");
			out.close();
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		out.close();
	}

}
