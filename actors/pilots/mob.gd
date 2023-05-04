extends NPC


func _ready() -> void:
	super._ready()
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(_delta: float) -> void:
	if player:
		point_at(player.ship.global_position)
		match_roll_with(player.ship)
		move_to(player.ship.global_transform * Vector3(0, 0, 30))
