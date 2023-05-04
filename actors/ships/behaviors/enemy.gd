extends Ship

var player: Player


func _ready() -> void:
	super._ready()
	position = Vector3(
		randf_range(-100, 100),
		randf_range(-100, 100),
		randf_range(-100, 100),
	)


func _physics_process(_delta: float) -> void:
	if player:
		point_at(player.global_position)
		match_roll_with(player)
		move_to(player.global_transform * Vector3(0, 0, 30))


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body as Player


func _on_detection_area_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
