using UnityEngine;

public class Sensor : MonoBehaviour {

	Vector4[] hits = new Vector4[20];
	Vector4[] hitColours = new Vector4[20];

	Material mat;

	int index;

	void Start(){
		mat = GetComponent<Renderer>().material;
	}


	void Update(){
		mat.SetInt ("_Impacts_Length", index);
		mat.SetVectorArray ("_Impacts", hits);
		//mat.SetFloat ("_JellyCoeff", jellyCoeff);
		mat.SetVectorArray ("_ImpactsColour", hitColours);
	}


	public void ReceiveHit(Vector3 pos, float radius, Color hitColour){
		Vector3 _transf = transform.InverseTransformPoint (pos);
		Vector4 newHit = new Vector4 (_transf.x, _transf.y, _transf.z, radius);
		hits[index] = newHit;

		Vector4 newColour = new Vector4 (hitColour.r, hitColour.g, hitColour.b, hitColour.a);
		hitColours [index] = newColour;
		index++;
	}
}
