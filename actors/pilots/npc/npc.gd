class_name NPC
extends Pilot

@onready var proxymity_distance := (($ProxymitySensor/CollisionShape3D as CollisionShape3D).shape as SphereShape3D).radius

var player: Player
var nodes_in_proxymity := {}


func _on_proxymity_sensor_node_entered(node: Node3D) -> void:
	nodes_in_proxymity[node] = true


func _on_proxymity_sensor_node_exited(node: Node3D) -> void:
	nodes_in_proxymity.erase(node)


func _on_detection_radar_area_entered(area: Area3D) -> void:
	if area is Player:
		player = area as Player


func _on_tracking_radar_area_exited(area: Area3D) -> void:
	if area == player:
		player = null


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


func point_at_difference(target_position: Vector3) -> float:
	var target_direction := ship.global_position.direction_to(target_position)
	var current_direction := -ship.global_transform.basis.z
	return (target_direction - current_direction).length()


func match_roll_with(target: Node3D) -> bool:
	var projected_target_up := Plane(ship.global_transform.basis.z).project(target.global_transform.basis.y)
	if projected_target_up.length() < 0.1:
		return true  # prevent constant rolling due to parallel forward and target up vectors
	var correction := projected_target_up - ship.global_transform.basis.y
	ship.apply_torque(correction.cross(-ship.global_transform.basis.y).normalized() * minf(correction.length(), 1) * ship.max_angular_acceleration().z)
	return correction.length() < 0.2


func thrust_to_move_to(target_position: Vector3, slowdown_distance: float = 10) -> Vector3:
	var target_relative_position := target_position - global_position
	var target_direction := target_relative_position.normalized()
	var target_distance := target_relative_position.length()
	var linear_acceleration := ship.max_linear_acceleration().z * minf(target_distance / slowdown_distance, 1)
	return target_direction * linear_acceleration


func thrust_to_evade(target_position: Vector3, evade_distance: float):
	var target_relative_position := target_position - global_position
	var target_direction := target_relative_position.normalized()
	var target_distance := target_relative_position.length()
	var linear_acceleration := ship.max_linear_acceleration().z * (1.0 - minf(target_distance / evade_distance, 1))
	return -target_direction * linear_acceleration


func evasion_thrust() -> Vector3:
	var evasion := Vector3()
	for node in nodes_in_proxymity:
		evasion += thrust_to_evade((node as Node3D).global_position, proxymity_distance)
	return evasion


func apply_thrust(linear_acceleration: Vector3) -> void:
	ship.apply_central_force((linear_acceleration).clamp(-ship.max_linear_acceleration(), ship.max_linear_acceleration()))
