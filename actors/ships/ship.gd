class_name Ship
extends RigidBody3D

@onready var weapon_set := $Ship/WeaponSet as WeaponSet

var pilot: Pilot


func _ready() -> void:
	can_sleep = false
	gravity_scale = 0
	linear_damp = 1
	angular_damp = 2
	inertia = Vector3(mass, mass, mass)  # disable automatic calculation of inertia from collision shapes


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if pilot:
		pilot._integrate_forces(state)


func max_linear_acceleration() -> Vector3:
	return Vector3(10, 10, 30) * mass


func max_angular_acceleration() -> Vector3:
	return Vector3(2, 2, 2) * mass

