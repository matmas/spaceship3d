extends RigidBody3D

@onready var player: Node3D = $"../Bob"


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


func point_at(target_position: Vector3, only_if_farther_than = 10):
	if (target_position - global_position).length() < only_if_farther_than:
		return true
	var target_dir := (target_position - global_position).normalized()
	var current_dir := global_transform.basis.z
	var correction := target_dir - current_dir
	self.apply_torque(correction.cross(-global_transform.basis.z).normalized() * correction.length() * 100)
	return correction.length() < 0.1


func match_roll_with(target: Node3D, ease_out = false):
	if ease_out:
		var correction := Plane(global_transform.basis.z).project(target.global_transform.basis.y) - global_transform.basis.y
		self.apply_torque(correction.cross(-global_transform.basis.y).normalized() * correction.length() * 100)
		return correction.length() < 0.1
	else:
		var correction := target.global_transform.basis.y.signed_angle_to(global_transform.basis.y, -global_transform.basis.z)
		self.apply_torque(global_transform.basis.z * correction * 50)
		return correction < 0.1


func move_to_position(target_position: Vector3):
	var correction := target_position - global_position
	self.apply_central_force(correction.normalized() * correction.length() * 4)


func move_to(target: Node3D):
	return move_to_position(target.global_position)


func _physics_process(_delta):
	if point_at(player.global_transform * Vector3(0, 0, 20)):
		match_roll_with(player, true)
		move_to_position(player.global_transform * Vector3(0, 0, 20))
