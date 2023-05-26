extends ConditionLeaf

@export var max_time_after_hit_msec := 1000.0


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	return SUCCESS if Time.get_ticks_msec() <= npc.last_hit_time + max_time_after_hit_msec else FAILURE
