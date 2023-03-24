extends CharacterBody3D

@onready var camera_pivot := $CameraPivot

var steering_direction := Vector2()
const DAMPING_FACTOR = 0.93

var angular_velocity := Vector3()
var previous_linear_velocity := Vector3()


func _ready():
	Signals.steering_direction_changed.connect(func(d): steering_direction = d)
	camera_pivot.rotation_order = EULER_ORDER_XYZ


func _physics_process(delta):
#	ship.apply_central_impulse(
#		ship.global_transform.basis * Vector3(
#			Input.get_axis("move_right", "move_left") * 50,
#			Input.get_axis("move_down", "move_up") * 50,
#			Input.get_axis("move_backward", "move_forward") * 150,
#		) * delta
#	)
#	ship.apply_torque_impulse(ship.global_transform.basis * Vector3(steering_direction.y * 0.1, -steering_direction.x, Input.get_axis("roll_left", "roll_right")) * delta * 20)
	var linear_acceleration: Vector3 = global_transform.basis * Vector3(
		Input.get_axis("move_right", "move_left"),
		Input.get_axis("move_down", "move_up"),
		Input.get_axis("move_backward", "move_forward"),
	).normalized() * Vector3(50, 50, 100)
	velocity += linear_acceleration * delta
	velocity *= DAMPING_FACTOR ** (delta * 60)

	var angular_acceleration: Vector3 = Vector3(
		-steering_direction.y,
		steering_direction.x,
		-Input.get_axis("roll_left", "roll_right"),
	)
	angular_velocity += angular_acceleration * delta
	angular_velocity *= DAMPING_FACTOR ** (delta * 60)

	rotate_object_local(Vector3.RIGHT, angular_acceleration.x * -delta)
	rotate_object_local(Vector3.UP, angular_acceleration.y * -delta)
	rotate_object_local(Vector3.FORWARD, angular_acceleration.z * delta)
	move_and_slide()

	var local_linear_velocity = global_transform.basis.inverse() * velocity
#	var linear_accel = (local_linear_velocity - previous_linear_velocity) * delta
	camera_pivot.position = local_linear_velocity * delta * -10
	camera_pivot.rotation = angular_velocity * delta * 10

	previous_linear_velocity = local_linear_velocity
