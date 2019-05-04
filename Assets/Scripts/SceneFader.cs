using System.Collections;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneFader : MonoBehaviour {

	public Image image;
	public AnimationCurve curve;

	void Start()
	{
        float a = 0;
		StartCoroutine (fadeIn ());
	}

	public void FadeTo()
	{
		//StartCoroutine (fadeOut());
	}

    public void Fade()
    {
        StartCoroutine(fadeOut());
    }

	IEnumerator fadeIn()
	{
		float t = 1f;
		while (t > 0) 
		{
			t-=Time.deltaTime;
			float a = curve.Evaluate (t);

			image.color = new Color (1f,1f,1f,a);

			yield return 0;
		}


    }


	IEnumerator fadeOut()
	{
		float t = 0f;
		while (t <1f) 
		{
			t+=Time.deltaTime;
			float a = curve.Evaluate (t);

			image.color = new Color (1f,1f,1f,a);

			yield return 0;


		}

	}
}
