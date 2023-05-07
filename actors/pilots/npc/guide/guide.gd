extends NPC


func _ready() -> void:
	super._ready()
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	await get_tree().create_timer(5).timeout
	Signals.talk.emit("p347", "Hello?")
	await get_tree().create_timer(2).timeout
	Signals.talk.emit("p347", "Are you still there?")
	await get_tree().create_timer(10).timeout
	Signals.talk.emit("p335", "This is getting weird...")


func _physics_process(_delta: float) -> void:
	if player:
		point_at(player.ship.global_position)
		match_roll_with(player.ship)
		apply_thrust(
			thrust_to_evade(player.ship.global_position)
			+ thrust_to_move_to(player.ship.global_transform * Vector3(0, 0, -20))
		)
