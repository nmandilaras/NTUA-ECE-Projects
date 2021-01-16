

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class Filter
 */
public class Filter implements javax.servlet.Filter {

    /**
     * Default constructor. 
     */
    public Filter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public boolean checkLoc(List<String> places, String path){
		for(String s: places)
			if (path.contains(s))
				return true;
		return false;
	}
	
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        String requestPath = request.getRequestURI();
		/*List<String> places = new ArrayList<String>(); 
		places = Arrays.asList("Home", "Profil", "Search","log.html","sign.html","Credentials");
        if (!checkLoc(places,requestPath) && !requestPath.equals("/Jitter/"))
        	response.sendError(HttpServletResponse.SC_NOT_FOUND);
        	*/
        if ((session == null || session.getAttribute("Username") == null) && !requestPath.endsWith("log.html") && !requestPath.endsWith("Jitter/") && !requestPath.endsWith("sign.html")  && !requestPath.endsWith("Credentials") ) {
        	response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        	//response.sendRedirect("http://localhost:8080/bankSystem/home.html"); // No logged-in user found, so redirect to login page or we should return an error message
        }else
            chain.doFilter(req, res); // Logged-in user found, so just continue request.
	}
	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
