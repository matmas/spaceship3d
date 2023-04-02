extends GPUParticles3D

@onready var camera := get_viewport().get_camera_3d()
@onready var previous_camera_position := camera.global_position

var camera_velocity := Vector3()


func _process(delta):
	global_transform = camera.global_transform
	var shader := draw_pass_1.surface_get_material(0) as ShaderMaterial
	shader.set_shader_parameter("camera_position", camera.global_position)
	shader.set_shader_parameter("camera_velocity", camera_velocity)

	camera_velocity = (camera.global_position - previous_camera_position) / delta
	previous_camera_position = camera.global_position
