<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
      <%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %> 
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home page</title>
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
	
	<div align='center'>
 	<div class='container' ><br><textarea id='jit' class='form-textarea' onchange='' name='' maxlength='140' cols='50' rows='3' ></textarea><br>
 	<button onclick='loadXMLDoc()'>Jit</button></div>
 	<div class='form-all'>
 		<br><ul id='unList' class='form-section'>
 		 	<c:set value="0" var="x"></c:set>
 		 	<c:forEach var="result" items="${results}">
 		 		<li class='form-line' onclick=''><label class='form-label-left' >
 					<form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='${result.userName}'><input class='nobutton' type='submit' value='${result.userName}'></form>
 					<!-- <form action='/JitterN/Njit' method='post'><input name='jit' type='hidden' value='${result.text}'><input name='reJit' type='hidden' value='${result.userName}'><input name='reId' type='hidden' value='${result.id}'><input class='nobutton' type='submit' value='Retweet'></form> -->
					<input id='jitText${x}' type='hidden' value="${result.text}"><input id='reJit${x}' type='hidden' value='${result.userName}'><input id='reId${x}' type='hidden' value='${result.id}'><button onclick='loadXMLDoc(true,${x})'>Retweet</button> ${fn:length(result.retweets)}
					<button class="btn btn-default" onclick='resize(this,${x})'>Reply <span class="badge">${fn:length(result.replies)}</span></button>
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