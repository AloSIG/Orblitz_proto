using UnityEngine;

public class Projectile : MonoBehaviour {

	Transform transform0;
	Vector3 velocity;
	float speed = 100f;

	float projRadius;

	[SerializeField]
	float impactRadius = 4f;
	[SerializeField]
	LayerMask mask;

	[SerializeField]
	ParticleSystem hitEffect;

	[SerializeField]
	AudioClip[] sfx;

	bool sensorHit;

	//[SerializeField]
	public Color projectileColour;

	void Start(){
		projRadius = transform.lossyScale.x * .5f;
	}

	void Update(){

		if (sensorHit) {
			Deactivate ();
		} else {

			velocity = Vector3.forward * speed * Time.deltaTime;

			velocity = ProbePath (velocity);

			transform.Translate (velocity, Space.Self);
		}

	}


	public void ResetParam(Vector3 pos, Color hitColour){
		transform.position = pos;
		sensorHit = false;
		projectileColour = hitColour;
	}

	Vector3 ProbePath(Vector3 _velocity){
		RaycastHit hit;
		Vector3 rayOrigin = new Vector3 (transform.position.x, transform.position.y, transform.position.z + projRadius);

		if (Physics.Raycast (rayOrigin, Vector3.forward, out hit, _velocity.z, mask)) {
			sensorHit = true;

			//Vector2 texHit = hit.textureCoord;
			//Debug.Log (texHit);

			//hit.collider.GetComponent<ImpactManager> ().GetHit (hit.textureCoord, impactRadius, projectileColour);
			//Debug.Log(hit.collider.name);
			hit.collider.GetComponent<ImpactManager> ().GetHit (hit.point, impactRadius, projectileColour);
			Quaternion hitNormalRot = Quaternion.LookRotation (hit.normal);
			Destroy(Instantiate (hitEffect, hit.point, hitNormalRot), 1.5f);

			int rand = Random.Range (0, 5);
			AudioSource.PlayClipAtPoint (sfx [rand], hit.point);

			return new Vector3 (_velocity.x, _velocity.y, hit.distance);
		} else {
			return _velocity;
		}
	}

	void Deactivate(){
		gameObject.SetActive (false);
	}



}
