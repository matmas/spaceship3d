shader_type spatial;
render_mode unshaded, shadows_disabled, blend_add;

uniform vec4 color: source_color = vec4(vec3(1.0), 1.0);
uniform float size_power = 6.0;

void vertex() {
	// Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}

void fragment() {
	vec2 center = vec2(0.5);
	
	float pattern = clamp(1.0 - pow(distance(UV, center), size_power) * 100.0, 0.0, 1.0);
	
	ALBEDO = pattern * color.rgb;
	ALPHA = pattern;
	EMISSION = color.rgb;
}
