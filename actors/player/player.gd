extends Actor

#const DAMPING_FACTOR = 0.93
#var angular_velocity := Vector3()

var steering_direction := Vector2()


func _init() -> void:
	Globals.player = self
	Mouse.cursor_position_changed.connect(func(_p: Vector2): steering_direction = _get_steering_direction())


func _physics_process(_delta: float) -> void:
	var linear_acceleration: Vector3 = global_transform.basis * (Vector3(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_down", &"move_up"),
		Input.get_axis(&"move_forward", &"move_backward"),
	).normalized() * _max_linear_acceleration())
	apply_central_force(linear_acceleration)
#	velocity += linear_acceleration * delta
#	velocity *= DAMPING_FACTOR ** (delta * 60)
#	move_and_slide()

	var angular_acceleration: Vector3 = Vector3(
		-steering_direction.y,
		-steering_direction.x,
		Input.get_axis(&"roll_right", &"roll_left"),
	)
	apply_torque(global_transform.basis * (angular_acceleration * _max_angular_acceleration()))
#	angular_velocity += angular_acceleration * delta
#	angular_velocity *= DAMPING_FACTOR ** (delta * 60)
#	rotate_object_local(Vector3.RIGHT, angular_acceleration.x * delta)
#	rotate_object_local(Vector3.UP, angular_acceleration.y * delta)
#	rotate_object_local(Vector3.FORWARD, angular_acceleration.z * -delta)


func _get_steering_direction() -> Vector2:
	var viewport_size := Vector2(get_viewport().size)
	var viewport_min_size := minf(viewport_size.x, viewport_size.y)
	return (Mouse.resolution_independent_cursor_position - Vector2(0.5, 0.5)) * 2 * viewport_size / viewport_min_size
