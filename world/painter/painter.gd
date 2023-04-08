extends Node

@onready var uv_scope := $UVScope as SubViewport
@onready var representation := $UVScope/Representation as MeshInstance3D
@onready var canvas_scene := preload("res://world/painter/canvas.tscn")

var _canvases := {}


func _ready():
	Signals.paint.connect(_paint)
#	await RenderingServer.frame_post_draw


func _paint(mesh_instance: MeshInstance3D, from_position: Vector3, to_position: Vector3):
	uv_scope.get_camera_3d().look_at_from_position(from_position, to_position)
	representation.mesh = mesh_instance.mesh
	representation.global_transform = mesh_instance.global_transform
	var image := uv_scope.get_texture().get_image()
	var color := image.get_pixel(image.get_width() / 2, image.get_height() / 2)  # warning-ignore:integer_division
	var uv := Vector2(color.r, color.g)

	var canvas := get_canvas(mesh_instance)
	var brush := canvas.get_node("Brush")

	brush.position = uv * canvas.get_texture().get_size()
	canvas.render_target_update_mode = SubViewport.UPDATE_ONCE
	var material := mesh_instance.get_active_material(0)
	if material is BaseMaterial3D:
		var base_material := material as BaseMaterial3D
		var copy := base_material.duplicate()
		mesh_instance.set_surface_override_material(0, copy)
		copy.detail_enabled = true
		copy.detail_mask = canvas.get_texture()


func get_canvas(mesh_instance: MeshInstance3D) -> SubViewport:
	if mesh_instance not in _canvases:
		var canvas := canvas_scene.instantiate()
		add_child(canvas)
		_canvases[mesh_instance] = canvas
	return _canvases[mesh_instance] as SubViewport
