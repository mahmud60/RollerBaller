using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerFollower : MonoBehaviour {

	// Use this for initialization
    public Transform player;
    public float yOffset;

	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        transform.position = player.position + new Vector3 (0, yOffset, 0);
		
	}
}
