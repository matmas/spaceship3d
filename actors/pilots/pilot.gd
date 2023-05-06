class_name Pilot
extends Area3D


@onready var ship := get_parent() as Ship


func _ready() -> void:
	ship.pilot = self


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	pass


func point_at(target_position: Vector3, min_distance: float = 10) -> void:
	var distance := ship.global_position.distance_to(target_position)
	if distance < min_distance:
		return
	var target_direction := ship.global_position.direction_to(target_position)
	_point_in_direction(target_direction)


func _point_in_direction(target_direction: Vector3) -> void:
	var current_direction := -ship.global_transform.basis.z
	var correction := target_direction - current_direction
	ship.apply_torque(correction.cross(ship.global_transform.basis.z).normalized() * minf(correction.length(), 1) * ship.max_linear_acceleration().x)


func match_roll_with(target: Node3D) -> bool:
	var projected_target_up := Plane(ship.global_transform.basis.z).project(target.global_transform.basis.y)
	if projected_target_up.length() < 0.1:
		return true  # prevent constant rolling due to parallel forward and target up vectors
	var correction := projected_target_up - ship.global_transform.basis.y
	ship.apply_torque(correction.cross(-ship.global_transform.basis.y).normalized() * minf(correction.length(), 1) * ship.max_angular_acceleration().z)
	return correction.length() < 0.2


func move_to(target_position: Vector3) -> void:
	var correction := target_position - global_position
	ship.apply_central_force((correction.normalized() * correction.length() * ship.linear_damp * ship.mass).clamp(-ship.max_linear_acceleration(), ship.max_linear_acceleration()))


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

