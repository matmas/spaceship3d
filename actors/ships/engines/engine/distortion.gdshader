shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform float distortion: hint_range(0, 1) = 0.01;
uniform vec2 distortion_speed = vec2(1.0);
uniform sampler2D noise_texture;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}

void fragment() {
	vec2 noise_tex = texture(noise_texture, UV + distortion_speed * TIME).rg * 2.0 - 1.0;
	vec2 distorted_screen_uv = mix(SCREEN_UV, SCREEN_UV + noise_tex, distortion);
	vec3 color = texture(screen_texture, distorted_screen_uv).rgb;
	ALBEDO = color;
	float distance_from_center = distance(vec2(0.5), UV) * 2.0;
	ALPHA = clamp(1.0 - distance_from_center, 0.0, 1.0);
}
