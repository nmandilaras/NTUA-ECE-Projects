#pragma strict
var image1 : Texture2D;
var content1 : GUIContent;
var image2 : Texture2D;
var content2 : GUIContent;
var charactersText1 : GUIText;
var characters =0;
static var pause1=0;
public static var whichHero = 4;
 var targetObj: Transform; 
var targetScript: colission2 = targetObj.GetComponent(colission2);
targetScript.peponi+=5;
//var cubeScript : colission2;
function Start () {
 //cubeScript = GameObject.FindGameObjectsWithTag("tower").gameObject.GetComponent(colission2);
 image1 = Resources.Load("Image1");
     content1.image = image1;
 image2 = Resources.Load("Image2");
     content2.image = image2;
     	SetCountText();
}
function OnGUI () {
	if (GUI.Button(Rect(10, 10, 50, 50), content1)){
//	if (GUI.Button (Rect (10,10,120,30), "Hero 1")) {
		whichHero = 1;
		Debug.Log("Hero "+whichHero+" chosen");
	}
	if (GUI.Button(Rect(110, 10, 50, 50), content2)){
	//if (GUI.Button (Rect (160,10,120,30), "Hero 2")) {
			whichHero = 2;
		Debug.Log("Hero "+whichHero+" chosen");
		}
      if (pause1==1) {
	      GUI.Button(Rect(640, 5, 200, 50),"OOoo please don't leave us!!!");
          if (GUI.Button (Rect (750,55,70,50), "Quit!")) Application.Quit();
          else if(GUI.Button (Rect (660,55,90,50), "Ok, I'll stay!"))  pause1=0;
      }
         	if ((score1 >= 10) && (score2 >= 10) && (score3 >= 10)&& (score4 >= 10)&& (score5 >= 10)&& (score6 >= 10)&& (score7 >= 10)&& (score8 >= 10)){
		 //winText.text="You win";
		GUI.Button(Rect(640, 5, 200, 50),"You win!!!");
          if (GUI.Button (Rect (760,55,70,50), "Quit!"))
            Application.Quit();
          else if(GUI.Button (Rect (650,55,110,50), "Let's play again!"))  
             Application.LoadLevel (0); 
     }		
} 
var hero1 : GameObject;
var hero2 : GameObject;
var hero3 : GameObject;
var hero4 : GameObject;
var hero5 : GameObject;
var hero6 : GameObject;
var hero7 : GameObject;
var hero8 : GameObject;
var score1=0;
var score2=0;
var score3=0;
var score4=0;
var score5=0;
var score6=0;
var score7=0;
var score8=0;
//public var winText : GUIText;
var ray: Ray;
var hit: RaycastHit;
var gridSpacing = 2.0; 
var target: GameObject;
var newHero : GameObject;
var objectToMove : GameObject;
var nextNameNumber = 0;
var enemy : GameObject;

function MoveObject (thisTransform : Transform, startPos : Vector3, endPos : Vector3, time : float) {
var i = 0.0;
var rate = 1.0/time;
while (i < 1.0) {
   i += Time.deltaTime * rate;
   thisTransform.position = Vector3.Lerp(startPos, endPos, i);
   yield;
}
}

function FindClosestEnemy (whichObject : GameObject) : GameObject {
	// Find all game objects with tag Tower
	var gos : GameObject[];
	gos = GameObject.FindGameObjectsWithTag("tower"); 
	var closest : GameObject; 
	var distance = Mathf.Infinity; 
	var position = transform.position; 
	// Iterate through them and find the closest one
	for (var go : GameObject in gos)  { 
		var diff = (go.transform.position - whichObject.transform.position);
		var curDistance = diff.sqrMagnitude; 
		if (curDistance < distance) { 
			closest = go; 
			distance = curDistance; 
		} 
	} 
	if (closest==hero5) score1++; 
	else if (closest==hero6)  score3++;
	else	if (closest==hero7)  score5++; 
	else if (closest==hero8)  score7++;
	return closest;	
}

function FindClosestGreenEnemy (whichObject : GameObject) : GameObject {
	var gos : GameObject[];
	gos=[hero5,hero6];
	var closest : GameObject; 
	var distance = Mathf.Infinity; 
	var position = transform.position; 
	for (var go : GameObject in gos)  { 
		var diff = (go.transform.position - whichObject.transform.position);
		var curDistance = diff.sqrMagnitude; 
		if (curDistance < distance) { 
			closest = go; 
			distance = curDistance; 
		} 
	} 
	if (closest==hero5) score2++;
	else if (closest==hero6)  score4++;
	return closest;	
}
function FindClosestRedEnemy (whichObject : GameObject) : GameObject {
	var gos : GameObject[];
	gos=[hero7,hero8];
	var closest : GameObject; 
	var distance = Mathf.Infinity; 
	var position = transform.position; 
	for (var go : GameObject in gos)  { 
		var diff = (go.transform.position - whichObject.transform.position);
		var curDistance = diff.sqrMagnitude; 
		if (curDistance < distance) { 
			closest = go; 
			distance = curDistance; 
		} 
	} 
	if (closest==hero7)  score6++; 
	else if (closest==hero8)  score8++;
	return closest;	
}
//Pass your mouse position to the below function and it will return the nearest grid co-ord to you.
function GetGridPosition (originalPosition : Vector3) {
	var newx = (Mathf.Round(originalPosition.x / 2) * 2);
	var newz = (Mathf.Round(originalPosition.z / 2) * 2);
	var convertPosition = new Vector3 (newx, (originalPosition.y), newz);
	return convertPosition;
}
function SetCountText(){
charactersText1.text = 'Heroes: ' + characters.ToString();
}
function Update () {
//Debug.Log(targetScript.peponi);
SetCountText();
 ray = Camera.main.ScreenPointToRay(Input.mousePosition);
	 if (Input.GetKey ("escape") && pause1==0) pause1=1;	
if (Input.GetKey ("c")) { 
	     score1 =10; score2 =10; score3 =10;  score4 =10; score5 =10; score6 =10; score7 =10; score8 =10;
	
	  }		
if(Input.GetMouseButtonDown(0)) 	
	{
	if(whichHero==1){
	    if (Physics.Raycast(ray, hit, 100)) {
	    		Debug.Log ("Hit point: " + hit.point + " Grid Position: " + GetGridPosition (hit.point));
	            if (hit.collider.name=="Plane") {newHero = Instantiate(hero1, GetGridPosition (hit.point) + Vector3(0, 1, 0), Quaternion.identity);
	    	characters++;}}
	    newHero.name = "Hero"+nextNameNumber;
		objectToMove = GameObject.Find("Hero"+nextNameNumber);
		//target = GameObject.Find("bottomleft");
		enemy = FindClosestEnemy(objectToMove);
		Debug.Log (enemy.name);
		Debug.Log ("object " + objectToMove.name + " will move to " + enemy.name);
		nextNameNumber++;
        MoveObject (objectToMove.transform, objectToMove.transform.position, enemy.transform.position, 1);
		}	
	else if(whichHero==2){
	    if (Physics.Raycast(ray, hit, 100)) {
	    		Debug.Log ("Hit point: " + hit.point + " Grid Position: " + GetGridPosition (hit.point));
	            if (hit.collider.name=="Plane") {newHero = Instantiate(hero2, GetGridPosition (hit.point) + Vector3(0, 1, 0), Quaternion.identity);
	    	characters++;}}
	    newHero.name = "Hero"+nextNameNumber;
		objectToMove = GameObject.Find("Hero"+nextNameNumber);
		enemy = FindClosestGreenEnemy(objectToMove);
		Debug.Log (enemy.name);
		Debug.Log ("object " + objectToMove.name + " will move to " + enemy.name);
		nextNameNumber++;
		MoveObject (objectToMove.transform, objectToMove.transform.position, enemy.transform.position, 1);
	    	}
	}
	if(Input.GetMouseButtonDown(1)) {
		if(whichHero==1){
	    if (Physics.Raycast(ray, hit, 100)) {
	    		Debug.Log ("Hit point: " + hit.point + " Grid Position: " + GetGridPosition (hit.point));
	            if (hit.collider.name=="Plane"){ newHero = Instantiate(hero3, GetGridPosition (hit.point) + Vector3(0, 1, 0), Quaternion.identity);
	    	characters++;}}
	    newHero.name = "Hero"+nextNameNumber;
		objectToMove = GameObject.Find("Hero"+nextNameNumber);
		enemy = FindClosestEnemy(objectToMove);
		Debug.Log (enemy.name);
		Debug.Log ("object " + objectToMove.name + " will move to " + enemy.name);
		nextNameNumber++;  	
		MoveObject (objectToMove.transform, objectToMove.transform.position, enemy.transform.position, 1);
	}
		else if(whichHero==2){
	    if (Physics.Raycast(ray, hit, 100)) {
	    		Debug.Log ("Hit point: " + hit.point + " Grid Position: " + GetGridPosition (hit.point));
	            if (hit.collider.name=="Plane") {newHero = Instantiate(hero4, GetGridPosition (hit.point) + Vector3(0, 1, 0), Quaternion.identity);
	    	characters++;}}
	    newHero.name = "Hero"+nextNameNumber;
		objectToMove = GameObject.Find("Hero"+nextNameNumber);
		enemy = FindClosestRedEnemy(objectToMove);
		Debug.Log (enemy.name);
		Debug.Log ("object " + objectToMove.name + " will move to " + enemy.name);
		nextNameNumber++;
	    MoveObject (objectToMove.transform, objectToMove.transform.position, enemy.transform.position, 1);
	}    
}	 

}



	
	