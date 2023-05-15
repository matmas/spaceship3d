class_name Bullet
extends Node3D

@onready var camera := get_viewport().get_camera_3d()
@onready var initial_global_position := global_position
@onready var max_travel_distance := camera.far

var linear_velocity := Vector3()
var excluded_rids: Array[RID] = []
var weapon: Weapon


func _process(delta: float) -> void:
	var params := PhysicsRayQueryParameters3D.new()
	params.from = global_position
	params.to = global_position + linear_velocity * delta
	params.exclude = excluded_rids
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	if result:
		global_position = result.position
		if result.collider is Ship:
			var ship := result.collider as Ship
			var impact_direction := initial_global_position.direction_to(result.position)
			var impact_position: Vector3 = result.position
			ship.hit.emit(weapon, impact_direction, impact_position)
		queue_free()
	else:
		global_position += linear_velocity * delta
		if initial_global_position.distance_squared_to(global_position) > pow(max_travel_distance, 2):
			queue_free()
