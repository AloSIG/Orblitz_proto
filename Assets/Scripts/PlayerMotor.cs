using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMotor : MonoBehaviour {


	Vector3 velocity;
	Quaternion rotation;

	Rigidbody rb;

	void Start(){
		rb = GetComponent<Rigidbody> ();
	}

	public void Move(Vector3 _velocity, Quaternion _rotation){
		velocity = _velocity;
		rotation = _rotation;

	}

	void FixedUpdate(){
		PerformMovement ();
	}

	void PerformMovement(){
		if (velocity != Vector3.zero) {
			rb.MovePosition (transform.position + velocity * Time.fixedDeltaTime);
			rb.MoveRotation (rotation);
		}
	}

}
