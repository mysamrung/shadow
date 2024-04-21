using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class RTDepth : MonoBehaviour
{
    public Shader depthOnlyShader;

    public int resolution = 256;

    public void Awake() {  
        Camera cam = GetComponent<Camera>();
        cam.RenderWithShader(depthOnlyShader, null);
    }

}
