extends Node


@onready var cursor_position := _get_viewport_center()
var steering_direction := Vector2()

signal cursor_position_changed(position)


func _ready() -> void:
	get_tree().root.size_changed.connect(_on_resize)


func _on_resize() -> void:
	cursor_position = _get_cursor_position_from_steering_direction()
	cursor_position_changed.emit(cursor_position)


func _unhandled_input(event: InputEvent) -> void:
	# Click inside window
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Press Escape
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		var e := event as InputEventMouseMotion
		cursor_position += e.relative
		var viewport_center := _get_viewport_center()
		var viewport_radius = _get_viewport_radius(viewport_center)
		var i := Geometry2D.segment_intersects_circle(viewport_center, cursor_position, viewport_center, viewport_radius)
		if i != -1:
			cursor_position = (cursor_position - viewport_center) * i + viewport_center
		cursor_position_changed.emit(cursor_position)
		steering_direction = _get_steering_direction()


func _get_steering_direction() -> Vector2:
	var viewport_center := _get_viewport_center()
	var viewport_radius = _get_viewport_radius(viewport_center)
	return (cursor_position - viewport_center) / viewport_radius


func _get_cursor_position_from_steering_direction() -> Vector2:
	var viewport_center := _get_viewport_center()
	var viewport_radius = _get_viewport_radius(viewport_center)
	return steering_direction * viewport_radius + viewport_center


func _get_viewport_center() -> Vector2:
	return Vector2(get_viewport().size) / 2


func _get_viewport_radius(viewport_center: Vector2) -> float:
	return minf(viewport_center.x, viewport_center.y)
