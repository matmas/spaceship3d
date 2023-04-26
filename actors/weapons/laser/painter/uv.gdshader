shader_type spatial;
render_mode unshaded;

vec3 toLinear(vec3 sRGB) {
	// From https://www.shadertoy.com/view/4tXcWr
	bvec3 cutoff = lessThan(sRGB, vec3(0.04045));
	vec3 higher = pow((sRGB + vec3(0.055)) / vec3(1.055), vec3(2.4));
	vec3 lower = sRGB / vec3(12.92);
	return mix(higher, lower, cutoff);
}

void fragment() {
	ALBEDO = toLinear(vec3(UV2, 0.0));
}
