class_name NPC
extends Pilot

@onready var proxymity_sensor := $ProxymitySensor as Area3D
@onready var proxymity_distance := ((proxymity_sensor.get_node("CollisionShape3D") as CollisionShape3D).shape as SphereShape3D).radius
@onready var detection_radar := $DetectionRadar as Area3D


var last_hit_direction := Vector3()
var last_hit_time := -INF


func _ready() -> void:
	await super._ready()
	ship.hit.connect(_process_hit)
	ship.shield.hit.connect(_process_hit)


func _physics_process(_delta: float) -> void:
	const collision_avoidance_importance = 1.5
	var collision_avoidance_thrust := Vector3()
	for node in proxymity_sensor.get_overlapping_bodies():
		collision_avoidance_thrust += _thrust_to_avoid(node.global_position, proxymity_distance) * collision_avoidance_importance
	ship.linear_acceleration_to_apply += collision_avoidance_thrust


func _thrust_to_avoid(target_position: Vector3, avoid_distance: float) -> Vector3:
	var target_relative_position := target_position - global_position
	var target_direction := target_relative_position.normalized()
	var target_distance := target_relative_position.length()
	var linear_acceleration := ship.max_linear_acceleration().z * (1.0 - minf(target_distance / avoid_distance, 1))
	return -target_direction * linear_acceleration


func _process_hit(source: Node3D, _impact_point: Vector3) -> void:
	last_hit_direction = global_position.direction_to(source.global_position)
	last_hit_time = Time.get_ticks_msec()
