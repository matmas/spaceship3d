extends NPC

var being_hit_from_direction := Vector3()


func _ready() -> void:
	await super._ready()
	ship.hit.connect(_process_hit)
	ship.shield.hit.connect(_process_hit)
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	ship.weapon_set.add_loadout(Loadouts.projectiles)
	ship.weapon_set.set_all_fixed(true)


func _physics_process(_delta: float) -> void:
	if being_hit_from_direction:
		point_in_direction(evasion_direction(being_hit_from_direction))
		apply_thrust(thrust_to_evade_hit_from(being_hit_from_direction))

	if player:
		match_roll_with(player.ship)
		if being_hit_from_direction.is_zero_approx():
			point_at(player.ship.global_position)
			match_roll_with(player.ship)
			apply_thrust(collision_avoidance_thrust() + thrust_to_move_to(player.ship.global_transform * Vector3(0, 0, 30)))
		ship.weapon_set.set_all_try_firing(point_at_difference(player.ship.global_position) < 0.05)


func _process_hit(source: Node3D, _impact_point: Vector3) -> void:
	being_hit_from_direction = global_position.direction_to(source.global_position)
