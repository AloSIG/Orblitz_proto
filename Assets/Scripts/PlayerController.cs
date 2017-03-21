using UnityEngine;

[RequireComponent(typeof(PlayerMotor))]
public class PlayerController : MonoBehaviour {

	[SerializeField]
	float speed = 5f;

	PlayerMotor motor;

	[SerializeField]
	float rotationSpeed = 3f;


	void Start(){
		motor = GetComponent<PlayerMotor> ();
	}

	void Update(){

		//float xMov = Input.GetAxisRaw ("Horizontal");
		float zMov = Input.GetAxisRaw ("Vertical");

		Vector3 movForward = transform.forward * zMov;

		Vector3 velocity = (movForward).normalized * speed;



		float yRot = Input.GetAxisRaw ("Horizontal");

		Vector3 _rotation = new Vector3 (0f, yRot, 0f) * rotationSpeed;
		Quaternion _rotQuat = Quaternion.Euler (_rotation);

		motor.Move (velocity, _rotQuat);
	}
}
