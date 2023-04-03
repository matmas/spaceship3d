extends MeshInstance3D

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics
var previous_global_transform := Transform3D()
var current_global_transform := Transform3D()
var physics_updated := false

func _ready():
	top_level = true
	global_transform = target.global_transform
	previous_global_transform = target.global_transform
	current_global_transform = target.global_transform


func _physics_process(_delta):
	physics_updated = true


func _process(_delta):
	if physics_updated:  # update at most once per frame when FPS < physics ticks per second
		physics_updated = false
		previous_global_transform = current_global_transform
		current_global_transform = target.global_transform

	global_transform = target.global_transform
	var f := Engine.get_physics_interpolation_fraction()
	global_transform = previous_global_transform.interpolate_with(current_global_transform, f)
