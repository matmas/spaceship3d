extends Actor


func _ready():
	super._ready()
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)
	await get_tree().create_timer(5).timeout
	Signals.talk.emit("p347", "Hello?")
	await get_tree().create_timer(0.3).timeout
	Signals.talk.emit("p347", "Are you still there?")
	await get_tree().create_timer(10).timeout
	Signals.talk.emit("p335", "This is getting weird...")


func _physics_process(_delta):
	var player := Globals.player
	point_at(player.global_position)
	match_roll_with(player)
#	move_to(player.global_transform * Vector3(0, 0, 20))
