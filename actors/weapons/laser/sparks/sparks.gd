extends GPUParticles3D

@onready var light := $Light as OmniLight3D
@onready var LIGHT_MAX_ENERGY := light.light_energy

var intensity = 0.0
var noise := FastNoiseLite.new()


func _process(delta: float) -> void:
	var target_intensity := float(emitting)
	intensity = move_toward(intensity, target_intensity, delta / lifetime)
	light.light_energy = intensity * LIGHT_MAX_ENERGY * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
