extends Sprite2D

@onready var steering := $Steering as Sprite2D


func _ready() -> void:
	_update_crosshairs()
	Mouse.cursor_position_changed.connect(func(_cursor_position: Vector2): _update_crosshairs())


func _update_crosshairs() -> void:
	position = get_viewport().size * 0.5
	steering.global_position = Mouse.get_cursor_position()
