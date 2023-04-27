extends OmniLight3D

@onready var default_energy := light_energy
@onready var particles := get_parent() as GPUParticles3D

var intensity := 0.0
var noise := FastNoiseLite.new()


func _ready() -> void:
	# light should not move relative to the parent unless local_coords if true
	top_level = not particles.local_coords


func _process(delta: float) -> void:
	if particles.emitting:
		global_position = particles.global_position
	var target_intensity := float(particles.emitting)
	intensity = move_toward(intensity, target_intensity, delta / particles.lifetime)
	light_energy = intensity * default_energy * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
