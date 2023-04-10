class_name Painter extends Node

@onready var uv_scope := $UVScope as SubViewport
@onready var representation := $UVScope/Representation as MeshInstance3D
@onready var brush := $Brush as TextureRect
@onready var canvas_scene := preload("res://painter/canvas.tscn") as PackedScene
@onready var CANVAS_SCENE_NAME := canvas_scene.instantiate().name

var _last_uv: Vector2
var _last_mesh_instance: MeshInstance3D
var _last_brush_transform: Transform3D


func paint_line(mesh_instance: MeshInstance3D, transform_start: Transform3D, transform_end: Transform3D):
	var canvas := _get_or_create_canvas(mesh_instance)
	var uv_start := _uv_of_brush_position(mesh_instance, transform_start)
	var uv_end := _uv_of_brush_position(mesh_instance, transform_end) if transform_start != transform_end else uv_start

	# skip large distances as UV maps are often non-linear
	# otherwise lines can bridge large distances even across UV boundaries
	if uv_start.distance_to(uv_end) > 0.1:
		uv_start = uv_end
	brush.reparent(canvas)
	brush.visible = true
	var brush_material := brush.material as ShaderMaterial
	brush_material.set_shader_parameter("line_start", uv_start)
	brush_material.set_shader_parameter("line_end", uv_end)
	canvas.render_target_update_mode = SubViewport.UPDATE_ONCE
	_setup_materials(mesh_instance, canvas)


func _uv_of_brush_position(mesh_instance: MeshInstance3D, brush_transform: Transform3D) -> Vector2:
	if mesh_instance == _last_mesh_instance and brush_transform == _last_brush_transform:
		return _last_uv
	uv_scope.get_camera_3d().global_transform = brush_transform
	representation.mesh = mesh_instance.mesh
	representation.global_transform = mesh_instance.global_transform
	var image := uv_scope.get_texture().get_image()
	var center := image.get_size() / 2
	var color := image.get_pixel(center.x, center.y)
	var uv := Vector2(color.r, color.g)
	_last_mesh_instance = mesh_instance
	_last_brush_transform = brush_transform
	_last_uv = uv
	return uv


func _get_or_create_canvas(mesh_instance: MeshInstance3D) -> SubViewport:
	var canvas := mesh_instance.find_child(CANVAS_SCENE_NAME, false, false) as SubViewport
	if canvas == null:
		canvas = canvas_scene.instantiate() as SubViewport
		mesh_instance.add_child(canvas)
	return canvas


func _setup_materials(mesh_instance: MeshInstance3D, canvas: SubViewport):
	var material := mesh_instance.get_active_material(0)
	mesh_instance.set_surface_override_material(0, _setup_material_for_canvas(material, canvas))


func _setup_material_for_canvas(material: Material, canvas: SubViewport) -> Material:
	if material is BaseMaterial3D:
		var unique_material := _unique_material(material)
		if material != unique_material:
			# previously non-unique are not configured yet
			_configure_material_for_canvas(unique_material, canvas)
		return unique_material
	return material  # unsupported material type


func _unique_material(material: Material) -> Material:
	if material.has_meta(&"unique"):
		return material
	var copy := material.duplicate() as Material
	copy.set_meta(&"unique", true)
	return copy


func _configure_material_for_canvas(material: Material, canvas: SubViewport) -> void:
	if material is BaseMaterial3D:
		var base_material := material as BaseMaterial3D
		base_material.detail_enabled = true
		base_material.detail_mask = canvas.get_texture()
