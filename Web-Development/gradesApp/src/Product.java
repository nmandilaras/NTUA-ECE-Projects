

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
 * Servlet implementation class Product
 */
public class Product extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Product() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out;
		out = response.getWriter();
		Connection con = null;
		Statement st = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/eksetasi","root","");
			st = con.createStatement();
			rs = st.executeQuery("SELECT * FROM students");
			out.println("<html><head><title>Grades</title></head>");
			out.println("<body> <h1>Results</h1><br>");
			while(rs.next()){
				out.println("ID: "+rs.getString("id")+"<br>");
				out.println("Name: "+rs.getString("name")+"<br>");
				if (rs.getString("grade") != null) {
					out.println("Grade: "+rs.getString("grade")+"<br>");
					out.println("<br>");
				}
				else {
					out.println("Grade:  ");
					out.println("<a href=\"Addser?name=" + rs.getString("name")+ "\">Add Grade</a><br><br>");
				}

			}
			out.println("<form action=\"Prics\" method=\"post\">");
			out.println("<input type=\"submit\" value=\"Statistics\"></input></form>");
			out.println("</body></html>");
			out.close();
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
		
}

