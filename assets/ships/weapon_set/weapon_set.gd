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


func set_all_belongs_to_player(belongs_to_player: bool) -> void:
	for place in get_children():
		for child in place.get_children():
			(child as Weapon).belongs_to_player = belongs_to_player


func get_average_projectile_speed() -> float:
	var sum := 0.0
	var count := 0
	for place in get_children():
		for child in place.get_children():
			var speed := (child as Weapon).projectile_speed
			if speed != INF:
				sum += speed
				count += 1
	return INF if count == 0 else sum / count


func add_loadout(loadout: Dictionary):
	for attachment_name in loadout:
		var weapon = loadout[attachment_name].instantiate()
		get_node(attachment_name).add_child(weapon)
