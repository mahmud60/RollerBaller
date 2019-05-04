using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectCollectibles : MonoBehaviour {

    ScoreManager scoreManager;

    bool combo = false;

    float pointAnimDurationSec = 2f;
    float pointAnimTimer = 0f;

    int target;

    float lerp = 0f, duration = 2f;

    private void Start()
    {
        scoreManager = GetComponent<ScoreManager>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Collectibles")
        {
            target = scoreManager.score + 5;
            StartCoroutine(CountTo(target));
            GetComponentInChildren<UvScroller>().index = 1;
            StartCoroutine(change());
        }
    }

    IEnumerator change()
    {
        yield return new WaitForSeconds(0.5f);
        GetComponentInChildren<UvScroller>().index = 0;
    }


    IEnumerator CountTo(int target)
    {

        int start = scoreManager.score;
        for (float timer = 0; timer < 0.5f; timer += Time.deltaTime)
        {
            float progress = timer / 0.5f;
            scoreManager.scoreText.color = Color.Lerp(scoreManager.scoreText.color, new Color(1f, 0.4745f, 0f, 1f),progress);
            scoreManager.score = (int)Mathf.Lerp(start, target, progress);
            yield return null;
        }
        scoreManager.score = target;

        yield return new WaitForSeconds(0.25f);
        scoreManager.scoreText.color = Color.white;
    }

}
