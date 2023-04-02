extends Actor

var steering_direction := Vector2()

#const DAMPING_FACTOR = 0.93
#var angular_velocity := Vector3()

func _init():
	Globals.player = self


func _ready():
	super._ready()
	Signals.steering_direction_changed.connect(func(d): steering_direction = d)


func _physics_process(_delta):
	var linear_acceleration: Vector3 = global_transform.basis * (Vector3(
		Input.get_axis("move_right", "move_left"),
		Input.get_axis("move_down", "move_up"),
		Input.get_axis("move_backward", "move_forward"),
	).normalized() * Vector3(50, 50, 200))
	apply_central_force(linear_acceleration)
#	velocity += linear_acceleration * delta
#	velocity *= DAMPING_FACTOR ** (delta * 60)
#	move_and_slide()

	var angular_acceleration: Vector3 = Vector3(
		steering_direction.y,
		-steering_direction.x,
		Input.get_axis("roll_left", "roll_right"),
	)
	apply_torque(global_transform.basis * (angular_acceleration * Vector3(1, 10, 10)))
#	angular_velocity += angular_acceleration * delta
#	angular_velocity *= DAMPING_FACTOR ** (delta * 60)
#	rotate_object_local(Vector3.RIGHT, angular_acceleration.x * delta)
#	rotate_object_local(Vector3.UP, angular_acceleration.y * delta)
#	rotate_object_local(Vector3.FORWARD, angular_acceleration.z * -delta)
