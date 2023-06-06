@icon("set_target_to_closest_enemy.svg")
class_name SetTargetToClosestEnemy
extends ActionLeaf

@export var target_key := "target"

var current_id: int


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var min_distance_squared := INF
	var closest: Pilot
	for area in npc.detection_radar.get_overlapping_areas():
		if area is Pilot:
			var pilot := area as Pilot
			if Factions.is_hostile_to_another(pilot.faction, npc.faction):
				var distance_squared := npc.global_position.distance_squared_to(pilot.global_position)
				if distance_squared < min_distance_squared:
					min_distance_squared = distance_squared
					closest = pilot

	if closest:
		blackboard.set_value(target_key, closest)
		return SUCCESS
	else:
		return FAILURE
