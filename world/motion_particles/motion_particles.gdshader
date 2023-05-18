shader_type spatial;
render_mode unshaded, shadows_disabled, depth_test_disabled;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 camera_velocity = vec3(0.0, 0.0, 40.0);

void vertex() {
	vec3 camera_position = (INV_VIEW_MATRIX * vec4(vec3(0.0), 1.0)).xyz;
	vec3 particle_origin = MODEL_MATRIX[3].xyz;
	vec3 x = camera_velocity * 0.01;
	vec3 y = normalize(cross(camera_position - particle_origin, x));
	vec3 z = cross(x, y);
	mat3 basis = mat3(x, y * length(camera_velocity) * 0.0006, z);
	COLOR.a *= min(length(camera_velocity * 0.025), 1.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(particle_origin + basis * VERTEX, 1.0);
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = COLOR.rgb * albedo_tex.rgb;
	ALPHA = COLOR.a * albedo_tex.a;
}
