shader_type canvas_item;
#include "crosshairs.gdshaderinc"

uniform vec4 color: source_color = vec4(1.0);

void fragment() {
	float pattern = clamp(disc(UV) - inner_disc(UV) - crossed_lines(UV), 0.0, 1.0);
	COLOR = pattern * color;
}
