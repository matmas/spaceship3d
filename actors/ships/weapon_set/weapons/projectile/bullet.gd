class_name Bullet
extends Node3D

var linear_velocity := Vector3()
var last_collision_free_position := Vector3()
var accumulated_delta := 0.0

func _process(delta: float) -> void:
	if last_collision_free_position == Vector3.ZERO:
		last_collision_free_position = global_position
	if Engine.get_process_frames() % 3 == get_instance_id() % 3:
		var params := PhysicsRayQueryParameters3D.new()
		params.from = last_collision_free_position
		params.to = last_collision_free_position + linear_velocity * accumulated_delta
		#	params.exclude = exclude
		var result := get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			global_position = result.position
			queue_free()
		last_collision_free_position = params.to
		accumulated_delta = 0
	else:
		accumulated_delta += delta
	global_position += linear_velocity * delta
