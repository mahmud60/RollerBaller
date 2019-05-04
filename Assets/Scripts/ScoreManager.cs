using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScoreManager : MonoBehaviour {

    public int score = 0;

    public Text scoreText;

    PlayerMovement player;

    bool increaseSpeed = true;

    private void Start()
    {
        player = GetComponent<PlayerMovement>();
    }

    private void Update()
    {
        if(score%10==0 && score!=0 && increaseSpeed)
        {
            player.speed += 5*Time.deltaTime;
            increaseSpeed = false;
        }

        else
        {
            increaseSpeed = true;
        }
        scoreText.text = score.ToString();
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag=="Tile")
        {
            score++;
        }
    }
}
