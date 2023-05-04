extends NPC


func _ready() -> void:
#	set_ship_variant(Variants.dispatcher)
	super._ready()
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(_delta: float) -> void:
	if player:
		point_at(player.global_position)
		match_roll_with(player)
		move_to(player.global_transform * Vector3(0, 0, 30))
