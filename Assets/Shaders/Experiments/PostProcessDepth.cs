using UnityEngine;

[ExecuteInEditMode]
public class PostProcessDepth : MonoBehaviour {

	Camera cam;
	[SerializeField]
	Material depthMat;

	void Start(){

		cam = GetComponent<Camera> ();
		cam.depthTextureMode = DepthTextureMode.Depth;

	}



}
