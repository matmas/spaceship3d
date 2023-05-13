class_name Bullet
extends Node3D


var linear_velocity := Vector3()



func _physics_process(delta: float) -> void:
	var new_position := global_transform.origin + linear_velocity * delta
	var params := PhysicsRayQueryParameters3D.new()
	params.from = global_transform.origin
	params.to = new_position
#	params.exclude = exclude
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	global_transform.origin = new_position
#	return result.position if result else Vector3()
	if result:
		queue_free()
