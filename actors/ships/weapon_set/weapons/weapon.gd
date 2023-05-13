class_name Weapon
extends Node3D

@onready var ray_cast := $RayCast as RayCast3D
@onready var aim := $Aim as Sprite2D
@onready var collision_exception := owner.owner as CollisionObject3D
@onready var camera := get_viewport().get_camera_3d() as Camera3D

var is_fixed := false
var is_firing := false
var targetting_speed := 1.0
var target_position_override := Vector3()


func _enter_tree() -> void:
	if not owner:
		owner = get_parent().owner if get_parent().scene_file_path == "" else get_parent()


func _ready() -> void:
	set_process(visible)
	set_physics_process(visible)
	ray_cast.add_exception(collision_exception)
	aim.visible = false


func _process(delta: float) -> void:
	if not is_fixed:
		var new_target_position := target_position_override if target_position_override else _mouse_cursor_to_world_position()
		var new_basis := Basis.looking_at(global_position.direction_to(new_target_position))
		global_transform.basis = global_transform.basis.slerp(new_basis, 1 - pow(0.1, delta * targetting_speed)).orthonormalized()
	if aim.visible:
		aim.position = camera.unproject_position(_collision_point_or_target_position())
		(aim.material as ShaderMaterial).set_shader_parameter(&"alpha", 1.0 if ray_cast.is_colliding() else 0.5)


func _physics_process(_delta: float) -> void:
	if not is_fixed:
		target_position_override = _mouse_cursor_to_collision_world_position()


func _mouse_cursor_to_world_position() -> Vector3:
	var ray_origin := camera.project_ray_origin(Mouse.get_cursor_position())
	return ray_origin + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far


func _mouse_cursor_to_collision_world_position() -> Vector3:
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(Mouse.get_cursor_position())
	params.to = params.from + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
	params.exclude = [collision_exception]
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	# Avoid targetting empty space just in front body by moving collision point a bit forward
	return to_global(to_local(result.position) + Vector3.FORWARD * 0.2) if result else Vector3()


func _collision_point_or_target_position() -> Vector3:
	return ray_cast.get_collision_point() if ray_cast.is_colliding() else to_global(ray_cast.target_position)
