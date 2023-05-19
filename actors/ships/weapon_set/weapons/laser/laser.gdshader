shader_type spatial;
render_mode blend_add;

uniform vec4 color: source_color = vec4(1.0, 0.36, 0.0, 1.0);
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
instance uniform float instance_alpha = 1.0;
uniform float emission_energy: hint_range(0.0, 100.0) = 16.0;
uniform sampler2D noise: source_color, filter_linear_mipmap, repeat_enable;

void fragment() {
	vec2 uv_offset = vec2(TIME, 0.0);
	vec4 noise_tex = texture(noise, UV - uv_offset);
	float fade = pow(1.0 - abs(UV.y - 0.5) * 2.0, 3.0);
	ALBEDO = color.rgb * noise_tex.rgb * fade;
	EMISSION = ALBEDO * emission_energy;
	ALPHA = alpha * instance_alpha;
}
