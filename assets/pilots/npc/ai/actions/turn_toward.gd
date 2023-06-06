extends ActionLeaf

@export var target_key := "target"
@export var direction_key: String
@export var direction_tolerance := 0.01


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not actor is NPC:
		return FAILURE
	var npc := actor as NPC

	var direction: Vector3

	if direction_key:
		direction = blackboard.get_value(direction_key) as Vector3
		if direction == null:
			return FAILURE
	elif target_key:
		var target := blackboard.get_value(target_key) as Node3D
		if not target:
			return FAILURE
		direction = npc.ship.global_position.direction_to(target.global_position)
	else:
		return FAILURE

	var current_direction := -npc.ship.global_transform.basis.z
	var correction := direction - current_direction
	var correction_length := correction.length()
	npc.ship.apply_torque(correction.cross(npc.ship.global_transform.basis.z).normalized() * minf(correction_length, 1) * npc.ship.max_linear_acceleration().x)
	return SUCCESS if correction_length < direction_tolerance else RUNNING
