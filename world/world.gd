extends Node3D

@onready var bob := $Bob as RigidBody3D


func _ready() -> void:
	(get_viewport().get_camera_3d() as InterpolatedCamera3D).set_target(bob.get_node("Ship") as VisualInstance3D)
