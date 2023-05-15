shader_type spatial;
render_mode blend_add, depth_draw_opaque, specular_schlick_ggx, unshaded, cull_disabled, shadows_disabled;
// Based on https://godotshaders.com/shader/spatial-ice-shader/
// and https://www.youtube.com/watch?v=Gym5JWHgjkk

uniform sampler2D screen_texture : hint_screen_texture, repeat_enable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
uniform vec4 main_color : source_color = vec4(0.23, 0.58, 0.82, 0.5);
uniform vec4 fresnel_color : source_color = vec4(0.63, 0.3, 0.61, 0.5);
uniform float fresnel_power: hint_range(1.0, 10.0) = 2.0;
uniform float fresnel_intensity: hint_range(1.0, 20.0) = 1.0;
uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform sampler2D noise_texture : source_color;
uniform float refraction_amount: hint_range(-1.0, 1.0) = 1.0;
uniform float metallic: hint_range(0.0, 1.0) = 0.134;
uniform float smoothness: hint_range(0.0, 1.0) = 0.627;
uniform float normals: hint_range(-3.0, 3.0) = 0.77;
uniform bool cull_front = false;
uniform bool cull_back = false;
uniform float impact_focus: hint_range(1.0, 200.0) = 8;
const int NUM_IMPACTS = 8;
uniform vec3 impact_directions[NUM_IMPACTS];
uniform float impact_alphas[NUM_IMPACTS];
varying float camera_distance;
varying mat4 modelview_matrix;

// Pulled straight from Godot's scene.glsl file
vec3 read_normalmap(in vec3 normalmap, in vec3 normal, in vec3 tangent, in vec3 binormal, in float normaldepth) {
	normalmap.xy = normalmap.xy * 2.0 - 1.0;
	normalmap.z = sqrt(max(0.0, 1.0 - dot(normalmap.xy, normalmap.xy)));  // always ignore Z, as it can be RG packed, Z may be pos/neg, etc.
	return normalize(mix(normal, tangent * normalmap.x + binormal * normalmap.y + normal * normalmap.z, normaldepth));
}

void vertex() {
	camera_distance = length((MODELVIEW_MATRIX * vec4(vec3(0.0), 1.0)).xyz);
	modelview_matrix = MODELVIEW_MATRIX;
}

void fragment() {
	if (cull_front && FRONT_FACING) { discard; }
	if (cull_back && !FRONT_FACING) { discard; }
	vec3 noise_tex = texture(noise_texture, UV * tiling + offset).rgb;
	float d = dot(vec3(SCREEN_UV, 0.0), vec3(0.333333));
	vec2 distorted_screen_uv = SCREEN_UV + (SCREEN_UV - vec2(d + d * noise_tex.x)) * vec2(refraction_amount);
	vec3 fresnel = vec3(pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), fresnel_power)) * fresnel_color.rgb * fresnel_color.a * fresnel_intensity;
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	float intersection_multiplier = pow(camera_distance, 2.0) * 0.01;
    float intersection = clamp(1.0 - (depth - FRAGCOORD.z) * 1000.0 * intersection_multiplier, 0.0, 1.0);
	vec3 intersection_color = intersection * fresnel_color.rgb * fresnel_color.a;
	vec3 main_tex = noise_tex.rgb * main_color.rgb * main_color.a;
	vec3 distortion = texture(screen_texture, distorted_screen_uv).rgb * main_color.rgb * main_color.a;
	ALBEDO = main_tex + distortion + fresnel + intersection_color;
	float total_alpha = alpha;
	for (int i = 0; i < NUM_IMPACTS; i++) {
		if (length(impact_directions[i]) > 0.0) {
			total_alpha += impact_alphas[i] * pow(max(dot((float(FRONT_FACING) * 2.0 - 1.0) * NORMAL, (modelview_matrix * vec4(impact_directions[i], 0.0)).xyz), 0.0), impact_focus);
		}
	}
	ALPHA = total_alpha;
	METALLIC = metallic;
	SPECULAR = smoothness;
	NORMAL = read_normalmap(noise_tex, vec3(normals), TANGENT, BINORMAL, NORMAL_MAP_DEPTH);
}
