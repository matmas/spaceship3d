class_name ShipEngine extends Node3D

@onready var exhaust := $Exhaust as AudioStreamPlayer3D
@onready var cone = $"Cone/Cone" as MeshInstance3D

var power := 0.0
var target_power := 0.0


func _ready() -> void:
	# We need to change each engine material independently
	cone.set_surface_override_material(0, cone.get_active_material(0).duplicate() as Material)


func set_power(value: float) -> void:
	target_power = clampf(value * 500, 0, 1)


func _process(delta: float) -> void:
	power = lerpf(power, target_power, 1 - pow(0.1, delta * 5))
	var material := cone.get_active_material(0) as ShaderMaterial
	material.set_shader_parameter(&"alpha_multiplier", power)
	material.set_shader_parameter(&"gradient_multiplier", power * 6)
	material.set_shader_parameter(&"gradient_shift", power)
	exhaust.volume_db = linear_to_db(power * 0.1)
