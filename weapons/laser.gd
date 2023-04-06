extends RayCast3D

@onready var impact_particles := $ImpactParticles as GPUParticles3D
@onready var light := $"ImpactParticles/Light" as OmniLight3D
@onready var mesh_instance := $Beam as MeshInstance3D
@onready var mesh := mesh_instance.mesh as PrismMesh
@onready var LIGHT_MAX_ENERGY := light.light_energy
@onready var camera := get_viewport().get_camera_3d() as Camera3D

var power := 0.0
var noise := FastNoiseLite.new()
var cursor_position := Vector2()
var target_position_override := Vector3()


func _ready():
	Signals.cursor_position_changed.connect(func(p: Vector2): cursor_position = p)
#	var m := impact_particles.process_material as ParticleProcessMaterial
#	m.color *= 1000.0


func _process(delta: float):
	if Input.is_action_pressed("fire"):
		power = move_toward(power, 1.0, delta * 60 * 0.2)
	else:
		power = move_toward(power, 0.0, delta * 60 * 0.1)
	light.light_energy = float(is_colliding()) * power * LIGHT_MAX_ENERGY * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
	enabled = power > 0.0
	mesh_instance.visible = power > 0.0
	mesh_instance.scale.x = power
	mesh_instance.scale.y = power

	var ray_origin := camera.project_ray_origin(cursor_position)
	var ray_end := ray_origin + camera.project_ray_normal(cursor_position) * camera.far

	var new_target_position: Vector3
	if target_position_override:
		new_target_position = target_position_override
	else:
		new_target_position = to_local(ray_end)
	target_position = target_position.lerp(new_target_position, delta * 5)

	var beam_endpoint: Vector3
	if is_colliding():
		beam_endpoint = get_collision_point()
		impact_particles.emitting = power == 1.0
		impact_particles.global_position = beam_endpoint
		impact_particles.look_at(beam_endpoint + get_collision_normal())
	else:
		beam_endpoint = to_global(target_position)
		impact_particles.emitting = false
	mesh_instance.global_position = (global_position + beam_endpoint) / 2
	mesh_instance.look_at(beam_endpoint)
	mesh_instance.scale.z = global_position.distance_to(beam_endpoint) / mesh.size.z


func _physics_process(delta: float):
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(cursor_position)
	params.to = params.from + camera.project_ray_normal(cursor_position) * camera.far
	var result := get_world_3d().direct_space_state.intersect_ray(params)
	# Avoid targetting empty space just in front body by moving collision point a small distance in
	target_position_override = (to_local(result.position) + Vector3.BACK * 0.1) if result else Vector3()
