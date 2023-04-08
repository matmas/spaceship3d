@tool
extends Node


func get_first_child_of_type(parent: Node, type: Variant) -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null


func update_children_masses(parent: Node, density: float) -> float:
	var total_mass_updated := 0.0
	for child in parent.get_children():
		if child is RigidBody3D:
			total_mass_updated += update_mass(child as RigidBody3D, density)
	return total_mass_updated


func update_mass(rigid_body: RigidBody3D, density: float) -> float:
	var total_mass_calculated := 0.0
	for child in rigid_body.get_children():
		if child is MeshInstance3D:
			var mesh_instance := child as MeshInstance3D
			if rigid_body.mass == 1:
				var volume := mesh_volume(mesh_instance.mesh as ArrayMesh)
				rigid_body.mass = volume * density
				total_mass_calculated += rigid_body.mass
	return total_mass_calculated


func mesh_volume(mesh: ArrayMesh) -> float:
	# From https://github.com/godotengine/godot-proposals/issues/2293
	var volume := 0.0
	var MDT := MeshDataTool.new()
	MDT.create_from_surface(mesh, 0)
	for i in range(MDT.get_face_count()):  # pa = point a, same for b and c
		var pa := MDT.get_vertex(MDT.get_face_vertex(i, 0))
		var pb := MDT.get_vertex(MDT.get_face_vertex(i, 1))
		var pc := MDT.get_vertex(MDT.get_face_vertex(i, 2))
		var tri_area := triangle_area(pa, pb, pc)
		var tri_normal := Plane(pa, pb, pc).normal
		volume += (pa.dot(tri_normal)) * tri_area
	return absf(volume) / 3


func triangle_area(point1: Vector3, point2: Vector3, point3: Vector3) -> float:
	var a := point1.distance_to(point2)
	var b := point2.distance_to(point3)
	var c := point3.distance_to(point1)
	var s := (a + b + c) / 2
	return sqrt(s * (s - a) * (s - b) * (s - c))
