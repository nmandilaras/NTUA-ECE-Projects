using UnityEngine;
using System.Collections;
//This line should always be present at the top of scripts which use pathfinding
using Pathfinding;
public class AstarAI : MonoBehaviour {
	//The point to move to
	public Vector3 targetPosition;
	
	private Seeker seeker;
	private CharacterController controller;
	
	//The calculated path
	public Path path;
	
	//The AI's speed per second
	public float speed = 100;
	
	//The max distance from the AI to a waypoint for it to continue to the next waypoint
	public float nextWaypointDistance = 3;
	
	//The waypoint we are currently moving towards
	private int currentWaypoint = 0;
	
	public float repathRate = 0.5f;
	private float lastRepath = -9999;
	static var hlp : AstarAI ;
	hlp = objectToMove.GetComponent("AstarAI");
	hlp.targetPosition = enemy.transform.position ;

	public void Start () {
		seeker = GetComponent<Seeker>();
		controller = GetComponent<CharacterController>();
		
		//Start a new path to the targetPosition, return the result to the OnPathComplete function
		//seeker.StartPath (transform.position,targetPosition, OnPathComplete);
	}
	
	public void OnPathComplete (Path p) {
		p.Claim (this);
		if (!p.error) {
			if (path != null) path.Release (this);
			path = p;
			//Reset the waypoint counter
			currentWaypoint = 0;
		} else {
			p.Release (this);
			Debug.Log ("Oh noes, the target was not reachable: "+p.errorLog);
		}
		
		//seeker.StartPath (transform.position,targetPosition, OnPathComplete);
	}
	
	public void Update () {
		if (Time.time - lastRepath > repathRate && seeker.IsDone()) {
			lastRepath = Time.time+ Random.value*repathRate*0.5f;
			seeker.StartPath (transform.position,targetPosition, OnPathComplete);
		}
		
		if (path == null) {
			//We have no path to move after yet
			return;
		}
		
		if (currentWaypoint > path.vectorPath.Count) return; 
		if (currentWaypoint == path.vectorPath.Count) {
			Debug.Log ("End Of Path Reached");
			currentWaypoint++;
			return;
		}
		
		//Direction to the next waypoint
		Vector3 dir = (path.vectorPath[currentWaypoint]-transform.position).normalized;
		dir *= speed;// * Time.deltaTime;
		//transform.Translate (dir);
		controller.SimpleMove (dir);
		
		//if (Vector3.Distance (transform.position,path.vectorPath[currentWaypoint]) < nextWaypointDistance) {
		if ( (transform.position-path.vectorPath[currentWaypoint]).sqrMagnitude < nextWaypointDistance*nextWaypointDistance) {
			currentWaypoint++;
			return;
		}
	}
} 