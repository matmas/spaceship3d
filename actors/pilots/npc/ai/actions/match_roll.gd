@icon("match_roll.svg")
class_name MatchRoll
extends ActionLeaf

@export var target_key := "target"


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var target := blackboard.get_value(target_key) as Node3D
	if not target:
		return FAILURE

	var projected_target_up := Plane(npc.ship.global_transform.basis.z).project(target.global_transform.basis.y)
	if projected_target_up.length() < 0.1:
		return SUCCESS  # prevent constant rolling due to parallel forward and target up vectors
	var correction := projected_target_up - npc.ship.global_transform.basis.y
	npc.ship.apply_torque(correction.cross(-npc.ship.global_transform.basis.y).normalized() * minf(correction.length(), 1) * npc.ship.max_angular_acceleration().z)
	return SUCCESS if correction.length() < 0.2 else RUNNING
