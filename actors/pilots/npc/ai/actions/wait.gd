@icon("wait.svg")
class_name Wait
extends ActionLeaf

@export var delay_msec := 1000.0

var run_at: float


func before_run(_actor: Node, _blackboard: Blackboard) -> void:
	run_at = Time.get_ticks_msec()


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return SUCCESS if Time.get_ticks_msec() > run_at + delay_msec else RUNNING
