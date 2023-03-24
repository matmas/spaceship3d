extends CharacterBody3D

@onready var camera_pivot := $CameraPivot

var steering_direction := Vector2()
const DAMPING_FACTOR = 0.93

var angular_velocity := Vector3()

func _ready():
	Signals.steering_direction_changed.connect(func(d): steering_direction = d)
	camera_pivot.rotation_order = EULER_ORDER_XYZ
#	gravity_scale = 0
#	can_sleep = false
#	linear_damp = 5
#	angular_damp = 5


func _physics_process(delta):
	var linear_acceleration: Vector3 = global_transform.basis * Vector3(
		Input.get_axis("move_right", "move_left"),
		Input.get_axis("move_down", "move_up"),
		Input.get_axis("move_backward", "move_forward"),
	).normalized() * Vector3(50, 50, 100)
#	apply_central_force(linear_acceleration * delta * 60)
	velocity += linear_acceleration * delta
	velocity *= DAMPING_FACTOR ** (delta * 60)
	move_and_slide()

	var angular_acceleration: Vector3 = Vector3(
		steering_direction.y,
		-steering_direction.x,
		Input.get_axis("roll_left", "roll_right"),
	)
#	apply_torque(global_transform.basis * (angular_acceleration * Vector3(60, 600, 600) * delta))
	angular_velocity += angular_acceleration * delta
	angular_velocity *= DAMPING_FACTOR ** (delta * 60)
	rotate_object_local(Vector3.RIGHT, angular_acceleration.x * delta)
	rotate_object_local(Vector3.UP, angular_acceleration.y * delta)
	rotate_object_local(Vector3.FORWARD, angular_acceleration.z * -delta)

	var local_linear_velocity = global_transform.basis.inverse() * velocity
#	var local_angular_velocity = global_transform.basis.inverse() * angular_velocity
	var local_angular_velocity = angular_velocity
	camera_pivot.position = local_linear_velocity * delta * -10
	camera_pivot.rotation = local_angular_velocity * Vector3(-1, -1, 1) * delta * 10
