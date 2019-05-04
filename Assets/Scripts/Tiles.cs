using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tiles : MonoBehaviour {

    ObjectGeneration obj;

    private void Start()
    {
        obj = GameObject.FindObjectOfType<ObjectGeneration>();
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.gameObject.tag=="Player")
        {
            obj.GenerateCube();
            StartCoroutine(FallDown());
        }
    }

    IEnumerator FallDown()
    {
        GetComponent<Rigidbody>().isKinematic = false;

        yield return new WaitForSeconds(1f);

        GetComponent<Rigidbody>().isKinematic = true;

        gameObject.SetActive(false);

    }
}
