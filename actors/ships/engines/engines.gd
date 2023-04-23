extends Node3D

@onready var ship = get_parent().get_parent()

@onready var engine_rear_left := $EngineRearL as ShipEngine
@onready var engine_rear_right := $EngineRearR as ShipEngine
@onready var engine_front_left := $EngineFrontL as ShipEngine
@onready var engine_front_right := $EngineFrontR as ShipEngine

var previous_linear_velocity := Vector3()


func _physics_process(_delta: float) -> void:
	var linear_velocity = ship.linear_velocity if ship is RigidBody3D else ship.velocity
	var local_linear_velocity = ship.global_transform.basis.inverse() * linear_velocity
	var linear_accel = (local_linear_velocity - previous_linear_velocity) * 0.016
	var pos_linear_accel := Vector3(max(0, linear_accel.x), max(0, linear_accel.y), max(0, linear_accel.z))
	var neg_linear_accel := Vector3(min(0, linear_accel.x), min(0, linear_accel.y), min(0, linear_accel.z))
	engine_front_right.set_power(pos_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	engine_front_left.set_power(pos_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))
	engine_rear_right.set_power(-neg_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	engine_rear_left.set_power(-neg_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))

	previous_linear_velocity = local_linear_velocity
