class_name WeaponSet
extends Node3D


func set_all_firing(is_firing: bool) -> void:
	for place in get_children():
		for weapon in place.get_children():
			(weapon as Weapon).is_firing = is_firing


func add_loadout(loadout: Dictionary):
	for attachment_name in loadout:
		var weapon = loadout[attachment_name].instantiate()
		get_node(attachment_name).add_child(weapon)
