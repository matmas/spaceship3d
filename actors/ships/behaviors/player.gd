extends Ship

var steering_direction := Vector2()
@onready var sparks := $Sparks as GPUParticles3D


func _ready() -> void:
	super._ready()
	Mouse.cursor_position_changed.connect(func(_p: Vector2): steering_direction = _get_steering_direction())
	contact_monitor = true
	max_contacts_reported = 1


func _physics_process(_delta: float) -> void:
	var linear_acceleration: Vector3 = global_transform.basis * (Vector3(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_down", &"move_up"),
		Input.get_axis(&"move_forward", &"move_backward"),
	).normalized() * _max_linear_acceleration())
	apply_central_force(linear_acceleration)

	var angular_acceleration: Vector3 = Vector3(
		-steering_direction.y,
		-steering_direction.x,
		Input.get_axis(&"roll_right", &"roll_left"),
	)
	apply_torque(global_transform.basis * (angular_acceleration * _max_angular_acceleration()))


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


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	sparks.emitting = state.get_contact_count() > 0
	if state.get_contact_count() > 0:
		var contact_point := global_position + state.get_contact_local_position(0)
		var contact_normal := state.get_contact_local_normal(0)
		sparks.global_position = contact_point
		if not Vector3.UP.cross(contact_point + contact_normal - sparks.global_position).is_zero_approx():
			sparks.look_at(contact_point + contact_normal)
