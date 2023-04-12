extends MeshInstance3D

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics
var previous_global_transform := Transform3D()
var current_global_transform := Transform3D()


func _ready():
	top_level = true
	global_transform = target.global_transform
	previous_global_transform = target.global_transform
	current_global_transform = target.global_transform
	_set_material_defaults()


func _physics_process(_delta):
	previous_global_transform = current_global_transform
	current_global_transform = target.global_transform


func _process(_delta):
	global_transform = target.global_transform
	var f := Engine.get_physics_interpolation_fraction()
	global_transform = previous_global_transform.interpolate_with(current_global_transform, f)


func _set_material_defaults():
	for surface in mesh.get_surface_count():
		var material := get_active_material(surface)
		if material is BaseMaterial3D:
			var base_material := material as BaseMaterial3D
			# enable material detail by default to avoid stutters when enabling them during runtime
			base_material.detail_enabled = true
			if base_material.detail_mask == null:
				base_material.detail_mask = preload("res://world/default_detail_mask.png")
