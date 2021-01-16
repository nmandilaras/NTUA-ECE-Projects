<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
      <%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %> 
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home page</title>
<link type='text/css' rel='Stylesheet' href='pages/general.css' />
<script src='pages/ajax.js'></script>
</head>
<body>
	<table class='heading' width='100%' border='0' cellpadding='0' cellspacing='0'><tr><td width='1' style='background-image:url(pages/gradient.png); background-repeat: repeat-x'><a href='/JitterN/Home'><img src='pages/JitterlogoF.png' border='0' alt='Jitterlogo' height='50' width='50' /></a></td><td width='100%' style='background-image:url(pages/gradient.png); background-repeat: repeat-x; text-align:left'><h1 align='left'>&nbsp Jitter </h1></td></tr></table>
 	<br><br><br><div align='center'>
 	<!-- <a class='profil' href='/JitterN/Profil?usr=${userName }'> <h4> ${userName} </h4></a>--> <!-- na ginei post -->
 	<form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${userName}'><h4><input class='profil' type='submit' value='${userName}'></h4></form>	
 	<form  action='/JitterN/Search' method='post'><input id='myInput' name='search' type='text'><input class='searchB' type='submit' value=''></form>
 	<div class='container' ><br><textarea id='jit' class='form-textarea' onchange='' name='' maxlength='140' cols='50' rows='3' ></textarea><br>
 	<button onclick='loadXMLDoc()'>Jit</button></div>
 	<form  action='/JitterN/Logout' method='get'><button class='logB' type='submit'>Log out</button></form>
 	<div class='form-all'>
 		<br><ul id='unList' class='form-section'>
 		 	<c:set value="0" var="x"></c:set>
 		 	<c:forEach var="result" items="${results}">
 		 		<li class='form-line' onclick=''><label class='form-label-left' >
 					<form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${result.userName}'><input class='nobutton' type='submit' value='${result.userName}'></form>
 					<!-- <form action='/JitterN/Njit' method='post'><input name='jit' type='hidden' value='${result.text}'><input name='reJit' type='hidden' value='${result.userName}'><input name='reId' type='hidden' value='${result.id}'><input class='nobutton' type='submit' value='Retweet'></form> -->
					<input id='jitText${x}' type='hidden' value="${result.text}"><input id='reJit${x}' type='hidden' value='${result.userName}'><input id='reId${x}' type='hidden' value='${result.id}'><button onclick='loadXMLDoc(true,${x})'>Retweet</button> ${fn:length(result.retweets)}
					<button class="btn btn-default" onclick='resize(this,${x})'>Reply</button> ${fn:length(result.replies)}
				</label>
				<label class='form-label '>
					${result.text}
				</label>
				<label class='form-label-right'>
					${result.date}
				</label></li>
				<c:set value="${x+1}" var="x"></c:set>
			</c:forEach>
 		</ul>
 	</div><div align='center' id="jolly" visible="false" style="position:fixed" onclick=""></div>
 	</div>
</body>
</html>