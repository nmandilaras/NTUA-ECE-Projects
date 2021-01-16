<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  <%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>  
 <!--  <%@ page import="com.model.User" %> -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Results</title>
<link type='text/css' rel='Stylesheet' href='pages/general.css' />
</head>
<body>
	<table class='heading' width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td width='1' style='background-image:url(pages/gradient.png); background-repeat: repeat-x'><a href='/JitterN/Home'><img src='pages/JitterlogoF.png' border='0' alt='Jitterlogo' height='50' width='50' /></a></td><td width='100%' style='background-image:url(pages/gradient.png); background-repeat: repeat-x; text-align:left'><h1 align='left'>&nbsp Jitter </h1></td></tr></table>
 	<br><br><br><form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${userName}'><h4><input class='profil' type='submit' value='${userName}'></h4></form>
 	<form  action='/JitterN/Search' method='post'><input id='myInput' name='search' type='text'><input class='searchB' type='submit' value=''></form>
 	<form  action='/JitterN/Logout' method='get'><button class='logB' type='submit'>Log out</button></form>
 	<div style='margin-left:10px;'>
 		<h2>Results</h2><br>
 		<table border=0>
 			<td>${title}</td>		
 	<c:forEach var="result" items="${results}">
 				<tr>
 					<td><form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${result.userName}'><input class='nobutton' type='submit' value='${result.userName}'></form></td>
 					<!--  <td><c:out value="${result.userName}"/></td> -->
 				</tr>
			</c:forEach>			
 		</table>
 	 	<div class='form-all'>
 		<br><ul id='unList' class='form-section'>
 		 	<c:forEach var="jit" items="${jits}">
 		 		<li class='form-line'><label class='form-label-left' >
 					<form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${jit.userName}'><input class='nobutton' type='submit' value='${jit.userName}'></form>
				</label>
				<label class='form-label '>
					${jit.text}
				</label>
				<label class='form-label-right'>
					${jit.date}
				</label></li>
			</c:forEach> 		
 		</ul>
 	</div>	
 	</div>
</body>
</html>