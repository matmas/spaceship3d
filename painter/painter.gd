class_name Painter extends Node

@onready var uv_scope := $UVScope as SubViewport
@onready var representation := $UVScope/Representation as MeshInstance3D
@onready var brush := $Brush as TextureRect
@onready var canvas_scene := preload("res://painter/canvas.tscn") as PackedScene
@onready var CANVAS_SCENE_NAME := canvas_scene.instantiate().name

const MAX_SURFACE_INDEX := 255

var _last_uv_color: Color
var _last_mesh_instance: MeshInstance3D
var _last_brush_transform: Transform3D


func paint_line(mesh_instance: MeshInstance3D, transform_start: Transform3D, transform_end: Transform3D):
	var canvases := _get_or_create_canvases(mesh_instance)
	var uv_color_start := _uv_color_from_brush_position(mesh_instance, transform_start)
	var uv_color_end := _uv_color_from_brush_position(mesh_instance, transform_end) if transform_start != transform_end else uv_color_start
	var uv_start := _get_uv_from_uv_color(uv_color_start)
	var uv_end := _get_uv_from_uv_color(uv_color_end)
	var surface_start := _get_surface_from_uv_color(uv_color_start)
	var surface_end := _get_surface_from_uv_color(uv_color_end)
	var surface := mini(surface_end, len(canvases) - 1)
	# skip large distances as UV maps are often non-linear
	# otherwise lines can bridge large distances even across UV boundaries
	if uv_start.distance_to(uv_end) > 0.1 or surface_start != surface_end:
		uv_start = uv_end

	var canvas = canvases[surface]
	brush.reparent(canvas)
	brush.visible = true
	var brush_material := brush.material as ShaderMaterial
	brush_material.set_shader_parameter("line_start", uv_start)
	brush_material.set_shader_parameter("line_end", uv_end)
	canvas.render_target_update_mode = SubViewport.UPDATE_ONCE
	_setup_materials(mesh_instance, canvases)


func _uv_color_from_brush_position(mesh_instance: MeshInstance3D, brush_transform: Transform3D) -> Color:
	if mesh_instance == _last_mesh_instance and brush_transform == _last_brush_transform:
		return _last_uv_color
	uv_scope.get_camera_3d().global_transform = brush_transform
	representation.mesh = mesh_instance.mesh
	representation.global_transform = mesh_instance.global_transform
	var image := uv_scope.get_texture().get_image()
	var center := image.get_size() / 2
	var uv_color := image.get_pixel(center.x, center.y)
	_last_mesh_instance = mesh_instance
	_last_brush_transform = brush_transform
	_last_uv_color = uv_color
	return uv_color


func _get_uv_from_uv_color(color: Color) -> Vector2:
	return Vector2(color.r, color.g)


func _get_surface_from_uv_color(color: Color) -> int:
	return roundi(color.b * MAX_SURFACE_INDEX)


func _get_or_create_canvases(mesh_instance: MeshInstance3D) -> Array:
	var canvases := mesh_instance.find_children("", "SubViewport", false, false)
	if canvases == []:
		if mesh_instance.material_override:
			mesh_instance.add_child(canvas_scene.instantiate())
		else:
			for surface in range(mesh_instance.mesh.get_surface_count()):
				mesh_instance.add_child(canvas_scene.instantiate())
		canvases = _get_or_create_canvases(mesh_instance)
		assert(canvases != [])
	return canvases


func _setup_materials(mesh_instance: MeshInstance3D, canvases: Array):
	if mesh_instance.material_override:
		mesh_instance.material_override = _setup_material(mesh_instance.material_override, canvases[0])
	else:
		for surface in mesh_instance.mesh.get_surface_count():
			if mesh_instance.get_surface_override_material(surface):
				mesh_instance.set_surface_override_material(surface, _setup_material(mesh_instance.get_surface_override_material(surface), canvases[surface]))
			elif mesh_instance.mesh.surface_get_material(surface):
				mesh_instance.mesh.surface_set_material(surface, _setup_material(mesh_instance.mesh.surface_get_material(surface), canvases[surface]))


func _setup_material(material: Material, canvas: SubViewport) -> Material:
	if material is BaseMaterial3D:
		var unique_material := _unique_material(material)
		if material != unique_material:
			return _configure_material(unique_material, canvas)
		return unique_material
	return material


func _unique_material(material: Material) -> Material:
	if material.has_meta(&"unique"):
		return material
	var copy := material.duplicate() as Material
	copy.set_meta(&"unique", true)
	return copy


func _configure_material(material: Material, canvas: SubViewport):
	if material is BaseMaterial3D:
		var base_material := material as BaseMaterial3D
		base_material.detail_enabled = true
		base_material.detail_mask = canvas.get_texture()
