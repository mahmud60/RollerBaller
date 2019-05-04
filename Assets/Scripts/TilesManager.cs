using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TilesManager : MonoBehaviour {

    public GameObject[] tilesPrefab;

    public GameObject CurrentTile;

    public GameObject tileReference;

    Stack<GameObject> topTiles = new Stack<GameObject>();
    Stack<GameObject> leftTiles = new Stack<GameObject>();

    private static TilesManager instance;

    float x, z;

    public static TilesManager Instance
    {
        get
        {
            if (instance == null)
                instance = GameObject.FindObjectOfType<TilesManager>();
            return instance;
        }
    }

    void Start ()
    {
        z = tileReference.GetComponent<Collider>().bounds.size.z;
        x = tileReference.GetComponent<Collider>().bounds.size.x;
        CreateTiles(25);
        for (int i = 0; i < 20; i++)
        {
            SpawnTile();
        }
	}
	
    public void CreateTiles(int amount)
    {
        for(int i = 0; i < amount; i++)
        {
            topTiles.Push(Instantiate(tilesPrefab[0]));
            leftTiles.Push(Instantiate(tilesPrefab[1]));
            topTiles.Peek().SetActive(false);
            leftTiles.Peek().SetActive(false);

            topTiles.Peek().name = "TopTile";
            leftTiles.Peek().name = "LeftTile";
        }
    }

    public void SpawnTile()
    {
        if(leftTiles.Count == 0 || topTiles.Count == 0)
        {
            CreateTiles(10);
        }

        int index = Random.Range(0, 2);

        if(index == 0)
        {
            // top tile
            GameObject temp = topTiles.Pop();
            temp.SetActive(true);
            //temp.transform.position = CurrentTile.transform.GetChild(0).GetChild(index).position;
            temp.transform.position = new Vector3(CurrentTile.transform.position.x, CurrentTile.transform.position.y, CurrentTile.transform.position.z +z);
            CurrentTile = temp;
        }
        else if(index == 1)
        {
            // left tile
            GameObject temp = leftTiles.Pop();
            temp.SetActive(true);
            //temp.transform.position = CurrentTile.transform.GetChild(0).GetChild(index).position;
            temp.transform.position = new Vector3(CurrentTile.transform.position.x-x, CurrentTile.transform.position.y, CurrentTile.transform.position.z);
            CurrentTile = temp;
        }

        int spawnCollectible = Random.Range(0, 10);

        if(spawnCollectible == 0)
        {
            CurrentTile.transform.GetChild(2).gameObject.SetActive(true);
        }
    }

    public void AddTopTile(GameObject obj)
    {
        topTiles.Push(obj);
        topTiles.Peek().SetActive(false);
    }

    public void AddLeftTile(GameObject obj)
    {
        leftTiles.Push(obj);
        leftTiles.Peek().SetActive(false);
    }
}
