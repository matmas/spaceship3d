extends Marker3D

var enemy_scene := preload("res://actors/ships/enemy/enemy.tscn")


func _ready() -> void:
	add_child(enemy_scene.instantiate())
