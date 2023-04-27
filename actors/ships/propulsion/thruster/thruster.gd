class_name Thruster extends Node3D

@onready var flame := $Flame as MeshInstance3D
@onready var distortion := $Distortion as MeshInstance3D
@onready var exhaust := $Exhaust as AudioStreamPlayer3D

var power := 0.0
var target_power := 0.0


func _ready() -> void:
	# We need to change each material independently
	flame.material_override = flame.material_override.duplicate() as Material
	distortion.set_surface_override_material(0, distortion.get_active_material(0).duplicate() as Material)


func _process(delta: float) -> void:
	power = lerpf(power, target_power, 1 - pow(0.1, delta * 5))
	var flame_material := flame.get_active_material(0) as ShaderMaterial
	flame_material.set_shader_parameter(&"alpha_multiplier", power)
	flame_material.set_shader_parameter(&"gradient_multiplier", power * 6)
	flame_material.set_shader_parameter(&"gradient_shift", power)
	exhaust.volume_db = linear_to_db(power * 0.1)

	var distortion_material := distortion.get_active_material(0) as ShaderMaterial
	distortion_material.set_shader_parameter(&"distortion", power * 0.005)


func set_power(value: float) -> void:
	target_power = value
