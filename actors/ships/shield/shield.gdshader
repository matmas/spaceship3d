shader_type spatial;
render_mode depth_draw_opaque, specular_schlick_ggx, unshaded;
// Port of Unity Ice Shader https://www.youtube.com/watch?v=Gym5JWHgjkk
// by NekotoArts https://godotshaders.com/shader/spatial-ice-shader/

uniform sampler2D screen_texture : hint_screen_texture, filter_linear, repeat_enable;
uniform float fresnel_power = 2.0;
uniform float fresnel_intensity = 1.0;
uniform vec4 main_color : source_color = vec4(1.0);
uniform vec3 fresnel_color : source_color = vec3(1.0);
uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform sampler2D ice_texture : source_color;
uniform float refraction_amount = 1.0;
uniform float metallic = 0.134;
uniform float smoothness = 0.627;
uniform float normals = 0.77;

// Pulled straight from Godot's scene.glsl file
vec3 read_normalmap(in vec3 normalmap, in vec3 normal, in vec3 tangent, in vec3 binormal, in float normaldepth) {
	normalmap.xy = normalmap.xy * 2.0 - 1.0;
	normalmap.z = sqrt(max(0.0, 1.0 - dot(normalmap.xy, normalmap.xy)));  // always ignore Z, as it can be RG packed, Z may be pos/neg, etc.
	return normalize(mix(normal, tangent * normalmap.x + binormal * normalmap.y + normal * normalmap.z, normaldepth));
}

void fragment() {
	vec3 ice_tex = texture(ice_texture, UV * tiling + offset).rgb;
	float d = dot(vec3(SCREEN_UV, 0.0), vec3(0.333333));
	vec2 distorted_screen_uv = SCREEN_UV + (SCREEN_UV - vec2(d + d * ice_tex.x)) * vec2(refraction_amount);
	vec3 fresnel = vec3(pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), fresnel_power)) * fresnel_color * fresnel_intensity;
	ALBEDO = main_color.rgb * (ice_tex + texture(screen_texture, distorted_screen_uv).rgb) + fresnel;
	ALPHA = main_color.a;
	METALLIC = metallic;
	SPECULAR = smoothness;
	NORMAL = read_normalmap(ice_tex, vec3(normals), TANGENT, BINORMAL, NORMAL_MAP_DEPTH);
}
