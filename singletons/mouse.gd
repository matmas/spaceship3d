extends Node

@onready var resolution_independent_cursor_position := Vector2(0.5, 0.5)
@onready var viewport_size := get_viewport().get_visible_rect().size

signal cursor_position_changed(position)


func _ready() -> void:
	get_tree().root.size_changed.connect(_on_resize)


func _on_resize() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	cursor_position_changed.emit(get_cursor_position())


func _unhandled_input(event: InputEvent) -> void:
	# Click inside window
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Press Escape
	if event is InputEventKey and event.is_action_pressed(&"ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		var e := event as InputEventMouseMotion
		_set_cursor_position(get_cursor_position() + e.relative)
		var viewport_center := viewport_size * 0.5
		var max_distance_from_center := minf(viewport_center.x, viewport_center.y)
		_set_cursor_position(get_limited_cursor_position(max_distance_from_center))
		cursor_position_changed.emit(get_cursor_position())


func get_cursor_position() -> Vector2:
	return resolution_independent_cursor_position * viewport_size


func _set_cursor_position(cursor_position: Vector2) -> void:
	resolution_independent_cursor_position = cursor_position / viewport_size


func get_limited_cursor_position(max_distance_from_center: float) -> Vector2:
	var cursor_position := get_cursor_position()
	var viewport_center := viewport_size * 0.5
	var i := Geometry2D.segment_intersects_circle(viewport_center, cursor_position, viewport_center, max_distance_from_center)
	if i == -1:
		return cursor_position
	# snap cursor to circle edge if it is outside
	return (cursor_position - viewport_center) * i + viewport_center
