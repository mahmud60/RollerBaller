using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {

    public Transform player;

    public float followDistance;
    public float followHeight;
    public float smoothSpeed;

    void Update()
    {
        //get a vector pointing from camera towards the ball

        Vector3 lookToward = player.position - transform.position;

        //make it stay a fixed distance behind ball
        Vector3 newPos;
        newPos = player.position - lookToward.normalized * followDistance;
        newPos.y = player.position.y + followHeight;

        transform.position += (newPos - transform.position) * Time.deltaTime * smoothSpeed;

        //re- calculate look direction (dont' do this line if you want to lag the look a little
        lookToward = player.position - transform.position;

        //make this camera look at target
        transform.forward = lookToward.normalized;
    }

}
