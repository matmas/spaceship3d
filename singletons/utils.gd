extends Node


func interpolated_global_position(collision_object: CollisionObject3D) -> Vector3:
	for child in collision_object.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return collision_object.global_position


func calculate_projectile_and_target_collision_point(target_position: Vector3, target_velocity: Vector3, ship_position: Vector3, ship_velocity: Vector3, projectile_speed: float, time: float = 0.01, max_recursion_depth: int = 20) -> Vector3:
	var relative_velocity := target_velocity - ship_velocity
	var target_future_position := target_position + relative_velocity * time
	var projectile_direction := ship_position.direction_to(target_future_position)
	var projectile_velocity := projectile_direction * projectile_speed + ship_velocity
	var projectile_travel_distance := ship_position.distance_to(target_future_position)
	var new_time := projectile_travel_distance / projectile_velocity.length()
	if max_recursion_depth == 0 or is_equal_approx(new_time, time):
		return target_future_position
	return calculate_projectile_and_target_collision_point(target_position, target_velocity, ship_position, ship_velocity, projectile_speed, new_time, max_recursion_depth - 1)
