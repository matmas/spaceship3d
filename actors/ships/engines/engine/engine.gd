class_name ShipEngine extends Node3D

@onready var exhaust := $Exhaust as AudioStreamPlayer3D
@onready var cone = $"Cone/Cone" as MeshInstance3D


func _ready() -> void:
	# We need to change particle velocities independently
	cone.set_surface_override_material(0, cone.get_active_material(0).duplicate() as Material)


func set_power(value: float) -> void:
	var material := cone.get_active_material(0) as ShaderMaterial
	material.set_shader_parameter(&"alpha_multiplier", clampf(value * 500, 0, 1))
	material.set_shader_parameter(&"gradient_multiplier", clampf(value * 500 * 6, 0, 6))
	material.set_shader_parameter(&"gradient_shift", clampf(value * 500, 0, 1))
	exhaust.volume_db = linear_to_db(clampf(value * 10, 0, 1))
