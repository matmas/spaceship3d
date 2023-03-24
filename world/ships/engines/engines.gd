extends Node3D

@onready var ship: CharacterBody3D = get_parent()

@onready var engine_rear_left := $EngineRearL
@onready var engine_rear_right := $EngineRearR
@onready var engine_front_left := $EngineFrontL
@onready var engine_front_right := $EngineFrontR

var previous_linear_velocity := Vector3()


func _ready():
	# We need to change particle velocities independently
	for particles in [engine_rear_left, engine_rear_right, engine_front_left, engine_front_right]:
		particles.process_material = particles.process_material.duplicate()


func _physics_process(delta):
	var local_linear_velocity = ship.global_transform.basis.inverse() * ship.velocity
	var linear_accel = (local_linear_velocity - previous_linear_velocity) * delta
	var pos_linear_accel := Vector3(max(0, linear_accel.x), max(0, linear_accel.y), max(0, linear_accel.z))
	var neg_linear_accel := Vector3(min(0, linear_accel.x), min(0, linear_accel.y), min(0, linear_accel.z))
	set_engine_power(engine_rear_left, pos_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_rear_right, pos_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_front_left, -neg_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_front_right, -neg_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))

	for particles in [engine_front_left, engine_front_right]:
		particles.emitting = particles.process_material.initial_velocity_max > 0.1

	previous_linear_velocity = local_linear_velocity


func set_engine_power(engine, value):
	engine.process_material.initial_velocity_min = value * 500
	engine.process_material.initial_velocity_max = value * 500
