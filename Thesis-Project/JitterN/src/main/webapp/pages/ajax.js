/**
 * 
 */
function resize(elem,x){
        if (elem == document.getElementById("jollyX")) 
        {
        	elem = document.getElementById("jolly");
        	elem.firstChild.style.visibility = "hidden";
            elem.style.visibility = "hidden";
        }
        else
        {
            var jolly = document.getElementById("jolly");            
            jolly.innerHTML = "<ul id='' class='form-section'><li class='form-line'>"+  elem.parentNode.parentNode.innerHTML + "<textarea id='reply' class='form-textarea'  maxlength='140' cols='50' rows='1' ></textarea><br><button onclick='reply(" + x.toString() +")'>Reply</button>" + "</li></ul><button id='jollyX'  onclick='resize(this)'>X</button>";
    	 	reply(x);
            jolly.firstChild.style.width = "700px";
            jolly.firstChild.style.backgroundColor = "white";
            jolly.firstChild.style.margin="20px 50px 20px 50px";
			var num = elem.naturalHeight/ elem.naturalWidth * 700 ;
            jolly.firstChild.style.height = num;
            jolly.style.visibility = "visible";
        }	
}

function loadXMLDoc(retweet,x){
	if (window.XMLHttpRequest)
  		xmlhttp=new XMLHttpRequest();
	else if (window.ActiveXObject)// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	else {
		alert("Your browser does not support AJAX.");
		return;
	}
	xmlhttp.onreadystatechange=setWarning;
	if(!retweet){
		if (check()) return;
		link = "/JitterN/Njit?jit=" + encodeURIComponent(document.getElementById('jit').value); 		
	}else{
		link = "/JitterN/Njit?jit=" + encodeURIComponent(document.getElementById('jitText'+ x).value) + "&reJit=" + document.getElementById('reJit'+ x).value + "&reId=" + document.getElementById('reId'+ x).value  ; 
	}
	xmlhttp.open("GET",link ,true); 
	xmlhttp.send();  
}

function setWarning(){ 
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

function reply(x){
	if (window.XMLHttpRequest)
  		xmlhttp=new XMLHttpRequest();
	else if (window.ActiveXObject)// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	else {
		alert("Your browser does not support AJAX.");
		return;
	}
	xmlhttp.onreadystatechange=setReplies;
	xmlhttp.open("GET","/JitterN/Reply?reply=" +  encodeURIComponent(document.getElementById('reply').value) + "&reId=" +  document.getElementById('reId'+ x).value,true); 
	xmlhttp.send();   
}

function setReplies(){ 
	if (xmlhttp.readyState==4 && xmlhttp.status==200){
		var list = JSON.parse(xmlhttp.responseText);
		if (list == null) return;
		console.log("OO boy" + list);
		var jolly = document.getElementById("jolly");
		for (var i = 0; i < list.length; i++){
			jolly.innerHTML += "<label class='form-label-leftR'>"+list[i][0]+" says:</label><label class='form-labelR '>" + list[i][1] + "</label><label class='form-label-rightR'> on " + list[i][2].substring(0, 10) +"</label><br>";
		}
	}
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
	xmlhttp.open("GET","/JitterN/Fetch" ,true); 
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
			 ListItem.innerHTML = "<label class='form-label-left'><form  action='/JitterN/Profil' method='post'><input name='usr' type='hidden' value='" + list[i].userName + "'><input class='nobutton' type='submit' value='" +  list[i].userName + "'></form></label>" +
			 		"<label class='form-label '>" + list[i].text + "</label>" +
			 				"<label class='form-label-right'>" + list[i].date + "</label>"; 
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