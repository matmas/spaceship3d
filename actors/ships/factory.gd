class_name ShipFactory
extends Node

var bob := preload("prototypes/bob.tscn")
var challenger := preload("prototypes/challenger.tscn")
var dispatcher := preload("prototypes/dispatcher.tscn")

var prototypes := [
	bob,
	challenger,
	dispatcher,
]

var laser := preload("weapons/laser/laser.tscn")

var weapons := [
	laser,
]

var twin_lasers := {
	^"Ship/WeaponLeft": laser,
	^"Ship/WeaponRight": laser,
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
