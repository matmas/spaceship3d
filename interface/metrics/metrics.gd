extends Label


func _ready() -> void:
	z_index = -1
	if OS.get_name() == "Android":
		label_settings.font_size = 30
		position.x = -50  # some phones have rounded corners


func _process(_delta: float) -> void:
	text = """\
	{fps} FPS
	{time_process}ms process
	{time_physics}ms physics
	{num_obj} objects
	{num_resources} resources
	{num_nodes} nodes
	{num_orphans} orphan nodes
	{num_physics_obj} physics objects
	{num_physics_col} physics collisions
	{num_physics_island} physics islands
	""".format({
		"fps": Performance.get_monitor(Performance.TIME_FPS),
		"num_obj": Performance.get_monitor(Performance.OBJECT_COUNT),
		"num_nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"time_process": "%.0f" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000),
		"time_physics": "%.0f" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000),
		"num_resources": Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT),
		"num_orphans": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT),
		"num_physics_obj": Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS),
		"num_physics_col": Performance.get_monitor(Performance.PHYSICS_3D_COLLISION_PAIRS),
		"num_physics_island": Performance.get_monitor(Performance.PHYSICS_3D_ISLAND_COUNT),
	})
	if Input.is_action_just_pressed("ui_home"):
		Node.print_orphan_nodes()
