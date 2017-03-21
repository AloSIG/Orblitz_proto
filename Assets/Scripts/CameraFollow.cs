using UnityEngine;

public class CameraFollow : MonoBehaviour {

	public Transform player;

	Vector3 offset;


	void Start(){
		offset = player.position - transform.position;


	}


	void Update(){
		Vector3 camPos = new Vector3 (player.position.x - offset.x, player.position.y - offset.y, player.position.z - offset.z);
		transform.position = camPos;
	}
}
