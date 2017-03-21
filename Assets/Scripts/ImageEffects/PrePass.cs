using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PrePass : MonoBehaviour
{
	private static RenderTexture prePass;

	void OnEnable()
	{
		prePass = new RenderTexture(Screen.width, Screen.height, 24);
		//prePass.antiAliasing = QualitySettings.antiAliasing;
		//maskPass = prePass;
		//displaced = new RenderTexture(Screen.width >> 1, Screen.height >> 1, 0);
		var camera = GetComponent<Camera>();
		var replaceShader = Shader.Find("Alo/ReplaceShader");
		camera.targetTexture = prePass;
		camera.SetReplacementShader(replaceShader, "Damageable");
		//Shader.SetGlobalTexture("_GlowPrePassTex", prePass);
		Shader.SetGlobalTexture("_MaskTex", prePass);


		//Shader.SetGlobalTexture("_GlowBlurredTex", displaced);

		//_blurMat = new Material(Shader.Find("Hidden/Blur"));
		//_blurMat.SetVector("_BlurSize", new Vector2(displaced.texelSize.x * 1.5f, displaced.texelSize.y * 1.5f));
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		

		Graphics.Blit(src, dst);

		/*
		Graphics.SetRenderTarget(prePass);
		GL.Clear(false, true, Color.clear);

		Graphics.Blit(src, prePass);
		*/

		/*
		for (int i = 0; i < 4; i++)
		{
			var temp = RenderTexture.GetTemporary(displaced.width, displaced.height);
			Graphics.Blit(displaced, temp, _blurMat, 0);
			Graphics.Blit(temp, displaced, _blurMat, 1);
			RenderTexture.ReleaseTemporary(temp);
		}
		*/

	}
}

