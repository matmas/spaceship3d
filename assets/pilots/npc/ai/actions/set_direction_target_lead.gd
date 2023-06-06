@icon("set_direction_target_lead.svg")
class_name SetDirectionTargetLead
extends ActionLeaf

@export var target_key := "target"
@export var direction_key := "direction"


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var target := blackboard.get_value(target_key) as Pilot
	if not target:
		return FAILURE

	var collision_point := Utils.calculate_projectile_and_target_collision_point(
		target.global_position,
		target.ship.linear_velocity,
		npc.ship.global_position,
		npc.ship.linear_velocity,
		npc.ship.weapon_set.get_average_projectile_speed(),
	)
	var direction := npc.ship.global_position.direction_to(collision_point)
	blackboard.set_value(direction_key, direction)
	return SUCCESS
