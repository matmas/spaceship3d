class_name Pilot
extends Area3D


@onready var ship := get_parent() as Ship


func _ready() -> void:
	ship.pilot = self
	await ship.ready
