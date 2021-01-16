/**
 * 
 */
function loadXMLDoc(){
	if (check()) return;
	if (window.XMLHttpRequest)
  		xmlhttp=new XMLHttpRequest();
	else if (window.ActiveXObject)// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	else {
		alert("Your browser does not support AJAX.");
		return;
	}
	xmlhttp.onreadystatechange=setWarning;
	xmlhttp.open("POST","Home?jit=" + document.getElementById('jit').value ,true); 
	xmlhttp.send();   //in the case of post:  xmlhttp.send(string_to_be_sent_as_body_of_POST)
}

function setWarning(){ // actions that we do when ajax call returns
	if (xmlhttp.readyState==4 && xmlhttp.status==200){
		location.reload(true);		
	}
}

function check(){	
	jit = document.getElementById("jit").value;
	if (jit == ""){
		alert("Sorry, your Jit is empty");
		return true;
	}
	return false;
}

function xmlLoadMore(){
	if (window.XMLHttpRequest)
  		xmlhttp=new XMLHttpRequest();
	else if (window.ActiveXObject)// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	else {
		alert("Your browser does not support AJAX.");
		return;
	}
	xmlhttp.onreadystatechange=setMore;
	xmlhttp.open("POST","Home?loadMore=true" ,true); 
	xmlhttp.send();   //in the case of post:  xmlhttp.send(string_to_be_sent_as_body_of_POST)
}

function setMore(){ // actions that we do when ajax call returns
	if (xmlhttp.readyState==4 && xmlhttp.status==200){
		var list = JSON.parse(xmlhttp.responseText);
		if (list == null) return;
		var unList = document.getElementById("unList");
		for (var i = 0; i < list.length; i++){
			 var ListItem = document.createElement("li");
			 ListItem.className="form-line";
			 ListItem.innerHTML = "<label class='form-label-left'><a href='Profil?usr=" + list[i].first + "'>" +  list[i].first + "</a></label><label class='form-label '>" + list[i].second + "</label><label class='form-label-right'>" + list[i].third + "</label>"; 
			console.log(list[i]);
			unList.appendChild(ListItem);
		}
	}
}

document.addEventListener('scroll', function (event) {
    if (document.body.scrollHeight == document.body.scrollTop + window.innerHeight) {
        xmlLoadMore();
    }else if (document.documentElement.scrollHeight == document.documentElement.scrollTop + window.innerHeight) { //for firefox and IE
    	xmlLoadMore();
    }
});