@tool
extends Node3D

const ROCK_DENSITY := 3500.0  # kg per cubic meters


func _ready() -> void:
	RandomSeed._ready()  # autoloads are not initialized when running as @tool
	_randomize_children_postions()


func _randomize_children_postions() -> void:
	for child in get_children():
		if child is RigidBody3D:
			var rigid_body := child as RigidBody3D
			rigid_body.position = Vector3(
				randf_range(-100, 100),
				randf_range(-100, 100),
				randf_range(-100, 100),
			)
