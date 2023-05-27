extends ConditionLeaf

@export var target_key := "target"
@export var tolerance := 0.05


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var target := blackboard.get_value(target_key) as Node3D
	if not target:
		return FAILURE

	var target_direction := npc.ship.global_position.direction_to(target.global_position)
	var current_direction := -npc.ship.global_transform.basis.z
	return SUCCESS if (target_direction - current_direction).length() < tolerance else FAILURE
