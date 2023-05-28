class_name Pilot
extends Area3D

@onready var ship := get_parent() as Ship

var faction: Factions.Faction


func _ready() -> void:
	ship.pilot = self
	# pilots want to set ship weapon loadouts in their _ready so ship must be ready beforehand
	await ship.ready
