extends Node


func interpolated_global_position(collision_object: CollisionObject3D) -> Vector3:
	for child in collision_object.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return collision_object.global_position


func calculate_projectile_and_target_collision_point(target_position: Vector3, target_velocity: Vector3, ship_position: Vector3, ship_velocity: Vector3, projectile_speed: float, time: float = 0.01, max_recursion_depth: int = 2) -> Vector3:
	var relative_velocity := target_velocity - ship_velocity
	var target_future_position := target_position + relative_velocity * time
	var projectile_direction := ship_position.direction_to(target_future_position)
	var projectile_velocity := projectile_direction * projectile_speed + ship_velocity
	var projectile_travel_distance := ship_position.distance_to(target_future_position)
	var new_time := projectile_travel_distance / projectile_velocity.length()
	if max_recursion_depth == 0 or is_equal_approx(new_time, time):
		return target_future_position
	return calculate_projectile_and_target_collision_point(target_position, target_velocity, ship_position, ship_velocity, projectile_speed, new_time, max_recursion_depth - 1)


#func get_rect_segment_intersection(rect: Rect2, segment_from: Vector2, segment_to: Vector2) -> Vector2:
#	var top_left := rect.position
#	var bottom_right := rect.end
#	var top_right := Vector2(top_left.x, bottom_right.y)
#	var bottom_left := Vector2(bottom_right.x, top_left.y)
#	var corners := [top_left, top_right, bottom_right, bottom_left]
#	for i in range(corners.size()):
#		var intersection = Geometry2D.segment_intersects_segment(corners[i], corners[(i + 1) % corners.size()], segment_from, segment_to)
#		if intersection != null:
#			return intersection as Vector2
#	return Vector2.ZERO
