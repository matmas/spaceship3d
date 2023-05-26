extends NPC


func _ready() -> void:
	super._ready()
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
