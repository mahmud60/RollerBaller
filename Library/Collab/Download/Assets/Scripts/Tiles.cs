using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tiles : MonoBehaviour {

    ObjectGeneration obj;

    private void Start()
    {
        obj = GameManager.FindObjectOfType<ObjectGeneration>();
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag=="Player")
        {
            //TilesManager.Instance.SpawnTile();
            obj.GenerateCube();
            StartCoroutine(FallDown());
        }
    }

    IEnumerator FallDown()
    {
        //yield return new WaitForSeconds(1f);
        GetComponent<Rigidbody>().isKinematic = false;

        yield return new WaitForSeconds(1f);

        GetComponent<Rigidbody>().isKinematic = true;
        //transform.position = new Vector3(transform.position.x, -20f, transform.position.z);
        gameObject.SetActive(false);

        /*if (name == "TopTile")
        {
            TilesManager.Instance.AddTopTile(gameObject);
        }
        else
        {
            TilesManager.Instance.AddLeftTile(gameObject);
        }*/
    }
}
