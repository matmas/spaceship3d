shader_type spatial;
render_mode unshaded, shadows_disabled, cull_front;

uniform vec3 color: source_color = vec3(1.0);
uniform float noise_speed: hint_range(0, 5) = 1.0;
uniform float noise_stretch: hint_range(0.1, 5) = 2.0;
uniform float gradient_shift: hint_range(0.1, 10) = 1.0;
instance uniform float instance_gradient_shift = 1.0;
uniform float gradient_multiplier: hint_range(0.1, 10) = 6.0;
instance uniform float instance_gradient_multiplier = 1.0;
uniform float alpha: hint_range(0, 2) = 1.0;
instance uniform float instance_alpha = 1.0;
uniform sampler2D noise_texture;

void fragment() {
	vec2 uv_motion = TIME * vec2(0.0, noise_speed);
	vec2 uv_stretch = vec2(1.0, noise_stretch);
	float noise = texture(noise_texture, UV / uv_stretch + uv_motion).r;
	float flicker_value = texture(noise_texture, vec2(TIME)).r;
	float flicker_multiplier = 1.0 + (flicker_value * 2.0 - 1.0) * 0.05;
	float gradient = UV.y * UV.y * gradient_multiplier * instance_gradient_multiplier * flicker_multiplier - 1.0 / (max(gradient_shift * instance_gradient_shift, 0.001) * flicker_multiplier);
	ALPHA = clamp((noise + gradient) * alpha * instance_alpha, 0.0, 1.0);
	ALBEDO = mix(color, color * 2.0, gradient);
}
