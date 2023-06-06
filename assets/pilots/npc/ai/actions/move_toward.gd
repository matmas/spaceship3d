class_name MoveToward
extends ActionLeaf

@export var target_key := "target"
@export var target_offset := Vector3()

## target_position_key overrides the target_key
@export var target_position_key: String

@export var slowdown_distance := 10.0
@export var target_position_tolerance := 1.0

## direction_key overrides target_position_key, slowdown_distance is ignored
@export var direction_key: String



func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var linear_acceleration: Vector3

	if direction_key:
		var direction := blackboard.get_value(direction_key) as Vector3
		if direction == null:
			return FAILURE
		linear_acceleration = direction * npc.ship.max_linear_acceleration().z
		npc.ship.linear_acceleration_to_apply += linear_acceleration
		return RUNNING
	else:
		var target_position: Vector3

		if target_position_key:
			target_position = blackboard.get_value(target_position_key) as Vector3
			if target_position == null:
				return FAILURE
		elif target_key:
			var target := blackboard.get_value(target_key) as Node3D
			if not target:
				return FAILURE
			target_position = target.global_transform * target_offset
		else:
			return FAILURE

		var target_relative_position := target_position - npc.ship.global_position
		var target_direction := target_relative_position.normalized()
		var target_distance := target_relative_position.length()
		linear_acceleration = target_direction * (npc.ship.max_linear_acceleration().z * minf(target_distance / slowdown_distance, 1))
		npc.ship.linear_acceleration_to_apply += linear_acceleration
		return SUCCESS if target_distance < target_position_tolerance else RUNNING
