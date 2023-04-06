extends Sprite2D

var cursor_position := Vector2.ZERO


func _ready():
	cursor_position = Vector2(get_viewport().size) / 2
	position = cursor_position


func _unhandled_input(event):
	# Click inside window
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Press Escape
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		var e := event as InputEventMouseMotion
		cursor_position += e.relative
		var viewport_center := Vector2(get_viewport().size) / 2
		var viewport_radius = min(viewport_center.x, viewport_center.y)
		var i := Geometry2D.segment_intersects_circle(viewport_center, cursor_position, viewport_center, viewport_radius)
		if i != -1:
			cursor_position = (cursor_position - viewport_center) * i + viewport_center
		position = cursor_position
		var steering_direction = (cursor_position - viewport_center) / viewport_radius
		Signals.steering_direction_changed.emit(steering_direction)
		Signals.cursor_position_changed.emit(cursor_position)
