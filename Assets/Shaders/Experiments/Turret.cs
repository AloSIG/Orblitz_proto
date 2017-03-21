using UnityEngine;
using System.Collections.Generic;

public class Turret : MonoBehaviour {

	[SerializeField]
	Projectile projectilePrefab;

	[SerializeField]
	Transform muzzlePos;

	/*
	[SerializeField]
	Color hitColour;
	*/
	List<Projectile> projectiles = new List<Projectile>();
	int index;

	void Start(){

		for (int i = 0; i < 10; i++) {
			Projectile newProj = Instantiate (projectilePrefab);
			projectiles.Add (newProj);
			newProj.gameObject.SetActive (false);
		}
	}


	void Update(){
		if (Input.GetKeyDown (KeyCode.Space)) {
			ShootProjectile ();
		}

		Debug.DrawRay (muzzlePos.position, Vector3.forward * 20, Color.red);
	}

	void ShootProjectile(){
		//Debug.Log (projectiles.Count);
		projectiles [index].gameObject.SetActive (true);
		//projectiles [index].ResetParam (muzzlePos.position, hitColour);
		projectiles [index].ResetParam (muzzlePos.position, projectilePrefab.projectileColour);

		index++;
		if (index >= projectiles.Count) {
			index = 0;
		}
	}

}
