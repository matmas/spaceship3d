@icon("set_direction_perpendicular_to_hit.svg")
class_name SetDirectionPerpendicularToHit
extends ActionLeaf

@export var direction_key := "direction"


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	if npc.last_hit_direction.is_zero_approx():
		return FAILURE

	var direction := npc.ship.global_transform.basis.z.cross(npc.last_hit_direction).cross(npc.last_hit_direction).normalized()
	blackboard.set_value(direction_key, direction)
	return SUCCESS
