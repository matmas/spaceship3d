class_name Integrity
extends Node3D

@onready var ship := Utils.get_rigid_body_ancestor(self) as Ship


func _ready() -> void:
	await ship.ready
	ship.hit.connect(_process_ship_hit)
	ship.shield.hit.connect(_process_shield_hit)


func _process_ship_hit(_weapon: Weapon, _source: Node3D, _impact_point: Vector3) -> void:
	ship.object_ui.hull_integrity_bar.max_value = ship.max_integrity
	ship.object_ui.hull_integrity_bar.value = ship.current_integrity


func _process_shield_hit(_weapon: Weapon, _source: Node3D, _impact_point: Vector3) -> void:
	ship.object_ui.shield_integrity_bar.max_value = ship.shield.max_integrity
	ship.object_ui.shield_integrity_bar.value = ship.shield.current_integrity
