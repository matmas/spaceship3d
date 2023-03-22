extends RigidBody3D


var steering_direction := Vector2()
var previous_linear_velocity := Vector3()

func _ready():
	Signals.steering_direction_changed.connect(func(d): steering_direction = d)

	# We need to change particle velocities independently
	for particles in [$EngineFrontL, $EngineFrontR, $EngineRearL, $EngineRearR]:
		particles.process_material = particles.process_material.duplicate()

func _physics_process(delta):
	apply_central_impulse(
		global_transform.basis * Vector3(
			Input.get_axis("move_right", "move_left") * 50,
			Input.get_axis("move_down", "move_up") * 50,
			Input.get_axis("move_backward", "move_forward") * 150,
		) * delta
	)
	apply_torque_impulse(global_transform.basis * Vector3(steering_direction.y * 0.1, -steering_direction.x, Input.get_axis("roll_left", "roll_right")) * delta * 20)

	var local_linear_velocity := global_transform.basis.inverse() * linear_velocity
	var linear_accel := local_linear_velocity - previous_linear_velocity

	$CameraPivot.position = local_linear_velocity * delta * -10
	$CameraPivot.rotation_order = EULER_ORDER_XYZ
	$CameraPivot.rotation = angular_velocity * delta * -10

	var pos_linear_accel := Vector3(max(0, linear_accel.x), max(0, linear_accel.y), max(0, linear_accel.z))
	var neg_linear_accel := Vector3(min(0, linear_accel.x), min(0, linear_accel.y), min(0, linear_accel.z))

	set_engine_power($EngineRearL, pos_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power($EngineRearR, pos_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))
	set_engine_power($EngineFrontL, -neg_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power($EngineFrontR, -neg_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))

	for particles in [$EngineFrontL, $EngineFrontR]:
		particles.emitting = particles.process_material.initial_velocity_max > 0.1

	previous_linear_velocity = local_linear_velocity

func set_engine_power(engine, value):
	engine.process_material.initial_velocity_min = value * 10
	engine.process_material.initial_velocity_max = value * 10
