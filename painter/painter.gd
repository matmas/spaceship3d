class_name Painter extends Node

@onready var uv_scope := $UVScope as SubViewport
@onready var representation := $UVScope/Representation as MeshInstance3D
@onready var brush := $Brush as TextureRect
@onready var canvas_scene := preload("res://painter/canvas.tscn") as PackedScene
@onready var CANVAS_SCENE_NAME := canvas_scene.instantiate().name

var _last_uv: Vector2


func paint_line(mesh_instance: MeshInstance3D, transform: Transform3D) -> void:
	var canvas := _get_or_create_canvas(mesh_instance)
	var uv_color := _uv_color_of_brush_position(mesh_instance, transform)

	var uv_start := _last_uv
	var uv_end := _uv_from_uv_color(uv_color)
	_last_uv = uv_end

	# skip large distances as UV maps are often non-linear
	# otherwise lines can bridge large distances even across UV boundaries
	if uv_start.distance_to(uv_end) > 0.1:
		uv_start = uv_end
	brush.reparent(canvas)
	brush.visible = true
	var brush_material := brush.material as ShaderMaterial
	brush_material.set_shader_parameter(&"line_start", uv_start)
	brush_material.set_shader_parameter(&"line_end", uv_end)
	canvas.render_target_update_mode = SubViewport.UPDATE_ONCE
	_switch_to_paintable_material(mesh_instance, canvas)


func _uv_color_of_brush_position(mesh_instance: MeshInstance3D, brush_transform: Transform3D) -> Color:
	uv_scope.get_camera_3d().global_transform = brush_transform
	representation.mesh = mesh_instance.mesh
	representation.global_transform = mesh_instance.global_transform
	var image := uv_scope.get_texture().get_image()
	var center := image.get_size() / 2
	return image.get_pixel(center.x, center.y)


func _uv_from_uv_color(color: Color) -> Vector2:
	return Vector2(color.r, color.g)


func _get_or_create_canvas(mesh_instance: MeshInstance3D) -> SubViewport:
	var canvas := mesh_instance.find_child(CANVAS_SCENE_NAME, false, false) as SubViewport
	if canvas == null:
		canvas = canvas_scene.instantiate() as SubViewport
		mesh_instance.add_child(canvas)
	return canvas


func _switch_to_paintable_material(mesh_instance: MeshInstance3D, canvas: SubViewport, surface: int = 0) -> void:
	if mesh_instance.material_override:
		mesh_instance.material_override = _make_material_paintable_unique(mesh_instance.material_override, canvas)
	else:
		if mesh_instance.get_surface_override_material(surface):
			mesh_instance.set_surface_override_material(surface, _make_material_paintable_unique(mesh_instance.get_surface_override_material(surface), canvas))
		elif mesh_instance.mesh.surface_get_material(surface):
			mesh_instance.mesh.surface_set_material(surface, _make_material_paintable_unique(mesh_instance.mesh.surface_get_material(surface), canvas))


func _make_material_paintable_unique(material: Material, canvas: SubViewport) -> Material:
	if material is BaseMaterial3D:
		var unique_material := _make_material_unique(material)
		if material != unique_material:
			# previously non-unique are not configured yet
			_make_material_paintable(unique_material, canvas)
		return unique_material
	return material  # unsupported material type


func _make_material_unique(material: Material) -> Material:
	if material.has_meta(&"unique"):
		return material
	var copy := material.duplicate() as Material
	copy.set_meta(&"unique", true)
	return copy


func _make_material_paintable(material: Material, canvas: SubViewport) -> void:
	if material is BaseMaterial3D:
		var base_material := material as BaseMaterial3D
		base_material.detail_enabled = true
		base_material.detail_mask = canvas.get_texture()
