extends NPC


func _ready() -> void:
	await super._ready()
	ship.position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	ship.weapon_set.add_loadout(Loadouts.twin_guns)
	ship.weapon_set.set_all_fixed(true)
	faction = Factions.Faction.Civilians
