shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);
uniform vec2 indicator_position = vec2(0.0);


void fragment() {
	vec2 center = vec2(0.5);
	float disc = min(pow(1.0 - distance(center, UV), 20.0) * 1000.0, 1.0);
	float inner_disc = min(pow(1.0 - distance(center, UV), 40.0) * 10000.0, 1.0);
	float vertical_line = min(pow(1.0 - abs(center.x - UV.x), 40.0), 1.0);
	float horizontal_line = min(pow(1.0 - abs(center.y - UV.y), 40.0), 1.0);
	float crossed_lines = vertical_line + horizontal_line;
	float indicator = clamp(pow(1.0 - distance(center, UV - indicator_position * 0.5), 40.0) * 10.0, 0.0, 1.0);
	float pattern = clamp(clamp(disc - inner_disc + indicator * pow((1.0 - length(indicator_position)), 40.0) * 10.0, 0.0, 1.0) - crossed_lines, 0.0, 1.0);
	COLOR = pattern * color;
}
