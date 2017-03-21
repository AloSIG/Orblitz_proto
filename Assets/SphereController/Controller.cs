using UnityEngine;

public class Controller : MonoBehaviour {

	[SerializeField]
	float maxSpeed;

	[SerializeField]
	AnimationCurve accelerationCurve;
	[SerializeField]
	float accelerationTime;


	float accelerationTimer;

	float currentSpeed;

	float spherePerim;
	float sphereRadius;

	float currentMagnitude;

	void Start(){
		sphereRadius = transform.lossyScale.x * .5f;
		spherePerim = Mathf.PI * transform.lossyScale.x;
	}


	void Update(){

		if (Input.GetKey (KeyCode.UpArrow)) {
			accelerationTimer += Time.deltaTime;

		} else {
			accelerationTimer -= Time.deltaTime * 2f;

		}

		accelerationTimer = Mathf.Clamp (accelerationTimer, 0, accelerationTime);
		float accelerationPercent = accelerationTimer / accelerationTime;
		accelerationPercent = Mathf.Clamp01 (accelerationPercent);
		currentSpeed = accelerationCurve.Evaluate (accelerationPercent) * maxSpeed;




		SphereMove (currentSpeed * Time.deltaTime);


	}

	void SphereMove(float _speed){



		_speed = ProbeForward (ref _speed);

		Vector3 _velocity = Vector3.forward * _speed;
		transform.Translate (_velocity, Space.Self);

		//Vector3 rotVec = transform.right * _velocity.z * 360f / spherePerim;
		//transform.Rotate (rotVec, Space.World);
		//transform.Rotate(transform.right, _velocity.z * 360f / spherePerim,Space.Self);
	}

	float ProbeForward(ref float _speed){
		RaycastHit hit;
		float rayLength = _speed;

		Debug.DrawRay (transform.position, transform.forward * rayLength, Color.blue);
		if (Physics.SphereCast (transform.position, sphereRadius, transform.forward, out hit, rayLength)) {
			//Debug.Break ();
			return hit.distance;
		} else {
			return _speed;
		}



	}

}
