@icon("keep_firing_at.svg")
class_name KeepFiringAt
extends ActionLeaf

@export var target_key := "target"
@export var direction_key: String  ## overrides target_key
@export var direction_tolerance := 0.05


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var direction: Vector3

	if direction_key:
		direction = blackboard.get_value(direction_key) as Vector3
		if direction == null:
			return FAILURE
	else:
		var target := blackboard.get_value(target_key) as Node3D
		if not target:
			return FAILURE
		direction = npc.ship.global_position.direction_to(target.global_position)

	var current_direction := -npc.ship.global_transform.basis.z
	var direction_difference := (direction - current_direction).length()
	npc.ship.weapon_set.set_all_try_firing(direction_difference < direction_tolerance)
	return RUNNING


func after_run(actor: Node, _blackboard: Blackboard) -> void:
	var npc := actor as NPC
	npc.ship.weapon_set.set_all_try_firing(false)


func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	var npc := actor as NPC
	npc.ship.weapon_set.set_all_try_firing(false)
