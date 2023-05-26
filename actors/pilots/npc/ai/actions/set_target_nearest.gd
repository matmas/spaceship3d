@icon("set_target_nearest.svg")
class_name SetTargetNearest
extends ActionLeaf

@export var target_key := "target"


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	for area in npc.detection_radar.get_overlapping_areas():
		if area is Player:
			blackboard.set_value(target_key, area)
			return SUCCESS
	return FAILURE
