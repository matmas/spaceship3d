extends Marker3D

var enemy_scene := preload("res://actors/enemy/enemy.tscn")


func _ready() -> void:
	add_child(enemy_scene.instantiate())
