## Sequence nodes will attempt to execute all of its children and report
## `SUCCESS` in case all of the children report a `SUCCESS` status code.
## If at least one child reports a `FAILURE` status code, this node will also
## return `FAILURE` and restart.
## In case a child returns `RUNNING` this node will tick again.
@tool
@icon("res://addons/beehave/icons/category_composite.svg")
class_name ParallelComposite extends Composite

var children_responses: Array[int] = []


func before_run(actor: Node, blackboard: Blackboard) -> void:
	children_responses.resize(get_child_count())
	for c in get_children():
		c.before_run(actor, blackboard)


func tick(actor: Node, blackboard: Blackboard) -> int:
	var at_least_one_child_running: bool = false
	var at_least_one_child_failure: bool = false

	for c in get_children():

		var response = c.tick(actor, blackboard)
		children_responses[c.get_index()] = response

		if can_send_message(blackboard):
			BeehaveDebuggerMessages.process_tick(c.get_instance_id(), response)

		if c is ConditionLeaf:
			blackboard.set_value("last_condition", c, str(actor.get_instance_id()))
			blackboard.set_value("last_condition_status", response, str(actor.get_instance_id()))

		match response:
			SUCCESS:
				c.after_run(actor, blackboard)
			FAILURE:
				c.after_run(actor, blackboard)
				at_least_one_child_failure = true
			RUNNING:
				at_least_one_child_running = true
				if c is ActionLeaf:
					blackboard.set_value("running_action", c, str(actor.get_instance_id()))

	if at_least_one_child_failure:
		interrupt(actor, blackboard)
		return FAILURE
	elif at_least_one_child_running:
		return RUNNING
	else:
		_reset()
		return SUCCESS


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	# Interrupt any child that was RUNNING before.
	for c in get_children():
		var response := children_responses[c.get_index()]
		if response == RUNNING:
			c.interrupt(actor, blackboard)
	_reset()


func _reset() -> void:
	children_responses.fill(SUCCESS)


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"SequenceComposite")
	return classes
