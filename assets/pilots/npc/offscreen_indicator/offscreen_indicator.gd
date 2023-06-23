extends Sprite2D

@onready var parent_node3d := get_parent() as Node3D
@onready var camera := get_viewport().get_camera_3d()

const PIXEL_OFFSET = 32.0
const MAX_CAMERA_DISTANCE = 1000.0


func _process(_delta: float) -> void:
	visible = not camera.is_position_in_frustum(parent_node3d.global_position)
	if visible:
		var camera_distance := camera.global_position.distance_to(parent_node3d.global_position)
		var alpha := clampf((MAX_CAMERA_DISTANCE - camera_distance) * 0.1, 0, 1)
		modulate.a = alpha
		if alpha > 0:
			# https://www.reddit.com/r/godot/comments/yovu0s/how_would_i_create_offscreen_indicators_in_a_3d/ivgg4i6/
			var viewport_center := get_viewport().get_visible_rect().size * 0.5
			var camera_to_position := camera.to_local(parent_node3d.global_position)
			var center_to_edge := Vector2(camera_to_position.x, -camera_to_position.y)
			var element := int(center_to_edge.abs().aspect() < viewport_center.aspect())
			center_to_edge *= viewport_center[element] / maxf(absf(center_to_edge[element]), 0.0001)
			position = viewport_center + center_to_edge - center_to_edge.normalized() * PIXEL_OFFSET
			rotation = center_to_edge.angle() + TAU * 0.25
