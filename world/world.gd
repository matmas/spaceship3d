extends Node3D


func _ready():
	for node in find_children("", "MeshInstance3D"):
		_set_material_defaults(node as MeshInstance3D)


func _set_material_defaults(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance.get_parent() is PhysicsBody3D:
		for surface in mesh_instance.mesh.get_surface_count():
			var material := mesh_instance.get_active_material(surface)
			if material is BaseMaterial3D:
				var base_material := material as BaseMaterial3D
				# enable material detail by default to avoid stutters when enabling them during runtime
				base_material.detail_enabled = true
				# mask needs to be black initially to keep the same appearence
				if base_material.detail_mask == null:
					base_material.detail_mask = preload("res://world/default_detail_mask.png")
				if base_material.detail_albedo == null:
					base_material.detail_albedo = preload("res://world/default_detail_albedo.png")
				if base_material.detail_normal == null:
					base_material.detail_normal = base_material.normal_texture
