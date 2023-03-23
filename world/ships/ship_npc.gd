extends RigidBody3D


func _ready():
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(delta):
	pass


func look_follow(state, current_transform, target_position):
	var cur_dir = current_transform.basis * Vector3.BACK
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	state.angular_velocity = Vector3.UP * (rotation_angle / state.step)

func _integrate_forces(state):
	var target: Node3D = $"../Bob"
	var target_position = target.global_transform.origin
	look_follow(state, global_transform, target_position)
