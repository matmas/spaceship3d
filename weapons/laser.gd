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
var endpoint := Vector3()


func _ready():
	Signals.cursor_position_changed.connect(func(p: Vector2): cursor_position = p)


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


func _physics_process(_delta):
	var ray_origin := camera.project_ray_origin(cursor_position)
	var ray_end := ray_origin + camera.project_ray_normal(cursor_position) * camera.far
	target_position = to_local(ray_end)
	if is_colliding():
		endpoint = get_collision_point()
		impact_particles.emitting = power == 1.0
		impact_particles.global_position = endpoint
		impact_particles.look_at(endpoint + get_collision_normal())
	else:
		endpoint = to_global(target_position)
		impact_particles.emitting = false
	mesh_instance.global_position = (endpoint + global_position) / 2
	mesh_instance.look_at(endpoint)
	mesh_instance.scale.z = endpoint.distance_to(global_position) / mesh.size.z
