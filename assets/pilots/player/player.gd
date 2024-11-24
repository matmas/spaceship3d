class_name Player
extends Pilot

var steering_direction := Vector2()
var detected_npcs := {}


func _init() -> void:
	faction = Factions.Faction.Players


func _ready() -> void:
	await super._ready()
	Mouse.cursor_position_changed.connect(func(_p: Vector2): steering_direction = _get_steering_direction())
	ship.weapon_set.add_loadout(Loadouts.twin_guns)
	ship.weapon_set.set_all_belongs_to_player(true)


func _process(_delta: float) -> void:
	ship.weapon_set.set_all_try_firing(Input.is_action_pressed("fire"))


func _physics_process(_delta: float) -> void:
	var linear_acceleration_direction := Vector3(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_down", &"move_up"),
		Input.get_axis(&"move_forward", &"move_backward"),
	).normalized()
	var linear_acceleration := linear_acceleration_direction * ship.max_linear_acceleration()
	ship.apply_central_force(ship.global_transform.basis * linear_acceleration)

	var angular_acceleration_direction := Vector3(
		-steering_direction.y,
		-steering_direction.x,
		Input.get_axis(&"roll_right", &"roll_left"),
	)
	var angular_acceleration := angular_acceleration_direction * ship.max_angular_acceleration()
	ship.apply_torque(ship.global_transform.basis * angular_acceleration)


func _get_steering_direction() -> Vector2:
	const DEADZONE := 0.01
	var viewport_size := get_viewport().get_visible_rect().size
	var viewport_min_size := minf(viewport_size.x, viewport_size.y)
	var direction := (Mouse.resolution_independent_cursor_position - Vector2(0.5, 0.5)) * 2 * viewport_size / viewport_min_size
	var magnitude := Vector2.ZERO.distance_to(direction)
	if magnitude < DEADZONE:
		direction = Vector2.ZERO
	else:
		direction = direction.normalized() * ((magnitude - DEADZONE) / (1 - DEADZONE))
	return direction


func _on_detection_radar_area_entered(area: Area3D) -> void:
	if area is NPC and area != self:
		var npc := area as NPC
		detected_npcs[npc] = true
		npc.offscreen_indicator.visible = true


func _on_tracking_radar_area_exited(area: Area3D) -> void:
	if area is NPC:
		var npc := area as NPC
		detected_npcs.erase(npc)
		npc.offscreen_indicator.visible = false
