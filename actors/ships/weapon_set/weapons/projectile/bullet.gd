class_name Bullet
extends RefCounted

var transform: Transform3D
var linear_velocity: Vector3
var exclude: Array[RID]
var world: World3D


func _init(bullet_transform: Transform3D, bullet_linear_velocity: Vector3, excluded: Array[RID], world3d: World3D) -> void:
	transform = bullet_transform
	linear_velocity = bullet_linear_velocity
	exclude = excluded
	world = world3d


func move_and_collide(delta: float) -> Vector3:
	var new_position := transform.origin + linear_velocity * delta
	var params := PhysicsRayQueryParameters3D.new()
	params.from = transform.origin
	params.to = new_position
	params.exclude = exclude
	var result := world.direct_space_state.intersect_ray(params)
	transform.origin = new_position
	return result.position if result else Vector3()
