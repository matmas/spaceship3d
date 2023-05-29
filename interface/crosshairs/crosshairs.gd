extends Node

@onready var steering := $Steering as Sprite2D
@onready var center_indicator := $CenterIndicator as Sprite2D
@onready var center_indicator_material := center_indicator.material as ShaderMaterial


func _ready() -> void:
	_update_crosshairs()
	Mouse.cursor_position_changed.connect(func(_cursor_position: Vector2): _update_crosshairs())


func _update_crosshairs() -> void:
	var center := get_viewport().get_visible_rect().size * 0.5

	steering.position = Mouse.get_cursor_position()
	center_indicator.position = center
