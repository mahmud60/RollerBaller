using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectiblesMovement : MonoBehaviour {
    public float spinSpeed;
    private float time;

    // Use this for initialization
    void Start ()
    {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        
        time += Time.deltaTime;

        transform.Rotate (new Vector3(spinSpeed * 2f , spinSpeed * 1f, spinSpeed * 0.5f) * Time.deltaTime);
        transform.position =  (new Vector3 (transform.position.x, transform.position.y + 0.005f*(Mathf.Sin(time *3f)), transform.position.z));
    }
}

