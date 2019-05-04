using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerFollower_InfPlane : MonoBehaviour

{	
    public Transform player;
    public float yOffset;


	void Update ()

    {
        transform.position = new Vector3 (player.position.x, yOffset, player.position.z);
	}
}
