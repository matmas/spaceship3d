extends Node

@onready var steering := $Steering as Sprite2D
@onready var steering_material := steering.material as ShaderMaterial


func _ready() -> void:
	_update_crosshairs()
	Mouse.cursor_position_changed.connect(func(_cursor_position: Vector2): _update_crosshairs())


func _update_crosshairs() -> void:
	var center := Vector2(get_viewport().size) * 0.5
	steering.position = Mouse.get_cursor_position()
	steering_material.set_shader_parameter(&"indicator_position", (center - steering.position) / Vector2(get_viewport().size))
