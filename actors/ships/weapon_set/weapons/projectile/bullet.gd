class_name Bullet
extends RayCast3D

var linear_velocity := Vector3()


func _process(delta: float) -> void:
	if is_colliding():
		queue_free()
	global_position += linear_velocity * delta
	target_position = to_local(global_position + linear_velocity * (get_physics_process_delta_time() + get_physics_process_delta_time() * (1 - Engine.get_physics_interpolation_fraction())))
