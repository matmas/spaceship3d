extends Node


func _ready() -> void:
	var debug_menu := get_tree().root.get_node_or_null("DebugMenu")
	if debug_menu:
		debug_menu.style = debug_menu.Style.VISIBLE_DETAILED
