extends Node


func interpolated_global_position(collision_object: CollisionObject3D) -> Vector3:
	for child in collision_object.get_children():
		if child is MeshInstance3D:
			# prefer physics interpolated mesh instance over jittery collision object
			return (child as MeshInstance3D).global_position
	return collision_object.global_position
