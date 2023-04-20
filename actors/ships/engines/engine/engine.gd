class_name ShipEngine extends GPUParticles3D

@onready var exhaust := $Exhaust as AudioStreamPlayer3D


func _ready() -> void:
	# We need to change particle velocities independently
	process_material = process_material.duplicate() as Material


func set_power(value: float) -> void:
	process_material.initial_velocity_min = value * 500
	process_material.initial_velocity_max = value * 500
	exhaust.volume_db = linear_to_db(clampf(value * 10, 0, 1))
