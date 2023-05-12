class_name Player
extends Pilot

var steering_direction := Vector2()


func _ready() -> void:
	await super._ready()
	Mouse.cursor_position_changed.connect(func(_p: Vector2): steering_direction = _get_steering_direction())
	(get_viewport().get_camera_3d() as InterpolatedCamera3D).set_target(ship.get_node("Ship") as VisualInstance3D)
	ship.weapon_set.add_loadout(Loadouts.twin_lasers)
	ship.weapon_set.set_all_aiming_visibility(true)


func _process(_delta: float) -> void:
	ship.weapon_set.set_all_firing(Input.is_action_pressed("fire"))


func _physics_process(_delta: float) -> void:
	var linear_acceleration_direction := Vector3(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_down", &"move_up"),
		Input.get_axis(&"move_forward", &"move_backward"),
	).normalized()
	var linear_acceleration := linear_acceleration_direction * ship.max_linear_acceleration()
	ship.apply_central_force(ship.global_transform.basis * linear_acceleration)

	var angular_acceleration_direction := Vector3(
		-steering_direction.y,
		-steering_direction.x,
		Input.get_axis(&"roll_right", &"roll_left"),
	)
	var angular_acceleration := angular_acceleration_direction * ship.max_angular_acceleration()
	ship.apply_torque(ship.global_transform.basis * angular_acceleration)


func _get_steering_direction() -> Vector2:
	const DEADZONE := 0.01
	var viewport_size := Vector2(get_viewport().size)
	var viewport_min_size := minf(viewport_size.x, viewport_size.y)
	var direction := (Mouse.resolution_independent_cursor_position - Vector2(0.5, 0.5)) * 2 * viewport_size / viewport_min_size
	var magnitude := Vector2.ZERO.distance_to(direction)
	if magnitude < DEADZONE:
		direction = Vector2.ZERO
	else:
		direction = direction.normalized() * ((magnitude - DEADZONE) / (1 - DEADZONE))
	return direction

