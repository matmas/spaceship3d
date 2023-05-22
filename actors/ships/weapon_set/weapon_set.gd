class_name WeaponSet
extends Node3D


func set_all_try_firing(try_firing: bool) -> void:
	for place in get_children():
		for weapon in place.get_children():
			(weapon as Weapon).try_firing = try_firing


func set_all_fixed(is_fixed: bool) -> void:
	for place in get_children():
		for weapon in place.get_children():
			(weapon as Weapon).is_fixed = is_fixed


func set_all_ui_visibility(is_ui_visible: bool) -> void:
	for place in get_children():
		for child in place.get_children():
			(child as Weapon).is_ui_visible = is_ui_visible


func add_loadout(loadout: Dictionary):
	for attachment_name in loadout:
		var weapon = loadout[attachment_name].instantiate()
		get_node(attachment_name).add_child(weapon)
