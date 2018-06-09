#pragma strict
var speed : float;
private var score1 : int;
private var score2 : int;
public var scoreText1 : GUIText;
public var scoreText2 : GUIText;
 var peponi =19;
function Start(){
	score1 = 0;
	score2 = 0;
	SetCountText();
}
function OnCollisionEnter(other : Collision){

//	if ((other.gameObject.tag == 'Sphere red') ||  (other.gameObject.tag == 'Sphere green')){

if (other.gameObject.tag == "Capsule"){
		other.gameObject.SetActive(false);
		score1 ++;
		SetCountText();
	}
else if (other.gameObject.tag == 'Sphere'){
		other.gameObject.SetActive(false);
		score2 ++;
		SetCountText();
	}
}
var ray: Ray;
var hit: RaycastHit;
var gridSpacing = 2.0; 
var target: GameObject;
var newHero : GameObject;
var objectToMove : GameObject;
var nextNameNumber = 0;
var enemy : GameObject;

function SetCountText(){
	scoreText1.text = 'Score1: ' + score1.ToString();
	scoreText2.text = 'Score2: ' + score2.ToString();
	if ((score1 >= 10) && (score2 >= 10))
	
		{if (gameObject.tag == "tower")
		objectToMove=gameObject;
		  MoveObject (objectToMove.transform, objectToMove.transform.position, Vector3(1500, 15000, 15000), 1);
          }
}
function MoveObject (thisTransform : Transform, startPos : Vector3, endPos : Vector3, time : float) {
var i = 0.0;
var rate = 1.0/time;
while (i < 1.0) {
i += Time.deltaTime * rate;

thisTransform.position = Vector3.Lerp(startPos, endPos, i);
yield;
}
}