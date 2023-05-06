class_name Pilot
extends Area3D


@onready var ship := get_parent() as Ship


func _ready() -> void:
	ship.pilot = self


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	pass
