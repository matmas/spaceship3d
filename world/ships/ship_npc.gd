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


func point_at(target_position: Vector3, min_distance = 10):
	if global_position.distance_to(target_position) < min_distance:
		return true
	var target_dir := global_position.direction_to(target_position)
	var current_dir := global_transform.basis.z
	var correction := target_dir - current_dir
	self.apply_torque(correction.cross(-global_transform.basis.z).normalized() * correction.length() * 100)
	return correction.length() < 0.1


func match_roll_with(target: Node3D):
	var projected_target_up := Plane(global_transform.basis.z).project(target.global_transform.basis.y)
	if projected_target_up.length() < 0.1:
		return true  # prevent constant rolling due to parallel forward and target up vectors
	var correction := projected_target_up - global_transform.basis.y
	self.apply_torque(correction.cross(-global_transform.basis.y).normalized() * correction.length() * 100)
	return correction.length() < 0.2


func move_to_position(target_position: Vector3):
	var correction := target_position - global_position
	self.apply_central_force(correction * 4)


func move_to(target: Node3D):
	return move_to_position(target.global_position)


func _physics_process(_delta):
	point_at(player.global_position)
	match_roll_with(player)
	move_to_position(player.global_transform * Vector3(0, 0, 20))
