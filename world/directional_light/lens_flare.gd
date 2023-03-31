extends MeshInstance3D

@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var directional_light: DirectionalLight3D = get_parent()


func get_light_apparent_global_position() -> Vector3:
	return camera.global_position + directional_light.global_transform.basis.z * camera.far


func _process(_delta):
	var shader := get_active_material(0) as ShaderMaterial
	shader.set_shader_parameter("sun_position", camera.unproject_position(get_light_apparent_global_position()))
	visible = not camera.is_position_behind(get_light_apparent_global_position())
