extends RigidBody3D


func _ready():
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(_delta):
	pass


#func look_follow(state: PhysicsDirectBodyState3D, target_position):
#	var target_dir = (target_position - global_transform.origin).normalized()
#	var cur_dir = global_transform.basis * Vector3.FORWARD
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#	state.angular_velocity = Vector3.UP * (rotation_angle / state.step)
#
#func _integrate_forces(state):
#	var target: Node3D = $"../Bob"
#	print(target.global_transform.origin)
#	look_follow(state, target.global_transform.origin)
