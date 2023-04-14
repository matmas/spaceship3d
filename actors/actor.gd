extends RigidBody3D
class_name Actor


func _ready() -> void:
	can_sleep = false
	gravity_scale = 0
	linear_damp = 5
	angular_damp = 5


func _max_linear_acceleration() -> Vector3:
	return Vector3(50, 50, 200) * mass


func _max_angular_acceleration() -> Vector3:
	return Vector3(1, 10, 10) * mass


func point_at(target_position: Vector3, min_distance: float = 10) -> void:
	var distance := global_position.distance_to(target_position)
	if distance < min_distance:
		return
	var target_direction := global_position.direction_to(target_position)
	_point_in_direction(target_direction)


func _point_in_direction(target_direction: Vector3) -> void:
	var current_direction := -global_transform.basis.z
	var correction := target_direction - current_direction
	self.apply_torque(correction.cross(global_transform.basis.z).normalized() * correction.length() * 100 * mass)


func match_roll_with(target: Node3D) -> bool:
	var projected_target_up := Plane(global_transform.basis.z).project(target.global_transform.basis.y)
	if projected_target_up.length() < 0.1:
		return true  # prevent constant rolling due to parallel forward and target up vectors
	var correction := projected_target_up - global_transform.basis.y
	self.apply_torque(correction.cross(-global_transform.basis.y).normalized() * correction.length() * 100 * mass)
	return correction.length() < 0.2


func move_to(target_position: Vector3) -> void:
	var correction := target_position - global_position
	self.apply_central_force((correction.normalized() * correction.length() * linear_damp * mass).clamp(-_max_linear_acceleration(), _max_linear_acceleration()))


#func move_forward(max_accel = 100):
#	self.apply_central_force(global_transform.basis.z * max_accel)
#
#
#func point_at_but_evade(target_position: Vector3, evade_distance = 50):
#	var distance := global_position.distance_to(target_position)
#	var direction_to_target := global_position.direction_to(target_position)
#	if distance < evade_distance:
#		var evade_direction := (linear_velocity.normalized() - direction_to_target).normalized()
#		_point_in_direction(evade_direction)
#	else:
#		_point_in_direction(direction_to_target)
