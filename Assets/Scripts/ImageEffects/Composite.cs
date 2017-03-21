using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class Composite : MonoBehaviour
{
	[Range (0, .2f)]
	public float Intensity = .5f;

	public Material _displacementMat;
	public Material _depthMat;


	void Update(){
		if (Input.GetKey (KeyCode.Space)) {
			Intensity += .2f * Time.deltaTime;
			Intensity = Mathf.Clamp (Intensity, 0, .2f);
		}
		if (Input.GetKey (KeyCode.B)) {
			Intensity -= .2f * Time.deltaTime;
			Intensity = Mathf.Clamp (Intensity, 0, .2f);
		}
	}


	void OnEnable()
	{
		_displacementMat = new Material(Shader.Find("Alo/Displacement"));
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		_displacementMat.SetFloat("_Magnitude", Intensity);
		Graphics.Blit(src, dst, _displacementMat, 0);
	}
}
