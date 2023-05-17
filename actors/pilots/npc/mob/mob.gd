extends NPC


func _ready() -> void:
	await super._ready()
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	ship.weapon_set.add_loadout(Loadouts.twin_lasers)
	ship.weapon_set.set_all_fixed(true)


func _physics_process(_delta: float) -> void:
	if player:
		point_at(player.ship.global_position)
		match_roll_with(player.ship)
		apply_thrust(thrust_to_move_to(player.ship.global_transform * Vector3(0, 0, 30)))
#		ship.weapon_set.set_all_try_firing(point_at_difference(player.ship.global_position) < 0.05)
