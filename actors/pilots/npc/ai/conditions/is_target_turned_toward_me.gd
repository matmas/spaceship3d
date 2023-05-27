extends ConditionLeaf

@export var target_key := "target"
@export var tolerance := 0.2


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var target := blackboard.get_value(target_key) as Node3D
	if not target:
		return FAILURE

	var direction_from_target_to_actor := target.global_position.direction_to(npc.ship.global_position)
	var direction_of_target := -target.global_transform.basis.z
	return SUCCESS if (direction_from_target_to_actor - direction_of_target).length() < tolerance else FAILURE
