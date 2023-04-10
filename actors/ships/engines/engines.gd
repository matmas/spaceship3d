extends Node3D

@onready var ship = get_parent().get_parent()

@onready var engine_rear_left := $EngineRearL as GPUParticles3D
@onready var engine_rear_right := $EngineRearR as GPUParticles3D
@onready var engine_front_left := $EngineFrontL as GPUParticles3D
@onready var engine_front_right := $EngineFrontR as GPUParticles3D

var previous_linear_velocity := Vector3()


func _ready() -> void:
	# We need to change particle velocities independently
	for particles in [engine_rear_left, engine_rear_right, engine_front_left, engine_front_right]:
		particles.process_material = particles.process_material.duplicate()


func _physics_process(_delta: float) -> void:
	var linear_velocity = ship.linear_velocity if ship is RigidBody3D else ship.velocity
	var local_linear_velocity = ship.global_transform.basis.inverse() * linear_velocity
	var linear_accel = (local_linear_velocity - previous_linear_velocity) * 0.016
	var pos_linear_accel := Vector3(max(0, linear_accel.x), max(0, linear_accel.y), max(0, linear_accel.z))
	var neg_linear_accel := Vector3(min(0, linear_accel.x), min(0, linear_accel.y), min(0, linear_accel.z))
	set_engine_power(engine_front_right, pos_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_front_left, pos_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_rear_right, -neg_linear_accel.z - neg_linear_accel.x + abs(linear_accel.y))
	set_engine_power(engine_rear_left, -neg_linear_accel.z + pos_linear_accel.x + abs(linear_accel.y))

	for particles in [engine_front_left, engine_front_right]:
		particles.emitting = particles.process_material.initial_velocity_max > 0.1

	previous_linear_velocity = local_linear_velocity


func set_engine_power(engine: GPUParticles3D, value: float) -> void:
	engine.process_material.initial_velocity_min = value * 500
	engine.process_material.initial_velocity_max = value * 500
