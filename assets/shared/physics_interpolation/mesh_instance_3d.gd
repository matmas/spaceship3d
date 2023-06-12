extends MeshInstance3D

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics

var previous_global_transform := Transform3D()
var current_global_transform := Transform3D()


func _ready():
	# Process interpolation before camera
	process_priority = -2

	top_level = true
	global_transform = target.global_transform
	previous_global_transform = target.global_transform
	current_global_transform = target.global_transform


func _physics_process(_delta):
	previous_global_transform = current_global_transform
	current_global_transform = target.global_transform


func _process(_delta):
	global_transform = target.global_transform
	var f := Engine.get_physics_interpolation_fraction()
	global_transform = previous_global_transform.interpolate_with(current_global_transform, f)
