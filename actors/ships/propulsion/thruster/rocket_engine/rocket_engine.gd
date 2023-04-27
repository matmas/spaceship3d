extends Thruster

@onready var distortion := $Distortion as MeshInstance3D


func _ready() -> void:
	super._ready()
	# We need to change each material independently
	distortion.set_surface_override_material(0, distortion.get_active_material(0).duplicate() as Material)


func _process(delta: float) -> void:
	super._process(delta)
	var distortion_material := distortion.get_active_material(0) as ShaderMaterial
	distortion_material.set_shader_parameter(&"distortion", power * 0.005)
