class_name Hittable
extends RigidBody3D

signal hit(weapon, source, impact_point)

var integrity := 100.0
var max_integrity := 100.0


func _ready() -> void:
	hit.connect(_process_hit)


func _process_hit(weapon: Weapon, _source: Node3D, _impact_point: Vector3) -> void:
	integrity = maxf(0.0, integrity - weapon.damage_per_hit())
