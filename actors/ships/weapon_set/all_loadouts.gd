extends Node


var twin_lasers := {
	^"Left": Weapons.laser,
	^"Right": Weapons.laser,
}

var projectiles := {
	^"Left": Weapons.projectile,
	^"Right": Weapons.projectile,
}

var combined := {
	^"Left": Weapons.laser,
	^"Right": Weapons.projectile,
}
