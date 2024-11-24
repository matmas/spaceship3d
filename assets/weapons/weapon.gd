class_name Weapon
extends Node3D

@onready var ray_cast := $RayCast as RayCast3D
@onready var aiming_dot := $AimingDot as Sprite2D
@onready var aiming_dot_material := aiming_dot.material as ShaderMaterial
@onready var target_lead := $TargetLead as Sprite2D
@onready var target_lead_material := target_lead.material as ShaderMaterial
@onready var ship := owner.owner as Ship
@onready var shield := ship.shield as Shield
@onready var camera := get_viewport().get_camera_3d() as Camera3D
@onready var projectile_max_travel_distance := minf(camera.far, 1000.0)

const focus_separation := 0.1

var is_fixed := false
var try_firing := false
var projectile_speed := INF
var targetting_speed := INF
var can_focus := false
var target_position_override := Vector3()
var belongs_to_player := false
var selection: Node3D


func _enter_tree() -> void:
	if not owner:  # when adding from script
		owner = get_parent().owner if get_parent().scene_file_path == "" else get_parent()


func _ready() -> void:
	set_process(visible)
	set_physics_process(visible)
	ray_cast.add_exception(ship)
	ray_cast.add_exception(shield)
	Signals.selection_changed.connect(func(collision_object): selection = collision_object)


func _process(delta: float) -> void:
	if not is_fixed:
		var new_target_position := target_position_override if target_position_override else _mouse_cursor_to_world_position()
		var new_basis := Basis.looking_at(global_position.direction_to(new_target_position), ship.global_transform.basis.y)
		global_transform.basis = global_transform.basis.slerp(new_basis, 1 - pow(0.1, delta * targetting_speed)).orthonormalized()
	aiming_dot.visible = belongs_to_player
	target_lead.visible = belongs_to_player
	if belongs_to_player:
		aiming_dot.position = camera.unproject_position(_collision_point_or_target_position())
		aiming_dot_material.set_shader_parameter(&"alpha", 1.0 if ray_cast.is_colliding() else 0.5)
		target_lead.visible = selection and selection is RigidBody3D
		if target_lead.visible:
			var selection_global_position := Utils.interpolated_global_position(selection)
			var collision_position := Utils.calculate_projectile_and_target_collision_point(
				selection_global_position,
				(selection as RigidBody3D).linear_velocity,
				Utils.interpolated_global_position(ship),
				ship.linear_velocity,
				projectile_speed,
			)
			var projectile_travel_distance := collision_position.distance_to(ship.global_position)
			target_lead.position = camera.unproject_position(collision_position)
			target_lead.visible = (
				not camera.is_position_behind(collision_position)
				and projectile_travel_distance < projectile_max_travel_distance
			)
			target_lead_material.set_shader_parameter(&"alpha", clampf((projectile_max_travel_distance - projectile_travel_distance) * 0.01, 0, 1))


func _physics_process(_delta: float) -> void:
	if not is_fixed and can_focus:
		target_position_override = _mouse_cursor_to_collision_world_position()


func _mouse_cursor_to_world_position() -> Vector3:
	var screen_position := _get_aiming_screen_position()
	var ray_origin := camera.project_ray_origin(screen_position)
	return ray_origin + camera.project_ray_normal(screen_position) * camera.far


func _mouse_cursor_to_collision_world_position() -> Vector3:
	var screen_position := _get_aiming_screen_position()
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(screen_position)
	params.to = params.from + camera.project_ray_normal(screen_position) * camera.far
	params.collision_mask = ray_cast.collision_mask
	params.exclude = [ship, shield]
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	# Avoid targetting empty space just in front body by moving collision point a bit forward along the -Z axis
	var local_offset := ship.to_local(global_position) * focus_separation + Vector3.FORWARD * 0.2
	return to_global(to_local(result.position) + local_offset) if result else Vector3()


func _collision_point_or_target_position() -> Vector3:
	return ray_cast.get_collision_point() if ray_cast.is_colliding() else to_global(ray_cast.target_position)


func _get_aiming_screen_position() -> Vector2:
	var viewport_center := Mouse.viewport_size * 0.5
	var max_distance_from_center := minf(viewport_center.x, viewport_center.y) * 0.75
	return Mouse.get_limited_cursor_position(max_distance_from_center)


func damage_per_hit() -> float:
	return 1.0
