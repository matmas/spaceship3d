class_name Bullet
extends Node3D

var linear_velocity := Vector3()


func _process(delta: float) -> void:
	var params := PhysicsRayQueryParameters3D.new()
	params.from = global_position
	params.to = global_position + linear_velocity * delta
	#	params.exclude = exclude
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	if result:
		global_position = result.position
		queue_free()
	else:
		global_position += linear_velocity * delta
