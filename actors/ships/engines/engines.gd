extends Node3D

@onready var ship := owner as RigidBody3D

@onready var engine_rear_left := $EngineRearL as ShipEngine
@onready var engine_rear_right := $EngineRearR as ShipEngine
@onready var engine_front_left := $EngineFrontL as ShipEngine
@onready var engine_front_right := $EngineFrontR as ShipEngine

var previous_linear_velocity := Vector3()


func _physics_process(_delta: float) -> void:
	var linear_velocity := ship.linear_velocity
	var local_linear_velocity := ship.global_transform.basis.inverse() * linear_velocity
	var linear_accel := (local_linear_velocity - previous_linear_velocity) * 0.016
	var pos_linear_accel := Vector3(maxf(0, linear_accel.x), maxf(0, linear_accel.y), maxf(0, linear_accel.z))
	var neg_linear_accel := Vector3(minf(0, linear_accel.x), minf(0, linear_accel.y), minf(0, linear_accel.z))
	set_engine_power(engine_front_right, pos_linear_accel.z - neg_linear_accel.x + absf(linear_accel.y))
	set_engine_power(engine_front_left, pos_linear_accel.z + pos_linear_accel.x + absf(linear_accel.y))
	set_engine_power(engine_rear_right, -neg_linear_accel.z - neg_linear_accel.x + absf(linear_accel.y))
	set_engine_power(engine_rear_left, -neg_linear_accel.z + pos_linear_accel.x + absf(linear_accel.y))

	previous_linear_velocity = local_linear_velocity


func set_engine_power(engine: ShipEngine, power: float):
	engine.set_power(clampf(power * 500, 0, 1))
