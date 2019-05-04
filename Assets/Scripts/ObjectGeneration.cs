using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectGeneration : MonoBehaviour {

    public GameObject cube;
    float x, z;

    GameObject[] generatedCubes;

    GameObject refCube;
    float time = 0;
    ObjectPooler objPooler;


    public float speed = 2.5f;


    public Transform player;
    public float yLerpSpeed;
    public float yDistance;

    PlayerMovement playerMovement;


    float distance, distancex,distancez;
    float targetZ;

    public float comboLimiter = 17f;
    int random;
    public float xLerp;




    public float duration = 0.5f;



    void Start ()
    {
        objPooler = GameObject.FindObjectOfType<ObjectPooler>();
        //playerMovement = GameObject.FindObjectOfType<PlayerMovement>();
        refCube = cube;
        generatedCubes = GameObject.FindGameObjectsWithTag("Tile");
        x = cube.GetComponent<Collider>().bounds.size.x;
        z = cube.GetComponent<Collider>().bounds.size.z;


        for (int i=0;i<20;i++)
          GenerateCube();
    }

	void Update ()
    {
        time += Time.deltaTime;

        MoveCubes();

        if (time < 0.05f)
        {
            GenerateCube();
        }            
       
    }

    public void GenerateCube()
    {
        random = Random.Range(0, 2);
        GameObject obj = ObjectPooler.current.GetPooledObject();
        if (obj == null)
            return;

        if(random==0)
        {
            obj.transform.position = new Vector3(refCube.transform.position.x, -60f, refCube.transform.position.z + z);
        }
        
        if(random==1)
        {
            obj.transform.position = new Vector3(refCube.transform.position.x - x, -60f, refCube.transform.position.z);
        }

        obj.SetActive(true);
        refCube = obj;

        int spawnCollectible = Random.Range(0, 10);

        if (spawnCollectible == 0)
        {
            refCube.transform.GetChild(2).gameObject.SetActive(true);
        }
    }

    private void MoveCubes()
    {
        for(int i=0;i<objPooler.pooledObjects.Count;i++)
        {
            if (objPooler.pooledObjects[i].activeInHierarchy)
            {
                distance = Vector3.Distance(player.position, new Vector3(objPooler.pooledObjects[i].transform.position.x, -10.5f, objPooler.pooledObjects[i].transform.position.z));

                distancex = objPooler.pooledObjects[i].transform.position.x - player.transform.position.x;
                distancez = objPooler.pooledObjects[i].transform.position.z - player.transform.position.z;
                // Makes the tiles visible

                /*if (distance < yDistance && distance > 5)
                {
                    objPooler.pooledObjects[i].transform.position = new Vector3(objPooler.pooledObjects[i].transform.position.x, Mathf.Lerp(objPooler.pooledObjects[i].transform.position.y, -10.5f, yLerpSpeed * Time.deltaTime), objPooler.pooledObjects[i].transform.position.z);
                }*/

                

                if (distancex > -yDistance || distancez < yDistance)
                {
                    if (player.transform.position.z < objPooler.pooledObjects[i].transform.position.z && player.transform.position.x > objPooler.pooledObjects[i].transform.position.x)
                        objPooler.pooledObjects[i].transform.position = new Vector3(objPooler.pooledObjects[i].transform.position.x, Mathf.Lerp(objPooler.pooledObjects[i].transform.position.y, -10.5f, yLerpSpeed * Time.deltaTime), objPooler.pooledObjects[i].transform.position.z);
                }
            } 
        }
    }
}
