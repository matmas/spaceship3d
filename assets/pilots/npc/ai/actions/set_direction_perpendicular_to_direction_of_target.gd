@icon("set_direction_perpendicular_to_direction_of_target.svg")
class_name SetDirectionPerpendicularToDirectionOfTarget
extends ActionLeaf

@export var target_key := "target"
@export var direction_key := "direction"


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var target := blackboard.get_value(target_key) as Node3D
	if not target:
		return FAILURE

	var direction_of_target := -target.global_transform.basis.z
	var direction := npc.ship.global_transform.basis.z.cross(direction_of_target).cross(direction_of_target).normalized()
	blackboard.set_value(direction_key, direction)
	return SUCCESS
