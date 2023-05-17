class_name Weapon
extends Node3D

@onready var ray_cast := $RayCast as RayCast3D
@onready var aiming_dot := $AimingDot as Sprite2D
@onready var aiming_dot_material := aiming_dot.material as ShaderMaterial
@onready var ship := owner.owner as Ship
@onready var shield := ship.shield as Shield
@onready var camera := get_viewport().get_camera_3d() as Camera3D

var is_fixed := false
var try_firing := false
var targetting_speed := 1.0
var target_position_override := Vector3()


func _enter_tree() -> void:
	if not owner:  # when adding from script
		owner = get_parent().owner if get_parent().scene_file_path == "" else get_parent()


func _ready() -> void:
	set_process(visible)
	set_physics_process(visible)
	ray_cast.add_exception(ship)
	ray_cast.add_exception(shield)
	aiming_dot.visible = false


func _process(delta: float) -> void:
	if not is_fixed:
		var new_target_position := target_position_override if target_position_override else _mouse_cursor_to_world_position()
		var new_basis := Basis.looking_at(global_position.direction_to(new_target_position))
		global_transform.basis = global_transform.basis.slerp(new_basis, 1 - pow(0.1, delta * targetting_speed)).orthonormalized()
	if aiming_dot.visible:
		aiming_dot.position = camera.unproject_position(_collision_point_or_target_position())
		aiming_dot_material.set_shader_parameter(&"alpha", 1.0 if ray_cast.is_colliding() else 0.5)


func _physics_process(_delta: float) -> void:
	if not is_fixed:
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
	# Avoid targetting empty space just in front body by moving collision point a bit forward
	return to_global(to_local(result.position) + Vector3.FORWARD * 0.2) if result else Vector3()


func _collision_point_or_target_position() -> Vector3:
	return ray_cast.get_collision_point() if ray_cast.is_colliding() else to_global(ray_cast.target_position)


func _get_aiming_screen_position() -> Vector2:
	var viewport_center := Mouse.viewport_size * 0.5
	var max_distance_from_center := minf(viewport_center.x, viewport_center.y) * 0.5
	return Mouse.get_limited_cursor_position(max_distance_from_center)
