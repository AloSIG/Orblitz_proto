using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class DisplayPlayer : MonoBehaviour {

	static RenderTexture prePass;


	void OnEnable(){
		prePass = new RenderTexture(Screen.width, Screen.height, 24);

		var camera = GetComponent<Camera> ();

		camera.targetTexture = prePass;
		Shader.SetGlobalTexture ("_PlayerTex", prePass);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst){
		Graphics.Blit (src, dst);
	}
}
