extends Node

@onready var steering := $Steering as Sprite2D
@onready var center_indicator := $CenterIndicator as Sprite2D


func _ready() -> void:
	_update_crosshairs()
	Mouse.cursor_position_changed.connect(func(_cursor_position: Vector2): _update_crosshairs())


func _update_crosshairs() -> void:
	var center := Vector2(get_viewport().size) * 0.5
	center_indicator.position = center
	steering.position = Mouse.get_cursor_position()
	center_indicator.modulate.a = minf(1.0 - steering.position.distance_to(center) * 0.01, 1)
