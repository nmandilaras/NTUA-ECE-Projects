 #pragma strict
 var screamSound : AudioClip;                    //in the projector assign the Screaming audio file
 
 function Start ()
 {
     GetComponent.<AudioSource>().clip = screamSound;                    //Assign the screamSound to the Scene object
     GetComponent.<AudioSource>().Play ();                                //Play the assigned audio file
     yield WaitForSeconds (GetComponent.<AudioSource>().clip.length);      //It will play the whole audio file then next thing.
     Application.LoadLevel ("Lose Screen");        //Reloads the "Main" Scene when the sound is done playing
 }