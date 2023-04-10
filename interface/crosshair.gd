extends Sprite2D


func _ready() -> void:
	position = Mouse.cursor_position
	Mouse.cursor_position_changed.connect(func(p: Vector2): position = p)
