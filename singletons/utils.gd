extends Node


func interpolated_global_position(node: Node3D) -> Vector3:
	for child in node.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return node.global_position


func calculate_projectile_and_target_collision_point(target_position: Vector3, target_velocity: Vector3, ship_position: Vector3, ship_velocity: Vector3, projectile_speed: float, time: float = 0.01, max_recursion_depth: int = 2) -> Vector3:
	var relative_velocity := target_velocity - ship_velocity
	var target_future_position := target_position + relative_velocity * time
	var projectile_direction := ship_position.direction_to(target_future_position)
	var projectile_velocity := projectile_direction * projectile_speed + ship_velocity
	var projectile_travel_distance := ship_position.distance_to(target_future_position)
	var new_time := projectile_travel_distance / projectile_velocity.length()
	if max_recursion_depth == 0 or is_equal_approx(new_time, time):
		return target_future_position
	return calculate_projectile_and_target_collision_point(
		target_position, target_velocity, ship_position, ship_velocity, projectile_speed,
		new_time, max_recursion_depth - 1
	)


func unproject_aabb_to_screen_space_rect(visual_instance: VisualInstance3D, camera: Camera3D) -> Rect2:
	var aabb := visual_instance.get_aabb()
	var vertex_positions := PackedVector2Array()
	vertex_positions.resize(8)
	for i in range(8):
		@warning_ignore("integer_division")
		var local_vertex := aabb.position + aabb.size * Vector3(i / 4, (i % 4) / 2, i % 2)
		var vertex := visual_instance.to_global(local_vertex)
		if camera.is_position_behind(vertex):
			return Rect2()
		vertex_positions[i] = camera.unproject_position(vertex)
	var rect := Rect2(vertex_positions[0], Vector2.ZERO)
	for i in range(1, 8):
		if not vertex_positions[i].is_zero_approx():
			rect = rect.expand(vertex_positions[i])
	var viewport_rect := camera.get_viewport().get_visible_rect()
	return rect if rect.intersects(viewport_rect) else Rect2()


func make_square(rect: Rect2, min_size: float = 0) -> Rect2:
	var center := rect.get_center()
	var square_size := maxf(maxf(rect.size.x, rect.size.y), min_size)
	return Rect2(
		center.x - square_size * 0.5,
		center.y - square_size * 0.5,
		square_size,
		square_size,
	)


func get_visual_instance_ancestor(node: Node) -> VisualInstance3D:
	var parent := node.get_parent()
	while parent != null:
		if parent is VisualInstance3D:
			return parent as VisualInstance3D
		parent = parent.get_parent()
	return null


func get_rigid_body_ancestor(node: Node) -> RigidBody3D:
	var parent := node.get_parent()
	while parent != null:
		if parent is RigidBody3D:
			return parent as RigidBody3D
		parent = parent.get_parent()
	return null


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
