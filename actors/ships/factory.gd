class_name ShipFactory
extends Node

var twin_lasers := {
	^"Ship/WeaponLeft": Weapons.laser,
	^"Ship/WeaponRight": Weapons.laser,
}

var weapon_loadouts := [
	twin_lasers
]


func build_ship(prototype: PackedScene, loadout: Dictionary) -> Ship:
	var ship := prototype.instantiate()
	for attachment_name in loadout:
		var weapon = loadout[attachment_name].instantiate()
		ship.get_node(attachment_name).add_child(weapon)
		weapon.owner = ship  # self-hitting testing via owner
	return ship
