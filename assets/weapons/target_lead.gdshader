shader_type canvas_item;

uniform vec4 color: source_color = vec4(vec3(1.0), 1.0);
uniform float alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 center = vec2(0.5);
	float disc = clamp(1.0 - dot(UV - center, UV - center) * 50.0, 0.0, 1.0);
	float line_width = 0.1;
	float vertical_line = smoothstep(0.5 - line_width * 0.5, 0.5, UV.x) - smoothstep(0.5, 0.5 + line_width * 0.5, UV.x);
	float horizontal_line = smoothstep(0.5 - line_width * 0.5, 0.5, UV.y) - smoothstep(0.5, 0.5 + line_width * 0.5, UV.y);
	float pattern = clamp((vertical_line + horizontal_line - disc) * disc * 2.0, 0.0, 1.0);
	COLOR = vec4(color.rgb, color.a * pattern * alpha);
}
