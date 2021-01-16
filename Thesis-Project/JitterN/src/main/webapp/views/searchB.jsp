<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
      <%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %> 
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search page</title>
<link href="pages/css/bootstrap.min.css" rel="stylesheet">
<link type='text/css' rel='Stylesheet' href='pages/generalB.css' />
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="pages/js/bootstrap.min.js"></script>
<script src='pages/ajax.js'></script>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top">
	  <div class="container">
	    <!-- Brand and toggle get grouped for better mobile display -->
	    <div class="navbar-header">
	      <a class="navbar-left" href="/JitterN/Home">
	        <img alt="Jitter" src="pages/JitterlogoF.png" height='50' width='50' >
	      </a>
	      <a class="navbar-brand" href="#"></a>
	      <a class="navbar-brand color-me" href="#">Jitter</a>
	    </div>
	
	    <!-- Collect the nav links, forms, and other content for toggling -->
	    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">	      
	      <form class="navbar-form navbar-left" role="search"  action='/JitterN/Search' method='post'>
	        <div class="form-group">
	          <input type="text" class="input form-control" placeholder="Search">
	        </div>
	        <button type="submit" class="btn btn-default "><span class="glyphicon glyphicon-search" aria-hidden="true"></span>&nbsp</button>
	      </form>
	      
	      <ul class="nav navbar-nav navbar-right">
	      <form class="navbar-form navbar-left" action='/JitterN/Profil' method='post'>
	      	 <div class="form-group">
	      	 	<input name='usr' type='hidden' value='${userName}'>
	      	 </div>
	      	<button type="submit" class="btn  btn-link color-me">${userName}</button>
	      </form>
	        <li class="dropdown">
	          <a href="#" class="dropdown-toggle color-me" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Menu <span class="caret"></span></a>
	          <ul class="dropdown-menu">
	            <li><a href="#">Action</a></li>
	            <li><a href="#">Another action</a></li>
	            <li><a href="#">Something else here</a></li>
	            <li role="separator" class="divider"></li>
	            <li><a href="/JitterN/Logout">Log out</a></li>
	          </ul>
	        </li>
	      </ul>
	    </div><!-- /.navbar-collapse -->
	  </div><!-- /.container-fluid -->
	</nav>
	
 	<div style='margin-left:10px;'>
 		<h2>Results</h2><br>
 		<table border=0>
 			<td>${title}</td>		
 	<c:forEach var="result" items="${results}">
 				<tr>
 					<td><form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${result.username}'><input class='nobutton' type='submit' value='${result.username}'></form></td>
 					<!--  <td><c:out value="${result.username}"/></td> -->
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