extends Node3D

@onready var ship := owner as RigidBody3D

var previous_linear_velocity := Vector3()
var previous_angular_velocity := Vector3()

# mass to thruster acceleration ratio divided by number of thrusters
const mass_to_thruster := 8
# moment of inertia to thruster acceleration ratio divided by number of thrusters
const inertia_to_thruster := 8


func _physics_process(_delta: float) -> void:
	var global_linear_velocity := ship.linear_velocity
	var linear_velocity := ship.global_transform.basis.inverse() * global_linear_velocity
	var linear_acceleration := linear_velocity - previous_linear_velocity

	var global_angular_velocity := ship.angular_velocity
	var angular_velocity := ship.global_transform.basis.inverse() * global_angular_velocity
	var angular_acceleration := angular_velocity - previous_angular_velocity

	for child in get_children():
		if child is Thruster:
			var thruster := child as Thruster
			var lateral_thrust := (linear_acceleration * mass_to_thruster).dot(-thruster.transform.basis.z)
			var angular_thrust := (angular_acceleration * inertia_to_thruster).cross(thruster.position).dot(-thruster.transform.basis.z)
			thruster.set_power(lateral_thrust + angular_thrust)

	previous_linear_velocity = linear_velocity
	previous_angular_velocity = angular_velocity