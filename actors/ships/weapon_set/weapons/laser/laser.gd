extends Weapon

@onready var beam := $Beam as MeshInstance3D
@onready var beam_scale := beam.scale
@onready var sparks := $Sparks as GPUParticles3D
@onready var smoke := $Smoke as GPUParticles3D
@onready var camera := get_viewport().get_camera_3d() as Camera3D
@onready var exclude := owner.owner as CollisionObject3D
@onready var painter := $Painter as Painter
@onready var firing := $Firing as AudioStreamPlayer3D
@onready var firing_volume := firing.volume_db
@onready var hitting := $Hitting as AudioStreamPlayer3D
@onready var hitting_volume := hitting.volume_db

var targetting_speed := 5.0

var power := 0.0
var target_position_override := Vector3()


func _enter_tree() -> void:
	if not owner:
		owner = get_parent().owner if get_parent().scene_file_path == "" else get_parent()


func _ready() -> void:
	beam.set_surface_override_material(0, beam.get_active_material(0).duplicate() as Material)
	add_exception(exclude)
	set_process(visible)
	set_physics_process(visible)
	firing.volume_db = -INF
	hitting.volume_db = -INF


func _process(delta: float) -> void:
	if is_firing:
		power = move_toward(power, 1.0, delta * 60 * 0.2)
	else:
		power = move_toward(power, 0.0, delta * 60 * 0.1)
	enabled = power > 0.0
	beam.visible = power > 0.0
	beam.scale.x = power * beam_scale.x
	beam.scale.y = power * beam_scale.y
	var beam_material := beam.get_active_material(0) as ShaderMaterial
	beam_material.set_shader_parameter(&"alpha", power)

	firing.volume_db = firing_volume + linear_to_db(lerpf(db_to_linear(firing.volume_db), power, 1 - pow(0.1, delta * 5)))
	hitting.volume_db = hitting_volume if is_colliding() else -INF
	hitting.global_position = get_collision_point()

	var ray_origin := camera.project_ray_origin(Mouse.get_cursor_position())
	var ray_end := ray_origin + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
	var new_target_position := target_position_override if target_position_override else ray_end
	var new_basis := Basis.looking_at(global_position.direction_to(new_target_position))
	global_transform.basis = global_transform.basis.slerp(new_basis, 1 - pow(0.1, delta * targetting_speed)).orthonormalized()

	var beam_endpoint := get_collision_point() if is_colliding() else to_global(target_position)
	for p in [sparks, smoke]:
		var particles := p as GPUParticles3D
		particles.emitting = is_colliding() and power == 1.0 and (particles == smoke and (get_collider() as Node).name.begins_with("rock") or particles != smoke)
		if is_colliding() and power == 1.0:
			particles.global_position = beam_endpoint
			if not Vector3.UP.cross(beam_endpoint + get_collision_normal() - particles.global_position).is_zero_approx():
				particles.look_at(beam_endpoint + get_collision_normal())

	beam.look_at(beam_endpoint, beam.global_position - camera.global_position)
	beam.scale.z = global_position.distance_to(beam_endpoint)

	if is_colliding() and power == 1.0:
		var mesh_instance = Utils.get_first_child_of_type(get_collider(), MeshInstance3D)
		if mesh_instance == null:
			mesh_instance = get_collider().get_parent()
		painter.paint_line(mesh_instance, global_transform)


func _physics_process(_delta: float) -> void:
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(Mouse.get_cursor_position())
	params.to = params.from + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
	params.exclude = [exclude]
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	# Avoid targetting empty space just in front body by moving collision point a bit forward
	target_position_override = to_global(to_local(result.position) + Vector3.FORWARD * 0.1) if result else Vector3()
