extends Node

@onready var resolution_independent_cursor_position := Vector2(0.5, 0.5)

signal cursor_position_changed(position)


func get_cursor_position() -> Vector2:
	return resolution_independent_cursor_position * Vector2(get_viewport().size)


func set_cursor_position(cursor_position: Vector2) -> void:
	resolution_independent_cursor_position = cursor_position / Vector2(get_viewport().size)


func _ready() -> void:
	get_tree().root.size_changed.connect(_on_resize)


func _on_resize() -> void:
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
		set_cursor_position(get_cursor_position() + e.relative)
		var viewport_center := Vector2(get_viewport().size) / 2
		var viewport_radius = minf(viewport_center.x, viewport_center.y)
		var i := Geometry2D.segment_intersects_circle(viewport_center, get_cursor_position(), viewport_center, viewport_radius)
		if i != -1:
			set_cursor_position((get_cursor_position() - viewport_center) * i + viewport_center)
		cursor_position_changed.emit(get_cursor_position())
