extends Node3D

@onready var ship := get_parent()


func _ready():
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(delta):
	pass
