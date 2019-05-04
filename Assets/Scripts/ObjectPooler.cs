using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPooler : MonoBehaviour {

    public static ObjectPooler current;

    public GameObject pooledObject;
    public int pooledAmount = 20;
    public bool willExpand = true;

    public List<GameObject> pooledObjects;

    GameObject parentObject;

    private void Awake()
    {
        current = this;
    }

    private void Start()
    {
        parentObject = GameObject.FindGameObjectWithTag("ParentTile");
        pooledObjects = new List<GameObject>();
        for(int i=0;i<pooledAmount;i++)
        {
            GameObject obj = (GameObject)Instantiate(pooledObject);
            obj.transform.parent = parentObject.transform;
            obj.SetActive(false);
            pooledObjects.Add(obj);
        }
    }

    public GameObject GetPooledObject()
    {
        for(int i =0; i<pooledObjects.Count;i++)
        {
            if (!pooledObjects[i].activeInHierarchy)
            {
                return pooledObjects[i];
            }
        }

        if(willExpand)
        {
            GameObject obj = (GameObject)Instantiate(pooledObject);
            obj.transform.parent = parentObject.transform;
            pooledObjects.Add(obj);
            return obj;
        }

        return null;
    }
}
