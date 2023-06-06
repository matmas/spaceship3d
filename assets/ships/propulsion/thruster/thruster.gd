class_name Thruster extends Node3D

@onready var flame := $Flame as MeshInstance3D
@onready var exhaust := $Exhaust as AudioStreamPlayer3D

var power := 0.0
var target_power := 0.0


func _ready() -> void:
	exhaust.volume_db = -INF


func _process(delta: float) -> void:
	power = lerpf(power, target_power, 1 - pow(0.1, delta * 5))
	flame.set_instance_shader_parameter(&"instance_alpha", power)
	flame.set_instance_shader_parameter(&"instance_gradient_multiplier", power)
	flame.set_instance_shader_parameter(&"instance_gradient_shift", power)
	exhaust.volume_db = linear_to_db(power * 0.1)
	if is_zero_approx(power):
		set_process(false)


func set_power(value: float) -> void:
	target_power = clampf(value, 0, 1)
	if not is_zero_approx(target_power):
		set_process(true)
