using UnityEngine;

public class MoveAround : MonoBehaviour {

	float speed = 25f;

	void Update(){
		Vector2 input = new Vector2 (Input.GetAxisRaw ("Horizontal"), Input.GetAxisRaw ("Vertical"));
		input = input.normalized;
		transform.Translate (input * Time.deltaTime * speed, Space.World);
	}

}
