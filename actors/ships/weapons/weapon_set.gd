class_name WeaponSet
extends Node3D


func set_all_firing(is_firing: bool) -> void:
	for place in get_children():
		for weapon in place.get_children():
			(weapon as Weapon).is_firing = is_firing
