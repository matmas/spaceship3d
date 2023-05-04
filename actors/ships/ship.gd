class_name Ship
extends RigidBody3D

var pilot: Pilot


func _ready() -> void:
	can_sleep = false
	gravity_scale = 0
	linear_damp = 1
	angular_damp = 2


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if pilot:
		pilot._integrate_forces(state)


func max_linear_acceleration() -> Vector3:
	return Vector3(10, 10, 30) * mass


func max_angular_acceleration() -> Vector3:
	return Vector3(1, 10, 10) * mass


func add_loadout(loadout: Dictionary):
	for attachment_name in loadout:
		var weapon = loadout[attachment_name].instantiate()
		get_node(attachment_name).add_child(weapon)
