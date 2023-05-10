float crossed_lines(vec2 uv) {
	vec2 center = vec2(0.5);
	float vertical_line = min(pow(1.0 - abs(center.x - uv.x), 40.0) * 4.0, 1.0);
	float horizontal_line = min(pow(1.0 - abs(center.y - uv.y), 40.0) * 4.0, 1.0);
	return vertical_line + horizontal_line;
}

float disc(vec2 uv) {
	vec2 center = vec2(0.5);
	return min(pow(1.0 - distance(center, uv), 20.0) * 1000.0, 1.0);
}

float inner_disc(vec2 uv) {
	vec2 center = vec2(0.5);
	return min(pow(1.0 - distance(center, uv), 40.0) * 10000.0, 1.0);
}
