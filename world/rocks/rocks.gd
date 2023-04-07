@tool
extends Node3D

# Adapted Volume.zip from https://github.com/godotengine/godot-proposals/issues/2293
var DEFAULT_DENSITY := 3500.0  # kg per cubic meters


func _ready():
	RandomSeed._ready()  # autoloads are not initialized when running as @tool
	_randomize_children_postions()

	var time1 := Time.get_ticks_msec()
	if _calculate_children_masses() > 0:
		var time2 := Time.get_ticks_msec()
		print("Mass calculation took ", time2 - time1, "ms.")


func _randomize_children_postions():
	for child in get_children():
		if child is RigidBody3D:
			var rigid_body := child as RigidBody3D
			rigid_body.position = Vector3(
				randf_range(-100, 100),
				randf_range(-100, 100),
				randf_range(-100, 100),
			)


func _calculate_children_masses() -> float:
	var total_mass_calculated := 0.0
	for child in get_children():
		if child is RigidBody3D:
			total_mass_calculated += _calculate_mass(child as RigidBody3D)
	return total_mass_calculated


func _calculate_mass(rigid_body: RigidBody3D) -> float:
	var total_mass_calculated := 0.0
	for child in rigid_body.get_children():
		if child is MeshInstance3D:
			var mesh_instance := child as MeshInstance3D
			if rigid_body.mass == 1:
				var volume := _calculate_mesh_volume(mesh_instance.mesh as ArrayMesh)
				rigid_body.mass = volume * DEFAULT_DENSITY
				total_mass_calculated += rigid_body.mass
	return total_mass_calculated


func _calculate_mesh_volume(mesh: ArrayMesh) -> float:
	var volume := 0.0
	var MDT := MeshDataTool.new()
	MDT.create_from_surface(mesh, 0)
	for i in range(MDT.get_face_count()):  # pa = point a, same for b and c
		var pa := MDT.get_vertex(MDT.get_face_vertex(i, 0))
		var pb := MDT.get_vertex(MDT.get_face_vertex(i, 1))
		var pc := MDT.get_vertex(MDT.get_face_vertex(i, 2))
		var tri_area := _calculate_triangle_area(pa, pb, pc)
		var tri_normal := Plane(pa, pb, pc).normal
		volume += (pa.dot(tri_normal)) * tri_area
	return absf(volume) / 3


func _calculate_triangle_area(point1: Vector3, point2: Vector3, point3: Vector3) -> float:
	var a := point1.distance_to(point2)
	var b := point2.distance_to(point3)
	var c := point3.distance_to(point1)
	var s := (a + b + c) / 2
	return sqrt(s * (s - a) * (s - b) * (s - c))
