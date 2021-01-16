<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert your rate</title>
</head>
<script>
function check(){
	value = document.getElementById("rate").value;
	if(isNaN(value) || value > 10 || value < 0 || value == "" )
		alert("rate must be a valid integer between zero and ten");
	else 
		document.myform.submit();
}
</script>
<body>
	Hello <%= session.getAttribute("Username") %><br>
	<form name="myform" method="post" action="addRate">
	<table border="0">
	 		
	<tr>
		<td>movie id:</td>
		<td><input id="id" type="text" name="movieid" size="30" /></td>
	</tr>
	<tr>
		<td>rate:</td>
		<td><input id="rate" type="text" name="rate" size="30"/></td>
		<td><span id="total"></span></td>	
	</tr>	
	<tr>
		<td colspan="2" align="center">
		<button type="button" onclick="check()">Submit </button>
		</td>
	</tr>
	</table>
	</form>	
</body>
</html>