extends Node

var ship_factory := ShipFactory.new()
@onready var world := $World as Node3D


func _ready() -> void:
	var player := ship_factory.build_ship(ship_factory.bob, ship_factory.twin_lasers)
	player.set_script(preload("res://actors/ships/behaviors/player.gd"))
	player.add_child(preload("res://actors/ships/weapons/laser/sparks/sparks.tscn").instantiate())
	for child in player.get_children():
		if child is MeshInstance3D:
			var mesh_instance := child as MeshInstance3D
			mesh_instance.add_child(AudioListener3D.new())
	world.add_child(player)
	get_viewport().get_camera_3d().set_target(player.get_node("Ship"))

	var guide := ship_factory.build_ship(ship_factory.challenger, ship_factory.twin_lasers)
	guide.set_script(preload("res://actors/ships/behaviors/guide.gd"))
	world.add_child(guide)

	var enemy := ship_factory.build_ship(ship_factory.dispatcher, ship_factory.twin_lasers)
	enemy.set_script(preload("res://actors/ships/behaviors/enemy.gd"))
	world.add_child(enemy)
