extends "res://world/characters/ship.gd"

@onready var player: Node3D = $"../../Player/Bob"


func _ready():
	super._ready()
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(_delta):
	point_at(player.global_position)
	match_roll_with(player)
