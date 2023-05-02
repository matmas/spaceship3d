@tool
extends EditorScenePostImport

const DEFAULT_DENSITY := 3500.0  # kg per cubic meters


func _post_import(scene: Node) -> Object:
	_process_node(scene)
	return scene


func _process_node(node: Node) -> void:
	if node is MeshInstance3D:
		_set_material_defaults(node as MeshInstance3D)
	if node is RigidBody3D:
		_update_mass(node as RigidBody3D, DEFAULT_DENSITY)
	for child in node.get_children():
		_process_node(child)


# NOTE: Also modifies existing materials saved as resources when Use external is enabled
func _set_material_defaults(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance.get_parent() is PhysicsBody3D:
		for surface in mesh_instance.mesh.get_surface_count():
			var material := mesh_instance.get_active_material(surface)
			if material is BaseMaterial3D:
				var base_material := material as BaseMaterial3D
				# Enable face culling if disabled
				if base_material.cull_mode == BaseMaterial3D.CULL_DISABLED:
					base_material.cull_mode = BaseMaterial3D.CULL_BACK

				# enable material detail by default to avoid stutters when enabling them during runtime
				base_material.detail_enabled = true
				# mask needs to be black initially to keep the same appearence
				if base_material.detail_mask == null:
					base_material.detail_mask = preload("default_detail_mask.png")
				if base_material.detail_albedo == null:
					base_material.detail_albedo = preload("default_detail_albedo.png")
				if base_material.detail_normal == null:
					base_material.detail_normal = base_material.normal_texture


func _update_mass(rigid_body: RigidBody3D, density: float) -> float:
	var total_mass_calculated := 0.0
	for child in rigid_body.get_children():
		if child is MeshInstance3D:
			var mesh_instance := child as MeshInstance3D
			if rigid_body.mass == 1:  # Godot default value for mass
				var volume := _mesh_volume(mesh_instance.mesh as ArrayMesh)
				rigid_body.mass = volume * density
				total_mass_calculated += rigid_body.mass
	return total_mass_calculated


func _mesh_volume(mesh: ArrayMesh) -> float:
	# From https://github.com/godotengine/godot-proposals/issues/2293
	var volume := 0.0
	var MDT := MeshDataTool.new()
	MDT.create_from_surface(mesh, 0)
	for i in range(MDT.get_face_count()):
		var point0 := MDT.get_vertex(MDT.get_face_vertex(i, 0))
		var point1 := MDT.get_vertex(MDT.get_face_vertex(i, 1))
		var point2 := MDT.get_vertex(MDT.get_face_vertex(i, 2))
		var tri_area := _triangle_area(point0, point1, point2)
		var tri_normal := Plane(point0, point1, point2).normal
		volume += (point0.dot(tri_normal)) * tri_area
	return absf(volume) / 3


func _triangle_area(point0: Vector3, point1: Vector3, point2: Vector3) -> float:
	return 0.5 * (point1 - point0).cross(point2 - point0).length()
