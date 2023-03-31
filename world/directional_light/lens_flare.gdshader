shader_type spatial;
render_mode blend_mix, unshaded, depth_draw_opaque, cull_disabled;

uniform vec2 sun_position = vec2(0.0);
uniform vec3 tint = vec3(1.4, 1.2, 1.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
//uniform sampler2D depth_texture : hint_depth_texture;


vec3 lensflare(vec2 uv, vec2 pos) {
	vec2 main = uv - pos;
	vec2 uvd = uv * (length(uv));
	
	float ang = atan(main.x, main.y);
	float dist = length(main);
	dist = pow(dist, 0.1);
	
	float f1 = max(0.01 - pow(length(uv + 1.2 * pos), 1.9), 0.0) * 7.0;

	float f2 = max(1.0 / (1.0 + 32.0 * pow(length(uvd + 0.8 * pos), 2.0)), 0.0) * 0.25;
	float f22 = max(1.0 / (1.0 + 32.0 * pow(length(uvd + 0.85 * pos), 2.0)), 0.0) * 0.23;
	float f23 = max(1.0 / (1.0 + 32.0 * pow(length(uvd + 0.9 * pos), 2.0)), 0.0) * 0.21;
	
	vec2 uvx = mix(uv, uvd, -0.5);
	
	float f4 = max(0.01 - pow(length(uvx + 0.4 * pos), 2.4), 0.0) * 6.0;
	float f42 = max(0.01 - pow(length(uvx + 0.45 * pos), 2.4), 0.0) * 5.0;
	float f43 = max(0.01 - pow(length(uvx + 0.5 * pos), 2.4), 0.0) * 3.0;
	
	uvx = mix(uv, uvd, -0.4);
	
	float f5 = max(0.01 - pow(length(uvx + 0.2 * pos), 5.5), 0.0) * 2.0;
	float f52 = max(0.01 - pow(length(uvx + 0.4 * pos), 5.5), 0.0) * 2.0;
	float f53 = max(0.01 - pow(length(uvx + 0.6 * pos), 5.5), 0.0) * 2.0;
	
	uvx = mix(uv, uvd, -0.5);
	
	float f6 = max(0.01 - pow(length(uvx - 0.3 * pos), 1.6), 0.0) * 6.0;
	float f62 = max(0.01 - pow(length(uvx - 0.325 * pos), 1.6), 0.0) * 3.0;
	float f63 = max(0.01 - pow(length(uvx - 0.35 * pos), 1.6), 0.0) * 5.0;
	
	vec3 c = vec3(0.0);
	
	c.r += f2 + f4 + f5 + f6;
	c.g += f22 + f42 + f52 + f62;
	c.b += f23 + f43 + f53 + f63;
	c = c * 1.3;
	return c;
}

mat4 translation(vec3 position) {
	return mat4(
			vec4(1.0, 0.0, 0.0, 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(0.0, 0.0, 1.0, 0.0),
			vec4(position, 1.0)
	);
}

void vertex() {
	float near = 0.05;
	MODELVIEW_MATRIX = mat4(1.0) + translation(vec3(0., 0., -(near + 0.0001)));
}

void fragment() {
	vec2 uv = FRAGCOORD.xy / VIEWPORT_SIZE.xy - 0.5;
	uv.x *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;  // fix aspect ratio
	vec2 sun = (sun_position.xy / VIEWPORT_SIZE.xy) - vec2(0.5, 0.5);
	sun.x *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;  // fix aspect ratio
	
	ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
	ALBEDO += tint * lensflare(uv, sun.xy) * 0.5;
	
//	float depth = texture(depth_texture, SCREEN_UV).r;
//    float dist = (INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0)).w;
//	ALBEDO = vec3(dist);
}
