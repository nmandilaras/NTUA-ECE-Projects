

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
 * Servlet implementation class Addser
 */
public class Addser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Addser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//doPost(request,response);
		PrintWriter out;
		out = response.getWriter();
		out.println("<html><head><title>Add Grade</title></head>");
		out.println("<body> <h1>Add Grade</h1><br>");		
		out.println("<form action=\"Addser?name=" + request.getParameter("name")+ "\" method=\"post\">");
		out.println("Student's name: <b>"+ request.getParameter("name") +"</b><br>");
		out.println("Grade: <input type=\"text\" name=\"pric\"></input>");
		out.println("<input type=\"submit\" value=\"Add\"></input></form>");
		out.println("</body></html>");
		out.close();		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out;
		String prod =  (String) request.getParameter("name");
		String pric =  (String) request.getParameter("pric");
		out = response.getWriter();
		Connection con = null;
		Statement st = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/eksetasi","root","");
			st = con.createStatement();
			st.executeUpdate("UPDATE students SET grade='"+pric+"' WHERE name ='"+prod+"' ;");
			response.sendRedirect("Product");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
