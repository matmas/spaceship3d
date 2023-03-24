extends RigidBody3D


func _ready():
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	can_sleep = false
	gravity_scale = 0
	linear_damp = 5
	angular_damp = 5


func _physics_process(_delta):
	pass


func look_follow(state: PhysicsDirectBodyState3D, target_position: Vector3):
	var target_dir := (target_position - global_position).normalized()
	var current_dir := global_transform.basis.z
	var correction := target_dir - current_dir
	state.angular_velocity = correction.cross(-global_transform.basis.z).normalized() * correction.length()

func _integrate_forces(state):
	look_follow(state, $"../Bob".global_position)
