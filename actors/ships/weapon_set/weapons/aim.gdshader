shader_type canvas_item;

uniform vec4 color: source_color = vec4(vec3(1.0), 1.0);
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
uniform float size_power = 2.5;

void fragment() {
	vec2 center = vec2(0.5);
	float pattern = clamp(1.0 - pow(distance(UV, center), size_power) * 1000.0, 0.0, 1.0);
	COLOR = vec4(color.rgb, color.a * pattern * alpha);
}
