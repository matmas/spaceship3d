class_name Thruster extends Node3D

@onready var flame := $Flame as MeshInstance3D
@onready var exhaust := $Exhaust as AudioStreamPlayer3D
@onready var flame_material := flame.get_surface_override_material(0) as ShaderMaterial
@onready var alpha_multiplier := flame_material.get_shader_parameter(&"alpha_multiplier") as float
@onready var gradient_multiplier := flame_material.get_shader_parameter(&"gradient_multiplier") as float
@onready var gradient_shift := flame_material.get_shader_parameter(&"gradient_shift") as float

var power := 0.0
var target_power := 0.0


func _ready() -> void:
	exhaust.volume_db = -INF


func _process(delta: float) -> void:
	power = lerpf(power, target_power, 1 - pow(0.1, delta * 5))
	flame_material.set_shader_parameter(&"alpha_multiplier", alpha_multiplier * power)
	flame_material.set_shader_parameter(&"gradient_multiplier", gradient_multiplier * power)
	flame_material.set_shader_parameter(&"gradient_shift", gradient_shift * power)
	exhaust.volume_db = linear_to_db(power * 0.1)


func set_power(value: float) -> void:
	target_power = clampf(value, 0, 1)
