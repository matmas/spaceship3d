shader_type spatial;
render_mode unshaded;

vec3 to_linear(vec3 sRGB) {
	// From https://www.shadertoy.com/view/4tXcWr
	bvec3 cutoff = lessThan(sRGB, vec3(0.04045));
	vec3 higher = pow((sRGB + vec3(0.055)) / vec3(1.055), vec3(2.4));
	vec3 lower = sRGB / vec3(12.92);
	return mix(higher, lower, cutoff);
}

void fragment() {
	vec3 color = vec3(UV, 0.0);
	ALBEDO = OUTPUT_IS_SRGB ? color : to_linear(color);
}
