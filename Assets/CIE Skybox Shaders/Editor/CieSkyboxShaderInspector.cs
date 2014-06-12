using UnityEngine;
using UnityEditor;

public class CieSkyboxShaderInspector : MaterialEditor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update ();

        if (isVisible)
        {
            EditorGUI.BeginChangeCheck();

            ColorProperty(GetMaterialProperty(targets, "_SkyColor"), "Color at Zenith");

            var az = GetMaterialProperty (targets, "_SunAzimuth");
            var al = GetMaterialProperty (targets, "_SunAltitude");

            if (az.hasMixedValue || al.hasMixedValue)
            {
                EditorGUILayout.HelpBox ("Editing angles is disabled because they have mixed values.", MessageType.Warning);
            }
            else
            {
                RangeProperty (az, "Azimuth of Sun");
                RangeProperty (al, "Altitude of Sun");
                EditorGUILayout.HelpBox ("Azimuth: " + az.floatValue + ", Altitude: " + al.floatValue, MessageType.None);
            }

            if (EditorGUI.EndChangeCheck ())
            {
                var raz = az.floatValue * Mathf.Deg2Rad;
                var ral = al.floatValue * Mathf.Deg2Rad;
                
                var dir = new Vector4 (
                    Mathf.Cos (ral) * Mathf.Sin (raz),
                    Mathf.Sin (ral),
                    Mathf.Cos (ral) * Mathf.Cos (raz),
                    0.0f
                );
                GetMaterialProperty (targets, "_SunVector").vectorValue = dir;

                PropertiesChanged ();
            }
        }
    }
}
