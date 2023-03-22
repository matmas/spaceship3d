extends Node3D

@onready var camera_pivot := $CameraPivot

var steering_direction := Vector2()


func _ready():
	Signals.steering_direction_changed.connect(func(d): steering_direction = d)


func _physics_process(delta):
	var ship = get_parent()

	ship.apply_central_impulse(
		ship.global_transform.basis * Vector3(
			Input.get_axis("move_right", "move_left") * 50,
			Input.get_axis("move_down", "move_up") * 50,
			Input.get_axis("move_backward", "move_forward") * 150,
		) * delta
	)
	ship.apply_torque_impulse(ship.global_transform.basis * Vector3(steering_direction.y * 0.1, -steering_direction.x, Input.get_axis("roll_left", "roll_right")) * delta * 20)

	var local_linear_velocity = ship.global_transform.basis.inverse() * ship.linear_velocity

	camera_pivot.position = local_linear_velocity * delta * -10
	camera_pivot.rotation_order = EULER_ORDER_XYZ
	camera_pivot.rotation = ship.angular_velocity * delta * -10

