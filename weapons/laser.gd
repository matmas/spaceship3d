extends RayCast3D

@onready var impact_particles := $ImpactParticles as GPUParticles3D
@onready var light := $"ImpactParticles/Light" as OmniLight3D
@onready var mesh_instance := $Beam as MeshInstance3D
@onready var mesh := mesh_instance.mesh as PrismMesh
@onready var MAX_LENGTH = abs(target_position.z)
@onready var MAX_THICKNESS = mesh.size.x

const LIGHT_MAX_ENERGY := 10

var power := 0.0
var target_power := 0.0
var noise := FastNoiseLite.new()


func _process(delta):
	if Input.is_action_pressed("fire"):
		target_power = 1.0
		set_power(move_toward(power, target_power, delta * 60 * 0.2))
	else:
		target_power = 0.0
		set_power(move_toward(power, target_power, delta * 60 * 0.1))
	light.light_energy = float(is_colliding()) * power * LIGHT_MAX_ENERGY * (noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.5


func set_power(value: float):
	power = value
	enabled = not is_zero_approx(power)
	mesh_instance.visible = not is_zero_approx(power)
	mesh.size.x = power * MAX_THICKNESS
	mesh.size.y = power * MAX_THICKNESS
	if not is_equal_approx(power, 1.0):
		impact_particles.emitting = false


func _physics_process(_delta):
	if is_colliding():
		var point := get_collision_point()
		impact_particles.look_at_from_position(Vector3(), get_collision_normal())
		impact_particles.emitting = true
		impact_particles.global_position = point
		mesh.size.z = global_position.distance_to(point)
	else:
		mesh.size.z = MAX_LENGTH
		impact_particles.emitting = false
	mesh_instance.position.z = mesh.size.z / 2
