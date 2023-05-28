extends Node


enum Faction { Pirates, Civilians, Players }


func are_factions_hostile_to_each_other(faction1: Faction, faction2: Faction) -> bool:
	if faction1 == faction2:
		return false
	if faction1 == Faction.Pirates or faction2 == Faction.Pirates:
		return true
	return false
