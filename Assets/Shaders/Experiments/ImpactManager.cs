using UnityEngine;
using System.Collections.Generic;

//[ExecuteInEditMode]
public class ImpactManager : MonoBehaviour {

	[SerializeField][Range(0,30)]
	float jellyCoeff;

	Vector4[] hits = new Vector4[20];
	Vector4[] hitColours = new Vector4[20];

	Material mat;

	int index;

	[SerializeField]
	GameObject sensorVision;

	void Start(){
		mat = sensorVision.GetComponent<Renderer>().material;
	}

	void Update(){

		mat.SetInt ("_Impacts_Length", index);
		mat.SetVectorArray ("_Impacts", hits);
		mat.SetFloat ("_JellyCoeff", jellyCoeff);
		mat.SetVectorArray ("_ImpactsColour", hitColours);


		//jellyCoeff = Mathf.Lerp (jellyCoeff, 0, 0.003f);
	}


	public void GetHit(Vector3 pos, float radius, Color hitColour){
		Vector3 _transf = transform.InverseTransformPoint (pos);
		//Debug.Log (_transf);
		Vector4 newHit = new Vector4 (_transf.x, _transf.y, _transf.z, radius);
		hits[index] = newHit;

		//alpha controls depth effect (0 = disabled, 1 = enabled)
		Vector4 newColour = new Vector4 (hitColour.r, hitColour.g, hitColour.b, hitColour.a);
		hitColours [index] = newColour;
		index++;
	}

	public void GetHit(Vector2 pos, float radius, Color hitColour){

		//Vector3 _transf = transform.InverseTransformPoint (pos);
		//Debug.Log (_transf);
		Vector4 newHit = new Vector4 (pos.x, pos.y, 0, radius);
		hits[index] = newHit;

		//alpha controls depth effect (0 = disabled, 1 = enabled)
		Vector4 newColour = new Vector4 (hitColour.r, hitColour.g, hitColour.b, hitColour.a);
		hitColours [index] = newColour;
		index++;
	}

	/*
	void OnDrawGizmos(){
		Gizmos.color = Color.green;

		Gizmos.DrawSphere (tempVec, 0.1f);

		Gizmos.color = Color.blue;
		if (hits [0] != null) {
			Vector3 temp = new Vector3 (hits [0].x, hits [0].y, hits [0].z);
			temp = 
			Gizmos.DrawWireSphere (new Vector3 (hits [0].x, hits [0].y, hits [0].z), 0.2f);
		}

	}
	*/

}
