extends Thruster

@onready var distortion := $Distortion as MeshInstance3D
@onready var light := $Light as OmniLight3D
@onready var light_energy := light.light_energy

var noise := FastNoiseLite.new()


func _ready() -> void:
	super._ready()
	light.light_energy = 0


func _process(delta: float) -> void:
	super._process(delta)
	distortion.set_instance_shader_parameter(&"instance_distortion", power * 0.5)
	light.light_energy = power * light_energy * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
