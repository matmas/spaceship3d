extends Node


enum Faction { Pirates, Civilians, Players }


func is_hostile_to_another(source_faction: Faction, target_faction: Faction) -> bool:
	if source_faction == target_faction:
		return false
	if source_faction == Faction.Pirates or target_faction == Faction.Pirates:
		return true
	return false
