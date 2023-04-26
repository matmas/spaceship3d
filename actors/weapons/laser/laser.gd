extends RayCast3D

@onready var beam := $Beam as MeshInstance3D
@onready var beam_mesh := beam.mesh as PrismMesh
@onready var sparks := $Sparks as GPUParticles3D
@onready var smoke := $Smoke as GPUParticles3D
@onready var sparks_light := $"Sparks/Light" as OmniLight3D
@onready var SPARKS_LIGHT_MAX_ENERGY := sparks_light.light_energy
@onready var camera := get_viewport().get_camera_3d() as Camera3D
@onready var exclude := owner
@onready var painter := $Painter as Painter
@onready var firing := $Firing as AudioStreamPlayer3D
@onready var hitting := $Hitting as AudioStreamPlayer3D

var targetting_speed := 1000.0

var power := 0.0
var noise := FastNoiseLite.new()
var target_position_override := Vector3()


func _ready() -> void:
	add_exception(exclude)
	set_process(visible)
	set_physics_process(visible)


func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		power = move_toward(power, 1.0, delta * 60 * 0.2)
	else:
		power = move_toward(power, 0.0, delta * 60 * 0.1)
	sparks_light.light_energy = float(is_colliding()) * power * SPARKS_LIGHT_MAX_ENERGY * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
	enabled = power > 0.0
	beam.visible = power > 0.0
	beam.scale.x = power
	beam.scale.y = power

	firing.volume_db = linear_to_db(power) if not is_colliding() else -INF
	hitting.volume_db = linear_to_db(power) if is_colliding() else -INF

	var ray_origin := camera.project_ray_origin(Mouse.get_cursor_position())
	var ray_end := ray_origin + camera.project_ray_normal(Mouse.get_cursor_position()) * camera.far
	var new_target_position := target_position_override if target_position_override else ray_end
	var new_basis := Basis.looking_at(global_position.direction_to(new_target_position))
	global_transform.basis = global_transform.basis.slerp(new_basis, 1 - pow(0.1, delta * targetting_speed)).orthonormalized()

	var beam_endpoint := get_collision_point() if is_colliding() else to_global(target_position)
	for particles in [sparks, smoke]:
		particles.emitting = is_colliding() and power == 1.0
		particles.global_position = beam_endpoint
		if is_colliding():
			particles.look_at(beam_endpoint + get_collision_normal(), get_collision_normal().cross(-particles.basis.z))

	beam.global_position = (global_position + beam_endpoint) / 2
	beam.look_at(beam_endpoint)
	beam.scale.z = global_position.distance_to(beam_endpoint) / beam_mesh.size.z

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
