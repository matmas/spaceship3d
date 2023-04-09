class_name Painter extends Node

@onready var uv_scope := $UVScope as SubViewport
@onready var representation := $UVScope/Representation as MeshInstance3D
@onready var brush := $Brush as TextureRect
@onready var canvas_scene := preload("res://painter/canvas.tscn") as PackedScene
@onready var CANVAS_SCENE_NAME := canvas_scene.instantiate().name


func paint_line(mesh_instance: MeshInstance3D, transform_start: Transform3D, transform_end: Transform3D):
	var canvas := _get_or_create_canvas(mesh_instance)
	var uv_end := await _uv_of_brush_position(mesh_instance, transform_end)
	var uv_start := await _uv_of_brush_position(mesh_instance, transform_start) if transform_start != transform_end else uv_end
	if uv_start.distance_to(uv_end) > 0.1:  # skip large distances as UV maps are often non-linear
		uv_start = uv_end
	brush.reparent(canvas)
	brush.visible = true
	var brush_material := brush.material as ShaderMaterial
	brush_material.set_shader_parameter("line_start", uv_start)
	brush_material.set_shader_parameter("line_end", uv_end)
	canvas.render_target_update_mode = SubViewport.UPDATE_ONCE
	_setup_material(mesh_instance, canvas)


func _uv_of_brush_position(mesh_instance: MeshInstance3D, brush_transform: Transform3D) -> Vector2:
	uv_scope.get_camera_3d().global_transform = brush_transform
	representation.mesh = mesh_instance.mesh
	representation.global_transform = mesh_instance.global_transform
	await RenderingServer.frame_post_draw
	var image := uv_scope.get_texture().get_image()
	var center := image.get_size() / 2
	var color := image.get_pixel(center.x, center.y)
	return Vector2(color.r, color.g)


func _get_or_create_canvas(mesh_instance: MeshInstance3D) -> SubViewport:
	var canvas := mesh_instance.find_child(CANVAS_SCENE_NAME, false, false) as SubViewport
	if canvas == null:
		canvas = canvas_scene.instantiate()
		mesh_instance.add_child(canvas)
	return canvas


func _setup_material(mesh_instance: MeshInstance3D, canvas: SubViewport):
	var material := mesh_instance.get_active_material(0)
	if material is BaseMaterial3D:
		var base_material := material as BaseMaterial3D
		if not base_material.has_meta(&"unique"):
			var copy := base_material.duplicate() as BaseMaterial3D
			copy.detail_enabled = true
			copy.detail_mask = canvas.get_texture()
			copy.set_meta(&"unique", true)
			mesh_instance.set_surface_override_material(0, copy)
