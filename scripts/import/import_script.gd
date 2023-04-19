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
					base_material.detail_mask = preload("res://scripts/import/default_detail_mask.png")
				if base_material.detail_albedo == null:
					base_material.detail_albedo = preload("res://scripts/import/default_detail_albedo.png")
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
	for i in range(MDT.get_face_count()):  # pa = point a, same for b and c
		var pa := MDT.get_vertex(MDT.get_face_vertex(i, 0))
		var pb := MDT.get_vertex(MDT.get_face_vertex(i, 1))
		var pc := MDT.get_vertex(MDT.get_face_vertex(i, 2))
		var tri_area := _triangle_area(pa, pb, pc)
		var tri_normal := Plane(pa, pb, pc).normal
		volume += (pa.dot(tri_normal)) * tri_area
	return absf(volume) / 3


func _triangle_area(point1: Vector3, point2: Vector3, point3: Vector3) -> float:
	var a := point1.distance_to(point2)
	var b := point2.distance_to(point3)
	var c := point3.distance_to(point1)
	var s := (a + b + c) / 2
	return sqrt(s * (s - a) * (s - b) * (s - c))
