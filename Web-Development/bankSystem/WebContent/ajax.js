/**
 * 
 */

function loadXMLDoc(){
	if (window.XMLHttpRequest)
  		xmlhttp=new XMLHttpRequest();
	else if (window.ActiveXObject)// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	else {
		alert("Your browser does not support AJAX.");
		return;
	}
	xmlhttp.onreadystatechange=setWarning;
	xmlhttp.open("GET","http://localhost:8080/bankSystem/confirm?commit=true",true); 
	xmlhttp.send();   //in the case of post:  xmlhttp.send(string_to_be_sent_as_body_of_POST)
}

function setWarning(){ // actions that we do when ajax call returns
	if (xmlhttp.readyState==4 && xmlhttp.status==200){
		location.reload(true);		
	}
}
