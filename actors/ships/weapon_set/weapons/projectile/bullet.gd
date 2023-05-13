class_name Bullet
extends RayCast3D

var linear_velocity := Vector3()


func _physics_process(delta: float) -> void:
	var new_position := global_transform.origin + linear_velocity * delta
	target_position = to_local(new_position)
	if is_colliding():
		queue_free()
	global_transform.origin = new_position
