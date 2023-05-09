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
	var distortion_material := distortion.get_active_material(0) as ShaderMaterial
	distortion_material.set_shader_parameter(&"distortion", power * 0.005)
	light.light_energy = power * light_energy * ((noise.get_noise_1d(Time.get_ticks_msec()) + 1) * 0.25 + 0.5)
