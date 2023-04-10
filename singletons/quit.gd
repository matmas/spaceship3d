extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.get_physical_keycode_with_modifiers() == KEY_MASK_CTRL | KEY_Q:
			get_tree().quit()
