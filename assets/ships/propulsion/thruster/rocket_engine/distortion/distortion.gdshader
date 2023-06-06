shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform float distortion: hint_range(0, 1) = 0.01;
instance uniform float instance_distortion = 1.0;
uniform float distortion_scale: hint_range(0, 10) = 1.0;
uniform float distortion_speed: hint_range(0, 10) = 1.0;
uniform sampler2D noise_texture;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}

void fragment() {
	float distance_from_center = distance(vec2(0.5), UV) * 2.0;
	float distortion_intensity = clamp(1.0 - distance_from_center, 0.0, 1.0);
	vec2 distortion_direction = normalize(vec2(-NORMAL.x, NORMAL.y));
	vec2 noise_tex = texture(noise_texture, UV / distortion_scale + distortion_direction * distortion_speed * TIME).rg * 2.0 - 1.0;
	vec2 distorted_screen_uv = SCREEN_UV + noise_tex * distortion_intensity * distortion * instance_distortion;
	vec3 color = texture(screen_texture, distorted_screen_uv).rgb;
	ALBEDO = color;
}
