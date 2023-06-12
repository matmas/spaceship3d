extends Node


enum Faction { Civilians, Players, Allies, Pirates }


func is_hostile_to_another(source_faction: Faction, target_faction: Faction) -> bool:
	if source_faction == target_faction:
		return false
	if source_faction == Faction.Pirates or target_faction == Faction.Pirates:
		return true
	return false


func get_color(faction: Faction) -> Color:
	if faction == Faction.Pirates:
		return Color.INDIAN_RED
	if faction == Faction.Allies:
		return Color.LIME_GREEN
	if faction == Faction.Civilians:
		return Color.YELLOW
	return Color.WHITE
