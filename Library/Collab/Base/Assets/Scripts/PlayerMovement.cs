using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class PlayerMovement : MonoBehaviour {

    public float speed;
    private Vector3 direction;

    bool isDead = false;

    public Button restartButton;
    public Rigidbody rb;

    RaycastHit hit;
    Ray ray;

    UvScroller uv;

    int layerMask;

    bool gameStarted = false;

    public Image MainMenu;

    public AnimationCurve curve;

    SceneFader sceneFader;

    void Start ()
    {

        rb = GetComponent<Rigidbody>();
        sceneFader = GetComponent<SceneFader>();
        uv = GetComponentInChildren<UvScroller>();
        layerMask = ~LayerMask.GetMask("Ignore Raycast");
        InvokeRepeating("Blink",2.0f,1.5f);
        rb.useGravity = false;

        //sceneFader.FadeTo();
    }
	

	void Update ()
    {
        if(Input.GetMouseButtonDown(0) && !gameStarted)
        {
            StartCoroutine(fadeOut());

        }

	    if(Input.GetMouseButtonDown(0) && !isDead && gameStarted)
        {
            if(direction == Vector3.forward)
            {
                direction = Vector3.left;
            }
            else
            {
                direction = Vector3.forward;
            }
        }

        float amountToMove = speed * 1000* Time.deltaTime;

        //transform.Translate(direction*amountToMove);
        rb.AddForce(direction * amountToMove);

        RayCast();
	}

    private void OnTriggerEnter(Collider other)
    {
        if(other.name == "Collectible")
        {
            other.gameObject.SetActive(false);
        }
    }

    void RayCast()
    {
        if(Physics.Raycast(transform.position,-Vector3.up,out hit,100f,layerMask))
        {
            isDead = false;
        }
        else
        {
            isDead = true;
            uv.index = 2;
            sceneFader.Fade();
            StartCoroutine(deathScene());
        }
    }

    IEnumerator deathScene()
    {

        yield return new WaitForSeconds(1f);
        SceneManager.LoadScene("Trial_02");

        /*yield return new WaitForSeconds(1);
        gameObject.SetActive(false);
        restartButton.gameObject.SetActive(true);*/
    }

    IEnumerator normalExp()
    {
        yield return new WaitForSeconds(0.5f);
        uv.index = 0;
    }

    void Blink()
    {
        int random = Random.Range(0, 2);

        if (random == 1 && !isDead)
        {
            if (uv.index != 1)
            {
                uv.index = 3;
                StartCoroutine(normalExp());
            }
        }
    }

    IEnumerator fadeOut()
    {
        float t = 1f;
        while (t > 0)
        {
            t -= Time.deltaTime;
            float a = curve.Evaluate(t);

            MainMenu.color = new Color(0f, 0f, 0f, a);

            yield return 0;
        }


        gameStarted = true;
        rb.useGravity = true;
    }
}
