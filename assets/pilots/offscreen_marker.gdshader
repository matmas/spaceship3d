shader_type canvas_item;

uniform vec4 color: source_color = vec4(vec3(1.0), 1.0);
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 center = vec2(0.5);
	float disc = clamp(1.0 - dot(UV - center, UV - center) * 5.0, 0.0, 1.0);
	float pattern = pow(1.0 - abs(1.0 - UV.y) * abs(UV.x - 0.5) * 10.0, 1.0) * disc;
	
	COLOR = vec4(color.rgb, color.a * pattern * alpha);
}
