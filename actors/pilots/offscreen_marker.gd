extends Node3D

@onready var visible_on_screen_notifier := $VisibleOnScreenNotifier as VisibleOnScreenNotifier3D
@onready var marker := $Marker as Sprite2D
@onready var camera := get_viewport().get_camera_3d()

const PIXEL_OFFSET = 32.0


func _ready() -> void:
	on_visibility_changed()
	visibility_changed.connect(on_visibility_changed)
	visible_on_screen_notifier.screen_entered.connect(on_screen_entered)
	visible_on_screen_notifier.screen_exited.connect(on_screen_exited)


func on_visibility_changed() -> void:
	marker.visible = visible and not visible_on_screen_notifier.is_on_screen()


func on_screen_entered() -> void:
	marker.visible = false
	set_process(false)


func on_screen_exited() -> void:
	marker.visible = true
	set_process(true)


func _process(_delta: float) -> void:
	# https://www.reddit.com/r/godot/comments/yovu0s/how_would_i_create_offscreen_indicators_in_a_3d/ivgg4i6/
	var viewport_center := get_viewport().get_visible_rect().size * 0.5
	var camera_to_position := camera.to_local(global_position)
	var center_to_edge := Vector2(camera_to_position.x, -camera_to_position.y)
	var element := int(center_to_edge.abs().aspect() < viewport_center.aspect())
	center_to_edge *= viewport_center[element] / maxf(absf(center_to_edge[element]), 0.0001)
	marker.position = viewport_center + center_to_edge - center_to_edge.normalized() * PIXEL_OFFSET
	marker.rotation = center_to_edge.angle() + TAU * 0.25
